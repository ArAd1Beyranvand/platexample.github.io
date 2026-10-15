import 'package:zambia_plate/zambia_plate.dart';

import '../catalogue.dart';

/// `zambia_plate`: the red-on-white private plate.
class ZambiaSource extends GallerySource {
  ZambiaSource();

  @override
  String get countryName => 'Zambia';

  @override
  String get packageName => 'zambia_plate';

  @override
  String get note =>
      'Three letters, four digits and a letter, red on white in the 520×110 '
      'European shape. Not drawn: the left badge (ZS mark and coat of arms) '
      'and the older series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The one plate measured: ADD 4077 T.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'zm.private',
          label: 'Private',
          spec: ZambiaPlates.private,
          theme: ZambiaThemes.private,
          country: ZambiaCountry.zambia,
          validator: const ZambiaValidator(),
          sampleValues: const <String?>['ADD', '4077', 'T'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
