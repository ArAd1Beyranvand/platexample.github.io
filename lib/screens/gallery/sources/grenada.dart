import 'package:grenada_plate/grenada_plate.dart';

import '../catalogue.dart';

/// `grenada_plate`: the current black-on-yellow plate.
class GrenadaSource extends GallerySource {
  GrenadaSource();

  @override
  String get countryName => 'Grenada';

  @override
  String get packageName => 'grenada_plate';

  @override
  String get note =>
      'Three letters and three digits, black on yellow, no frame or strip. '
      'Not drawn: the 1974 Independence porcelain plate and the white front '
      'plate the article mentions (no picture).';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current',
      note: 'Series of three letters, then three digits.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'gd.current',
          label: 'Current',
          spec: GrenadaPlates.current,
          theme: GrenadaThemes.current,
          country: GrenadaCountry.grenada,
          validator: const GrenadaValidator(),
          sampleValues: const <String>['GAA', '876'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
