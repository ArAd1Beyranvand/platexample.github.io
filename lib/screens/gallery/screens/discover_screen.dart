import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/country_shelf.dart';

/// The front page: what this archive holds, then a shelf per country.
///
/// Replaces a screen that opened with every section of every country
/// concatenated — the first thing a visitor saw was fifteen near-identical
/// Yemeni plates, and Palestine was four screens below the fold. Here the
/// whole catalogue is legible in one scroll of four shelves, and depth is
/// something you ask for rather than something you wade through.
class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key, required this.onOpenPlate, required this.onOpenCountry});

  final void Function(CatalogueItem item, String heroTag) onOpenPlate;
  final ValueChanged<GallerySource> onOpenCountry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int systems = gallerySources.fold(0, (int n, GallerySource s) => n + s.highlights.length);
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xl, Gap.lg, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Plate archive', style: theme.textTheme.displaySmall),
                const SizedBox(height: Gap.sm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'Every licence plate the packages in this repo can draw. A '
                    'plate is a geometry, a livery and a country block — so two '
                    'of these can share a spec and still be different plates.',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
                  ),
                ),
                const SizedBox(height: Gap.lg),
                Wrap(
                  spacing: Gap.sm,
                  runSpacing: Gap.sm,
                  children: <Widget>[
                    _Stat(value: '${gallerySources.length}', label: 'countries'),
                    _Stat(value: '$systems', label: 'systems'),
                    _Stat(value: '${catalogueItems.length}', label: 'plates'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Gap.xl)),
        for (final GallerySource source in gallerySources) ...<Widget>[
          SliverToBoxAdapter(
            child: CountryShelf(source: source, onOpenPlate: onOpenPlate, onMore: () => onOpenCountry(source)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: Gap.xl)),
        ],
      ],
    );
  }
}

/// A number and what it counts. Three of them across the top is the fastest
/// possible answer to "how big is this thing".
class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm + 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: Radii.smAll,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(value, style: theme.textTheme.titleMedium),
          const SizedBox(width: Gap.xs + 2),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
