import 'dart:math';

import 'package:caribbean_plate/caribbean_plate.dart';

import '../catalogue.dart';

/// `anguilla_plate`: the 2007 plate, one design.
class AnguillaSource extends GallerySource {
  AnguillaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1967);

  @override
  String get countryName => 'Anguilla';

  @override
  String get packageName => 'anguilla_plate';

  @override
  String get note =>
      'A type letter and one to four digits over a blue-and-white gradient, '
      'with the coat of arms. The 1950s white-on-black plate and the '
      "Governor's crown plate are not modelled.";

  late final GalleryEntry _private = GalleryEntry(
    id: 'ai.private',
    label: 'Private · 2007',
    spec: AnguillaPlates.private,
    theme: AnguillaThemes.standard,
    country: AnguillaCountry.anguilla,
    validator: const AnguillaValidator(),
    sampleValues: AnguillaSerialGenerator.generate(AnguillaPlates.private, random: _rng),
  );

  List<GallerySection>? _sections;

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'Type letter (A, or P for personal) and up to four digits. The '
          'digits are narrower on the real plate than the engine\'s glyph.',
      entries: <GalleryEntry>[_private],
    ),
  ];
}
