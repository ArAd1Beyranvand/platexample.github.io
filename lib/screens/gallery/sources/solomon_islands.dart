import 'package:solomon_islands_plate/solomon_islands_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `solomon_islands_plate`: The Solomon Islands private plate.
class SolomonIslandsSource extends GallerySource {
  SolomonIslandsSource();

  @override
  String get countryName => 'Solomon Islands';

  @override
  String get packageName => 'solomon_islands_plate';

  @override
  String get note => 'The private plate: two letters and four digits.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const SolomonIslandsValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SolomonIslandsCountry.solomon_islands,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'sb.private',
          'Private',
          SolomonIslandsPlates.private,
          SolomonIslandsThemes.private,
          <String?>['MA', '5021'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
