import 'dart:math';

import 'package:eritrea_plate/eritrea_plate.dart';

import '../catalogue.dart';

/// `eritrea_plate`: the one plate the article documents.
class EritreaSource extends GallerySource {
  EritreaSource();

  final Random _rng = Random(1993);

  @override
  String get countryName => 'Eritrea';

  @override
  String get packageName => 'eritrea_plate';

  @override
  String get note =>
      'ER and a digit in a disc over a five-digit number, black on white. '
      'The article lists no categories; the digits read about three quarters '
      'of the real height.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 520 × 289',
      note: 'Proportions measured off the article\'s only photograph.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'er.standard',
          label: 'Standard · black on white',
          spec: EritreaPlates.standard,
          theme: EritreaThemes.standard,
          country: EritreaCountry.eritrea,
          validator: const EritreaValidator(),
          sampleValues: EritreaSerialGenerator.generate(
            EritreaPlates.standard,
            random: _rng,
          ),
          note: 'Colours sampled from the colour-balanced photo.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
