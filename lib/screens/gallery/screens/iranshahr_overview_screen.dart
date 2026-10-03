import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';
import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../widgets/country_group.dart';

/// The Iranshahr overview page, showing the five countries (Bahrain, Azerbaijan,
/// Afghanistan, Armenia, Tajikistan) as separate groups, just like the Discover
/// page shows different country packages.
///
/// This page is shown when navigating to `/iranshahr` after clicking "All plates"
/// on the Iranshahr group in the Discover page. Each country group has an
/// "All plates" button pointing to `/iranshahr/{country}` for its detail page.
class IranshahirOverviewScreen extends StatelessWidget {
  const IranshahirOverviewScreen({
    super.key,
    required this.onOpenPlate,
    required this.onOpenCountry,
  });

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
                    _Header(compact: compact),
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
                itemCount: iranshahirCountries.length * 2 - 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index.isOdd) return const NRule();
                  final GallerySource source = iranshahirCountries[index ~/ 2];
                  return CountryGroup(
                    key: ValueKey<String>(source.countryName),
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

/// The header: title and description for the Iranshahr overview.
class _Header extends StatelessWidget {
  const _Header({required this.compact});

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
            'Iranshahr'.toUpperCase(),
            style: NType.kicker.copyWith(
              fontSize: 11,
              letterSpacing: 0.12 * 11,
              color: N.accent300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nine countries, one package',
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
            'Bahrain, Azerbaijan, Afghanistan, Armenia, Tajikistan, Kuwait, Qatar, '
            'Iraq and the UAE, in one iranshahr_plate import. The countries share '
            'no design; each has its own specs, colours and country block.',
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
