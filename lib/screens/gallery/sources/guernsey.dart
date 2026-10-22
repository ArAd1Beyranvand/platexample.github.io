import 'package:united_kingdom_plate/united_kingdom_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `guernsey_plate`: the white front, yellow rear and Alderney plates.
class GuernseySource extends GallerySource {
  GuernseySource();

  @override
  String get countryName => 'Guernsey';

  @override
  String get packageName => 'guernsey_plate';

  @override
  String get note =>
      'Up to five digits, no letters; Alderney adds the prefix AY and up to '
      'four digits. Not drawn: the optional GBG oval, hire cars\' black H on '
      'yellow, and Alderney\'s one-line standard plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateCountry country,
    String serial,
  ) => GalleryEntry(
    id: 'gg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: country,
    validator: const GuernseyValidator(),
    sampleValues: <String?>[serial],
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Guernsey',
      note: 'Black on white at the front, black on yellow at the rear.',
      entries: <GalleryEntry>[
        _e(
          'front',
          'Front',
          GuernseyPlates.front,
          GuernseyThemes.front,
          GuernseyCountry.guernsey,
          '8982',
        ),
        _e(
          'rear',
          'Rear',
          GuernseyPlates.rear,
          GuernseyThemes.rear,
          GuernseyCountry.guernsey,
          '69571',
        ),
      ],
    ),
    GallerySection(
      title: 'Alderney',
      note: 'AY over one to four digits, on a yellow rear plate.',
      entries: <GalleryEntry>[
        _e(
          'alderney',
          'Alderney rear',
          GuernseyPlates.alderney,
          GuernseyThemes.alderney,
          GuernseyCountry.alderney,
          '933',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
