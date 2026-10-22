import 'package:brazil_plate/brazil_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `brazil_plate`: the 400 × 130 Mercosul plate in its seven category
/// colours.
class BrazilSource extends GallerySource {
  BrazilSource();

  @override
  String get countryName => 'Brazil';

  @override
  String get packageName => 'brazil_plate';

  @override
  String get note =>
      'ABC1D23 under the blue BRASIL band, the flag at the right and the '
      'Mercosul logo at the left. The ink colour gives the category.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String value) =>
      GalleryEntry(
        id: 'br.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: BrazilCountry.brazil,
        validator: const BrazilPlateValidator(),
        sampleValues: value.split(''),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Mercosul — 400 × 130',
      note:
          'Three letters, a digit, a letter and two digits; the series '
          "implies the issuing state. The serial reads about 70% of the "
          'real height. The QR code is not drawn.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black',
          BrazilPlates.mercosul,
          BrazilThemes.private,
          'QTP5F71',
        ),
        _entry(
          'commercial',
          'Commercial · red',
          BrazilPlates.mercosul,
          BrazilThemes.commercial,
          'CXZ7B41',
        ),
        _entry(
          'official',
          'Official · blue',
          BrazilPlates.mercosul,
          BrazilThemes.official,
          'BOK3C58',
        ),
        _entry(
          'diplomatic',
          'Diplomatic · gold',
          BrazilPlates.mercosul,
          BrazilThemes.diplomatic,
          'OYW4R26',
        ),
        _entry('dealer', 'Dealer · green', BrazilPlates.mercosul, BrazilThemes.dealer, 'MSK9B10'),
        _entry(
          'collector',
          'Collector · grey',
          BrazilPlates.mercosul,
          BrazilThemes.collector,
          'DKV0I01',
        ),
        _entry(
          'collector.national',
          'Collector, Brazil only · white on black',
          BrazilPlates.mercosulNational,
          BrazilThemes.collectorNational,
          'QTP5F71',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
