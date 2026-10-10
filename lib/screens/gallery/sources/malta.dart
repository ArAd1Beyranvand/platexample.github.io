import 'package:malta_plate/malta_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `malta_plate`: the EU plate with the island's usage colours — three letters
/// and three digits for private cars, and digit-only series for the rest.
class MaltaSource extends GallerySource {
  MaltaSource();

  @override
  String get countryName => 'Malta';

  @override
  String get packageName => 'malta_plate';

  @override
  String get note =>
      'Three letters and three digits, black on white with the EU band. The '
      'taxi, bus and trailer series are digits only, the taxi closing with the '
      'island letter (M for Malta, G for Gozo); the personalised plate takes '
      'any eight letters or digits. Not drawn: the year sticker and the '
      'motorcycle plate\'s two-row layout.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'mt.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MaltaCountry.malta,
    validator: const MaltaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 110',
      note: 'Three letters then three digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', MaltaPlates.private,
            MaltaThemes.private, 'A B C 1 2 3'),
        _e('personalised', 'Personalised · eight cells',
            MaltaPlates.personalised, MaltaThemes.personalised,
            'M A L T A 0 0 1'),
      ],
    ),
    GallerySection(
      title: 'Usage colours',
      note: 'Digit-only series on a coloured field; the taxi closes with the '
          'island letter.',
      entries: <GalleryEntry>[
        _e('taxi', 'Taxi · white on red', MaltaPlates.taxi,
            MaltaThemes.taxi, '4 5 6 M'),
        _e('bus', 'Bus · black on green', MaltaPlates.bus,
            MaltaThemes.bus, '7 8 9'),
        _e('trailer', 'Trailer · black on yellow', MaltaPlates.trailer,
            MaltaThemes.trailer, '1 2 3 4'),
      ],
    ),
    GallerySection(
      title: 'Motorcycle and vintage',
      note: 'The same six cells as the private plate, on a shorter face.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', MaltaPlates.motorcycle,
            MaltaThemes.motorcycle, 'D E F 4 5 6'),
        _e('vintage', 'Vintage', MaltaPlates.vintage,
            MaltaThemes.vintage, 'G H J 7 8 9'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
