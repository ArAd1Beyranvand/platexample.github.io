import 'package:liberia_plate/liberia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `liberia_plate`: Liberia's diplomatic plate.
class LiberiaSource extends GallerySource {
  LiberiaSource();

  @override
  String get countryName => 'Liberia';

  @override
  String get packageName => 'liberia_plate';

  @override
  String get note => 'The diplomatic plate: mission, status (CD or CMD) and number.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const LiberiaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: LiberiaCountry.liberia,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Diplomatic',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'lr.diplomatic',
          'Diplomatic',
          LiberiaPlates.diplomatic,
          LiberiaThemes.diplomatic,
          <String?>['1', 'CD', '13'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
