import 'package:polynesia_plate/polynesia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `french_polynesia_plate`: Six digits and a letter; yellow at the front and white at the rear.
class FrenchPolynesiaSource extends GallerySource {
  FrenchPolynesiaSource();

  @override
  String get countryName => 'French Polynesia';

  @override
  String get packageName => 'french_polynesia_plate';

  @override
  String get note => 'Six digits and a letter; yellow at the front and white at the rear.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'pf.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: FrenchPolynesiaCountry.french_polynesia,
        validator: const FrenchPolynesiaValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Six digits and a letter; yellow at the front and white at the rear.',
      entries: <GalleryEntry>[
        _entry(
          'front',
          'Front · yellow',
          FrenchPolynesiaPlates.regular,
          FrenchPolynesiaThemes.front,
          '233051 P',
        ),
        _entry(
          'rear',
          'Rear · white',
          FrenchPolynesiaPlates.regular,
          FrenchPolynesiaThemes.rear,
          '233051 P',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
