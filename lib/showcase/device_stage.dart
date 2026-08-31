import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plate_number/plate_number.dart';

import '../device_preview/device_config.dart';
import '../device_preview/device_frame.dart';
import '../device_preview/device_transition.dart';
import '../poster/poster_tokens.dart';
import '../showcase/demo_config.dart';
import '../showcase/device_cycle.dart';
import '../showcase/plate_typist.dart';
import '../widgets/plate_display.dart';

class DeviceStage extends StatefulWidget {
  const DeviceStage({
    super.key,
    this.onFrameDeviceChanged,
    this.onPhaseChanged,
  });

  /// Fired the instant a hop starts, with the incoming device — i.e. the same
  /// moment [_DeviceStageState._frameDevice] flips, before the plate content
  /// has caught up. The callout rails switch on this, so they leave while the
  /// device is still morphing.
  final ValueChanged<DeviceType>? onFrameDeviceChanged;

  /// Fired for every phase reported by the frame transition.
  final ValueChanged<DeviceTransitionPhase>? onPhaseChanged;

  @override
  State<DeviceStage> createState() => _DeviceStageState();
}

class _DeviceStageState extends State<DeviceStage> {
  final DeviceCycleController _controller = DeviceCycleController();
  final PlateTypist _typist = PlateTypist();

  /// Mirrors [PlateTypist.activeKey] as a value the keycaps and the keypad can
  /// subscribe to individually.
  ///
  /// The stage used to wrap the entire device subtree in an
  /// `AnimatedBuilder(animation: _typist)`, so every press and every release —
  /// roughly every 115ms through a run — rebuilt the plate, its live text
  /// fields, the ambient backdrop, the device shell and 41 keycaps, to change
  /// which single key is drawn highlighted. Now only the highlight rebuilds.
  final ValueNotifier<String?> _pressedKey = ValueNotifier<String?>(null);

  void _syncPressedKey() => _pressedKey.value = _typist.activeKey;

  /// Drives the frame's geometry morph; flips the instant a hop starts so the
  /// shell begins reshaping toward the incoming device.
  DeviceType _frameDevice = DeviceType.desktop;

  /// Drives the plate type shown and its backing bloc; lags [_frameDevice],
  /// only catching up during the blank hold once the outgoing plate has faded
  /// out (see [_onContentSwap]).
  DeviceType _contentDevice = DeviceType.desktop;

  /// Bloc for the content device, recreated on every content swap so each plate
  /// starts blank. [PlateDisplay] renders from it via its `bloc` param.
  late PlateCardBloc _bloc = PlateCardBloc(specFor(_contentDevice));

  /// Drives character entry from the tablet's [VirtualKeypad] into the
  /// attached [PlateCanvas], without either side knowing the active slot's
  /// index.
  final PlateInputController _plateInput = PlateInputController();

  /// A tapped laptop keycap, routed through the attached plate's active slot.
  /// PlateInputController.submit is a no-op when the character isn't in the
  /// slot's alphabet, so the deck's Persian letters land only on letter slots
  /// and its digits only on digit slots — no hard-coded character checks here,
  /// and it keeps working for any plate of any country.
  void _onDeckKey(String label) {
    if (_typist.isRunning) return; // never fight the auto-typist
    if (label == kPlateBackspaceKey) {
      _plateInput.backspace();
      return;
    }
    _plateInput.submit(label);
  }

  /// Bumped on every device hop; captured by pending awaits so a stale run
  /// (a delayed typist start from a device we already left) bails out.
  int _generation = 0;

  /// The generation a typing run has already been kicked off for, so a repeated
  /// idle phase for the same device doesn't start a second run.
  int _startedGen = -1;

  /// Which plate slot currently holds focus, driving the tablet's letters
  /// pad via its alphabet. Null when focus is off the plate.
  int? _activeIndex;

  /// Latest validation of the German plate's typed value, or null when nothing
  /// has been flagged yet (empty letter slot, or a non-German device is shown).
  /// Drives the tablet plate's active-field colour: red when invalid. Reset on
  /// every content swap, same as [_activeIndex].
  GermanPlateValidationResult? _germanValidation;

  /// Watches [_bloc]'s state so typed German values can be re-validated. Re-
  /// subscribed on every content swap because [_bloc] is recreated there.
  StreamSubscription<PlateCardState>? _blocSub;

  void _setActiveIndex(int? index) {
    if (_activeIndex == index) return;
    setState(() => _activeIndex = index);
  }

  /// Barred keys for the tablet's keypad, derived from the active slot's
  /// group and the values already typed before it. Empty when the active
  /// slot isn't in a barred group (or there is none).
  Set<String> _unavailableKeysFor(PlateCardState state) {
    final index = _activeIndex;
    if (index == null) return const {};
    final spec = specFor(DeviceType.tablet);
    final values = state.plateNumber.values;
    PlateTextGroup? groupContaining(String key) {
      for (final g in spec.textGroups) {
        if (g.key == key && g.indices.contains(index)) return g;
      }
      return null;
    }

    String valueBeforeActive(PlateTextGroup group) {
      final buffer = StringBuffer();
      for (final i in group.indices) {
        if (i >= index) continue;
        buffer.write(i < values.length ? (values[i] ?? '') : '');
      }
      return buffer.toString();
    }

    final serialGroup = groupContaining('serial');
    if (serialGroup != null) {
      return GermanPlateValidator.barredNextDigits(
        valueBeforeActive(serialGroup),
      );
    }
    final lettersGroup = groupContaining('letters');
    if (lettersGroup != null) {
      return GermanPlateValidator.barredNextLetters(
        valueBeforeActive(lettersGroup),
      );
    }
    return const {};
  }

  /// Subscribes [_validateGermanPlate] to the current [_bloc], dropping any
  /// subscription to a previous (now-closed) bloc first.
  void _listenToBloc() {
    _blocSub?.cancel();
    _blocSub = _bloc.stream.listen(_validateGermanPlate);
  }

  /// Re-derives [_germanValidation] from a fresh plate state. Only meaningful
  /// while the German plate is on screen; a no-op for other devices.
  void _validateGermanPlate(PlateCardState state) {
    if (!mounted || _contentDevice != DeviceType.tablet) return;
    final spec = specFor(DeviceType.tablet);
    final values = state.plateNumber.values;
    // Don't flag anything red while the identifier letter is still blank — an
    // empty letter always fails the regex, which would be noise, not signal.
    if (spec.valueOfGroup('letters', values).isEmpty) {
      if (_germanValidation != null) {
        setState(() => _germanValidation = null);
      }
      return;
    }
    final result = GermanPlateValidator.validateValues(spec, values);
    // Only `isValid` is rendered from this (it picks the underline colour), and
    // this fires on EVERY bloc emission — i.e. every keystroke. Rebuilding the
    // stage each time meant a new DeviceFrame, a fresh page on the glass and a
    // fresh keypad per character. Store the result either way; rebuild only
    // when the thing actually drawn from it changes.
    if (_germanValidation?.isValid == result.isValid) {
      _germanValidation = result;
      return;
    }
    setState(() => _germanValidation = result);
  }

  @override
  void initState() {
    super.initState();
    _typist.addListener(_syncPressedKey);
    _listenToBloc();
    // The first device never fires a transition phase, so kick it off directly
    // once the tree is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTyping());
  }

  @override
  void dispose() {
    _typist.removeListener(_syncPressedKey);
    _typist.dispose();
    _pressedKey.dispose();
    _blocSub?.cancel();
    _bloc.close();
    _controller.dispose();
    _plateInput.dispose();
    super.dispose();
  }

  void _onDeviceChanged(DeviceType device) {
    _generation++;
    _typist.cancel();
    // Only the frame starts reshaping now. The plate + its bloc stay on the
    // outgoing device until it has faded out; _onContentSwap does the hand-off.
    // DeviceCycle rebuilds its builder as part of the same advance, so the new
    // frame device is picked up without a setState here.
    _frameDevice = device;
    widget.onFrameDeviceChanged?.call(device);
  }

  /// Fired by [DeviceFrame] the moment content opacity hits zero, as the frame
  /// starts morphing — the outgoing plate is already invisible, so its bloc can
  /// be closed and replaced without a visible flash.
  void _onContentSwap() {
    if (!mounted) return;
    _bloc.close();
    _contentDevice = _frameDevice;
    _bloc = PlateCardBloc(specFor(_contentDevice));
    _activeIndex = null;
    _germanValidation = null;
    _listenToBloc();
    setState(() {});
  }

  void _onPhase(DeviceTransitionPhase phase) {
    widget.onPhaseChanged?.call(phase);
    // At idle the content has fully faded back in, so it's safe to start typing.
    if (phase == DeviceTransitionPhase.idle) _maybeStartTyping();
  }

  void _maybeStartTyping() {
    if (!mounted || _startedGen == _generation) return;
    _startedGen = _generation;
    _runTyping(_generation);
  }

  Future<void> _runTyping(int gen) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted || gen != _generation) return;

    final device = _contentDevice;
    final config = demoConfigs[device]!;
    await _typist.run(
      bloc: _bloc,
      spec: config.spec,
      controller: _plateInput,
      steps: config.script,
      useLetterPicker: false,
      onSlotChanged: config.showsValidation ? _setActiveIndex : null,
      context: context,
    );
    if (!mounted || gen != _generation) return;

    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted || gen != _generation) return;
    _controller.advance();
  }

  @override
  Widget build(BuildContext context) {
    return DeviceCycle(
      controller: _controller,
      onDeviceChanged: _onDeviceChanged,
      builder: (context, device) {
        // Isolate the device + plate in its own layer. It is expensive to
        // raster (perspective transform, nested FittedBoxes, clips and live
        // TextFields), and on Linux an instant window maximise that forces a
        // full re-raster of it can miss the GL embedder's frame deadline and
        // crash the app with "Timed out waiting for OpenGL frame". A
        // RepaintBoundary lets the resize composite the cached layer instead
        // of re-rendering it from scratch.
        //
        // Keystrokes no longer rebuild anything here: the pressed key travels
        // down as [_pressedKey], and only the widgets that draw a highlight
        // subscribe to it.
        return RepaintBoundary(child: _buildDevice(device));
      },
    );
  }

  Widget _buildDevice(DeviceType frameDevice) {
    // The shell morphs to [frameDevice], but the plate on the glass stays on
    // [_contentDevice] until the swap, so the outgoing plate keeps rendering
    // through its fade-out instead of being replaced the instant the hop fires.
    final contentDevice = _contentDevice;
    final config = demoConfigs[contentDevice]!;
    // The active slot's alphabet, not its position, decides whether the
    // tablet's letters pad shows: a digit-only alphabet keeps the digit grid,
    // anything else slides the letters layer in.
    final activeIndex = _activeIndex;
    final activeAlphabet = activeIndex == null
        ? null
        : config.spec.slotAt(activeIndex)?.alphabet;
    final showLetters = activeAlphabet != null && !activeAlphabet.isNumeric;
    return DeviceFrame(
      device: frameDevice,
      onPhaseChanged: _onPhase,
      onContentSwap: _onContentSwap,
      deckPressedKey: _pressedKey,
      onDeckKey: _onDeckKey,
      builder: (context, _) => PlateDisplay(
        spec: config.spec,
        mode: PlateMode.input,
        // activeColor is the completed-field underline colour; swap it to red
        // for the tablet's German plate when the typed value is invalid (e.g. a
        // forbidden letter combination). Other devices keep the accent.
        activeColor:
            config.showsValidation && _germanValidation?.isValid == false
            ? PosterTokens.invalid
            : PosterTokens.accent,
        bloc: _bloc,
        // The laptop deck already carries letter keys, so its letter comes in
        // through the library's on-screen-keypad mode instead of the modal
        // picker. Other devices keep their platform default.
        inputSource: config.inputSource,
        onActiveIndexChanged: config.showsValidation ? _setActiveIndex : null,
        controller: config.usesController ? _plateInput : null,
        showBackdrop: true,
        plateWidthFactor: config.plateWidthFactor,
        // The pad watches the pressed key itself, so the twice-per-keystroke
        // flash rebuilds individual keys rather than this whole page.
        //
        // The barred-key set is the one thing here that does have to track the
        // typed value, so the full pad sits under a BlocBuilder scoped to
        // itself — the recompute stays local instead of dragging the stage,
        // the device shell and the plate along with it.
        keyboard: !config.showsKeypad
            ? null
            : !config.compactKeypad
            ? BlocBuilder<PlateCardBloc, PlateCardState>(
                bloc: _bloc,
                builder: (context, state) => PlateKeypad(
                  highlightedKey: null,
                  highlightedKeyListenable: _pressedKey,
                  compact: false,
                  showLetters: showLetters,
                  digitAlphabet: PlateAlphabet.latinDigits,
                  letterAlphabet: PlateAlphabet.latinUppercase,
                  activeAlphabet: activeAlphabet,
                  // NOTE the deliberate demo tension: the auto-typist commits
                  // via bloc.add and is unaffected by key enabledness, so the
                  // scripted "88" red beat still plays; greying protects only
                  // interactive taps.
                  unavailableKeys: _unavailableKeysFor(state),
                  theme: const PlateKeypadTheme(
                    highlight: PosterTokens.keypadHighlight,
                    keyBorder: PosterTokens.hairline,
                  ),
                  onKey: (key) => key == kPlateBackspaceKey
                      ? _plateInput.backspace()
                      : _plateInput.submit(key),
                ),
              )
            // The compact pad bars nothing, so it never needs the bloc: built
            // once, and only its keys react to a flash.
            : PlateKeypad(
                highlightedKey: null,
                highlightedKeyListenable: _pressedKey,
                compact: config.compactKeypad,
                theme: const PlateKeypadTheme(
                  highlight: PosterTokens.keypadHighlight,
                  keyBorder: PosterTokens.hairline,
                ),
              ),
      ),
    );
  }
}
