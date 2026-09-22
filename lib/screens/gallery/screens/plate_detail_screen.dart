import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';
import 'package:plate_keypad/plate_keypad.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/plate_binding.dart';
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
    final ColorScheme colors = theme.colorScheme;
    final CatalogueItem item = widget.item;
    final GalleryEntry entry = _entry;
    final PlateSpec spec = entry.spec;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    Gap.lg,
                    Gap.lg,
                    Gap.lg,
                    // Room for the floating dock, plus the usual breathing space.
                    Gap.xl + 96,
                  ),
                  children: <Widget>[
                    // The transparent app bar is gone — the shell's own header
                    // stays on screen now and reads `PLATE DETAIL`, so a second
                    // bar under it was one chrome too many. sk18–sk21 replace
                    // this placeholder with the design's
                    // `DISCOVER / IRAN / IR.CAR` breadcrumb row.
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text('← back'),
                      ),
                    ),
                    const SizedBox(height: Gap.sm),
                    Text(item.source.countryName, style: theme.textTheme.labelLarge),
                    const SizedBox(height: Gap.xs),
                    Text(entry.label, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: Gap.xs),
                    Text(
                      item.section.title,
                      style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(height: Gap.lg),
                    // The stage: taller and darker than a catalogue-grid frame, an
                    // ambient glow of the plate's own colours behind it, so the
                    // one plate this page is about reads as the main event
                    // rather than a bigger version of a catalogue tile.
                    _Stage(
                      spec: spec,
                      heroTag: widget.heroTag,
                      child: PlateBinding<PlateTheme?>(
                        controller: _plate,
                        select: (PlateController c) => entry.themeFor(c.values),
                        builder: (BuildContext context, PlateTheme? plateTheme) => PlateCanvas(
                          spec: spec,
                          theme: plateTheme,
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
                    const SizedBox(height: Gap.xl),
                    SettingsSection(
                      title: 'Input',
                      child: _InputSourcePicker(
                        selected: _inputSource,
                        onChanged: (PlateInputSource s) => setState(() => _inputSource = s),
                      ),
                    ),
                    const SizedBox(height: Gap.xl),
                    const Eyebrow('Details'),
                    const SizedBox(height: Gap.sm),
                    _FactGrid(
                      facts: <_Fact>[
                        _Fact(label: 'Package', value: item.source.packageName, icon: Icons.inventory_2_outlined),
                        _Fact(label: 'Spec', value: spec.id, icon: Icons.fingerprint),
                        _Fact(label: 'Slots', value: '${spec.slotCount}', icon: Icons.view_column_outlined),
                        _Fact(
                          label: 'Proportions',
                          value: '${(spec.canvasWidth / spec.canvasHeight).toStringAsFixed(2)} : 1',
                          icon: Icons.aspect_ratio_outlined,
                        ),
                        _Fact(
                          label: 'Validator',
                          value: entry.validator == null ? 'None in this package' : entry.validator.runtimeType.toString(),
                          icon: entry.validator == null ? Icons.shield_outlined : Icons.verified_user_outlined,
                        ),
                        if (entry.note != null) _Fact(label: 'Note', value: entry.note!, icon: Icons.sticky_note_2_outlined),
                      ],
                    ),
                    const SizedBox(height: Gap.lg),
                    Text(
                      item.section.note,
                      style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant, height: 1.5),
                    ),
                  ],
                ),
              ),
              // The pad depends on the value only through the focused slot, which
              // moves far less often than a character changes. Binding it to the
              // active slot alone keeps a keystroke that stays in one slot from
              // rebuilding every key.
              if (_inputSource == PlateInputSource.packageKeypad)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    border: Border(top: BorderSide(color: colors.outlineVariant)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: PlateBinding<PlateSlot?>(
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
                  ),
                ),
            ],
          ),
          // Verdict and Submit, docked to the bottom rather than inline in the
          // scroll: the two things that read the live value stay in the same
          // place regardless of scroll position, and disappear together with
          // the pad rather than competing with it for the same strip.
          if (_inputSource != PlateInputSource.packageKeypad)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: PlateBinding<(PlateValidation?, bool)>(
                controller: _plate,
                select: (PlateController c) => (c.validation, c.isCompleted),
                builder: (BuildContext context, (PlateValidation?, bool) state) {
                  final (PlateValidation? verdict, bool completed) = state;
                  return _SubmitDock(
                    verdict: verdict,
                    completed: completed,
                    onSubmit: completed && (verdict?.isValid ?? true) ? _onSubmit : null,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// The plate's stage: a deep, top-lit surface with a soft glow of the plate's
/// own colours pooled behind it, so the single artefact this page is about
/// feels lit rather than merely enlarged.
class _Stage extends StatelessWidget {
  const _Stage({required this.spec, required this.child, required this.heroTag});

  final PlateSpec spec;
  final Widget child;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Radii.lgAll,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[colors.surfaceContainerHigh, colors.surfaceContainerLowest],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.primary.withValues(alpha: isDark ? 0.18 : 0.10),
            blurRadius: 60,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Gap.xl),
        child: SizedBox(
          height: 220,
          child: Center(
            child: Hero(
              tag: heroTag,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(width: spec.canvasWidth, height: spec.canvasHeight, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The verdict and the Submit action, merged into one bottom-docked bar: a
/// blurred, translucent surface that floats over the scroll rather than a
/// button sitting cold in the flow of the page.
class _SubmitDock extends StatelessWidget {
  const _SubmitDock({required this.verdict, required this.completed, required this.onSubmit});

  final PlateValidation? verdict;
  final bool completed;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final (IconData icon, Color color, String message) = switch (verdict) {
      null => (Icons.remove_circle_outline, colors.onSurfaceVariant, 'No validator for this plate'),
      final PlateValidation v when !v.isValid => (Icons.error_outline, colors.error, v.reason!),
      _ when !completed => (Icons.more_horiz, colors.onSurfaceVariant, 'Keep going'),
      _ => (Icons.check_circle_outline, colors.primary, 'Valid plate'),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.sm),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 18, color: color),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ),
              const SizedBox(width: Gap.md),
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Which source drives the plate's characters, as three icon-first chips
/// rather than a labelled segmented button with a caption underneath — the
/// caption only ever explained the one already selected, so folding it into
/// a short helper line under the row says the same thing in less space.
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
    final ColorScheme colors = theme.colorScheme;
    final (IconData, String, String) active = _labels[selected]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (final MapEntry<PlateInputSource, (IconData, String, String)> e in _labels.entries) ...<Widget>[
              Expanded(child: _SourceChip(icon: e.value.$1, label: e.value.$2, selected: e.key == selected, onTap: () => onChanged(e.key))),
              if (e.key != _labels.keys.last) const SizedBox(width: Gap.sm),
            ],
          ],
        ),
        const SizedBox(height: Gap.sm),
        Text(
          active.$3,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final ThemeData theme = Theme.of(context);
    return Material(
      color: selected ? colors.primaryContainer : colors.surfaceContainerHigh,
      borderRadius: Radii.smAll,
      child: InkWell(
        borderRadius: Radii.smAll,
        onTap: onTap,
        child: AnimatedContainer(
          duration: Motion.fast,
          curve: Motion.curve,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 20, color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? colors.onPrimaryContainer : colors.onSurfaceVariant,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The plate's vitals, as a two-column wrap of small cards rather than a
/// stack of label-value rows — a row-per-fact reads as a form; a grid of
/// short cards reads as what it is, a spec sheet.
class _FactGrid extends StatelessWidget {
  const _FactGrid({required this.facts});

  final List<_Fact> facts;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final double width = (constraints.maxWidth - Gap.sm) / 2;
      return Wrap(
        spacing: Gap.sm,
        runSpacing: Gap.sm,
        children: <Widget>[for (final _Fact fact in facts) SizedBox(width: width, child: fact)],
      );
    },
  );
}

/// One fact, as an icon, a small-caps label, and its value.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(Gap.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: Radii.mdAll,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 14, color: colors.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
