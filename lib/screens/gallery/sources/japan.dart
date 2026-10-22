import 'package:japan_plate/japan_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `japan_plate`: the national plate in its four colours, the two-wheeler
/// pair, the diplomatic plate and the Roman-letter plate issued for export.
class JapanSource extends GallerySource {
  JapanSource();

  @override
  String get countryName => 'Japan';

  @override
  String get packageName => 'japan_plate';

  @override
  String get note =>
      'The office, a class code and a hiragana, then a serial of two pairs of '
      'digits around a hyphen; the colour says what the vehicle is. Not drawn: '
      'the municipal plates, the illuminated plate, the Imperial and U.S. '
      'forces plates, and the hyphen\'s omission when the first pair is all '
      'dots.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'jp.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: JapanCountry.japan,
    validator: const JapanValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars — 330 × 165',
      note:
          'Office and class code above, hiragana and serial below. Private '
          'is green on white, commercial white on green; the kei cars are '
          'black on yellow and yellow on black.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private · green on white',
          JapanPlates.private,
          JapanThemes.private,
          <String?>['多摩', '500', 'さ', '46', '49'],
        ),
        _e(
          'commercial',
          'Commercial · white on green',
          JapanPlates.commercial,
          JapanThemes.commercial,
          <String?>['京都', '500', 'あ', '46', '49'],
        ),
        _e(
          'kei_private',
          'Kei private · black on yellow',
          JapanPlates.keiPrivate,
          JapanThemes.keiPrivate,
          <String?>['北見', '580', 'あ', '46', '49'],
        ),
        _e(
          'kei_commercial',
          'Kei commercial · yellow on black',
          JapanPlates.keiCommercial,
          JapanThemes.keiCommercial,
          <String?>['鹿児島', '480', 'り', '46', '49'],
        ),
      ],
    ),
    GallerySection(
      title: 'Two-wheelers over 250 cc',
      note:
          'No class code: the office and hiragana share the top row, beside '
          'the inspection sticker.',
      entries: <GalleryEntry>[
        _e(
          'motorcycle',
          'Private · green on white',
          JapanPlates.motorcycle,
          JapanThemes.motorcycle,
          <String?>['松本', 'あ', '46', '49'],
        ),
        _e(
          'motorcycle_commercial',
          'Commercial · white on green',
          JapanPlates.motorcycleCommercial,
          JapanThemes.motorcycleCommercial,
          <String?>['松本', 'ゆ', '46', '49'],
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and export',
      note:
          'The diplomatic plate is five digits after an encircled 外. The '
          'export plate replaces the kanji and hiragana with Roman letters '
          'and carries the flag.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic', JapanPlates.diplomatic, JapanThemes.diplomatic, <String?>[
          '13401',
        ]),
        _e('export', 'Export · Saitama Ōmiya', JapanPlates.export, JapanThemes.export, <String?>[
          'STO',
          'HA',
          '3219',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
