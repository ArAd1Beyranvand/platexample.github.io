import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';
import 'package:plate_keypad/plate_keypad.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/plate_binding.dart';
import '../widgets/plate_tile.dart';
import '../widgets/section_header.dart';
import '../theme/tokens.dart';

/// One plate, on its own, at size, and editable — the page a tile opens into.
///
/// The old app jumped a tap on a card straight into a separate playground,
/// which meant looking closely at a plate and editing one were two different
/// places. They are one place now: this screen is both. Tap a slot and type,
/// or switch to the on-screen pad below — the facts about the plate (which
/// package draws it, which spec, how many slots, whether a validator covers
/// it) sit right under the thing they describe.
class PlateDetailScreen extends StatefulWidget {
  const PlateDetailScreen({super.key, required this.item, required this.heroTag});

  final CatalogueItem item;
  final String heroTag;

  @override
  State<PlateDetailScreen> createState() => _PlateDetailScreenState();
}

class _PlateDetailScreenState extends State<PlateDetailScreen> {
  late final GalleryEntry _entry = widget.item.entry;
  late final PlateController _plate = PlateController(spec: _entry.spec, values: _entry.sampleValues);

  PlateInputSource _inputSource = PlateInputSource.system;

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  /// The keypad's labels, taken off the plate itself — Persian digits on an
  /// Iranian plate, Latin on a German. A spec with no letter slot falls back to
  /// Latin capitals, which the pad then never slides in.
  PlateAlphabet _alphabet({required bool numeric}) {
    for (final PlateSlot slot in _entry.spec.slots) {
      if (slot.alphabet.isNumeric == numeric) return slot.alphabet;
    }
    return numeric ? PlateAlphabet.latinDigits : PlateAlphabet.latinUppercase;
  }

  void _onSubmit() => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(behavior: SnackBarBehavior.floating, content: Text(_plate.text(sep: ' · '))),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CatalogueItem item = widget.item;
    final GalleryEntry entry = _entry;
    final PlateSpec spec = entry.spec;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(item.source.countryName)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xl),
              children: <Widget>[
                // Tall, and left to breathe: this is the whole reason for the page.
                SizedBox(
                  height: 240,
                  child: Hero(
                    tag: widget.heroTag,
                    child: PlateFrame(
                      spec: spec,
                      padding: Gap.lg,
                      // The livery can be a fact about the value — Gaza reads its
                      // usage off its own last two digits — so the canvas is
                      // rebuilt when, and only when, the theme that value
                      // resolves to actually changes.
                      child: PlateBinding<PlateTheme?>(
                        controller: _plate,
                        select: (PlateController c) => entry.themeFor(c.values),
                        builder: (BuildContext context, PlateTheme? theme) => PlateCanvas(
                          spec: spec,
                          theme: theme,
                          country: entry.country,
                          inputSource: _inputSource,
                          validator: entry.validator,
                          // Paints the underlines red; never bars a keystroke.
                          autoValidate: true,
                          controller: _plate,
                          // A `chosen` slot — Iran's letter, the West Bank's
                          // governorate — asks the host for a character. This
                          // is what the dependency on plate_keypad is for.
                          onChooseCharacter: (PlateAlphabet alphabet) => PlateCharacterPicker.show(context, alphabet),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Gap.md),
                // The verdict line and Submit are the two things here that read
                // the value directly, and they flip together: one binding on
                // the pair `(verdict, isCompleted)` rebuilds both.
                PlateBinding<(PlateValidation?, bool)>(
                  controller: _plate,
                  select: (PlateController c) => (c.validation, c.isCompleted),
                  builder: (BuildContext context, (PlateValidation?, bool) state) {
                    final (PlateValidation? verdict, bool completed) = state;
                    return Column(
                      children: <Widget>[
                        VerdictBar(verdict: verdict, completed: completed),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            // Gated on *full* as well as valid: a validator
                            // stays quiet until the last register, so an
                            // empty plate reads as valid and the verdict
                            // alone would let a blank one through.
                            onPressed: completed && (verdict?.isValid ?? true) ? _onSubmit : null,
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Submit'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: Gap.xl),
                Text(entry.label, style: theme.textTheme.headlineSmall),
                const SizedBox(height: Gap.xs),
                Text(
                  item.section.title,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: Gap.lg),
                SettingsSection(title: 'Input', child: _InputSourcePicker(selected: _inputSource, onChanged: (PlateInputSource s) => setState(() => _inputSource = s))),
                const SizedBox(height: Gap.xl),
                const Eyebrow('Details'),
                const SizedBox(height: Gap.sm),
                _Fact(label: 'Package', value: item.source.packageName),
                _Fact(label: 'Spec', value: spec.id),
                _Fact(label: 'Slots', value: '${spec.slotCount}'),
                _Fact(label: 'Proportions', value: '${(spec.canvasWidth / spec.canvasHeight).toStringAsFixed(2)} : 1'),
                _Fact(
                  label: 'Validator',
                  value: entry.validator == null ? 'none in this package' : entry.validator.runtimeType.toString(),
                ),
                if (entry.note != null) _Fact(label: 'Note', value: entry.note!),
                const SizedBox(height: Gap.lg),
                Text(
                  item.section.note,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
                ),
              ],
            ),
          ),
          // The pad depends on the value only through the focused slot, which
          // moves far less often than a character changes. Binding it to the
          // active slot alone keeps a keystroke that stays in one slot from
          // rebuilding every key.
          if (_inputSource == PlateInputSource.packageKeypad)
            PlateBinding<PlateSlot?>(
              controller: _plate,
              select: (PlateController c) => c.activeSlot,
              builder: (BuildContext context, PlateSlot? active) => PlateKeypad(
                highlightedKey: null,
                compact: true,
                showLetters: active != null && !active.alphabet.isNumeric,
                digitAlphabet: _alphabet(numeric: true),
                letterAlphabet: _alphabet(numeric: false),
                activeAlphabet: active?.alphabet,
                onKey: (String key) => key == kPlateBackspaceKey ? _plate.backspace() : _plate.submit(key),
              ),
            ),
        ],
      ),
    );
  }
}

/// Which source drives the plate's characters, as three clearly-labelled
/// segments rather than a raw enum name each — `PlateInputSource.system` on
/// its own says nothing to someone who has not read core_plate's source.
class _InputSourcePicker extends StatelessWidget {
  const _InputSourcePicker({required this.selected, required this.onChanged});

  final PlateInputSource selected;
  final ValueChanged<PlateInputSource> onChanged;

  static const Map<PlateInputSource, (IconData, String, String)> _labels = <PlateInputSource, (IconData, String, String)>{
    PlateInputSource.system: (Icons.keyboard_alt_outlined, 'System', 'The platform keyboard.'),
    PlateInputSource.hardwareKeyboard: (
      Icons.keyboard_outlined,
      'Hardware',
      'Physical key presses only; no on-screen IME.',
    ),
    PlateInputSource.packageKeypad: (
      Icons.dialpad_outlined,
      'Keypad',
      'The pad below drives PlateController.submit and .backspace.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final (IconData, String, String) active = _labels[selected]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Characters come from', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 8),
        SegmentedButton<PlateInputSource>(
          segments: <ButtonSegment<PlateInputSource>>[
            for (final MapEntry<PlateInputSource, (IconData, String, String)> e in _labels.entries)
              ButtonSegment<PlateInputSource>(value: e.key, icon: Icon(e.value.$1, size: 18), label: Text(e.value.$2)),
          ],
          selected: <PlateInputSource>{selected},
          onSelectionChanged: (Set<PlateInputSource> s) => onChanged(s.first),
        ),
        const SizedBox(height: 6),
        Text(
          active.$3,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}

/// One label-and-value row. A table rather than prose, because these are
/// lookups: nobody reads a spec id, they check it.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 116,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
