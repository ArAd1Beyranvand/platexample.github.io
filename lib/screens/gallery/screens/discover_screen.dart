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
class DiscoverScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // A [LayoutBuilder], not [MediaQuery]: the showcase renders the whole
    // shell again inside its simulated device frames, and this page has to
    // take the layout its own column calls for rather than the window's.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < NBreak.detail;
        final EdgeInsets padding = compact ? _compactPadding : _padding;
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
                    const SizedBox(height: 28),
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
              sliver: SliverList.builder(
                // Two children per source — the group and the rule under it —
                // so a group is built only when it scrolls into reach.
                itemCount: gallerySources.length * 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index.isOdd) return const NRule();
                  final GallerySource source = gallerySources[index ~/ 2];
                  return CountryGroup(
                    key: ValueKey<String>(source.packageName),
                    source: source,
                    compact: compact,
                    onOpenPlate: onOpenPlate,
                    onOpenCountry: () => onOpenCountry(source),
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
