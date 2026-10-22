import 'dart:math';

import 'package:jamaica_plate/jamaica_plate.dart';

import '../catalogue.dart';

/// `jamaica_plate`: the private-car plate, the only one the article shows.
class JamaicaSource extends GallerySource {
  JamaicaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1987);

  @override
  String get countryName => 'Jamaica';

  @override
  String get packageName => 'jamaica_plate';

  @override
  String get note =>
      'Private cars only: blue on white, four digits and one or two letters '
      '(one on motorcycles). The other series are described in prose without '
      'an image and are not drawn.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note:
          'The serial is about 57% of the real height: the plate face is '
          'condensed and a run wider than its box is scaled down.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'jm.private',
          label: '1987 · blue on white',
          spec: JamaicaPlates.private,
          theme: JamaicaThemes.private,
          country: JamaicaCountry.jamaica,
          validator: const JamaicaValidator(),
          sampleValues: JamaicaSerialGenerator.generate(JamaicaPlates.private, random: _rng),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
