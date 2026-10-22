import 'package:polynesia_plate/polynesia_plate.dart';

import '../catalogue.dart';

/// `norfolk_island_plate`: the `3◆203` plate, black on yellow.
class NorfolkIslandSource extends GallerySource {
  NorfolkIslandSource();

  @override
  String get countryName => 'Norfolk Island';

  @override
  String get packageName => 'norfolk_island_plate';

  @override
  String get note =>
      'A block digit 1 to 7, a diamond and three digits, black on yellow '
      'under the caption N·I. The administrative and motorcycle plates have '
      'no picture and are not modelled.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — photo proportions',
      note: 'The one private plate, drawn in the proportions of the photograph.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'nf.private',
          label: 'Private',
          spec: NorfolkIslandPlates.private,
          theme: NorfolkIslandThemes.private,
          country: NorfolkIslandCountry.norfolk_island,
          validator: const NorfolkIslandValidator(),
          sampleValues: <String?>['3', '203'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
