import 'package:antigua_and_barbuda_plate/antigua_and_barbuda_plate.dart';

import '../catalogue.dart';

/// `antigua_and_barbuda_plate`: private, government and taxi plates.
class AntiguaAndBarbudaSource extends GallerySource {
  AntiguaAndBarbudaSource();

  @override
  String get countryName => 'Antigua and Barbuda';

  @override
  String get packageName => 'antigua_and_barbuda_plate';

  @override
  String get note =>
      'A class letter and a number, with the colours naming the vehicle type. '
      'Only the current series is drawn.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Private, government and taxi.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ag.private',
          label: 'Private',
          spec: AntiguaAndBarbudaPlates.private,
          theme: AntiguaAndBarbudaThemes.private,
          country: AntiguaAndBarbudaCountry.antigua_and_barbuda,
          validator: const AntiguaAndBarbudaValidator(),
          sampleValues: <String?>['A', '1587'],
        ),
        GalleryEntry(
          id: 'ag.government',
          label: 'Government',
          spec: AntiguaAndBarbudaPlates.government,
          theme: AntiguaAndBarbudaThemes.government,
          country: AntiguaAndBarbudaCountry.antigua_and_barbuda,
          validator: const AntiguaAndBarbudaValidator(maxDigits: 3),
          sampleValues: <String?>['G', '631'],
        ),
        GalleryEntry(
          id: 'ag.taxi',
          label: 'Taxi',
          spec: AntiguaAndBarbudaPlates.taxi,
          theme: AntiguaAndBarbudaThemes.taxi,
          country: AntiguaAndBarbudaCountry.antigua_and_barbuda,
          validator: const AntiguaAndBarbudaValidator(),
          sampleValues: <String?>['H', '3589'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
