import 'package:spain_plate/spain_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `gibraltar_plate`: white front and yellow rear, with the `GBZ` band.
class GibraltarSource extends GallerySource {
  GibraltarSource();

  @override
  String get countryName => 'Gibraltar';

  @override
  String get packageName => 'gibraltar_plate';

  @override
  String get note =>
      'G, a serial and a series letter. Not drawn: the pre-Brexit EU star '
      'ring, the square rear plate, the pre-2001 serials without a series '
      'letter beyond `G 1`, and the Governor\'s and military vehicles.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'gi.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GibraltarCountry.gibraltar,
    validator: const GibraltarValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'Black on white at the front, black on yellow at the rear.',
      entries: <GalleryEntry>[
        _e('front', 'Front', GibraltarPlates.private, GibraltarThemes.front, <String?>[
          'G',
          '6442',
          'F',
        ]),
        _e('rear', 'Rear', GibraltarPlates.private, GibraltarThemes.rear, <String?>[
          'G',
          '3624',
          'C',
        ]),
        _e('temporary', 'Temporary', GibraltarPlates.temporary, GibraltarThemes.rear, <String?>[
          'G',
          '6065',
          'E',
          '10',
          '19',
        ]),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'Trailer, official, dealer and armed-forces plates.',
      entries: <GalleryEntry>[
        _e('trailer', 'Trailer', GibraltarPlates.trailer, GibraltarThemes.rear, <String?>[
          'GT',
          '1234',
          'A',
        ]),
        _e('official', 'Chief Minister', GibraltarPlates.numbered, GibraltarThemes.rear, <String?>[
          'G',
          '1',
        ]),
        _e('dealer', 'Dealer', GibraltarPlates.dealer, GibraltarThemes.front, <String?>[
          'DLR',
          '190',
        ]),
        _e('forces', 'Armed forces', GibraltarPlates.armedForces, GibraltarThemes.rear, <String?>[
          '44',
          'RN',
          '34',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
