import 'package:plate_core/plate_core.dart';
import 'package:serbia_plate/serbia_plate.dart';

import '../catalogue.dart';

/// `serbia_plate`: the region letters, the crest between them and the number,
/// across the private plate and the nine special series.
class SerbiaSource extends GallerySource {
  SerbiaSource();

  @override
  String get countryName => 'Serbia';

  @override
  String get packageName => 'serbia_plate';

  @override
  String get note =>
      'The region letters, the small crest, then four digits and two letters. '
      'Each special series changes the register rather than only the colour — '
      'the police plate leads with П, the taxi closes with TX, the oldtimer '
      'with OT. Not drawn: the Cyrillic echo under the Latin region code and '
      'the two-row variants of the special series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'rs.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SerbiaCountry.serbia,
    validator: const SerbiaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 112',
      note: 'Region letters, four digits, two letters.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', SerbiaPlates.private,
            SerbiaThemes.private, 'B G 1 2 3 4 A B'),
      ],
    ),
    GallerySection(
      title: 'Usage series',
      note: 'The closing letters, not the colour, name the usage.',
      entries: <GalleryEntry>[
        _e('taxi', 'Taxi · closes with TX', SerbiaPlates.taxi,
            SerbiaThemes.taxi, 'N S 1 2 3 4 5 T X'),
        _e('oldtimer', 'Oldtimer · closes with OT', SerbiaPlates.oldtimer,
            SerbiaThemes.oldtimer, 'B G O T 1 2 3'),
        _e('trailer', 'Trailer', SerbiaPlates.trailer,
            SerbiaThemes.trailer, 'A B 1 2 3 B G'),
        _e('agricultural', 'Agricultural', SerbiaPlates.agricultural,
            SerbiaThemes.agricultural, 'K G 1 2 A B C'),
        _e('moped', 'Moped', SerbiaPlates.moped,
            SerbiaThemes.moped, 'B G 1 2 3 4 5'),
        _e('motorcycle', 'Motorcycle', SerbiaPlates.motorcycle,
            SerbiaThemes.motorcycle, 'N S 5 4 3 2 1'),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'The police, military and diplomatic registers.',
      entries: <GalleryEntry>[
        _e('police', 'Police · leads with П', SerbiaPlates.police,
            SerbiaThemes.police, 'П 1 2 3 4 5 6'),
        _e('military', 'Military', SerbiaPlates.military,
            SerbiaThemes.military, 'A 1 2 3 4'),
        _e('diplomatic', 'Diplomatic corps', SerbiaPlates.diplomatic,
            SerbiaThemes.diplomatic, 'B G 1 2 A 3 4 5 6 7'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
