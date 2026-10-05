import 'package:flutter/material.dart';

import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/sources/sources.dart';
import '../screens/gallery/widgets/plate_tile.dart';
import 'section_header.dart';

/// "One country per package": a start-aligned swipe carousel with the next card
/// peeking, one card per gallery source.
class PackageCarousel extends StatefulWidget {
  const PackageCarousel({
    super.key,
    required this.onOpenCountry,
    required this.onOpenArchive,
  });

  final ValueChanged<GallerySource> onOpenCountry;
  final VoidCallback onOpenArchive;

  static const double gutter = 18;
  static const double cardWidth = 262;
  static const double cardGap = 12;
  static const double stageHeight = 96;

  static double get cardHeight => PlateTile.heightFor(stageHeight);

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
    final double cardHeight = PackageCarousel.cardHeight;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(gutter, 0, gutter, 16),
            child: SectionHeader(
              leading: 'ONE COUNTRY PER PACKAGE',
              trailing: 'ALL COUNTRIES',
              onTrailingTap: widget.onOpenArchive,
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
                          child: PlateTile(
                            key: ValueKey<String>(_items[index].entry.id),
                            entry: _items[index].entry,
                            heroTag: 'carousel:${_items[index].entry.id}',
                            stageHeight: PackageCarousel.stageHeight,
                            autoReplay: true,
                            onTap: () =>
                                widget.onOpenCountry(_items[index].source),
                          ),
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
