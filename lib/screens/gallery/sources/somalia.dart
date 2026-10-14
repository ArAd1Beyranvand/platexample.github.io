import 'package:somalia_plate/somalia_plate.dart';

import '../catalogue.dart';

/// `somalia_plate`: the 520 × 200 bilingual plate, black on white.
class SomaliaSource extends GallerySource {
  SomaliaSource();

  @override
  String get countryName => 'Somalia';

  @override
  String get packageName => 'somalia_plate';

  @override
  String get note =>
      'SOM, the coat of arms and الصومال over two letters and four digits. '
      'Only this one design is documented; the Puntland series is not '
      'implemented.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 520 × 200',
      note:
          'The size is the artwork\'s own proportion, as the article gives '
          'none. The serial reads about 74% of the real height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'so.standard',
          label: 'Standard · black on white',
          spec: SomaliaPlates.standard,
          theme: SomaliaThemes.standard,
          country: SomaliaCountry.somalia,
          validator: const SomaliaPlateValidator(),
          sampleValues: <String?>['AD', '4657'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
