import 'package:mauritania_plate/mauritania_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `mauritania_plate`: the 520 × 110 Euro-style plate in blue and in red.
class MauritaniaSource extends GallerySource {
  MauritaniaSource();

  @override
  String get countryName => 'Mauritania';

  @override
  String get packageName => 'mauritania_plate';

  @override
  String get note =>
      '1234 AB 00 with the RIM strip at the right; the last two digits are '
      'the region. Nothing in this package is specific to Israel.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String value) =>
      GalleryEntry(
        id: 'mr.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: MauritaniaCountry.mauritania,
        validator: const MauritaniaPlateValidator(),
        sampleValues: value.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Euro-style — 520 × 110',
      note:
          'Four digits, two letters and a region code. The serial reads '
          'about 66% of the real height. '
          'and the article does not say what the red series is for.',
      entries: <GalleryEntry>[
        _entry('blue', 'Blue', MauritaniaPlates.blue, MauritaniaThemes.blue, '1234 AB 00'),
        _entry('red', 'Red', MauritaniaPlates.red, MauritaniaThemes.red, '1006 TT 05'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
