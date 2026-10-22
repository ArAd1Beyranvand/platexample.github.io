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
      title: 'ABC-12-34',
      note: 'Three letters, two digits, two digits: most states.',
      entries: <GalleryEntry>[
        _e('bc', 'Baja California', MexicoPlates.bajaCalifornia, MexicoThemes.standard, <String?>[
          'AHD',
          '41',
          '02',
        ]),
        _e('camp', 'Campeche', MexicoPlates.campeche, MexicoThemes.campeche, <String?>[
          'DFF',
          '81',
          '88',
        ]),
        _e('chis', 'Chiapas', MexicoPlates.chiapas, MexicoThemes.standard, <String?>[
          'DMT',
          '60',
          '00',
        ]),
        _e('chih', 'Chihuahua', MexicoPlates.chihuahua, MexicoThemes.standard, <String?>[
          'DZG',
          '20',
          '01',
        ]),
        _e('gro', 'Guerrero', MexicoPlates.guerrero, MexicoThemes.standard, <String?>[
          'HFT',
          '42',
          '43',
        ]),
        _e('jal', 'Jalisco', MexicoPlates.jalisco, MexicoThemes.standard, <String?>[
          'JDS',
          '80',
          '80',
        ]),
        _e('mex', 'Estado de México', MexicoPlates.stateOfMexico, MexicoThemes.standard, <String?>[
          'NCM',
          '68',
          '10',
        ]),
        _e('mich', 'Michoacán', MexicoPlates.michoacan, MexicoThemes.standard, <String?>[
          'PFR',
          '15',
          '18',
        ]),
        _e('mor', 'Morelos', MexicoPlates.morelos, MexicoThemes.standard, <String?>[
          'PXR',
          '84',
          '44',
        ]),
        _e('oax', 'Oaxaca', MexicoPlates.oaxaca, MexicoThemes.oaxaca, <String?>['TJK', '89', '22']),
        _e('pue', 'Puebla', MexicoPlates.puebla, MexicoThemes.standard, <String?>[
          'TVN',
          '84',
          '08',
        ]),
        _e('qro', 'Querétaro', MexicoPlates.queretaro, MexicoThemes.standard, <String?>[
          'UNR',
          '61',
          '98',
        ]),
        _e(
          'slp',
          'San Luis Potosí',
          MexicoPlates.sanLuisPotosi,
          MexicoThemes.sanLuisPotosi,
          <String?>['UYT', '00', '00'],
        ),
        _e('son', 'Sonora', MexicoPlates.sonora, MexicoThemes.sonora, <String?>['VUK', '17', '75']),
        _e('tab', 'Tabasco', MexicoPlates.tabasco, MexicoThemes.standard, <String?>[
          'WLU',
          '94',
          '69',
        ]),
        _e('ver', 'Veracruz', MexicoPlates.veracruz, MexicoThemes.veracruz, <String?>[
          'YBU',
          '80',
          '66',
        ]),
      ],
    ),
    GallerySection(
      title: 'Other serials',
      note:
          'Two letters, two and three digits (Coahuila, Zacatecas); three '
          'letters, three digits, a letter (Nuevo León, Quintana Roo, '
          'Yucatán); two letters, four digits, a letter (Sinaloa); two '
          'digits twice, three letters (Baja California Sur); Mexico City '
          'prints three digits and three letters, without I, O or Q.',
      entries: <GalleryEntry>[
        _e('coah', 'Coahuila', MexicoPlates.coahuila, MexicoThemes.standard, <String?>[
          'EN',
          '86',
          '000',
        ], format: MexicoFormat.letters2Digits2Digits3),
        _e('zac', 'Zacatecas', MexicoPlates.zacatecas, MexicoThemes.standard, <String?>[
          'ZA',
          '65',
          '576',
        ], format: MexicoFormat.letters2Digits2Digits3),
        _e('nl', 'Nuevo León', MexicoPlates.nuevoLeon, MexicoThemes.standard, <String?>[
          'SYY',
          '677',
          'A',
        ], format: MexicoFormat.letters3Digits3Letter1),
        _e('qroo', 'Quintana Roo', MexicoPlates.quintanaRoo, MexicoThemes.standard, <String?>[
          'URU',
          '197',
          'A',
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
