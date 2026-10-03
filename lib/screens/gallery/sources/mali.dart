import 'package:mali_plate/mali_plate.dart';

import '../catalogue.dart';

/// `mali_plate`: the simple 520 × 110 current series, one plate type.
///
/// Mali's registration plate is one of the world's simplest: a single format
/// with no variants, no colour coding, no usage categories. White plate with
/// black frame and black text, format AB 1234 MD (2 letters, 4 digits, 2 letters).
class MaliSource extends GallerySource {
  MaliSource();

  @override
  String get countryName => 'Mali';

  @override
  String get packageName => 'mali_plate';

  @override
  String get note => 'One simple plate type: no variants, no categories, '
      'no colour coding. Format: 2 letters, 4 digits, 2 letters.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current series — 520 × 110',
      note: 'All vehicles use the same black on white plate. '
          'No provincial coding, no usage categories.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ml.standard',
          label: 'Standard plate',
          spec: MaliPlates.all['standard']!(),
          theme: MaliThemes.standard,
          country: MaliCountry.mali,
          validator: const MaliValidator(),
          sampleValues: <String?>[
            'A', 'B', '1', '2', '3', '4', 'M', 'D', //
          ],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
