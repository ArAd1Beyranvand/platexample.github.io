import 'package:plate_core/plate_core.dart';
import 'package:san_marino_plate/san_marino_plate.dart';

import '../catalogue.dart';

/// `san_marino_plate`: a coloured prefix and up to four digits, with the coat
/// of arms at the left.
class SanMarinoSource extends GallerySource {
  SanMarinoSource();

  @override
  String get countryName => 'San Marino';

  @override
  String get packageName => 'san_marino_plate';

  @override
  String get note =>
      'A letter or short code, then up to four digits; the prefix is red on '
      'the coded plates. Not drawn: PROVA (test), GE, VU, the year sticker and '
      'the older and 2023 front plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'sm.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SanMarinoCountry.san_marino,
    validator: const SanMarinoValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Vehicles',
      note: 'A letter and up to four digits.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private',
          SanMarinoPlates.private,
          SanMarinoThemes.private,
          'L 3237',
        ),
        _e(
          'trailer',
          'Trailer · R',
          SanMarinoPlates.trailer,
          SanMarinoThemes.trailer,
          'R 2558',
        ),
        _e(
          'export',
          'Export · E',
          SanMarinoPlates.export,
          SanMarinoThemes.export,
          'E 2001',
        ),
        _e(
          'electric',
          'Electric · VE',
          SanMarinoPlates.electric,
          SanMarinoThemes.electric,
          'VE 001',
        ),
      ],
    ),
    GallerySection(
      title: 'Institutions',
      note: 'A red code and up to three digits.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic · CD',
          SanMarinoPlates.diplomatic,
          SanMarinoThemes.diplomatic,
          'CD 60',
        ),
        _e(
          'red_cross',
          'Red Cross · CRS',
          SanMarinoPlates.redCross,
          SanMarinoThemes.redCross,
          'CRS 16',
        ),
        _e(
          'police',
          'Police',
          SanMarinoPlates.police,
          SanMarinoThemes.police,
          'POLIZIA 145',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
