import 'package:polynesia_plate/polynesia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cook_islands_plate`: the car plate (372 × 134) and the motorcycle plate
/// (an assumed 200 × 145).
class CookIslandsSource extends GallerySource {
  CookIslandsSource();

  @override
  String get countryName => 'Cook Islands';

  @override
  String get packageName => 'cook_islands_plate';

  @override
  String get note =>
      'Cars carry four digits in green on yellow between the captions KIA '
      'ORANA and COOK ISLANDS. The motorcycle plate is three letters over '
      'three digits; its size and colours are estimated from a photograph '
      'where the plates are about 30 px wide. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ck.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: CookIslandsCountry.cook_islands,
        validator: const CookIslandsValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Two designs.',
      entries: <GalleryEntry>[
        _entry(
          'car',
          'Car · green on yellow',
          CookIslandsPlates.car,
          CookIslandsThemes.car,
          '1348',
        ),
        _entry(
          'motorcycle',
          'Motorcycle · dark on amber',
          CookIslandsPlates.motorcycle,
          CookIslandsThemes.motorcycle,
          'AAP 676',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
