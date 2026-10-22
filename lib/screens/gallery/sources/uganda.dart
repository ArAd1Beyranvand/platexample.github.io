import 'package:plate_core/plate_core.dart';
import 'package:uganda_plate/uganda_plate.dart';

import '../catalogue.dart';

/// `uganda_plate`: the police plate, a two-letter series and a serial of four
/// or five digits in red on yellow.
class UgandaSource extends GallerySource {
  UgandaSource();

  @override
  String get countryName => 'Uganda';

  @override
  String get packageName => 'uganda_plate';

  @override
  String get note =>
      'Two letters and four or five digits, red on yellow, under a small flag '
      'strip. Not drawn: the digital UG government series (no picture to '
      'measure), the c. 1990 foreign-agency plate and the flag\'s crane.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'ug.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: UgandaCountry.uganda,
    validator: const UgandaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Police',
      note: 'The UP series on the ambulance in the article.',
      entries: <GalleryEntry>[
        _e('police', 'Police', UgandaPlates.police, UgandaThemes.police, 'UP 2938'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
