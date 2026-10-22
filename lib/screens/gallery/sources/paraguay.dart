import 'package:paraguay_plate/paraguay_plate.dart';

import '../catalogue.dart';

/// `paraguay_plate`: the 2019 Mercosur plate, four letters and three digits
/// under a blue country band.
class ParaguaySource extends GallerySource {
  ParaguaySource();

  @override
  String get countryName => 'Paraguay';

  @override
  String get packageName => 'paraguay_plate';

  @override
  String get note =>
      'Four letters and three digits, black on white under a blue band with '
      'the country name and flag. Not drawn: the Mercosur logo, the flag\'s '
      'emblem, the sticker and the motorcycle plate.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Mercosur',
      note: 'The plate issued since July 2019.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'py.mercosur',
          label: 'Mercosur',
          spec: ParaguayPlates.mercosur,
          theme: ParaguayThemes.mercosur,
          country: ParaguayCountry.paraguay,
          validator: const ParaguayValidator(),
          sampleValues: const <String?>['ABCD', '123'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
