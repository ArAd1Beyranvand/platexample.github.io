import 'package:cuba_plate/cuba_plate.dart';

import '../catalogue.dart';

/// `cuba_plate`: three specs and one livery. Every 2013 Cuban plate is black on
/// white, so the only thing that tells a legal entity's car from a person's is
/// the CUBA strip — which is why the two cars are separate specs here rather
/// than one spec under two themes.
class CubaSource extends GallerySource {
  CubaSource();

  @override
  String get countryName => 'Cuba';

  @override
  String get packageName => 'cuba_plate';

  @override
  String get note =>
      'The 2013 system: a series letter and six digits on a car, five on a '
      'motorcycle, always black on white. See cuba_plate/README.md.';

  static List<String?> _values(String value) => <String?>[for (final c in value.split('')) c];

  /// Cached: the catalogue pairs highlights back to sections by identity.
  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars — 420 × 110',
      note:
          'One design. A natural person\'s plate rules off a white CUBA strip; '
          'a legal entity\'s fills it blue.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'cu.car',
          label: 'Natural person · white strip',
          spec: CubaPlates.car,
          theme: CubaPlates.theme,
          country: CubaCountry.cuba,
          validator: const CubaValidator(),
          sampleValues: _values('P025245'),
        ),
        GalleryEntry(
          id: 'cu.carLegalEntity',
          label: 'Legal entity · blue strip',
          spec: CubaPlates.carLegalEntity,
          theme: CubaPlates.theme,
          country: CubaCountry.cuba,
          validator: const CubaValidator(),
          sampleValues: _values('T003526'),
          note: 'T is a vehicle rented to tourism.',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycle — 200 × 140',
      note: 'The letter alone on the top row, beside CUBA in a ruled box; five digits below.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'cu.motorcycle',
          label: 'Motorcycle',
          spec: CubaPlates.motorcycle,
          theme: CubaPlates.theme,
          country: CubaCountry.cuba,
          validator: const CubaValidator(),
          sampleValues: _values('P28588'),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
