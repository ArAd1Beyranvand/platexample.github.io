import 'package:mexico_plate/mexico_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `mexico_plate`: one state private-car design per state, a serial in
/// fields (`AHD` `41` `02`), each with its own validator format.
class MexicoSource extends GallerySource {
  MexicoSource();

  @override
  String get countryName => 'Mexico';

  @override
  String get packageName => 'mexico_plate';

  @override
  String get note =>
      'Every state issues its own design under one national numbering. '
      'Serials are fields: three letters, two digits, two digits; the '
      'colours are sampled from photographs, the state artwork is not drawn.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    MexicoFormat format = MexicoFormat.letters3Digits2Digits2,
  }) => GalleryEntry(
    id: 'mx.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MexicoCountry.mexico,
    validator: MexicoValidator(format),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'State plates',
      note:
          'The state is a choice in the name row and picks the livery. '
          'ABC-12-34 (16 states), AB-12-345 (Coahuila, Zacatecas), '
          'ABC-123-A (Nuevo León, Quintana Roo); Yucatán has a banded top; '
          'Sinaloa, Baja California Sur and Mexico City have their own serials.',
      entries: <GalleryEntry>[
        _e('state', 'State plates', MexicoPlates.standard, MexicoThemes.standard, <String?>[
          'AHD',
          '41',
          '02',
          'BAJA CALIFORNIA',
        ]),
        _e('state_aa', 'Coahuila, Zacatecas', MexicoPlates.twoLetters, MexicoThemes.standard, <String?>[
          'EN',
          '86',
          '000',
          'COAHUILA',
        ], format: MexicoFormat.letters2Digits2Digits3),
        _e('state_aaa_a', 'Nuevo León, Quintana Roo', MexicoPlates.threeDigits, MexicoThemes.standard, <String?>[
          'SYY',
          '677',
          'A',
          'NUEVO LEÓN',
        ], format: MexicoFormat.letters3Digits3Letter1),
        _e('yuc', 'Yucatán', MexicoPlates.yucatan, MexicoThemes.standard, <String?>[
          'ZCT',
          '609',
          'A',
        ], format: MexicoFormat.letters3Digits3Letter1),
        _e('sin', 'Sinaloa', MexicoPlates.sinaloa, MexicoThemes.standard, <String?>[
          'TR',
          '6228',
          'A',
        ], format: MexicoFormat.letters2Digits4Letter1),
        _e(
          'bcs',
          'Baja California Sur',
          MexicoPlates.bajaCaliforniaSur,
          MexicoThemes.standard,
          <String?>['42', '62', 'AVB'],
          format: MexicoFormat.digits2Digits2Letters3,
        ),
        _e('cdmx', 'Mexico City', MexicoPlates.mexicoCity, MexicoThemes.standard, <String?>[
          '477',
          'PNK',
        ], format: MexicoFormat.digits3Letters3),
      ],
    ),
    GallerySection(
      title: 'Federal, antique and 1992',
      note: 'Tourism (SPF), a Morelos antique and the green 1992 series.',
      entries: <GalleryEntry>[
        _e('spf', 'Federal tourism (SPF)', MexicoPlates.tourism, MexicoThemes.tourism, <String?>[
          '847',
          'RB',
          '5',
        ], format: MexicoFormat.tourism),
        _e('antique', 'Antique (Morelos)', MexicoPlates.antique, MexicoThemes.antique, <String?>[
          '3',
          'NE',
          '88',
        ], format: MexicoFormat.antique),
        _e('1992', '1992 series', MexicoPlates.legacy, MexicoThemes.legacy, <String?>[
          'SLC',
          '8377',
        ], format: MexicoFormat.legacy),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
