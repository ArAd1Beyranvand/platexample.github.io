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
        _e(
          'private',
          'Private car',
          SerbiaPlates.private,
          SerbiaThemes.private,
          'BG 1234 AB',
        ),
      ],
    ),
    GallerySection(
      title: 'Usage series',
      note: 'The closing letters, not the colour, name the usage.',
      entries: <GalleryEntry>[
        _e(
          'taxi',
          'Taxi · closes with TX',
          SerbiaPlates.taxi,
          SerbiaThemes.taxi,
          'NS 12345 T X',
        ),
        _e(
          'oldtimer',
          'Oldtimer · closes with OT',
          SerbiaPlates.oldtimer,
          SerbiaThemes.oldtimer,
          'BG O T 123',
        ),
        _e(
          'trailer',
          'Trailer',
          SerbiaPlates.trailer,
          SerbiaThemes.trailer,
          'AB 123 BG',
        ),
        _e(
          'agricultural',
          'Agricultural',
          SerbiaPlates.agricultural,
          SerbiaThemes.agricultural,
          'KG 12 ABC',
        ),
        _e(
          'moped',
          'Moped',
          SerbiaPlates.moped,
          SerbiaThemes.moped,
          'BG 12 345',
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          SerbiaPlates.motorcycle,
          SerbiaThemes.motorcycle,
          'NS 54 321',
        ),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'The police, military and diplomatic registers.',
      entries: <GalleryEntry>[
        _e(
          'police',
          'Police · leads with П',
          SerbiaPlates.police,
          SerbiaThemes.police,
          'П 123 456',
        ),
        _e(
          'military',
          'Military',
          SerbiaPlates.military,
          SerbiaThemes.military,
          'A 1234',
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          SerbiaPlates.diplomatic,
          SerbiaThemes.diplomatic,
          'B G 12 A 345 6 7',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
