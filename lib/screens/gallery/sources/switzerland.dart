import 'package:plate_core/plate_core.dart';
import 'package:switzerland_plate/switzerland_plate.dart';

import '../catalogue.dart';

/// `switzerland_plate`: the current federal series. The diplomatic entries'
/// validator and spec both refuse country code 7 with "COUNTRY NOT FOUND".
class SwitzerlandSource extends GallerySource {
  SwitzerlandSource();

  @override
  String get countryName => 'Switzerland';

  @override
  String get packageName => 'switzerland_plate';

  @override
  String get note =>
      'A canton code and up to six digits, black on white, the category in '
      'the field colour. The cantonal arms printed beside the shield are not '
      'drawn, and the shield is a hand-drawn approximation. Diplomatic '
      'country code 7 is refused in every layer with "COUNTRY NOT FOUND".';

  static List<String?> _v(String s) =>
      s.split(' ').map<String?>((t) => t.isEmpty ? null : t).toList();

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const SwitzerlandValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SwitzerlandCountry.switzerland,
    validator: validator,
    sampleValues: _v(values),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Rear, two rows — 300 × 160',
      note: 'Utility and exceptional transport differ only in the field.',
      entries: <GalleryEntry>[
        _e('ch.high', 'Private', SwitzerlandPlates.high, SwitzerlandThemes.standard, 'ZH 123456'),
        _e('ch.utility', 'Utility', SwitzerlandPlates.high, SwitzerlandThemes.utility, 'ZH 4229'),
        _e(
          'ch.exceptional',
          'Exceptional transport',
          SwitzerlandPlates.high,
          SwitzerlandThemes.exceptional,
          'BE 5678',
        ),
        _e(
          'ch.dealer',
          'Dealer',
          SwitzerlandPlates.dealer,
          SwitzerlandThemes.standard,
          'TI 1234 U',
        ),
        _e(
          'ch.temporary',
          'Temporary',
          SwitzerlandPlates.temporary,
          SwitzerlandThemes.standard,
          'VD 12345 06',
        ),
      ],
    ),
    GallerySection(
      title: 'Rear, one row — 500 × 110',
      note: 'Cantonal one-row rear plate, plus the bicycle-carrier, military and customs plates.',
      entries: <GalleryEntry>[
        _e('ch.long', 'Private', SwitzerlandPlates.long, SwitzerlandThemes.standard, 'SG 123456'),
        _e('ch.red', 'Bicycle carrier', SwitzerlandPlates.long, SwitzerlandThemes.red, 'SG 123456'),
        _e(
          'ch.military',
          'Military',
          SwitzerlandPlates.military,
          SwitzerlandThemes.military,
          'M 123456',
          validator: const SwitzerlandValidator(military: true),
        ),
        _e(
          'ch.customs',
          'Customs',
          SwitzerlandPlates.customs,
          SwitzerlandThemes.standard,
          'ZH 1 Z',
        ),
      ],
    ),
    GallerySection(
      title: 'Front, small — 300 × 80',
      note: 'The short front plate.',
      entries: <GalleryEntry>[
        _e('ch.front', 'Front', SwitzerlandPlates.front, SwitzerlandThemes.standard, 'GR 1999'),
        _e(
          'ch.agricultural',
          'Agricultural front',
          SwitzerlandPlates.front,
          SwitzerlandThemes.agricultural,
          'TG 7',
        ),
        _e(
          'ch.motorcycle',
          'Motorcycle',
          SwitzerlandPlates.motorcycle,
          SwitzerlandThemes.standard,
          'SG 12345',
        ),
        _e(
          'ch.scooter',
          'Scooter',
          SwitzerlandPlates.scooter,
          SwitzerlandThemes.scooter,
          'LU 4567',
          note:
              'Laid out like the motorcycle plate: its photograph could '
              'not be rectified.',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic — 500 × 110',
      note: 'Diplomatic and consular series.',
      entries: <GalleryEntry>[
        _e(
          'ch.diplomatic',
          'Diplomatic (CD)',
          SwitzerlandPlates.diplomatic,
          SwitzerlandThemes.diplomatic,
          'CD GE 29 201',
          validator: const SwitzerlandDiplomaticValidator(),
          note: 'The last field is the country code. Try typing 7.',
        ),
        _e(
          'ch.consular',
          'Consular (CC)',
          SwitzerlandPlates.consular,
          SwitzerlandThemes.diplomatic,
          'CC ZH 8 38',
          validator: const SwitzerlandDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
