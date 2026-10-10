import 'package:plate_core/plate_core.dart';
import 'package:turkmenistan_plate/turkmenistan_plate.dart';

import '../catalogue.dart';

/// `turkmenistan_plate`: the region letter, the number and the TM code, across
/// the classic plate, the white private plate and the state series.
class TurkmenistanSource extends GallerySource {
  TurkmenistanSource();

  @override
  String get countryName => 'Turkmenistan';

  @override
  String get packageName => 'turkmenistan_plate';

  @override
  String get note =>
      'A region letter, four digits and the two-letter country code. Each '
      'series reorders the register rather than only recolouring it — the '
      'foreign plate leads with a digit, the government plate ends with the '
      'letters. Not drawn: the crescent and stars in full detail and the '
      'transit series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    TurkmenistanValidator validator,
  ) => GalleryEntry(
    id: 'tm.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TurkmenistanCountry.turkmenistan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The classic plate carries one region letter, the current two.',
      entries: <GalleryEntry>[
        _e('classic', 'Classic', TurkmenistanPlates.classic,
            TurkmenistanThemes.classic, 'A 1 2 3 4 A G',
            TurkmenistanValidator.classic),
        _e('private', 'Private car', TurkmenistanPlates.private,
            TurkmenistanThemes.private, 'A T 5 6 7 8 A G',
            const TurkmenistanValidator()),
        _e('trailer', 'Trailer', TurkmenistanPlates.trailer,
            TurkmenistanThemes.private, 'A T 1 1 2 2 B N',
            TurkmenistanValidator.trailer),
      ],
    ),
    GallerySection(
      title: 'Foreign and export',
      note: 'The foreign plate leads with the status digit.',
      entries: <GalleryEntry>[
        _e('foreign', 'Foreign resident', TurkmenistanPlates.foreign,
            TurkmenistanThemes.foreign, '1 H 2 3 4 5 6',
            TurkmenistanValidator.foreign),
        _e('foreign_trailer', 'Foreign trailer',
            TurkmenistanPlates.foreignTrailer, TurkmenistanThemes.foreign,
            '2 H T 8 9 0 1', TurkmenistanValidator.foreignTrailer),
        _e('export', 'Export', TurkmenistanPlates.export,
            TurkmenistanThemes.foreign, 'A B C 1 2 3 4',
            TurkmenistanValidator.export),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'Diplomatic, government, military and ceremonial registers.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic corps', TurkmenistanPlates.diplomatic,
            TurkmenistanThemes.diplomatic, '1 2 C D 3 4 5',
            TurkmenistanValidator.diplomatic),
        _e('government', 'Government', TurkmenistanPlates.government,
            TurkmenistanThemes.government, '1 2 3 4 A G A',
            TurkmenistanValidator.government),
        _e('military', 'Military', TurkmenistanPlates.military,
            TurkmenistanThemes.government, '5 6 7 8 A G',
            TurkmenistanValidator.military),
        _e('ceremony', 'Ceremonial', TurkmenistanPlates.ceremony,
            TurkmenistanThemes.government, 'T U R K M E 1',
            TurkmenistanValidator.ceremony),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
