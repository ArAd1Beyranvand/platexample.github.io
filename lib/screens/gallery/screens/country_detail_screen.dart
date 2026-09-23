import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';
import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/plate_tile.dart';

/// Everything one country ships, as one flat wall of plates.
///
/// Transcribed from `target-country-desktop.png`: the design export ships no
/// `data-screen-label="Country"` block — the country page is drawn by the
/// export's JS off `state.country` rather than as a section of its own — so
/// the picture is the spec and the measurements below are taken off it.
///
/// The sectioning is gone. The old screen repeated the Discover index's
/// anatomy one level down: a heading and an explanatory paragraph per system,
/// with a grid under each. That is the right shape for an index that shows one
/// plate per system and the wrong one for the page whose whole job is to show
/// *all* of them — four headings between a reader and the fourteenth plate.
/// Here the sections survive only as a count in the hero's stat row, and every
/// plate the package ships is in one grid in catalogue order.
///
/// The plates themselves are untouched: each is drawn by its own country
/// package through the usual `PlateView` path, exactly as on Discover. The
/// design's plate drawings have the wrong proportions, blocks and colours and
/// none of them is copied.
class CountryDetailScreen extends StatelessWidget {
  const CountryDetailScreen({
    super.key,
    required this.source,
    required this.onOpenPlate,
    this.onOpenDiscover,
    this.onSwitchCountry,
  });

  final GallerySource source;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  /// `DISCOVER` in the breadcrumb. Null leaves the word inert — the back
  /// button beside it goes to the same place, so a shell that cannot pop to
  /// its index loses nothing but the second way in.
  final VoidCallback? onOpenDiscover;

  /// `OTHER COUNTRIES`, mobile only: replaces this page in place with the
  /// tapped country's, rather than pushing — so the back gesture still lands
  /// on Discover no matter how many countries were browsed in between. Null
  /// hides the block, which the desktop layout relies on.
  final void Function(GallerySource source)? onSwitchCountry;

  /// Discover's `padding: 72px 64px 96px 72px`, and its media query's
  /// `56px 40px 72px` under [NBreak.detail]. The same section shell, because
  /// this page is Discover one level down and a different gutter would read
  /// as a different site.
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(72, 72, 64, 96);
  static const EdgeInsets _compactPadding = EdgeInsets.fromLTRB(40, 56, 40, 72);

  /// Breadcrumb to hero, and hero to kicker.
  static const double _crumbToHero = 28;
  static const double _heroToKicker = 40;
  static const double _kickerToGrid = 18;

  /// Grid to the `OTHER COUNTRIES` divider, and divider to its kicker.
  static const double _gridToOtherDivider = 28;
  static const double _otherDividerToKicker = 24;
  static const double _otherKickerToList = 16;

  @override
  Widget build(BuildContext context) {
    // A [LayoutBuilder], not [MediaQuery]: the showcase renders the whole
    // shell again inside its simulated device frames, and this page has to
    // take the layout its own column calls for rather than the window's.
    // The old `PlateSizes` helper, which the previous screen sized its grid
    // from, read `MediaQuery.sizeOf` and so could not be used here; it was
    // deleted in sk15 once this screen stopped calling it.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool compact = width < NBreak.detail;
        final EdgeInsets padding = compact ? _compactPadding : _padding;
        final List<CatalogueItem> items = source.catalogueItems;
        final double stageHeight = compact ? 84 : PlateTile.defaultStageHeight;

        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, padding.top, padding.right, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _Breadcrumb(countryName: source.countryName, onOpenDiscover: onOpenDiscover),
                    const SizedBox(height: _crumbToHero),
                    _HeroCard(source: source, compact: compact),
                    const SizedBox(height: _heroToKicker),
                    Text(
                      '${source.packageName} · Every plate'.toUpperCase(),
                      style: NType.kicker.copyWith(color: N.n500),
                    ),
                    const SizedBox(height: _kickerToGrid),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(padding.left, 0, padding.right, padding.bottom),
              sliver: PlateSliverGrid(
                stageHeight: stageHeight,
                // 4 columns at 1440, 3 at ≤1280, 2 at ≤1040 — expressed as the
                // widest a column may get rather than as a count, because the
                // page column is the window less the 208px rail less 136px of
                // gutter, and a count would have to know all three.
                maxCrossAxisExtent: _columnExtent(width - padding.horizontal),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final CatalogueItem item = items[index];
                  final String tag = 'country:${item.entry.id}';
                  return PlateTile(
                    key: ValueKey<String>(item.entry.id),
                    entry: item.entry,
                    heroTag: tag,
                    stageHeight: stageHeight,
                    onTap: () => onOpenPlate(item, tag),
                  );
                },
              ),
            ),
            // Mobile only, per sk19: the desktop hero card already spends the
            // page's whole width on one country, and a list of the other five
            // would be one more competing wall of cards on a screen that has
            // room to spare. On a narrow window the grid ends the page with
            // nothing to do next; this gives it one.
            if (compact && onSwitchCountry != null)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(0, _gridToOtherDivider, 0, 0),
                sliver: SliverToBoxAdapter(
                  child: _OtherCountries(
                    current: source,
                    padding: padding,
                    onSwitchCountry: onSwitchCountry!,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// The grid's `maxCrossAxisExtent` for a content column [contentWidth] wide.
  ///
  /// Solved from the column count the design asks for rather than tuned by
  /// hand: at 1440 the content column is ~1024px and four cards across it are
  /// 241 apiece, at 1280 three are 236, at 1040 two are 232 — near enough one
  /// number that a single fixed extent would have to sit inside all three
  /// windows, and would break the moment the rail's width changed. Dividing
  /// instead means the count is the thing that is pinned.
  static double _columnExtent(double contentWidth) {
    final int columns = contentWidth >= 960
        ? 4
        : contentWidth >= 720
        ? 3
        : contentWidth >= 420
        ? 2
        : 1;
    final double gaps = PlateTile.gridGap * (columns - 1);
    // A hair under the exact share: the delegate divides by
    // `(width + spacing) / (extent + spacing)` and rounds *up*, so an extent
    // that lands exactly on the share can tip to one column more.
    return (contentWidth - gaps) / columns - 0.5;
  }
}

/// `← DISCOVER / IRAN`: a round back button, then the trail in mono caps.
///
/// Replaces the sk17 placeholder — a bare `← back` text button — and the page
/// heading that was under it. The country's name is said once, by the hero.
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.countryName, required this.onOpenDiscover});

  final String countryName;
  final VoidCallback? onOpenDiscover;

  /// The circle in the picture, measured off it.
  static const double _buttonSize = 36;

  @override
  Widget build(BuildContext context) {
    final TextStyle crumb = NType.kicker.copyWith(color: N.n500);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _BackButton(onPressed: () => Navigator.of(context).maybePop()),
        const SizedBox(width: 16),
        // Only `DISCOVER` is a target. The separator and the country's own
        // name are where you already are, and a hover state on them would
        // promise a navigation that does not exist.
        _CrumbLink(label: 'Discover'.toUpperCase(), style: crumb, onPressed: onOpenDiscover),
        Text(' / ', style: crumb),
        Text(countryName.toUpperCase(), style: crumb.copyWith(color: N.n300)),
      ],
    );
  }
}

/// The breadcrumb's circular back affordance: a 1px divider ring and an arrow,
/// lighting to the accent on hover like every other Nocturne control.
class _BackButton extends StatefulWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: Container(
            width: _Breadcrumb._buttonSize,
            height: _Breadcrumb._buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _hovered ? N.accent700 : N.divider),
              color: _hovered ? N.accentAt(0.10) : null,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 16,
              color: _hovered ? N.accent300 : N.n200,
            ),
          ),
        ),
      ),
    );
  }
}

/// One tappable word in the trail. Inert — and unhoverable — when its
/// callback is null.
class _CrumbLink extends StatefulWidget {
  const _CrumbLink({required this.label, required this.style, required this.onPressed});

  final String label;
  final TextStyle style;
  final VoidCallback? onPressed;

  @override
  State<_CrumbLink> createState() => _CrumbLinkState();
}

class _CrumbLinkState extends State<_CrumbLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed == null) return Text(widget.label, style: widget.style);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: Text(
          widget.label,
          style: widget.style.copyWith(color: _hovered ? N.n200 : widget.style.color),
        ),
      ),
    );
  }
}

/// The page's hero: the country's name, its description and three counts, on
/// a card tinted from the country's own leading plate.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.source, required this.compact});

  final GallerySource source;
  final bool compact;

  /// `≈48px` of padding in the picture, `28px` under [NBreak.detail].
  static const EdgeInsets _padding = EdgeInsets.all(48);
  static const EdgeInsets _compactPadding = EdgeInsets.all(28);

  /// `max-width: 640px` on the description, as on every other lede in the app.
  static const double _proseWidth = 640;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact ? _compactPadding : _padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NRadius.lg),
        border: Border.all(color: N.n800),
        gradient: LinearGradient(
          // The picture's light falls from the top-left corner.
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color.lerp(N.surface, source.heroTint, 0.18)!,
            N.n900,
            N.bg,
          ],
          // The tint is a corner, not a wash: it is spent by a third of the
          // way across, and the rest of the card is the page's own black.
          stops: const <double>[0, 0.55, 1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LayoutBuilder(
            // The picture's title is ~64px in a 1300px card. Measured against
            // the card rather than the viewport, for the same reason every
            // other Nocturne headline is: inside the showcase's phone panel
            // the viewport is still the desktop window.
            builder: (BuildContext context, BoxConstraints constraints) {
              final double size = (constraints.maxWidth * 0.05).clamp(38.0, 64.0);
              return Text(
                source.countryName,
                style: TextStyle(
                  fontFamily: NType.archivo,
                  fontWeight: FontWeight.w800,
                  fontSize: size,
                  height: 1,
                  letterSpacing: -0.035 * size,
                  color: N.n100,
                ),
              );
            },
          ),
          SizedBox(height: compact ? 18 : 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _proseWidth),
            // The same string the About screen's country row shows, from the
            // same field — `GallerySource.note` is the one description a
            // country has, and a second copy here is how the two drift.
            child: Text(
              source.note,
              style: const TextStyle(fontFamily: NType.serif, fontSize: 18, height: 1.6, color: N.n300),
            ),
          ),
          SizedBox(height: compact ? 28 : 36),
          _StatRow(source: source),
        ],
      ),
    );
  }
}

/// `4 / PLATES SHOWN · 11 specs / SPECS · 3 / SECTIONS`.
///
/// Every value is counted off the catalogue, so a section added to a source
/// or a package gaining a plate moves these without anyone editing a number.
/// The middle tile prints its unit inside the number, as the picture has it.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.source});

  final GallerySource source;

  /// `gap: ≈40px` in the picture. A [Wrap], not a [Row]: three tiles do not
  /// fit beside each other in the mobile panel's card.
  static const double _gap = 40;

  @override
  Widget build(BuildContext context) {
    final List<({String value, String label})> tiles = <({String value, String label})>[
      (value: '${source.entries.length}', label: 'Plates shown'),
      (value: '${source.specIds.length} specs', label: 'Specs'),
      (value: '${source.sections.length}', label: 'Sections'),
    ];
    return Wrap(
      spacing: _gap,
      runSpacing: 24,
      children: <Widget>[for (final ({String value, String label}) tile in tiles) _StatTile(tile: tile)],
    );
  }
}

/// One count: the number over its kicker, as on Discover's header and the
/// Showcase stat band — bigger here, because the hero has the room.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.tile});

  final ({String value, String label}) tile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          tile.value,
          style: const TextStyle(
            fontFamily: NType.archivo,
            fontWeight: FontWeight.w800,
            fontSize: 30,
            height: 1,
            letterSpacing: -0.025 * 30,
            color: N.n100,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          tile.label.toUpperCase(),
          style: NType.kicker.copyWith(fontSize: 10, letterSpacing: 0.1 * 10, color: N.n500),
        ),
      ],
    );
  }
}

extension on GallerySource {
  /// The colour this country's hero is tinted from: the country block on its
  /// leading plate.
  ///
  /// Not [CatalogueSourceLook.accent], which reads `theme.plateBackground` —
  /// the plate's *field*, which is white on four of the six countries and so
  /// tints every one of them the same. The block is the coloured thing on a
  /// plate: Iran's navy, Bahrain's red, Germany's EU blue. It is read off the
  /// entry's own `country` override where it has one and its spec's otherwise,
  /// which is the same order `PlateCanvas` resolves it in.
  ///
  /// A plate whose block is suppressed (`PlateSpec.panel` off — Germany's `04`
  /// and `07` numbers) still carries a country value, so this never falls
  /// through for want of one; the fallback is for a source with no entries.
  Color get heroTint {
    for (final GalleryEntry entry in highlights) {
      return (entry.country ?? entry.spec.country).panelColor;
    }
    return accent ?? N.accent;
  }

  /// Every plate this source ships, in catalogue order, each paired with the
  /// section it came from — the grid's contents, and what a tapped card needs
  /// in order to open into a detail page.
  List<CatalogueItem> get catalogueItems => <CatalogueItem>[
    for (final CatalogueItem item in searchCatalogue(country: this)) item,
  ];
}

/// `OTHER COUNTRIES`, mobile only: a kicker over one tappable row per country
/// besides the one already open — every entry in [gallerySources] but
/// [current].
class _OtherCountries extends StatelessWidget {
  const _OtherCountries({required this.current, required this.padding, required this.onSwitchCountry});

  final GallerySource current;
  final EdgeInsets padding;
  final void Function(GallerySource source) onSwitchCountry;

  static const double _rowGap = 12;

  @override
  Widget build(BuildContext context) {
    final List<GallerySource> others = <GallerySource>[
      for (final GallerySource source in gallerySources)
        if (source.countryName != current.countryName) source,
    ];
    if (others.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Full-bleed, like the breadcrumb's rule: the divider marks a break
        // between the page's two subjects and reads as one only if it runs
        // to both edges of the panel, not just the content column.
        const Divider(height: 1, thickness: 1, color: N.divider),
        Padding(
          padding: EdgeInsets.fromLTRB(padding.left, _CountryDetailScreenSpacing.dividerToKicker, padding.right, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Other countries'.toUpperCase(), style: NType.kicker.copyWith(color: N.n500)),
              const SizedBox(height: _CountryDetailScreenSpacing.kickerToList),
              for (final GallerySource source in others) ...<Widget>[
                _OtherCountryRow(source: source, onTap: () => onSwitchCountry(source)),
                if (source != others.last) const SizedBox(height: _rowGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Spacing shared between [CountryDetailScreen] and [_OtherCountries] — kept
/// off the screen's own private statics, which [_OtherCountries] cannot see.
abstract final class _CountryDetailScreenSpacing {
  static const double dividerToKicker = CountryDetailScreen._otherDividerToKicker;
  static const double kickerToList = CountryDetailScreen._otherKickerToList;
}

/// One row: the country's name and a short catalogue meta line on the left, a
/// read-only miniature of its lead plate and a chevron on the right.
class _OtherCountryRow extends StatefulWidget {
  const _OtherCountryRow({required this.source, required this.onTap});

  final GallerySource source;
  final VoidCallback onTap;

  @override
  State<_OtherCountryRow> createState() => _OtherCountryRowState();
}

class _OtherCountryRowState extends State<_OtherCountryRow> {
  bool _hovered = false;
  bool _pressed = false;

  /// Scoped to this row, like [PlateTile]'s own controller: display-only, but
  /// still a [ChangeNotifier] that `PlateView` listens to, so it must be
  /// disposed with the row rather than rebuilt and leaked on every frame.
  late final PlateController? _plate = _leadOf(widget.source) == null
      ? null
      : PlateController(spec: _leadOf(widget.source)!.spec, values: _leadOf(widget.source)!.sampleValues);

  static GalleryEntry? _leadOf(GallerySource source) => source.highlights.isEmpty ? null : source.highlights.first;

  bool get _lit => _hovered || _pressed;

  @override
  void dispose() {
    _plate?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GallerySource source = widget.source;
    final GalleryEntry? lead = _leadOf(source);

    return Semantics(
      button: true,
      label: source.countryName,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: N.surface,
              borderRadius: BorderRadius.circular(NRadius.md),
              border: Border.all(color: _lit ? N.accent700 : N.n800),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        source.countryName,
                        style: const TextStyle(
                          fontFamily: NType.archivo,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: N.n100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(source.packageName, style: NType.specId.copyWith(color: N.n500)),
                      const SizedBox(height: 4),
                      Text(
                        '${source.entries.length} entries · ${source.specIds.length} specs',
                        style: TextStyle(fontFamily: NType.mono, fontSize: 11, color: N.n500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (lead != null && _plate != null) ...<Widget>[
                  SizedBox(
                    height: 28,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: lead.spec.canvasWidth,
                            height: lead.spec.canvasHeight,
                            child: PlateView(
                              controller: _plate,
                              theme: lead.themeFor(_plate.values),
                              country: lead.country,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Icon(Icons.arrow_forward, size: 16, color: N.n400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
