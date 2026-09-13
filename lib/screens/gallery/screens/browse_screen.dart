import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/plate_tile.dart';

/// The whole catalogue at once, searchable and filterable.
///
/// The screen the old app was missing entirely. Everything it showed was
/// reachable only by scrolling to it in a fixed order, so "which package has
/// a two-line motorcycle plate" or "what is `ps.gaza.moto`" could only be
/// answered by reading the page top to bottom. A catalogue's job is lookup,
/// and lookup needs a query.
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, required this.onOpenPlate});

  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _query = TextEditingController();

  /// Null is "all countries" rather than a fifth chip, so the filter row has
  /// one chip per country and the cleared state is simply none selected.
  GallerySource? _country;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CatalogueItem> results = searchCatalogue(query: _query.text, country: _country);
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: _query,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search plates, systems, spec ids…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _query.text.isEmpty
                        ? null
                        : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => setState(_query.clear)),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerLow,
                    border: const OutlineInputBorder(borderRadius: Radii.smAll, borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: Gap.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (final GallerySource source in gallerySources)
                        Padding(
                          padding: const EdgeInsets.only(right: Gap.sm),
                          child: FilterChip(
                            label: Text(source.countryName),
                            selected: identical(_country, source),
                            // Selecting the selected chip clears it, so the
                            // filter needs no separate "all" affordance.
                            onSelected: (bool on) => setState(() => _country = on ? source : null),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: Gap.md),
                Text(
                  results.length == catalogueItems.length
                      ? '${results.length} plates'
                      : '${results.length} of ${catalogueItems.length} plates',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: Gap.md),
              ],
            ),
          ),
        ),
        if (results.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(Gap.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search_off_rounded, size: 40, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: Gap.md),
                  Text('No plate matches that.', style: theme.textTheme.titleMedium),
                  const SizedBox(height: Gap.xs),
                  Text(
                    'Try a country, a system, or part of a spec id.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.xl),
            sliver: PlateSliverGrid(
              stageHeight: 320,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final CatalogueItem item = results[index];
                final String tag = 'browse:${item.entry.id}';
                return PlateTile(
                  key: ValueKey<String>(item.entry.id),
                  entry: item.entry,
                  heroTag: tag,
                  stageHeight: 320,
                  // In a mixed grid the country is the missing fact; the
                  // system qualifies it where a country has more than one.
                  subtitle: '${item.source.countryName} · ${item.entry.spec.id}',
                  onTap: () => widget.onOpenPlate(item, tag),
                );
              },
            ),
          ),
      ],
    );
  }
}
