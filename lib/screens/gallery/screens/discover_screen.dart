import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';
import '../catalogue_index.dart';
import '../catalogue_stats.dart';
import '../sources/sources.dart';
import '../widgets/country_group.dart';

/// Computed once: [gallerySources] never changes at runtime, and this screen
/// rebuilds on every resize.
final CatalogueStats _catalogueStats = CatalogueStats.of(gallerySources);

/// `02 — Discover`: every plate the repo can draw, a country at a time.
///
/// Transcribed from `.pg-discover` in `design_ref/Plate Gallery.dc.html`
/// (lines 176–226) — a header over a rule, then one [CountryGroup] per source
/// with an [NRule] between them.
///
/// The plates themselves are untouched: each is rendered by its own country
/// package through the usual `PlateView` path. The design draws its plates as
/// little HTML mock-ups with the wrong proportions, blocks and colours, and
/// none of that is copied here — this screen restyles everything *around* the
/// plate and supplies the surface it sits on.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    required this.onOpenPlate,
    required this.onOpenCountry,
  });

  final void Function(CatalogueItem item, String heroTag) onOpenPlate;
  final ValueChanged<GallerySource> onOpenCountry;

  /// `padding: 72px 64px 96px 72px`, and the media query's
  /// `56px 40px 72px` under [NBreak.detail] (line 69).
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(72, 72, 64, 96);
  static const EdgeInsets _compactPadding = EdgeInsets.fromLTRB(40, 56, 40, 72);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

/// Unlisted search terms, keyed by package: names a person might type that
/// are not one of the source's [GallerySource.countryNames].
const Map<String, List<String>> _hiddenAliases = <String, List<String>>{
  // Yemen ships the Riyadh-issued plates carried over from saudi_arabia_plate.
  'yemen_plate': <String>['saudi arabia'],
  'iran_plate': <String>['persia', 'persian', 'tehran'],
  'iranshahr_plate': <String>['persia', 'persian', 'tehran'],
};

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _query = '';

  /// A set like `iranshahr` matches when any of its member countries does, so
  /// searching "Oman" surfaces the set itself rather than a lone country.
  List<GallerySource> get _visibleSources {
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) return gallerySources;
    return <GallerySource>[
      for (final GallerySource source in gallerySources)
        if (<String>[
          source.countryName,
          ...source.countryNames,
          ...?_hiddenAliases[source.packageName],
        ].any((String name) => name.toLowerCase().contains(query)))
          source,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<GallerySource> sources = _visibleSources;
    // A [LayoutBuilder], not [MediaQuery]: the showcase renders the whole
    // shell again inside its simulated device frames, and this page has to
    // take the layout its own column calls for rather than the window's.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < NBreak.detail;
        final EdgeInsets padding = compact
            ? DiscoverScreen._compactPadding
            : DiscoverScreen._padding;
        return CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                padding.top,
                padding.right,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _Header(stats: _catalogueStats, compact: compact),
                    const SizedBox(height: 40),
                    _SearchBar(
                      shown: sources.length,
                      total: gallerySources.length,
                      filtering: _query.trim().isNotEmpty,
                      onChanged: (String value) =>
                          setState(() => _query = value),
                    ),
                    const SizedBox(height: 20),
                    const NRule(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                padding.left,
                0,
                padding.right,
                padding.bottom,
              ),
              sliver: sources.isEmpty
                  ? SliverToBoxAdapter(child: _NoMatches(query: _query.trim()))
                  : SliverList.builder(
                      // Two children per source — the group and the rule under it —
                      // so a group is built only when it scrolls into reach.
                      itemCount: sources.length * 2 - 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index.isOdd) return const NRule();
                        final GallerySource source = sources[index ~/ 2];
                        return CountryGroup(
                          key: ValueKey<String>(source.packageName),
                          source: source,
                          compact: compact,
                          onOpenPlate: widget.onOpenPlate,
                          onOpenCountry: () => widget.onOpenCountry(source),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

/// `.pg-dhead`: the eyebrow, the title and the lede on the left, the four
/// counts inline on the right, both sitting on the same bottom edge.
class _Header extends StatelessWidget {
  const _Header({required this.stats, required this.compact});

  final CatalogueStats stats;
  final bool compact;

  /// `max-width: 640px` on the text block.
  static const double _textWidth = 640;

  @override
  Widget build(BuildContext context) {
    final Widget text = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _textWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '02 — Discover'.toUpperCase(),
            style: NType.kicker.copyWith(
              fontSize: 11,
              letterSpacing: 0.12 * 11,
              color: N.accent300,
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            // `font-size: clamp(34px, 3.6vw, 48px)`, measured against this
            // column rather than the viewport — inside a phone panel the
            // viewport is the desktop window, and reading it would set a
            // 48px headline in a 390px column.
            builder: (BuildContext context, BoxConstraints constraints) => Text(
              'Plate archive',
              style: TextStyle(
                fontFamily: NType.archivo,
                fontWeight: FontWeight.w800,
                fontSize: (constraints.maxWidth * 0.036).clamp(34.0, 48.0),
                height: 0.95,
                letterSpacing:
                    -0.035 * (constraints.maxWidth * 0.036).clamp(34.0, 48.0),
                color: N.n100,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // The design's own serif for the lede is one of the two places Nocturne leaves Archivo for
          // Newsreader, the showcase hero's paragraph being the other.
          const Text(
            'Every plate the packages can render and take input for. Open one '
            'to type into it, swap the input mode, and run its validator.',
            style: TextStyle(
              fontFamily: NType.serif,
              fontSize: 18,
              height: 1.5,
              color: N.n400,
            ),
          ),
        ],
      ),
    );

    final Widget statRow = Padding(
      // `padding-bottom: 6px` — the numbers sit a touch above the header's
      // bottom edge so their baseline lines up with the lede's last line.
      padding: const EdgeInsets.only(bottom: 6),
      child: Wrap(
        spacing: 36,
        runSpacing: 20,
        children: <Widget>[
          for (final ({int value, String label}) tile in stats.tiles)
            _StatTile(tile: tile),
        ],
      ),
    );

    if (compact) {
      // `grid-template-columns: minmax(0,1fr)` and `align-items: start`
      // (line 67): the counts drop under the lede at the row gap, 32px.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[text, const SizedBox(height: 32), statRow],
      );
    }
    return Row(
      // `align-items: end`.
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: text),
        const SizedBox(width: 48),
        Flexible(child: statRow),
      ],
    );
  }
}

/// One count in the header's inline row: the same number-over-kicker anatomy
/// as the Showcase stat band, smaller and without the band's dividers.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.tile});

  final ({int value, String label}) tile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '${tile.value}',
          style: const TextStyle(
            fontFamily: NType.archivo,
            fontWeight: FontWeight.w800,
            fontSize: 26,
            height: 1,
            letterSpacing: -0.025 * 26,
            color: N.n100,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          tile.label.toUpperCase(),
          style: NType.kicker.copyWith(
            fontSize: 10,
            letterSpacing: 0.1 * 10,
            color: N.n500,
          ),
        ),
      ],
    );
  }
}

/// The filter row between the header and the first group: a wide search
/// field on the left, the number of groups it leaves on the right.
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.shown,
    required this.total,
    required this.filtering,
    required this.onChanged,
  });

  final int shown;
  final int total;
  final bool filtering;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: _SearchBox(onChanged: onChanged),
          ),
        ),
        const SizedBox(width: 24),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: filtering ? 1 : 0,
          child: Text(
            '$shown of $total'.toUpperCase(),
            style: NType.kicker.copyWith(
              fontSize: 10,
              letterSpacing: 0.1 * 10,
              color: shown == 0 ? N.n600 : N.accent300,
            ),
          ),
        ),
      ],
    );
  }
}

/// The country search field.
class _SearchBox extends StatefulWidget {
  const _SearchBox({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool focused = _focus.hasFocus;
    final Color border = focused
        ? N.accent
        : _hovered
        ? N.n600
        : N.n800;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: focused ? N.n900 : N.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
          boxShadow: <BoxShadow>[
            if (focused)
              BoxShadow(
                color: N.accent.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search_rounded,
              size: 18,
              color: focused ? N.accent300 : N.n500,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                onChanged: (String value) {
                  widget.onChanged(value);
                  setState(() {});
                },
                cursorColor: N.accent300,
                style: const TextStyle(
                  fontFamily: NType.archivo,
                  fontSize: 14,
                  color: N.n100,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search a country — Oman, Spain, Persia…',
                  hintStyle: NType.kicker.copyWith(
                    fontSize: 11,
                    letterSpacing: 0.08 * 11,
                    color: N.n600,
                  ),
                ),
              ),
            ),
            if (_controller.text.isNotEmpty)
              GestureDetector(
                onTap: _clear,
                child: const MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(Icons.close_rounded, size: 16, color: N.n500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shown in place of the groups when no country matches.
class _NoMatches extends StatelessWidget {
  const _NoMatches({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: <Widget>[
          const Icon(Icons.travel_explore_rounded, size: 32, color: N.n700),
          const SizedBox(height: 16),
          Text(
            'No country matches “$query”',
            style: const TextStyle(
              fontFamily: NType.serif,
              fontSize: 18,
              color: N.n400,
            ),
          ),
        ],
      ),
    );
  }
}
