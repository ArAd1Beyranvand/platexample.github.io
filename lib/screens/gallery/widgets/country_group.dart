import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';
import '../../../widgets/nocturne/n_button.dart';
import '../catalogue.dart';
import '../catalogue_index.dart';
import '../sources/sources.dart';
import 'plate_tile.dart';

/// One country on the Discover index: a text rail naming the package and what
/// it holds, and beside it a grid of that country's leading plates.
///
/// Transcribed from `.pg-group` in `design_ref/Plate Gallery.dc.html`
/// (lines 194–225): `grid-template-columns: 220px minmax(0,1fr)`, `gap: 48px`,
/// `padding: 44px 0`. Under [NBreak.detail] the design's media query
/// (line 68) collapses it to one column at `gap: 24px`, and the plate grid
/// goes to a single card per row with it.
///
/// Was a horizontal shelf — a heading, a "More" button and a sideways run of
/// tiles. The shelf hid most of every country behind a drag nobody makes, and
/// put the country's name, its package and its size in one cramped line above
/// it. The rail gives all three room and still costs less vertical space than
/// the shelf's header did.
class CountryGroup extends StatelessWidget {
  const CountryGroup({
    super.key,
    required this.source,
    required this.onOpenPlate,
    required this.onOpenCountry,
    required this.compact,
  });

  final GallerySource source;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  /// `All plates →` — the country detail screen, which sk12 restyles.
  final VoidCallback onOpenCountry;

  /// Whether the page is under [NBreak.detail]. Passed down rather than
  /// measured here: the design's query is on the viewport, and this box has
  /// already lost the section's 136px of horizontal padding, so measuring it
  /// would turn the layout over a hundred pixels late.
  final bool compact;

  /// `grid-template-columns: 220px minmax(0,1fr)`.
  static const double _railWidth = 220;

  @override
  Widget build(BuildContext context) {
    final Widget rail = _Rail(source: source, onOpenCountry: onOpenCountry);
    final Widget plates = _PlateGrid(
      source: source,
      onOpenPlate: onOpenPlate,
      compact: compact,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 32 : 44),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[rail, const SizedBox(height: 24), plates],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: _railWidth, child: rail),
                const SizedBox(width: 48),
                Expanded(child: plates),
              ],
            ),
    );
  }
}

/// The left column: what the country is, which package draws it, how much of
/// it there is, and the way in.
class _Rail extends StatelessWidget {
  const _Rail({required this.source, required this.onOpenCountry});

  final GallerySource source;
  final VoidCallback onOpenCountry;

  @override
  Widget build(BuildContext context) {
    final int entries = source.entries.length;
    final int specs = source.specIds.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          source.countryName,
          style: NType.h3.copyWith(
            fontSize: 24,
            letterSpacing: -0.025 * 24,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        // The package and the two counts, as one mono block at `line-height:
        // 1.9` — the design sets them as two lines of one element, and the
        // generous leading is what keeps a 220px rail from reading as a
        // paragraph of code.
        Text(
          '${source.packageName}\n$entries entries · $specs specs',
          style: NType.kicker.copyWith(
            letterSpacing: 0.1 * 11,
            height: 1.9,
            color: N.n500,
          ),
        ),
        const SizedBox(height: 10),
        // The systems this country ships, named the way its own sections are —
        // `Gaza · West Bank modern · West Bank legacy`. Derived, so a section
        // added to a source turns up here without anyone editing a string.
        Text(
          <String>[
            for (final GallerySection section in source.sections) section.title,
          ].join(' · '),
          style: const TextStyle(
            fontFamily: NType.serif,
            fontSize: 15,
            height: 1.5,
            color: N.n600,
          ),
        ),
        const SizedBox(height: 18),
        NButton(
          label: 'All plates →',
          onPressed: onOpenCountry,
          variant: NButtonVariant.ghost,
          padding: const EdgeInsets.symmetric(vertical: NSpace.s2),
        ),
      ],
    );
  }
}

/// The right column: one card per highlight, two across and one under
/// [NBreak.detail].
class _PlateGrid extends StatelessWidget {
  const _PlateGrid({
    required this.source,
    required this.onOpenPlate,
    required this.compact,
  });

  final GallerySource source;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final List<CatalogueItem> items = source.highlightItems;
    final double stageHeight = compact ? 84 : PlateTile.defaultStageHeight;
    return GridView.builder(
      // Inside the page's own scroll view: this grid lays out all of its
      // children and lets the page scroll them. That is affordable here and
      // nowhere else — a group shows one plate per system, never more than
      // five cards, where a country's full catalogue is fifteen.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 1 : 2,
        mainAxisSpacing: PlateTile.gridGap,
        crossAxisSpacing: PlateTile.gridGap,
        mainAxisExtent: PlateTile.heightFor(stageHeight),
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final CatalogueItem item = items[index];
        final String tag = 'discover:${item.entry.id}';
        return PlateTile(
          key: ValueKey<String>(item.entry.id),
          entry: item.entry,
          heroTag: tag,
          stageHeight: stageHeight,
          onTap: () => onOpenPlate(item, tag),
          // Every card Discover shows loops its own replay — see
          // [PlateTile.autoReplay].
          autoReplay: true,
        );
      },
    );
  }
}
