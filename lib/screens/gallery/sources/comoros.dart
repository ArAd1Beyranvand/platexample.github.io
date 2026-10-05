import 'package:comoros_plate/comoros_plate.dart';

import '../catalogue.dart';

/// `comoros_plate`: the single-row plate and the square two-row plate, silver
/// on black.
class ComorosSource extends GallerySource {
  ComorosSource();

  @override
  String get countryName => 'Comoros';

  @override
  String get packageName => 'comoros_plate';

  @override
  String get note =>
      'A number, a letter and a two-digit code; the square plate adds the '
      'crescent, four stars and COMORES. The island, government and '
      'diplomatic series are not implemented, and nothing Israel-specific '
      'exists to refuse.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Single row — 520 × 110',
      note: 'The ink reads about 79% of the artwork\'s height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'km.standard',
          label: 'Standard · silver on black',
          spec: ComorosPlates.standard,
          theme: ComorosThemes.standard,
          country: ComorosCountry.comoros,
          validator: const ComorosPlateValidator(),
          sampleValues: '1284A73'.split(''),
        ),
      ],
    ),
    GallerySection(
      title: 'Square — 326 × 200',
      note:
          'The size is the photograph\'s proportion once rectified, as the '
          'article gives none. The ink reads about 65% of the real height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'km.square',
          label: 'Square · silver on black',
          spec: ComorosPlates.square,
          theme: ComorosThemes.square,
          country: ComorosCountry.comoros,
          validator: const ComorosPlateValidator(),
          sampleValues: '079U73'.split(''),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
