import 'package:saint_vincent_and_the_grenadines_plate/saint_vincent_and_the_grenadines_plate.dart';

import '../catalogue.dart';

/// `saint_vincent_and_the_grenadines_plate`: the usage letter and four digits.
class SaintVincentAndTheGrenadinesSource extends GallerySource {
  SaintVincentAndTheGrenadinesSource();

  @override
  String get countryName => 'Saint Vincent and the Grenadines';

  @override
  String get packageName => 'saint_vincent_and_the_grenadines_plate';

  @override
  String get note =>
      'One usage letter then four digits, black on white — P for private, H '
      'for hire, T for a truck. Not drawn: the country caption and the '
      'motorcycle and government series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The leading letter is the usage class.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'vc.private',
          label: 'Private car',
          spec: SaintVincentAndTheGrenadinesPlates.private,
          theme: SaintVincentAndTheGrenadinesThemes.private,
          country: SaintVincentAndTheGrenadinesCountry.saint_vincent_and_the_grenadines,
          validator: const SaintVincentAndTheGrenadinesValidator(),
          sampleValues: 'P 1234'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
