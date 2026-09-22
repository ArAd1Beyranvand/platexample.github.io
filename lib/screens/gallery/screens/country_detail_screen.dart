import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../plate_sizes.dart';
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
          // The page's own header is gone: the shell's chrome stays on screen
          // now, and drawing an app bar under it said `Iran` twice with a
          // second back affordance. sk18–sk21 put the design's
          // `DISCOVER / IRAN` breadcrumb row and full-bleed hero here; until
          // then this placeholder keeps the page navigable.
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('← back'),
                  ),
                  const SizedBox(height: Gap.sm),
                  Text(source.countryName, style: theme.textTheme.titleLarge),
                ],
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
