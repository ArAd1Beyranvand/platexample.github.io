import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';
import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/country_group.dart';

/// An umbrella source's page: one group per [GallerySource.members], laid out
/// like the Discover index — Iranshahr's countries, Yemen's systems.
///
/// Each group's "All plates" opens the member's own page, nested under the
/// umbrella's URL (`/discover/{umbrella}/{member}`).
class GroupOverviewScreen extends StatelessWidget {
  const GroupOverviewScreen({
    super.key,
    required this.source,
    required this.onOpenPlate,
    required this.onOpenCountry,
  });

  final GallerySource source;

  final void Function(CatalogueItem item, String heroTag) onOpenPlate;
  final ValueChanged<GallerySource> onOpenCountry;

  /// Same padding as Discover for visual consistency.
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(72, 72, 64, 96);
  static const EdgeInsets _compactPadding = EdgeInsets.fromLTRB(40, 56, 40, 72);

  @override
  Widget build(BuildContext context) {
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
                    _Header(source: source, compact: compact),
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
                itemCount: source.members.length * 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index.isOdd) return const NRule();
                  final GallerySource member = source.members[index ~/ 2];
                  return CountryGroup(
                    key: ValueKey<String>(member.countryName),
                    source: member,
                    compact: compact,
                    onOpenPlate: onOpenPlate,
                    onOpenCountry: () => onOpenCountry(member),
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

/// The header: the umbrella's name, its headline and its note.
class _Header extends StatelessWidget {
  const _Header({required this.source, required this.compact});

  final GallerySource source;
  final bool compact;

  static const double _textWidth = 640;

  @override
  Widget build(BuildContext context) {
    final Widget text = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _textWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            source.countryName.toUpperCase(),
            style: NType.kicker.copyWith(
              fontSize: 11,
              letterSpacing: 0.12 * 11,
              color: N.accent300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            source.overviewTitle,
            style: TextStyle(
              fontFamily: NType.archivo,
              fontWeight: FontWeight.w800,
              fontSize: compact ? 36 : 52,
              height: 1.1,
              letterSpacing: -0.035 * (compact ? 36 : 52),
              color: N.n100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            source.note,
            style: const TextStyle(
              fontFamily: NType.serif,
              fontSize: 18,
              height: 1.6,
              color: N.n300,
            ),
          ),
        ],
      ),
    );

    return text;
  }
}
