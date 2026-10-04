import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';
import 'package:plate_keypad/plate_keypad.dart';

import '../../../theme/nocturne.dart';
import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/plate_binding.dart';
import '../widgets/plate_detail/input_mode_list.dart';
import '../widgets/plate_detail/plate_breadcrumb.dart';
import '../widgets/plate_detail/plate_details_table.dart';
import '../widgets/plate_detail/plate_title_block.dart';
import '../widgets/plate_detail/submit_block.dart';
import '../widgets/section_header.dart';

/// One plate, on its own, at size, and editable — the page a tile opens into.
///
/// Desktop (`>= NBreak.detail`): two columns, `minmax(0, 1.15fr) | 380px` —
/// the plate and its title on the left, the input picker and the fact table
/// pinned in a persistent aside on the right. Below `NBreak.detail`: one
/// column, the aside moving under the main block. The mobile treatment below
/// `NBreak.shell` is sk21's.
///
/// One state object (this screen's own `State`) drives every extracted part —
/// [PlateBreadcrumb], [PlateTitleBlock], [InputModeList], [PlateDetailsTable],
/// [SubmitBlock] — so sk21 can reuse them for the mobile panel without a
/// second copy of the plate/input-mode state.
class PlateDetailScreen extends StatefulWidget {
  const PlateDetailScreen({
    super.key,
    required this.item,
    required this.heroTag,
    this.onOpenDiscover,
    this.onOpenCountry,
    this.isIranshahirOverview = false,
  });

  final CatalogueItem item;
  final String heroTag;

  /// `DISCOVER` in the breadcrumb. Null leaves the word inert.
  final VoidCallback? onOpenDiscover;

  /// The country segment in the breadcrumb. Null leaves it inert.
  final void Function(GallerySource source)? onOpenCountry;

  /// Whether this plate is in the Iranshahr context.
  final bool isIranshahirOverview;

  @override
  State<PlateDetailScreen> createState() => _PlateDetailScreenState();
}

class _PlateDetailScreenState extends State<PlateDetailScreen> {
  late final GalleryEntry _entry = widget.item.entry;
  late final PlateController _plate = PlateController(spec: _entry.spec);

  PlateInputSource _inputSource = PlateInputSource.system;

  @override
  void initState() {
    super.initState();
    _plate.completed.addListener(_onCompletedChanged);
  }

  @override
  void dispose() {
    _plate.completed.removeListener(_onCompletedChanged);
    _plate.dispose();
    super.dispose();
  }

  /// Drops focus the moment the last slot fills in — whichever kind of
  /// keyboard is up. `FocusManager.instance.primaryFocus` needs no
  /// `BuildContext`, so this fires straight off the controller's own
  /// [ValueListenable] rather than waiting for a rebuild.
  void _onCompletedChanged() {
    if (_plate.isCompleted) FocusManager.instance.primaryFocus?.unfocus();
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

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(_plate.text(sep: ' · ')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CatalogueItem item = widget.item;
    final GalleryEntry entry = _entry;
    final PlateSpec spec = entry.spec;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < NBreak.shell) {
          return _MobilePlateDetail(
            item: item,
            entry: entry,
            spec: spec,
            plate: _plate,
            inputSource: _inputSource,
            onInputSourceChanged: (PlateInputSource s) =>
                setState(() => _inputSource = s),
            onOpenDiscover: widget.onOpenDiscover,
            onOpenCountry: widget.onOpenCountry,
            heroTag: widget.heroTag,
            onSubmit: _onSubmit,
            alphabet: _alphabet,
            isIranshahirOverview: widget.isIranshahirOverview,
          );
        }

        final bool oneColumn = constraints.maxWidth < NBreak.detail;
        final EdgeInsets mainPadding = oneColumn
            ? const EdgeInsets.fromLTRB(40, 24, 40, 24)
            : const EdgeInsets.fromLTRB(72, 72, 0, 72);

        final Widget main = _MainColumn(
          item: item,
          entry: entry,
          spec: spec,
          plate: _plate,
          inputSource: _inputSource,
          onOpenDiscover: widget.onOpenDiscover,
          onOpenCountry: widget.onOpenCountry,
          heroTag: widget.heroTag,
          padding: mainPadding,
          center: !oneColumn,
          isIranshahirOverview: widget.isIranshahirOverview,
        );

        final Widget aside = _Aside(
          item: item,
          entry: entry,
          spec: spec,
          plate: _plate,
          inputSource: _inputSource,
          onInputSourceChanged: (PlateInputSource s) =>
              setState(() => _inputSource = s),
          onSubmit: _onSubmit,
          borderOnTop: oneColumn,
        );

        final Widget page = oneColumn
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[main, aside],
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 115,
                    child: SingleChildScrollView(child: main),
                  ),
                  SizedBox(
                    width: 380,
                    child: SingleChildScrollView(child: aside),
                  ),
                ],
              );

        // The pad depends on the value only through the focused slot, which
        // moves far less often than a character changes. Binding it to the
        // active slot alone keeps a keystroke that stays in one slot from
        // rebuilding every key.
        return Column(
          children: <Widget>[
            Expanded(child: page),
            if (_inputSource == PlateInputSource.packageKeypad)
              PlateBinding<PlateSlot?>(
                controller: _plate,
                select: (PlateController c) => c.activeSlot,
                // No slot focused — the plate just completed, or the field
                // was unfocused some other way — and the pad has nothing
                // left to type into, so it drops off screen with it.
                builder: (BuildContext context, PlateSlot? active) =>
                    active == null
                    ? const SizedBox.shrink()
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          border: Border(
                            top: BorderSide(color: colors.outlineVariant),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: PlateKeypad(
                            highlightedKey: null,
                            compact: true,
                            showLetters: !active.alphabet.isNumeric,
                            digitAlphabet: _alphabet(numeric: true),
                            letterAlphabet: _alphabet(numeric: false),
                            activeAlphabet: active.alphabet,
                            onKey: (String key) => key == kPlateBackspaceKey
                                ? _plate.backspace()
                                : _plate.submit(key),
                          ),
                        ),
                      ),
              ),
          ],
        );
      },
    );
  }
}

/// sk21: the page below [NBreak.shell] — a scrolling body plus a pinned
/// footer, sharing this screen's one [PlateController] and [_inputSource]
/// rather than a second copy of either.
///
/// The footer sits outside the scroll view so it is always on screen; the
/// scroll body carries the plate, its title, the `INPUT` card list and the
/// `DETAILS` table. Two things move with the keyboard/keypad:
/// - **System**: the soft keyboard pushes [MediaQuery.viewInsets] up; this
///   widget rebuilds around that inset so the footer keeps riding above it,
///   and the focused slot's `Scrollable.ensureVisible` (already wired into
///   `PlateCanvas`/`core_plate`) brings the plate back into view.
/// - **Keypad**: the in-app pad renders between the scroll body and the
///   footer instead of overlaying anything, so the footer never gets covered.
///   On a short phone this can starve the plate of room; [_TitleBlock]
///   collapses first rather than letting the plate itself scroll off.
class _MobilePlateDetail extends StatelessWidget {
  const _MobilePlateDetail({
    required this.item,
    required this.entry,
    required this.spec,
    required this.plate,
    required this.inputSource,
    required this.onInputSourceChanged,
    required this.onOpenDiscover,
    required this.onOpenCountry,
    required this.heroTag,
    required this.onSubmit,
    required this.alphabet,
    this.isIranshahirOverview = false,
  });

  final CatalogueItem item;
  final GalleryEntry entry;
  final PlateSpec spec;
  final PlateController plate;
  final PlateInputSource inputSource;
  final ValueChanged<PlateInputSource> onInputSourceChanged;
  final VoidCallback? onOpenDiscover;
  final void Function(GallerySource source)? onOpenCountry;
  final String heroTag;
  final VoidCallback onSubmit;
  final PlateAlphabet Function({required bool numeric}) alphabet;
  final bool isIranshahirOverview;

  static const EdgeInsets _bodyPadding = EdgeInsets.symmetric(horizontal: 18);
  static const EdgeInsets _footerPadding = EdgeInsets.fromLTRB(18, 16, 18, 16);

  @override
  Widget build(BuildContext context) {
    final bool showsKeypad = inputSource == PlateInputSource.packageKeypad;
    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final List<PlateDetailRow> rows = <PlateDetailRow>[
      PlateDetailRow(label: 'Package', value: item.source.packageName),
      PlateDetailRow(label: 'Spec', value: spec.id, mono: true),
      PlateDetailRow(
        label: 'Country block',
        value: _countryBlock,
        font: NType.forScript(_countryBlock),
      ),
      PlateDetailRow(label: 'Slots', value: '${spec.slotCount}'),
      PlateDetailRow(label: 'Livery', value: entry.label),
      PlateDetailRow(
        label: 'Proportions',
        value:
            '${(spec.canvasWidth / spec.canvasHeight).toStringAsFixed(2)} : 1',
      ),
      PlateDetailRow(
        label: 'Validator',
        value: entry.validator == null
            ? 'None'
            : entry.validator.runtimeType.toString(),
      ),
    ];

    return Padding(
      // Rides the footer and keypad above the system keyboard. The scroll
      // body needs no matching adjustment: `Scrollable.ensureVisible` off the
      // focused slot already accounts for the same inset when it decides how
      // far to scroll.
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Column(
        children: <Widget>[
          Expanded(
            // No padding here: the two dividers below need the full panel
            // width, and each other child instead carries its own 18px
            // horizontal padding — see `_bodyPadding` on each.
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: _bodyPadding,
                    child: PlateBreadcrumb(
                      countryName: item.source.countryName,
                      specId: spec.id,
                      onOpenDiscover: onOpenDiscover,
                      onOpenCountry: onOpenCountry == null
                          ? null
                          : () => onOpenCountry!(item.source),
                      isIranshahirOverview: isIranshahirOverview,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: N.divider),
                  const SizedBox(height: 24),
                  Padding(
                    padding: _bodyPadding,
                    child: _PlateStage(
                      spec: spec,
                      heroTag: heroTag,
                      child: PlateBinding<PlateTheme?>(
                        controller: plate,
                        select: (PlateController c) => entry.themeFor(c.values),
                        builder:
                            (BuildContext context, PlateTheme? plateTheme) =>
                                PlateCanvas(
                                  spec: spec,
                                  theme: plateTheme,
                                  country: entry.country,
                                  inputSource: inputSource,
                                  validator: entry.validator,
                                  autoValidate: true,
                                  controller: plate,
                                  onChooseCharacter: (PlateAlphabet a) =>
                                      PlateCharacterPicker.show(context, a),
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: _bodyPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Collapses first if the keypad leaves the body short
                        // of room on a small phone — the plate itself never
                        // yields.
                        _TitleBlock(
                          collapsed: showsKeypad,
                          livery: entry.label,
                          countryName: item.source.countryName,
                          packageName: item.source.packageName,
                        ),
                        PlateBinding<int>(
                          controller: plate,
                          select: (PlateController c) => c.values
                              .where((String? v) => v != null && v.isNotEmpty)
                              .length,
                          builder: (BuildContext context, int filled) => Text(
                            '$filled SLOTS FILLED · ${spec.id}'.toUpperCase(),
                            style: NType.kicker.copyWith(color: N.n500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, thickness: 1, color: N.divider),
                  const SizedBox(height: 24),
                  Padding(
                    padding: _bodyPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Eyebrow('Input'),
                        const SizedBox(height: 16),
                        InputModeList(
                          style: InputModeListStyle.cards,
                          selected: inputSource,
                          onChanged: onInputSourceChanged,
                        ),
                        const SizedBox(height: 32),
                        const Eyebrow('Details'),
                        const SizedBox(height: 12),
                        PlateDetailsTable(rows: rows),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showsKeypad)
            PlateBinding<PlateSlot?>(
              controller: plate,
              select: (PlateController c) => c.activeSlot,
              // No slot focused — the plate just completed, or the field was
              // unfocused some other way — so the pad drops off screen too.
              builder: (BuildContext context, PlateSlot? active) =>
                  active == null
                  ? const SizedBox.shrink()
                  : PlateKeypad(
                      highlightedKey: null,
                      compact: true,
                      showLetters: !active.alphabet.isNumeric,
                      digitAlphabet: alphabet(numeric: true),
                      letterAlphabet: alphabet(numeric: false),
                      activeAlphabet: active.alphabet,
                      onKey: (String key) => key == kPlateBackspaceKey
                          ? plate.backspace()
                          : plate.submit(key),
                    ),
            ),
          DecoratedBox(
            decoration: const BoxDecoration(
              color: N.bg,
              border: Border(top: BorderSide(color: N.divider)),
            ),
            child: Padding(
              padding: _footerPadding,
              child: _Submit(plate: plate, onSubmit: onSubmit),
            ),
          ),
        ],
      ),
    );
  }

  /// The value the `COUNTRY BLOCK` row shows — see [_Aside._countryBlock].
  String get _countryBlock {
    if (spec.labels.isNotEmpty) return spec.labels.first.text;
    final PlateCountry country = entry.country ?? spec.country;
    return country.captionLines.join(' ');
  }
}

/// [PlateTitleBlock] at sk21's mobile size (`≈32px`), dropping the `Country ·
/// package` line when the keypad has eaten the room a short phone would
/// otherwise give it — keeping the plate itself on screen rather than
/// letting it scroll off, per sk21's keypad-mode rule.
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.collapsed,
    required this.livery,
    required this.countryName,
    required this.packageName,
  });

  final bool collapsed;
  final String livery;
  final String countryName;
  final String packageName;

  static const double _liveryFontSize = 32;

  @override
  Widget build(BuildContext context) {
    if (!collapsed) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: PlateTitleBlock(
          livery: livery,
          countryName: countryName,
          packageName: packageName,
          liveryFontSize: _liveryFontSize,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        livery,
        style: const TextStyle(
          fontFamily: NType.archivo,
          fontWeight: FontWeight.w800,
          fontSize: _liveryFontSize,
          height: 1.05,
          letterSpacing: -0.02 * _liveryFontSize,
          color: N.n100,
        ),
      ),
    );
  }
}

/// The left column: breadcrumb, title, the plate itself, and the live slot
/// caption. Scrolls on its own on a short viewport; the aside scrolls
/// independently beside it, which the design does not forbid — only an aside
/// that scrolls *without* the page would be wrong, and this is the reverse.
class _MainColumn extends StatelessWidget {
  const _MainColumn({
    required this.item,
    required this.entry,
    required this.spec,
    required this.plate,
    required this.inputSource,
    required this.onOpenDiscover,
    required this.onOpenCountry,
    required this.heroTag,
    required this.padding,
    required this.center,
    this.isIranshahirOverview = false,
  });

  final CatalogueItem item;
  final GalleryEntry entry;
  final PlateSpec spec;
  final PlateController plate;
  final PlateInputSource inputSource;
  final VoidCallback? onOpenDiscover;
  final void Function(GallerySource source)? onOpenCountry;
  final String heroTag;
  final EdgeInsets padding;

  /// Whether this column should claim the full viewport height and centre its
  /// content within it. True on the desktop two-column layout, where this is
  /// the whole left-hand side beside the aside. False in the one-column
  /// layout, where this stacks above the aside in the same scroll view and
  /// centring within the full viewport would push the aside off-screen.
  final bool center;
  final bool isIranshahirOverview;

  @override
  Widget build(BuildContext context) {
    // The content sits in the middle third of the viewport rather than
    // hugging the top: a bare `minHeight` the size of the available space
    // (less this column's own padding) plus `mainAxisAlignment.center` on the
    // column pushes the block toward the middle on a tall window without
    // pinning it there on a short one, where the padding alone already fills
    // the space and centring would do nothing. Only done when [center] is
    // true — see its doc comment.
    if (!center) {
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: _children(),
        ),
      );
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double minHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _children(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _children() => <Widget>[
    PlateBreadcrumb(
      countryName: item.source.countryName,
      specId: spec.id,
      onOpenDiscover: onOpenDiscover,
      onOpenCountry: onOpenCountry == null
          ? null
          : () => onOpenCountry!(item.source),
      isIranshahirOverview: isIranshahirOverview,
    ),
    const SizedBox(height: 32),
    PlateTitleBlock(
      livery: entry.label,
      countryName: item.source.countryName,
      packageName: item.source.packageName,
    ),
    const SizedBox(height: 24),
    _PlateStage(
      spec: spec,
      heroTag: heroTag,
      child: PlateBinding<PlateTheme?>(
        controller: plate,
        select: (PlateController c) => entry.themeFor(c.values),
        builder: (BuildContext context, PlateTheme? plateTheme) => PlateCanvas(
          spec: spec,
          theme: plateTheme,
          country: entry.country,
          inputSource: inputSource,
          validator: entry.validator,
          // Paints the underlines red; never bars a keystroke.
          autoValidate: true,
          controller: plate,
          // A `chosen` slot — Iran's letter, the West Bank's
          // governorate — asks the host for a character.
          onChooseCharacter: (PlateAlphabet alphabet) =>
              PlateCharacterPicker.show(context, alphabet),
        ),
      ),
    ),
    const SizedBox(height: 12),
    PlateBinding<int>(
      controller: plate,
      select: (PlateController c) =>
          c.values.where((String? v) => v != null && v.isNotEmpty).length,
      builder: (BuildContext context, int filled) => Text(
        '$filled SLOTS FILLED · ${spec.id}'.toUpperCase(),
        style: NType.kicker.copyWith(color: N.n500),
      ),
    ),
  ];
}

/// The plate itself, at size, with no stage decoration around it — the
/// design draws it directly on the page, not on a lit board.
class _PlateStage extends StatelessWidget {
  const _PlateStage({
    required this.spec,
    required this.child,
    required this.heroTag,
  });

  final PlateSpec spec;
  final Widget child;
  final String heroTag;

  /// `≈680px` at 1440, scaling down with the column.
  static const double _maxWidth = 680;

  @override
  Widget build(BuildContext context) {
    // No nested `LayoutBuilder` here: the Hero flight measures this subtree
    // off-tree, mid-flight, where a `LayoutBuilder` can see stale or
    // momentarily zero constraints and hand `PlateCanvas` a zero size to hit
    // test. `ConstrainedBox` + `AspectRatio` sizes the same way without ever
    // asking the incoming constraints what they are.
    return Hero(
      tag: heroTag,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: AspectRatio(
          aspectRatio: spec.canvasWidth / spec.canvasHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: spec.canvasWidth,
              height: spec.canvasHeight,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// The right rail: `INPUT`, `DETAILS`, then the submit block pinned to the
/// bottom. `border-left` on the desktop two-column layout, `border-top` when
/// the layout collapses to one column.
class _Aside extends StatelessWidget {
  const _Aside({
    required this.item,
    required this.entry,
    required this.spec,
    required this.plate,
    required this.inputSource,
    required this.onInputSourceChanged,
    required this.onSubmit,
    required this.borderOnTop,
  });

  final CatalogueItem item;
  final GalleryEntry entry;
  final PlateSpec spec;
  final PlateController plate;
  final PlateInputSource inputSource;
  final ValueChanged<PlateInputSource> onInputSourceChanged;
  final VoidCallback onSubmit;
  final bool borderOnTop;

  @override
  Widget build(BuildContext context) {
    final List<PlateDetailRow> rows = <PlateDetailRow>[
      PlateDetailRow(label: 'Package', value: item.source.packageName),
      PlateDetailRow(label: 'Spec', value: spec.id, mono: true),
      PlateDetailRow(
        label: 'Country block',
        value: _countryBlock,
        font: NType.forScript(_countryBlock),
      ),
      PlateDetailRow(label: 'Slots', value: '${spec.slotCount}'),
      PlateDetailRow(label: 'Livery', value: entry.label),
      PlateDetailRow(
        label: 'Proportions',
        value:
            '${(spec.canvasWidth / spec.canvasHeight).toStringAsFixed(2)} : 1',
      ),
      PlateDetailRow(
        label: 'Validator',
        value: entry.validator == null
            ? 'None'
            : entry.validator.runtimeType.toString(),
      ),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        border: borderOnTop
            ? const Border(top: BorderSide(color: N.divider))
            : const Border(left: BorderSide(color: N.divider)),
      ),
      child: SizedBox(
        height: borderOnTop ? null : MediaQuery.sizeOf(context).height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 56, 40, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Eyebrow('Input'),
              const SizedBox(height: 20),
              InputModeList(
                selected: inputSource,
                onChanged: onInputSourceChanged,
              ),
              const SizedBox(height: 40),
              const Eyebrow('Details'),
              const SizedBox(height: 12),
              PlateDetailsTable(rows: rows),
              const SizedBox(height: 40),
              if (borderOnTop)
                _Submit(plate: plate, onSubmit: onSubmit)
              else
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _Submit(plate: plate, onSubmit: onSubmit),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// The value the `COUNTRY BLOCK` row shows — the printed label on the
  /// plate's own field (Iran's `ایران`) where the spec has one, since that is
  /// what the design's screenshot shows; the country panel's own caption
  /// (`I.R. IRAN`) otherwise, for specs that print no such label.
  String get _countryBlock {
    if (spec.labels.isNotEmpty) return spec.labels.first.text;
    final PlateCountry country = entry.country ?? spec.country;
    return country.captionLines.join(' ');
  }
}

class _Submit extends StatelessWidget {
  const _Submit({required this.plate, required this.onSubmit});

  final PlateController plate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return PlateBinding<(PlateValidation?, bool)>(
      controller: plate,
      select: (PlateController c) => (c.validation, c.isCompleted),
      builder: (BuildContext context, (PlateValidation?, bool) state) {
        final (PlateValidation? verdict, bool completed) = state;
        return SubmitBlock(
          verdict: verdict,
          completed: completed,
          onSubmit: completed && (verdict?.isValid ?? true) ? onSubmit : null,
        );
      },
    );
  }
}
