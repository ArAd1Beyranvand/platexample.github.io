import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_keypad/plate_keypad.dart';

import '../design/tokens.dart';
import '../widgets/controls.dart';
import 'plate_animation_demo.dart';

/// How a slot's alphabet is named in the status line: "2 digits",
/// "a Persian letter", "a letter A–Z".
String describeSlots(PlateAlphabet alphabet, int count) {
  if (alphabet.isNumeric) return count == 1 ? 'a digit' : '$count digits';
  final String script = scriptOf(alphabet);
  if (script == 'A–Z') {
    return count == 1 ? 'a letter A–Z' : '$count letters A–Z';
  }
  return count == 1 ? 'a $script letter' : '$count $script letters';
}

/// "A–Z" for Latin capitals, otherwise the script's English name.
String scriptOf(PlateAlphabet alphabet) {
  final String all = alphabet.characters.join();
  bool any(int lo, int hi) => all.runes.any((int r) => r >= lo && r <= hi);
  if (RegExp('[پچژگکی]').hasMatch(all)) return 'Persian';
  if (any(0x0600, 0x06FF)) return 'Arabic';
  if (any(0x0400, 0x04FF)) return 'Cyrillic';
  if (any(0x0E80, 0x0EFF)) return 'Lao';
  if (any(0x0E00, 0x0E7F)) return 'Thai';
  if (any(0x1780, 0x17FF)) return 'Khmer';
  if (any(0x1000, 0x109F)) return 'Myanmar';
  if (any(0xAC00, 0xD7AF) || any(0x1100, 0x11FF)) return 'Korean';
  if (any(0x0900, 0x097F)) return 'Devanagari';
  return 'A–Z';
}

/// A letter the user picks rather than types (Persian series letters,
/// Lao provinces), or any non-Latin letter slot.
bool isPickedAlphabet(PlateAlphabet alphabet) =>
    !alphabet.isNumeric &&
    (alphabet.input == AlphabetInput.chosen || scriptOf(alphabet) != 'A–Z');

int? firstEmpty(List<String?> values) {
  for (int i = 0; i < values.length; i++) {
    if (values[i] == null || values[i]!.isEmpty) return i;
  }
  return null;
}

/// The verdict on a full plate: the entry's validator, else the spec's
/// restrictions, else valid.
PlateValidation verdictOf(
  PlateSpec spec,
  List<String?> values,
  PlateValidator? validator,
) {
  final PlateEntry entry = PlateEntry(spec: spec, values: values);
  return validator?.validate(entry) ??
      restrictionVerdict(entry) ??
      const PlateValidation.valid();
}

/// A live PlateCanvas with the DS status line under it and, when the next
/// slot takes a picked letter, the inline letter picker.
class LivePlate extends StatefulWidget {
  const LivePlate({
    super.key,
    required this.controller,
    required this.validName,
    this.theme,
    this.country,
    this.validator,
    this.inputSource,
    this.showInvalidNote = false,
    this.keypadBelow,
    this.fixedSize = false,
  });

  final PlateController controller;

  /// Shown after **Valid**, e.g. "Iran private car".
  final String validName;
  final PlateTheme? theme;
  final PlateCountry? country;
  final PlateValidator? validator;
  final PlateInputSource? inputSource;

  /// The "Validators flag a plate…" note under an invalid status.
  final bool showInvalidNote;

  /// Slotted between the status/picker and whatever follows (the keypad).
  final Widget? keypadBelow;

  /// Keeps the card the same height whatever the spec: the plate scales into
  /// a fixed box, the status line keeps two lines, and the keypad replaces
  /// the inline letter picker.
  final bool fixedSize;

  @override
  State<LivePlate> createState() => _LivePlateState();
}

class _LivePlateState extends State<LivePlate> {
  String? _hint;
  Timer? _hintTimer;

  PlateController get _c => widget.controller;

  // TEMPORARY DEMO: drives PlateAnimationDemoBar below the plate.
  final PlateAnimationController _anim = PlateAnimationController();
  Set<PlatePartKind> _keep = const <PlatePartKind>{};

  @override
  void initState() {
    super.initState();
    _c.addListener(_changed);
    _c.rejection.addListener(_rejected);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void didUpdateWidget(LivePlate old) {
    super.didUpdateWidget(old);
    if (!identical(old.controller, _c)) {
      old.controller.removeListener(_changed);
      old.controller.rejection.removeListener(_rejected);
      _c.addListener(_changed);
      _c.rejection.addListener(_rejected);
    }
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _anim.dispose();
    HardwareKeyboard.instance.removeHandler(_onKey);
    _c.removeListener(_changed);
    _c.rejection.removeListener(_rejected);
    super.dispose();
  }

  /// The canvas can notify while it builds (attaching validation), when a
  /// synchronous setState would assert; those rebuilds wait for the frame.
  void _changed() => _safeSetState(() {});

  void _safeSetState(VoidCallback fn) {
    if (SchedulerBinding.instance.schedulerPhase !=
        SchedulerPhase.persistentCallbacks) {
      setState(fn);
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(fn);
    });
  }

  void _rejected() {
    final PlateRestriction? r = _c.rejection.value;
    if (r != null) _flash(r.reason);
  }

  /// Observes (never consumes) keys typed into the focused plate, to explain
  /// a character the slot refuses. The canvas itself just ignores it.
  bool _onKey(KeyEvent event) {
    final int? index = _c.activeIndex;
    final String? ch = event.character;
    if (event is! KeyDownEvent || index == null || ch == null) return false;
    if (ch.trim().isEmpty || ch.runes.length != 1) return false;
    final PlateSlot? slot = _c.spec.slotAt(index);
    if (slot != null && !slot.alphabet.accepts(ch)) {
      _flash('Slot ${index + 1} takes ${describeSlots(slot.alphabet, 1)}.');
    }
    return false;
  }

  void _flash(String text) {
    _hintTimer?.cancel();
    _safeSetState(() => _hint = text);
    _hintTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _hint = null);
    });
  }

  /// The slot the next character goes into: the caret, else the first gap.
  int? get _next {
    final int? active = _c.activeIndex;
    if (active != null) return active;
    return firstEmpty(_c.values);
  }

  void _pick(String character) {
    final int? next = _next;
    if (next == null) return;
    if (_c.activeIndex == null) _c.focusSlot(next);
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.submit(character));
  }

  /// Plate height as a share of the card width; wider or taller plates are
  /// scaled down to fit rather than resizing the card.
  static const double _plateAspect = 0.3;

  Widget _plateBox(Widget canvas) {
    if (!widget.fixedSize) return canvas;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) => SizedBox(
        height: c.maxWidth * _plateAspect,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(width: c.maxWidth, child: canvas),
        ),
      ),
    );
  }

  Widget _statusBox(Widget status) =>
      widget.fixedSize ? SizedBox(height: 44, child: status) : status;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PlateSpec spec = _c.spec;
    final List<String?> values = _c.values;
    final int? next = firstEmpty(values);
    final PlateValidation? verdict = next == null
        ? verdictOf(spec, values, widget.validator)
        : null;

    final Color dot;
    String? word;
    Color wordColor = t.text;
    final String text;
    if (_hint != null) {
      dot = t.error;
      text = _hint!;
    } else if (verdict != null && !verdict.isValid) {
      dot = t.error;
      word = 'Not valid';
      wordColor = t.error;
      text = verdict.reason!;
    } else if (verdict != null) {
      dot = t.ok;
      word = 'Valid';
      wordColor = t.ok;
      text = widget.validName;
    } else {
      dot = t.subtle;
      final PlateAlphabet a = spec.slots[next!].alphabet;
      int run = 0;
      while (next + run < spec.slotCount &&
          values[next + run] == null &&
          identical(spec.slots[next + run].alphabet, a) &&
          identical(spec.groupAt(next + run), spec.groupAt(next))) {
        run++;
      }
      final String what = describeSlots(a, run);
      text =
          (next == 0 ? 'Type $what to start' : 'Now $what') +
          (isPickedAlphabet(a) ? '. Pick one below.' : '.');
    }

    final int? pickAt = _next;
    final PlateAlphabet? pickAlphabet = pickAt == null
        ? null
        : spec.slotAt(pickAt)?.alphabet;
    final bool showPicker =
        !widget.fixedSize &&
        next != null &&
        pickAlphabet != null &&
        isPickedAlphabet(pickAlphabet);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _plateBox(
          PlateCanvas(
            spec: spec,
            controller: _c,
            theme: widget.theme,
            country: widget.country,
            inputSource: widget.inputSource,
            validator: widget.validator,
            animation: _anim,
            specTransition: PlateSpecTransition(keepKinds: _keep),
            onChooseCharacter: (PlateAlphabet a) =>
                PlateCharacterPicker.show(context, a),
          ),
        ),
        // TEMPORARY DEMO control.
        const SizedBox(height: 8),
        PlateAnimationDemoBar(
          controller: _anim,
          spec: spec,
          keep: _keep,
          onKeepChanged: (k) => setState(() => _keep = k),
        ),
        const SizedBox(height: 14),
        _statusBox(
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dot,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        if (word != null)
                          TextSpan(
                            text: '$word · ',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: wordColor,
                            ),
                          ),
                        TextSpan(text: text),
                      ],
                    ),
                    maxLines: widget.fixedSize ? 2 : null,
                    overflow: widget.fixedSize ? TextOverflow.ellipsis : null,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: t.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.showInvalidNote && verdict != null && !verdict.isValid)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 18),
            child: Text(
              'Validators flag a plate. They never block a keystroke.',
              style: TextStyle(fontSize: 13, color: t.subtle),
            ),
          ),
        if (showPicker) ...<Widget>[
          const SizedBox(height: 14),
          LetterPicker(alphabet: pickAlphabet, onPick: _pick),
        ],
        if (widget.keypadBelow != null) ...<Widget>[
          const SizedBox(height: 16),
          widget.keypadBelow!,
        ],
      ],
    );
  }
}

/// The package keypad wired to [controller], showing the alphabets of the
/// spec's slots and highlighting the one the next character goes into.
class SlotKeypad extends StatelessWidget {
  const SlotKeypad({super.key, required this.controller, this.maxWidth = 320});

  final PlateController controller;
  final double maxWidth;

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: controller, builder: _buildKeypad);

  Widget _buildKeypad(BuildContext context, Widget? _) {
    final PlateSpec spec = controller.spec;
    final Iterable<PlateAlphabet> all = spec.slots.map(
      (PlateSlot s) => s.alphabet,
    );
    final PlateAlphabet digits = all.firstWhere(
      (PlateAlphabet a) => a.isNumeric,
      orElse: () => all.first,
    );
    final PlateAlphabet letters = all.firstWhere(
      (PlateAlphabet a) => !a.isNumeric,
      orElse: () => digits,
    );
    final int? at = controller.activeIndex ?? firstEmpty(controller.values);
    final PlateAlphabet? active = at == null ? null : spec.slotAt(at)?.alphabet;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: PlateKeypad(
          highlightedKey: null,
          digitAlphabet: digits,
          letterAlphabet: letters,
          activeAlphabet: active,
          // Which panel is up: letters only while the next slot takes one.
          showLetters: active != null && !active.isNumeric,
          onKey: (String key) {
            if (key == kPlateBackspaceKey) {
              controller.backspace();
            } else {
              controller.submit(key);
            }
          },
        ),
      ),
    );
  }
}

/// The spec's own letters as chips, from the slot's alphabet (never a
/// hard-coded list).
class LetterPicker extends StatelessWidget {
  const LetterPicker({super.key, required this.alphabet, required this.onPick});

  final PlateAlphabet alphabet;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      textDirection: alphabet.direction,
      children: <Widget>[
        for (final String c in alphabet.characters)
          PdTappable(
            onTap: () => onPick(c),
            width: 40,
            height: 40,
            border: t.divider,
            hoverColor: t.accentSoft,
            semanticLabel: 'Letter ${alphabet.render(c)}',
            child: Center(
              child: Text(
                alphabet.render(c),
                style: TextStyle(
                  fontFamily: PdFonts.persian,
                  fontSize: 17,
                  color: t.text,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A plate in display mode with fixed values (the landing's example cards).
class StaticPlate extends StatefulWidget {
  const StaticPlate({
    super.key,
    required this.spec,
    this.values,
    this.theme,
    this.country,
  });

  final PlateSpec spec;
  final List<String?>? values;
  final PlateTheme? theme;
  final PlateCountry? country;

  @override
  State<StaticPlate> createState() => _StaticPlateState();
}

class _StaticPlateState extends State<StaticPlate> {
  late final PlateController _c = PlateController(spec: widget.spec);

  @override
  void initState() {
    super.initState();
    if (widget.values != null) _c.setValues(widget.values!);
  }

  @override
  void didUpdateWidget(StaticPlate old) {
    super.didUpdateWidget(old);
    if (!identical(old.spec, widget.spec)) _c.adoptSpec(widget.spec);
    if (widget.values != null) _c.setValues(widget.values!);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeFocus(
    child: PlateCanvas(
      spec: widget.spec,
      mode: PlateMode.display,
      controller: _c,
      theme: widget.theme,
      country: widget.country,
      onChooseCharacter: (_) async => null,
    ),
  );
}
