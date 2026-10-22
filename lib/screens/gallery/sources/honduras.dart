import 'package:honduras_plate/honduras_plate.dart';

import '../catalogue.dart';

/// `honduras_plate`: the 2018 plate, black on white under a blue band.
class HondurasSource extends GallerySource {
  HondurasSource();

  @override
  String get countryName => 'Honduras';

  @override
  String get packageName => 'honduras_plate';

  @override
  String get note =>
      'A class letter, two series letters and four digits (H AB 0123) in '
      'black on white under a blue band with the flag, drawn in code. Only '
      'the 2018 design has a photo; the older commercial, diplomatic, '
      'government, trailer and light-truck formats are not drawn. The '
      'article lists nothing Israel-specific, so nothing is refused.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '2018',
      note: 'The current private plate.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'hn.private',
          label: 'Private · black on white',
          spec: HondurasPlates.private,
          theme: HondurasThemes.private,
          country: HondurasCountry.honduras,
          validator: const HondurasValidator(),
          sampleValues: const <String?>['H', 'AB', '0123'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
