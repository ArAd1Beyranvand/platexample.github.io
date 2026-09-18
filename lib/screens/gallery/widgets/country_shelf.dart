import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import 'plate_tile.dart';

/// One country on the discover screen: a heading, a "More" affordance, and a
/// sideways run of one plate per system.
///
/// A shelf rather than a card. The old country card drew a border around the
/// whole country, which nested a box inside a box inside the page and made
/// four countries look like four dialogs stacked up. Shelves share the page's
/// background and are separated by space alone, so the plates — which *are*
/// boxes, with real borders of their own — are the only framed thing on
/// screen.
class CountryShelf extends StatelessWidget {
  const CountryShelf({super.key, required this.source, required this.onOpenPlate, required this.onMore});

  final GallerySource source;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CatalogueItem> items = source.highlightItems;
    final Color accent = source.accent ?? theme.colorScheme.primary;
    final PlateSizes sizes = PlateSizes.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
          child: Row(
            children: <Widget>[
              // The country's own plate colour, as a keyline. Four countries
              // scrolling past need something pre-verbal to tell them apart,
              // and this is the one colour each is actually recognised by.
              Container(
                width: 4,
                height: 26,
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: Gap.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(source.countryName, style: theme.textTheme.titleLarge),
                    Text(
                      '${source.packageName} · ${source.entries.length} plates',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onMore,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('More'),
              ),
            ],
          ),
        ),
        const SizedBox(height: Gap.md),
        SizedBox(
          height: sizes.shelfStageHeight + 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // Bleeds to the window edge so a partly-visible tile at the right
            // says "this scrolls" without a scrollbar having to.
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            itemCount: items.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: Gap.md),
            itemBuilder: (BuildContext context, int index) {
              final CatalogueItem item = items[index];
              final String tag = 'discover:${item.entry.id}';
              return SizedBox(
                width: sizes.shelfTileWidth,
                child: PlateTile(
                  entry: item.entry,
                  heroTag: tag,
                  // On a shelf the label is the plate and the system is what
                  // you cannot otherwise tell — the opposite of a country
                  // grid, where the plate is.
                  subtitle: item.section.title,
                  stageHeight: sizes.shelfStageHeight,
                  onTap: () => onOpenPlate(item, tag),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
