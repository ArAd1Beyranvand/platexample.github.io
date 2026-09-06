import 'package:flutter/material.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:core_plate/core_plate.dart';

import '../device_preview/device_config.dart';
import '../device_preview/device_frame.dart';
import '../device_preview/device_transition.dart';
import '../poster/poster_tokens.dart';
import '../showcase/demo_config.dart';
import '../showcase/device_cycle.dart';
import '../showcase/plate_mirror.dart';
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

  /// Drives the plate type shown and its backing controller; lags
  /// [_frameDevice],
  /// only catching up during the blank hold once the outgoing plate has faded
  /// out (see [_onContentSwap]).
  DeviceType _contentDevice = DeviceType.desktop;

  /// The plate's characters for the content device, recreated on every content
  /// swap so each plate starts blank. It is also the handle the tablet's keypad,
  /// the laptop's deck keys and the auto-typist drive entry through: one object
  /// where there used to be a bloc for the value and a controller for the focus.
  /// [PlateDisplay] hands it straight to its [PlateCanvas].
  late PlateController _plate = PlateController(spec: specFor(_contentDevice));

  /// The read-only second plate's value, on the devices that show two — the
  /// laptop, stacking Yemen's 2026 unified plate over the 1993 northern one,
  /// and the tablet, stacking a legacy West Bank plate over a Gaza plate. Null
  /// on the phone, which shows one.
  PlateController? _secondary;

  /// Copies each committed value from [_plate] onto [_secondary]. Live for
  /// as long as a two-plate device is on screen.
  VoidCallback? _mirror;

  /// Points [_secondary] and [_mirror] at the content device, discarding
  /// whatever the outgoing device left behind.
  ///
  /// The mirror is a listener on the controller rather than anything in the
  /// tree because the second plate has to keep up with the auto-typist even
  /// while the stage itself is not rebuilding — keystrokes deliberately do not
  /// rebuild this subtree (see [_pressedKey]).
  void _installMirror() {
    final previous = _mirror;
    if (previous != null) _plate.removeListener(previous);
    _mirror = null;
    _secondary?.dispose();
    _secondary = null;

    final config = demoConfigs[_contentDevice]!;
    final secondarySpec = config.secondarySpec;
    final pairs = config.mirrorPairs;
    // Both or neither: a second spec with no pairing would render a plate that
    // never fills in, and a pairing with no spec has nothing to write to.
    assert((secondarySpec == null) == (pairs == null));
    if (secondarySpec == null || pairs == null) return;

    final secondary = PlateController(spec: secondarySpec);
    _secondary = secondary;

    void write() {
      // The whole value at once: `setValues` notifies once for the write, so
      // replaying every slot on each keystroke costs one rebuild pass, not
      // seven.
      secondary.setValues(
        mirrorByGroup(
          from: config.spec,
          to: secondarySpec,
          values: _plate.values,
          pairs: pairs,
        ),
      );
    }

    // Once up front, then on every change. A listener only fires on changes, so
    // without this pass the slots a spec fills from a one-character alphabet —
    // Gaza's leading `3`, printed on every Gaza plate ever issued — would sit
    // blank until the first keystroke arrived to trigger them.
    write();
    _mirror = write;
    _plate.addListener(write);
  }

  /// A tapped laptop keycap, routed through the attached plate's active slot.
  /// PlateController.submit is a no-op when the character isn't in the
  /// slot's alphabet, so the deck's Persian letters land only on letter slots
  /// and its digits only on digit slots — no hard-coded character checks here,
  /// and it keeps working for any plate of any country.
  void _onDeckKey(String label) {
    if (_typist.isRunning) return; // never fight the auto-typist
    if (label == kPlateBackspaceKey) {
      _plate.backspace();
      return;
    }
    _plate.submit(label);
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

  void _setActiveIndex(int? index) {
    if (_activeIndex == index) return;
    setState(() => _activeIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _typist.addListener(_syncPressedKey);
    _installMirror();
    // The first device never fires a transition phase, so kick it off directly
    // once the tree is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartTyping());
  }

  @override
  void dispose() {
    _typist.removeListener(_syncPressedKey);
    _typist.dispose();
    _pressedKey.dispose();
    final mirror = _mirror;
    if (mirror != null) _plate.removeListener(mirror);
    _secondary?.dispose();
    _plate.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDeviceChanged(DeviceType device) {
    _generation++;
    _typist.cancel();
    // Only the frame starts reshaping now. The plate + its controller stay on the
    // outgoing device until it has faded out; _onContentSwap does the hand-off.
    // DeviceCycle rebuilds its builder as part of the same advance, so the new
    // frame device is picked up without a setState here.
    _frameDevice = device;
    widget.onFrameDeviceChanged?.call(device);
  }

  /// Fired by [DeviceFrame] the moment content opacity hits zero, as the frame
  /// starts morphing — the outgoing plate is already invisible, so its
  /// controller can be disposed and replaced without a visible flash.
  void _onContentSwap() {
    if (!mounted) return;
    final mirror = _mirror;
    if (mirror != null) _plate.removeListener(mirror);
    _mirror = null;
    _plate.dispose();
    _contentDevice = _frameDevice;
    _plate = PlateController(spec: specFor(_contentDevice));
    _installMirror();
    _activeIndex = null;
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
      spec: config.spec,
      controller: _plate,
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
        // Null for the plates printed black on white; the plates that ship
        // their own colours — the Palestinian green-on-white, both Yemeni ones
        // — carry them here.
        baseTheme: config.theme,
        // The laptop stacks Yemen's two current systems and the tablet stacks
        // Palestine's, both plates filling in from the same keystrokes. See
        // plate_mirror.dart, and its caveat that the crossover is a display
        // device rather than a claim about a vehicle.
        secondarySpec: config.secondarySpec,
        secondaryTheme: config.secondaryTheme,
        secondaryController: _secondary,
        activeColor: PosterTokens.accent,
        // The plate judges itself now: with a validator and autoValidate on, it
        // paints its own completed-field underline red when the typed value is
        // invalid. The stage neither watches the value nor holds a verdict — a
        // host that wants its own timing would read
        // PlateController.validation instead.
        alertColor: PosterTokens.invalid,
        validator: config.validator,
        autoValidate: config.showsValidation,
        // The laptop deck already carries letter keys, so its letter comes in
        // through the library's on-screen-keypad mode instead of the modal
        // picker. Other devices keep their platform default.
        inputSource: config.inputSource,
        // Core ships no built-in picker since the keypad split; hand it the
        // one from plate_keypad for any `chosen`-alphabet slot.
        onChooseCharacter: (alphabet) =>
            PlateCharacterPicker.show(context, alphabet),
        onActiveIndexChanged: config.showsValidation ? _setActiveIndex : null,
        // Always passed now, on every device: this is where the plate's
        // characters live, not just a focus handle, so the canvas has to render
        // from it. `usesController` still says which devices drive entry from
        // an app-supplied pad.
        controller: _plate,
        showBackdrop: true,
        plateWidthFactor: config.plateWidthFactor,
        // The pad watches the pressed key itself, so the twice-per-keystroke
        // flash rebuilds individual keys rather than this whole page.
        //
        // The full pad used to sit under a BlocBuilder scoped to itself,
        // because the barred-key set had to track the typed value. Nothing in
        // it depends on plate state any more, so the BlocBuilder is gone and
        // the pad is built from the stage's own state alone. The rebuild was
        // dropped, not hoisted.
        keyboard: !config.showsKeypad
            ? null
            : !config.compactKeypad
            ? PlateKeypad(
                highlightedKey: null,
                highlightedKeyListenable: _pressedKey,
                compact: false,
                showLetters: showLetters,
                digitAlphabet: PlateAlphabet.latinDigits,
                letterAlphabet: PlateAlphabet.latinUppercase,
                activeAlphabet: activeAlphabet,
                // The demo now types a forbidden value by hand or by script —
                // every key in the active alphabet is tappable either way — and
                // the plate goes red once it lands. That is the behaviour being
                // demonstrated.
                theme: const PlateKeypadTheme(
                  highlight: PosterTokens.keypadHighlight,
                  keyBorder: PosterTokens.hairline,
                ),
                onKey: (key) => key == kPlateBackspaceKey
                    ? _plate.backspace()
                    : _plate.submit(key),
              )
            : PlateKeypad(
                highlightedKey: null,
                highlightedKeyListenable: _pressedKey,
                compact: config.compactKeypad,
                // The compact pad drives the bicycle plate, which is Persian —
                // stated here now that PlateKeypad has no country default.
                digitAlphabet: PersianAlphabets.digits,
                letterAlphabet: PersianAlphabets.plateLetters,
                theme: const PlateKeypadTheme(
                  highlight: PosterTokens.keypadHighlight,
                  keyBorder: PosterTokens.hairline,
                ),
              ),
      ),
    );
  }
}
