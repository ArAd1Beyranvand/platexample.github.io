import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';

import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/sources/sources.dart';
import '../screens/gallery/widgets/plate_tile.dart';
import '../theme/nocturne.dart';
import 'mobile_tokens.dart';
import 'section_header.dart';

/// "One plate per package": a start-aligned swipe carousel with the next card
/// peeking, one card per gallery source.
class PackageCarousel extends StatefulWidget {
  const PackageCarousel({super.key});

  static const double gutter = 18;
  static const double cardWidth = 262;
  static const double cardGap = 12;
  static const double stageHeight = 96;

  static const EdgeInsets _cardPadding = EdgeInsets.fromLTRB(16, 16, 16, 14);

  /// Both borders, both paddings, the stage, the 16 gap, the rule, the 12 gap
  /// and the pinned footer line.
  static const double cardHeight =
      16 + 14 + 2 + stageHeight + 16 + 1 + 12 + _footerLine;
  static const double _footerLine = 18;

  @override
  State<PackageCarousel> createState() => _PackageCarouselState();
}

class _PackageCarouselState extends State<PackageCarousel> {
  final List<CatalogueItem> _items = <CatalogueItem>[
    for (final GallerySource source in gallerySources)
      source.highlightItems.first,
  ];
  PageController? _pages;

  @override
  void dispose() {
    _pages?.dispose();
    super.dispose();
  }

  PageController _controllerFor(double fraction) {
    final PageController? current = _pages;
    if (current != null && current.viewportFraction == fraction) return current;
    final int page = current?.hasClients == true ? current!.page!.round() : 0;
    current?.dispose();
    return _pages = PageController(
      initialPage: page,
      viewportFraction: fraction,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double gutter = PackageCarousel.gutter;
    const double cardWidth = PackageCarousel.cardWidth;
    const double cardHeight = PackageCarousel.cardHeight;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 16),
            child: SectionHeader(
              leading: 'ONE PLATE PER PACKAGE',
              trailing: 'SWIPE →',
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double viewport = constraints.maxWidth - gutter;
              return SizedBox(
                height: cardHeight + 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: gutter),
                  child: PageView.builder(
                    padEnds: false,
                    clipBehavior: Clip.none,
                    controller: _controllerFor(
                      (cardWidth + PackageCarousel.cardGap) / viewport,
                    ),
                    itemCount: _items.length,
                    itemBuilder: (BuildContext context, int index) => Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: RepaintBoundary(
                          child: _PackageCard(item: _items[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatefulWidget {
  const _PackageCard({required this.item});

  final CatalogueItem item;

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  late final PlateController _plate = PlateController(
    spec: widget.item.entry.spec,
    values: widget.item.entry.sampleValues,
  );

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GalleryEntry entry = widget.item.entry;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NRadius.lg),
        border: Border.all(color: MobileTokens.n800),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[MobileTokens.surface, MobileTokens.n900],
        ),
      ),
      child: Padding(
        padding: PackageCarousel._cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: PackageCarousel.stageHeight,
              child: ExcludeSemantics(
                child: IgnorePointer(
                  child: PlateFrame(
                    spec: entry.spec,
                    child: PlateView(
                      controller: _plate,
                      theme: entry.themeFor(_plate.values),
                      country: entry.country,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: MobileTokens.n800),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.item.source.countryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: NType.archivo,
                      fontSize: 14,
                      height: PackageCarousel._footerLine / 14,
                      color: MobileTokens.n100,
                    ),
                  ),
                ),
                const SizedBox(width: NSpace.s4),
                Text(
                  entry.spec.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NType.specId.copyWith(
                    fontSize: 9.5,
                    letterSpacing: 0.06 * 9.5,
                    height: PackageCarousel._footerLine / 9.5,
                    color: MobileTokens.n500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
