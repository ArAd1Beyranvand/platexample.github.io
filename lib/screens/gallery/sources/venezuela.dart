import 'package:venezuela_plate/venezuela_plate.dart';

import '../catalogue.dart';

/// `venezuela_plate`: one spec, one livery. The state name under the serial
/// follows the last letter, so the entries differ only in their sample values.
class VenezuelaSource extends GallerySource {
  VenezuelaSource();

  @override
  String get countryName => 'Venezuela';

  @override
  String get packageName => 'venezuela_plate';

  @override
  String get note =>
      'The 2008 car plate: seven characters on the flag. Where the letters '
      'fall gives the category, and the last letter prints its state.';

  static List<String?> _values(String value) => <String?>[
    value.substring(0, 6),
    value.substring(6),
  ];

  /// Cached: the catalogue pairs highlights back to sections by identity.
  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 300 × 150',
      note:
          'One design for every category; which cells are letters tells the '
          'category, and the last letter prints its state below.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 've.car',
          label: 'Private car · Lara',
          spec: VenezuelaPlates.car,
          theme: VenezuelaPlates.theme,
          country: VenezuelaCountry.venezuela,
          validator: const VenezuelaValidator(),
          sampleValues: _values('AB174SK'),
        ),
        GalleryEntry(
          id: 've.car.taxi',
          label: 'Taxi · Distrito Capital',
          spec: VenezuelaPlates.car,
          theme: VenezuelaPlates.theme,
          country: VenezuelaCountry.venezuela,
          validator: const VenezuelaValidator(),
          sampleValues: _values('7A1B2CA'),
          note: 'Taxi serials start with a fixed 7.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
