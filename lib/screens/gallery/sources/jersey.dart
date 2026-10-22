import 'package:united_kingdom_plate/united_kingdom_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `jersey_plate`: the silver front and yellow rear plates.
class JerseySource extends GallerySource {
  JerseySource();

  @override
  String get countryName => 'Jersey';

  @override
  String get packageName => 'jersey_plate';

  @override
  String get note =>
      'The letter J and one to six digits. Not drawn: the hire cars\' red H '
      'block, the integral L and P motorcycle plates and the E prefix for '
      'temporary imports.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateCountry country,
    String serial,
  ) => GalleryEntry(
    id: 'je.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: country,
    validator: const JerseyValidator(),
    sampleValues: <String?>[serial],
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note:
          'Silver front with the arms between JERSEY and GBJ; black on yellow '
          'at the rear.',
      entries: <GalleryEntry>[
        _e('front', 'Front', JerseyPlates.front, JerseyThemes.front, JerseyCountry.front, '181148'),
        _e('rear', 'Rear', JerseyPlates.rear, JerseyThemes.rear, JerseyCountry.jersey, '98257'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
