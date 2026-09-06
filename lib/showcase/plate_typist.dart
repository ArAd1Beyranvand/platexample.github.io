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

/// The keystrokes for the car plate ("91-ه-886-40"): '9' and '1' typed as a
/// quick burst, a pause, the letter, another pause, then '886' and '40' as
/// two more quick bursts.
const List<TypistStep> carScript = [
  KeyStep(0, '9'),
  KeyStep(1, '1', pauseAfter: true),
  KeyStep(2, 'ه', pauseAfter: true),
  KeyStep(3, '8'),
  KeyStep(4, '8'),
  KeyStep(5, '6', pauseAfter: true),
  KeyStep(6, '4'),
  KeyStep(7, '0'),
];

/// The keystrokes for the tablet demo: a legacy West Bank plate (`7·1234·40`),
/// mirrored live onto the Gaza plate below it (`3·1234·40`).
///
/// Slot 0 is the district code — `7` is the northern West Bank, registered
/// after 1995. Slots 1–4 are the serial. Slots 5–6 are the usage class, and
/// they are the whole point of the run:
///
/// - The run passes through an invalid state and comes back.
///   `PSWestBankLegacyValidator` stays quiet until the usage group has
///   something in it, so nothing goes red while the serial is being typed. The
///   first usage digit (`4`) leaves a one-digit code, which is not a legal
///   class — the plate goes red and holds there long enough to read. The second
///   digit (`0`) finishes it as `40`, which is valid, and the red clears.
/// - `40` means **private** on the West Bank plate and **municipality** on the
///   Gaza plate. The two code spaces are unrelated and share only their digits,
///   which is exactly why the two plates below are printed in different
///   colours from the same typed value.
///
/// The district digit is `7` rather than a rounder number because Gaza's
/// leading slot is a one-character alphabet: it fills itself with `3` and
/// never takes the district digit, and a `7` above a `3` makes that visible
/// instead of looking like a coincidence.
const List<TypistStep> palestineLegacyCarScript = [
  KeyStep(0, '7', pauseAfter: true),
  KeyStep(1, '1'),
  KeyStep(2, '2'),
  KeyStep(3, '3'),
  KeyStep(4, '4', pauseAfter: true),
  // One digit is an unfinished usage class, and the plate says so before the
  // second digit rescues it.
  KeyStep(5, '4', holdAfter: Duration(milliseconds: 1200)),
  KeyStep(6, '0'),
];

/// The keystrokes for the Yemeni laptop demo, typed into the 2026 unified
/// plate and mirrored live onto the 1993 northern plate below it.
///
/// Slots 0-4 are the five-digit vehicle number; slots 5-6 are the two-digit
/// code stacked in the blue side panel. The mirror sends the number to the
/// northern plate's serial and the side code to its governorate register, so
/// the whole run reads as one value written out in two grammars.
///
/// The run deliberately passes through an invalid state and comes back:
/// `YemenUnifiedValidator` stays quiet until the side code has something in
/// it, so nothing goes red while the number is being typed, and the first
/// side-code digit ("0") lands the plate on a one-digit code — invalid, and
/// painted red. It holds there long enough to read, then the second digit
/// ("6") finishes the code as `06`, which is Al Hudaydah on the northern
/// plate below. `3` was chosen as the number's leading digit because a
/// northern serial is never zero-padded.
const List<TypistStep> yemenUnifiedCarScript = [
  KeyStep(0, '3'),
  KeyStep(1, '4', pauseAfter: true),
  KeyStep(2, '7'),
  KeyStep(3, '1'),
  KeyStep(4, '9', pauseAfter: true),
  // Side code (slots 5-6): one digit is an unfinished code, and the plate
  // says so before the second digit rescues it.
  KeyStep(5, '0', holdAfter: Duration(milliseconds: 1200)),
  KeyStep(6, '6'),
];

/// The keystrokes for the bicycle plate: eight straight digits, no letter.
/// Typed as four quick pairs rather than an even drip — pausing after every
/// single digit made the longest plate of the three the slowest to watch.
const List<TypistStep> bicycleScript = [
  KeyStep(0, '9'),
  KeyStep(1, '1', pauseAfter: true),
  KeyStep(2, '8'),
  KeyStep(3, '8', pauseAfter: true),
  KeyStep(4, '6'),
  KeyStep(5, '4', pauseAfter: true),
  KeyStep(6, '0'),
  KeyStep(7, '4'),
];

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

    // Release it.
    activeKey = null;
    _notify();
    return _sleep(keyStep.holdAfter ?? (keyStep.pauseAfter ? gap : burstGap));
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
    } finally {
      if (sheetOpen && navigator.canPop()) navigator.pop();
      scroll.dispose();
    }
  }

  /// Awaits [d], returning false if the run was cancelled or disposed meanwhile.
  Future<bool> _sleep(Duration d) async {
    await Future<void>.delayed(d);
    return !_cancelled && !_disposed;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Aborts an in-flight [run]; the walk unwinds at its next guarded await.
  void cancel() {
    _cancelled = true;
    _running = false;
    activeKey = null;
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelled = true;
    super.dispose();
  }
}
