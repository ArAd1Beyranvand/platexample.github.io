import 'dart:math';

import 'package:russia_plate/russia_plate.dart';

import '../catalogue.dart';

/// `south_ossetia_plate`: the standard plate.
class SouthOssetiaSource extends GallerySource {
  SouthOssetiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1992);

  @override
  String get countryName => 'South Ossetia';

  @override
  String get packageName => 'south_ossetia_plate';

  @override
  String get note =>
      'A letter, three digits and two letters, then the flag and RSO left of '
      'a divider. Only twelve Cyrillic capitals that look Latin are used, as '
      'in Russia, but without a region code.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Black on white with the national flag.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'so.standard',
          label: 'Standard · А733АН',
          spec: SouthOssetiaPlates.standard,
          theme: SouthOssetiaThemes.standard,
          country: SouthOssetiaCountry.southOssetia,
          validator: const SouthOssetiaValidator(),
          sampleValues: SouthOssetiaSerialGenerator.generate(
            SouthOssetiaPlates.standard,
            random: _rng,
          ),
        ),
      ],
    ),
  ];
  List<GallerySection>? _sections;
}
