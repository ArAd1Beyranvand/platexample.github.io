import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:core_plate/core_plate.dart';

/// One step in a typing script: either a keystroke into a slot, or a
/// backspace. `pauseAfter: true` marks a natural break (a burst just
/// finished, or a letter was just entered) — the typist waits the slower
/// [PlateTypist.gap] there. Everywhere else it waits the quicker
/// [PlateTypist.burstGap], so a run reads as bursts of digits rather than
/// one evenly-spaced drip. [holdAfter], when set, overrides that gap/burstGap
/// choice with an exact duration — for a deliberate beat (e.g. lingering on
/// an invalid state) rather than the run's usual rhythm.
sealed class TypistStep {
  const TypistStep({this.pauseAfter = false, this.holdAfter});

  final bool pauseAfter;
  final Duration? holdAfter;
}

/// Types [char] into the slot at [index].
class KeyStep extends TypistStep {
  const KeyStep(this.index, this.char, {super.pauseAfter, super.holdAfter});

  final int index;
  final String char;
}

/// Deletes a character via [PlateController.backspace] — the active
/// slot if it holds a value, otherwise the previous slot.
class BackspaceStep extends TypistStep {
  const BackspaceStep({super.pauseAfter, super.holdAfter});
}

/// Builds a typing script from a plate's [values], so any entry that ships
/// `sampleValues` can be auto-typed without a hand-authored [TypistStep] list.
///
/// This is what lets the showcase draw a random country on each device and the
/// discover page auto-type any card, in place of the hand-authored per-plate
/// scripts the showcase used to carry. A hand-written script could tune one
/// plate's *rhythm and story* — a deliberate pause on a letter, a hold on a
/// one-digit invalid state; this builder makes no such judgement. It walks
/// the slots in index order and:
///
/// - Skips a slot whose alphabet holds exactly one character (a printed
///   constant, like Gaza's leading `3`): the plate fills it itself, and typing
///   it would flash a key for a character the visitor never chose.
/// - Skips an empty ([values] holds null or '') slot — a partial plate types
///   only what it has.
/// - Marks a natural break ([TypistStep.pauseAfter]) after every letter slot
///   and at the end of each run of digits it can see, so a plate reads as
///   bursts rather than an even drip — the same rhythm the hand-written scripts
///   aim for.
List<TypistStep> scriptFromValues({
  required PlateSpec spec,
  required List<String?> values,
}) {
  final steps = <TypistStep>[];
  // The index of the last step actually emitted, so pauses can be attached
  // retroactively when a burst ends (the slot that ends it is the one before
  // the break, not the one that starts the next burst).
  int lastEmitted = -1;
  for (var i = 0; i < spec.slots.length; i++) {
    final slot = spec.slots[i];
    // A one-character alphabet is a printed constant, not a keystroke.
    if (slot.alphabet.characters.length <= 1) continue;
    final char = i < values.length ? values[i] : null;
    if (char == null || char.isEmpty) continue;

    final isLetter = !slot.alphabet.isNumeric;
    // A letter is its own beat: pause after it, and pause after the digit that
    // ran up to it so the burst before the letter closes cleanly.
    if (isLetter && lastEmitted >= 0) {
      steps[lastEmitted] = _withPause(steps[lastEmitted]);
    }
    steps.add(KeyStep(i, char, pauseAfter: isLetter));
    lastEmitted = steps.length - 1;
  }
  return steps;
}

/// Returns [step] with [TypistStep.pauseAfter] set, preserving its kind.
TypistStep _withPause(TypistStep step) => switch (step) {
  KeyStep(:final index, :final char, :final holdAfter) => KeyStep(
    index,
    char,
    pauseAfter: true,
    holdAfter: holdAfter,
  ),
  BackspaceStep(:final holdAfter) => BackspaceStep(
    pauseAfter: true,
    holdAfter: holdAfter,
  ),
};

/// Tracks which slot the letters pad is currently showing across a [PlateTypist.run],
/// so the pad only rises or falls when the kind of slot actually changes.
/// Null means the digit pad is up.
class _LetterPadState {
  int? shown;
}

/// Auto-types a plate one slot at a time, flashing each key as it goes.
///
/// [activeKey] is the label of the key currently held down (for the laptop deck
/// or the on-screen keypad to highlight); it is null between keystrokes. Drive a
/// run with [run] and stop it early with [cancel]; every `await` inside a run is
/// guarded so a cancel (or a dispose) unwinds the walk immediately.
class PlateTypist extends ChangeNotifier {
  /// Label currently being "pressed", or null between keystrokes.
  String? activeKey;

  bool _running = false;
  bool _cancelled = true;
  bool _disposed = false;

  /// The in-flight wait from [_sleep], if any. Tracked so [cancel] and
  /// [dispose] can cancel the real [Timer] underneath rather than merely
  /// flipping a flag [_sleep] checks once the delay has already elapsed —
  /// otherwise a disposed typist still leaves a pending timer alive for up to
  /// [gap]/[burstGap]/the loop's hold, which widget tests that assert no
  /// timers survive teardown catch immediately.
  Timer? _sleepTimer;
  Completer<bool>? _sleepCompleter;

  bool get isRunning => _running;

  /// Walks [steps] in order against [controller], flashing each key for
  /// [flash]. [spec] resolves each [KeyStep.index] to its [PlateSlot] so a
  /// letter slot (non-numeric alphabet) is detected the same way the keypad
  /// decides whether to show its letters pad, rather than by a hardcoded
  /// index/char.
  ///
  /// One [PlateController] does both jobs: it writes the characters and it
  /// drives focus, so [BackspaceStep]s go through the same handle the on-screen
  /// keypad's backspace key uses.
  Future<void> run({
    required PlateSpec spec,
    required PlateController controller,
    required List<TypistStep> steps,
    required bool useLetterPicker,
    required BuildContext context,
    Duration gap = const Duration(milliseconds: 320),
    Duration burstGap = const Duration(milliseconds: 90),
    Duration flash = const Duration(milliseconds: 140),
    ValueChanged<int?>? onSlotChanged,
  }) async {
    _cancelled = false;
    _running = true;
    // Which slot is currently reported through onSlotChanged (i.e. which
    // pad is up): null means the digit pad, a slot index means the letters
    // pad is showing that slot's alphabet. Tracked at run level so the pad
    // only rises/falls when the kind actually changes, instead of once per
    // step.
    final padState = _LetterPadState();
    for (final step in steps) {
      if (_cancelled) break;
      final keepGoing = await _runStep(
        step,
        spec: spec,
        controller: controller,
        useLetterPicker: useLetterPicker,
        context: context,
        gap: gap,
        burstGap: burstGap,
        flash: flash,
        onSlotChanged: onSlotChanged,
        padState: padState,
      );
      if (!keepGoing) break;
    }

    _running = false;
    activeKey = null;
    onSlotChanged?.call(null);
    _notify();
  }

  /// Runs one [step]; returns false when the run should stop (cancelled or
  /// disposed mid-step).
  Future<bool> _runStep(
    TypistStep step, {
    required PlateSpec spec,
    required PlateController controller,
    required bool useLetterPicker,
    required BuildContext context,
    required Duration gap,
    required Duration burstGap,
    required Duration flash,
    required ValueChanged<int?>? onSlotChanged,
    required _LetterPadState padState,
  }) async {
    if (step is BackspaceStep) {
      activeKey = kPlateBackspaceKey;
      _notify();
      if (!await _sleep(flash)) return false;

      // Keystrokes land straight on the controller (see below), bypassing the real
      // focus chain PlateCanvas tracks its active slot through — so unless
      // something has already focused a slot, seed it before backspacing,
      // the same way re-entering the plate programmatically would.
      if (controller.activeIndex == null) controller.focusFirstEmpty();
      controller.backspace();

      activeKey = null;
      _notify();
      return _sleep(step.holdAfter ?? (step.pauseAfter ? gap : burstGap));
    }

    final keyStep = step as KeyStep;
    final slot = spec.slotAt(keyStep.index);
    final isLetterSlot = slot != null && !slot.alphabet.isNumeric;

    if (isLetterSlot) {
      if (useLetterPicker) {
        await _pickLetter(
          controller: controller,
          context: context,
          spec: spec,
          step: keyStep,
        );
        if (_cancelled) return false;
        return _sleep(keyStep.holdAfter ?? gap);
      }
      if (onSlotChanged != null) {
        if (padState.shown != keyStep.index) {
          final padAlreadyUp = padState.shown != null;
          onSlotChanged(keyStep.index);
          padState.shown = keyStep.index;
          if (!padAlreadyUp) {
            if (!await _sleep(
              kPlateKeypadSlide + const Duration(milliseconds: 80),
            )) {
              return false;
            }
          }
        }
        controller.focusSlot(keyStep.index);
        activeKey = keyStep.char;
        _notify();
        if (!await _sleep(flash)) return false;
        controller.setAt(keyStep.index, keyStep.char);
        _advanceCursor(spec: spec, controller: controller, from: keyStep.index);
        activeKey = null;
        _notify();
        return _sleep(keyStep.holdAfter ?? gap);
      }
    } else if (onSlotChanged != null && padState.shown != null) {
      onSlotChanged(null);
      padState.shown = null;
      if (!await _sleep(kPlateKeypadSlide + const Duration(milliseconds: 80))) {
        return false;
      }
    }

    // Press the key.
    controller.focusSlot(keyStep.index);
    activeKey = keyStep.char;
    _notify();
    if (!await _sleep(flash)) return false;

    controller.setAt(keyStep.index, keyStep.char);
    _advanceCursor(spec: spec, controller: controller, from: keyStep.index);

    // Release it.
    activeKey = null;
    _notify();
    return _sleep(keyStep.holdAfter ?? (keyStep.pauseAfter ? gap : burstGap));
  }

  /// Steps the cursor onto the slot the next character will land in, the
  /// instant the current one is committed.
  ///
  /// Characters are written straight to the controller rather than through
  /// [PlateController.submit], so nothing advances focus for us: without this
  /// the caret sat *on* the digit just typed until the next step's
  /// [PlateController.focusSlot] moved it, which through a whole run reads as
  /// the caret dropping a slot behind every keystroke and catching up a beat
  /// later. A real typist's caret is always one slot ahead of the last
  /// character, and at the end of the plate it stays where it is rather than
  /// wrapping back to the start.
  void _advanceCursor({
    required PlateSpec spec,
    required PlateController controller,
    required int from,
  }) {
    final next = spec.nextIndex(from);
    if (next != null) controller.focusSlot(next);
  }

  /// Opens [PlateCharacterPicker] and scrolls it to [step]'s character
  /// before committing the value.
  Future<void> _pickLetter({
    required PlateController controller,
    required BuildContext context,
    required PlateSpec spec,
    required KeyStep step,
  }) async {
    if (!context.mounted) return;

    final alphabet = spec.slotAt(step.index)!.alphabet;
    final target = alphabet.characters.indexOf(step.char);
    final scroll = FixedExtentScrollController(initialItem: 0);
    final navigator = Navigator.of(context);
    var sheetOpen = false;

    try {
      // Fire-and-forget: the sheet stays up until we pop it below.
      unawaited(
        PlateCharacterPicker.show(context, alphabet, scrollController: scroll),
      );
      sheetOpen = true;

      // Let the picker mount so the controller is attached before we scroll.
      if (!await _sleep(const Duration(milliseconds: 220))) return;
      if (scroll.hasClients) {
        await scroll.animateToItem(
          target,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      if (_cancelled) return;
      if (!await _sleep(const Duration(milliseconds: 400))) return;

      if (sheetOpen && navigator.canPop()) {
        navigator.pop();
        sheetOpen = false;
      }
      controller.setAt(step.index, step.char);
      _advanceCursor(spec: spec, controller: controller, from: step.index);
    } finally {
      if (sheetOpen && navigator.canPop()) navigator.pop();
      scroll.dispose();
    }
  }

  /// Awaits [d], returning false if the run was cancelled or disposed meanwhile.
  ///
  /// A real, cancellable [Timer] rather than a bare `Future.delayed`: [cancel]
  /// and [dispose] cancel it directly, so a stopped or torn-down typist has no
  /// timer left ticking in the background.
  Future<bool> _sleep(Duration d) {
    final completer = Completer<bool>();
    _sleepCompleter = completer;
    _sleepTimer = Timer(d, () {
      _sleepTimer = null;
      if (!completer.isCompleted) completer.complete(!_cancelled && !_disposed);
    });
    return completer.future;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Cancels [_sleepTimer] if one is waiting, unblocking whichever `await
  /// _sleep(...)` is in flight so the run unwinds immediately instead of at
  /// the timer's original due time.
  void _cancelSleep() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    final completer = _sleepCompleter;
    if (completer != null && !completer.isCompleted) completer.complete(false);
  }

  /// Aborts an in-flight [run]; the walk unwinds at its next guarded await.
  void cancel() {
    _cancelled = true;
    _running = false;
    activeKey = null;
    _cancelSleep();
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelled = true;
    _cancelSleep();
    super.dispose();
  }
}
