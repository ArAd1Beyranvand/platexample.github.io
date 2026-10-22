import 'package:malawi_plate/malawi_plate.dart';

import '../catalogue.dart';

/// `malawi_plate`: two letters and four digits, silver on black.
class MalawiSource extends GallerySource {
  MalawiSource();

  @override
  String get countryName => 'Malawi';

  @override
  String get packageName => 'malawi_plate';

  @override
  String get note =>
      'Two letters and four digits, silver on black. Only the private plate '
      'was measured. Not drawn: the year stamp and sticker, and any other '
      'category.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 124',
      note: 'Two letters then four digits.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'mw.private',
          label: 'Private car',
          spec: MalawiPlates.private,
          theme: MalawiThemes.private,
          country: MalawiCountry.malawi,
          validator: const MalawiValidator(),
          sampleValues: const <String>['BC', '5049'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
