import 'package:lesotho_plate/lesotho_plate.dart';

import '../catalogue.dart';

/// `lesotho_plate`: the blue-on-white private plate with its validity sticker.
class LesothoSource extends GallerySource {
  LesothoSource();

  @override
  String get countryName => 'Lesotho';

  @override
  String get packageName => 'lesotho_plate';

  @override
  String get note =>
      'One or two letters and four digits in blue on white, with a mokorotlo '
      'validity sticker. Not drawn: the red government and dealer plates and '
      'the CD diplomatic plates.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The sticker shows the five-year validity period.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ls.private',
          label: 'Private',
          spec: LesothoPlates.private,
          theme: LesothoThemes.private,
          country: LesothoCountry.lesotho,
          validator: const LesothoValidator(),
          sampleValues: <String?>['A', '1705'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
