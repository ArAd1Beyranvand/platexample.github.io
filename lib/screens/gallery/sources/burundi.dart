import 'package:burundi_plate/burundi_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `burundi_plate`: Burundi's plates, one entry per category.
class BurundiSource extends GallerySource {
  BurundiSource();

  @override
  String get countryName => 'Burundi';

  @override
  String get packageName => 'burundi_plate';

  @override
  String get note => "Burundi's plates as drawn by burundi_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const BurundiValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: BurundiCountry.burundi,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('bi.front', 'Front', BurundiPlates.front, BurundiThemes.front, <String?>[
          'A',
          '0412',
          'A',
        ]),
        _e('bi.rear', 'Rear', BurundiPlates.rear, BurundiThemes.rear, <String?>['B', '6232', 'A']),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
