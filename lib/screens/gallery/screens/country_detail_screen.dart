import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/plate_tile.dart';
import '../widgets/section_header.dart';

/// Everything one country ships, system by system — where "More" lands.
///
/// The depth the discover screen deliberately withholds. Yemen's four
/// sections and Palestine's three live here in full, each under its own
/// heading and explanation, so the shelf out front can stay at one plate per
/// system without anything becoming unreachable.
class CountryDetailScreen extends StatelessWidget {
  const CountryDetailScreen({super.key, required this.source, required this.onOpenPlate});

  final GallerySource source;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = source.accent ?? theme.colorScheme.primary;
    final PlateSizes sizes = PlateSizes.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: Gap.lg, bottom: Gap.md, right: Gap.lg),
              title: Text(source.countryName, style: theme.textTheme.titleLarge),
              background: DecoratedBox(
                // The country's plate colour, washed out to a backdrop. Ties
                // the page to the shelf it was opened from without tinting
                // anything the plates themselves sit against.
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[accent.withValues(alpha: 0.28), theme.colorScheme.surface],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Eyebrow(source.packageName, color: accent),
                  const SizedBox(height: Gap.sm),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      source.note,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final GallerySection section in source.sections) ...<Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xl, Gap.lg, Gap.md),
              sliver: SliverToBoxAdapter(
                child: SectionIntro(title: section.title, note: section.note, count: section.entries.length),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
              sliver: PlateSliverGrid(
                stageHeight: sizes.gridStageHeight,
                maxCrossAxisExtent: sizes.gridMaxCrossAxisExtent,
                itemCount: section.entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final GalleryEntry entry = section.entries[index];
                  final String tag = 'country:${entry.id}';
                  return PlateTile(
                    key: ValueKey<String>(entry.id),
                    entry: entry,
                    heroTag: tag,
                    stageHeight: sizes.gridStageHeight,
                    onTap: () => onOpenPlate(CatalogueItem(source: source, section: section, entry: entry), tag),
                  );
                },
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: Gap.xl)),
        ],
      ),
    );
  }
}
