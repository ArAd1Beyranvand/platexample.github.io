import 'package:plate_core/plate_core.dart';
import 'package:north_korea_plate/north_korea_plate.dart';

import '../catalogue.dart';

/// `south_korea_plate`: the current series. Every field is one slot, so
/// sample values are one token per field.
class SouthKoreaSource extends GallerySource {
  SouthKoreaSource();

  @override
  String get countryName => 'South Korea';

  @override
  String get packageName => 'north_korea_plate';

  @override
  String get note =>
      'Class digits, one Hangul syllable and a four-digit serial; yellow '
      'commercial, blue diplomatic, orange US Forces and the 2024 neon-green '
      'luxury plate with its Euroband. The neon plate and the US Forces '
      'digit split are estimated, not measured.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SouthKoreaCountry.south_korea,
    validator: const SouthKoreaValidator(),
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current plates',
      note: 'Heights follow each photograph: 335×155, 335×170 and 520×110.',
      entries: <GalleryEntry>[
        _e('kr.private', 'Private', SouthKoreaPlates.private, SouthKoreaThemes.private, <String?>[
          '12',
          '가',
          '3456',
        ]),
        _e(
          'kr.commercial',
          'Commercial',
          SouthKoreaPlates.commercial,
          SouthKoreaThemes.commercial,
          <String?>['서울', '31', '가', '1234'],
        ),
        _e(
          'kr.military',
          'Military',
          SouthKoreaPlates.military,
          SouthKoreaThemes.military,
          <String?>['38', '육', '4104'],
        ),
        _e(
          'kr.diplomatic',
          'Diplomatic',
          SouthKoreaPlates.diplomatic,
          SouthKoreaThemes.diplomatic,
          <String?>['123', '456'],
        ),
        _e(
          'kr.us_forces',
          'US Forces',
          SouthKoreaPlates.usForces,
          SouthKoreaThemes.usForces,
          <String?>['1', '6047'],
        ),
        _e('kr.neon', 'Neon green', SouthKoreaPlates.neon, SouthKoreaThemes.neon, <String?>[
          '177',
          '호',
          '1336',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
