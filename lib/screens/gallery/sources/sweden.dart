import 'package:plate_core/plate_core.dart';
import 'package:sweden_plate/sweden_plate.dart';

import '../catalogue.dart';

/// `sweden_plate`: three letters, two digits and a digit or letter behind the
/// EU band, and the taxi, dealer, diplomatic, temporary and military plates.
class SwedenSource extends GallerySource {
  SwedenSource();

  @override
  String get countryName => 'Sweden';

  @override
  String get packageName => 'sweden_plate';

  @override
  String get note =>
      'Three letters, then two digits and a digit or (since 2019) a letter, '
      'black on white, with the EU stars and S on a blue band at the left. '
      'Taxi plates are yellow, dealer plates green, diplomatic plates blue '
      '(mission code, three digits, status letter; the code CA is refused '
      'as COUNTRY NOT FOUND), temporary plates red and military plates yellow '
      'digits on black. Not drawn: the 1906–1973 county series, the square '
      'motorcycle plate, personal plates and the tax sticker.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'se.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SwedenCountry.sweden,
    validator: const SwedenValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration — 520 × 110',
      note:
          'Three letters, two digits and a digit or letter; the short form '
          'is 300 mm wide.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car',
          SwedenPlates.private,
          SwedenThemes.private,
          'ABC|12|A',
        ),
        _e(
          'american',
          'Short plate',
          SwedenPlates.american,
          SwedenThemes.private,
          'EPR|47|9',
        ),
        _e('taxi', 'Taxi', SwedenPlates.taxi, SwedenThemes.taxi, 'MLB|94|2'),
        _e(
          'dealer',
          'Dealer',
          SwedenPlates.dealer,
          SwedenThemes.dealer,
          'MLB|206',
        ),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'Diplomatic, temporary and military plates.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic',
          SwedenPlates.diplomatic,
          SwedenThemes.diplomatic,
          'DL|004|B',
        ),
        _e(
          'temporary',
          'Temporary',
          SwedenPlates.temporary,
          SwedenThemes.temporary,
          '25|09|MLB|426|2002|B',
        ),
        _e(
          'military',
          'Military',
          SwedenPlates.military,
          SwedenThemes.military,
          '118076',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
