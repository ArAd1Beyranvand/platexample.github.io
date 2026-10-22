import 'package:barbados_plate/barbados_plate.dart';

import '../catalogue.dart';

/// `barbados_plate`: the parish letter and up to four digits.
class BarbadosSource extends GallerySource {
  BarbadosSource();

  @override
  String get countryName => 'Barbados';

  @override
  String get packageName => 'barbados_plate';

  @override
  String get note =>
      'One or two letters (the parish, or the category) then up to four '
      'digits — silver on black front and rear, black on grey at the front. '
      'Not drawn: the special series (President, CD, MP, buses) and the '
      'metallic emblem plates, which have no reference graphic.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The leading letter is the parish: L is Saint Lucy, A Saint Andrew.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'bb.black',
          label: 'Front and rear',
          spec: BarbadosPlates.black,
          theme: BarbadosThemes.black,
          country: BarbadosCountry.barbados,
          validator: const BarbadosValidator(),
          sampleValues: 'L 4159'.split(' '),
        ),
        GalleryEntry(
          id: 'bb.white',
          label: 'Front',
          spec: BarbadosPlates.white,
          theme: BarbadosThemes.white,
          country: BarbadosCountry.barbados,
          validator: const BarbadosValidator(),
          sampleValues: 'A 4083'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
