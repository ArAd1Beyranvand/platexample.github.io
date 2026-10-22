import 'package:samoa_plate/samoa_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `samoa_plate`: Samoa's modern, plain, dotted and government plates.
class SamoaSource extends GallerySource {
  SamoaSource();

  @override
  String get countryName => 'Samoa';

  @override
  String get packageName => 'samoa_plate';

  @override
  String get note => 'Modern, plain, dotted and government plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const SamoaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SamoaCountry.samoa,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('ws.modern', 'Modern', SamoaPlates.modern, SamoaThemes.modern, <String?>['5511']),
        _e('ws.plain', 'Plain', SamoaPlates.plain, SamoaThemes.green, <String?>['893']),
        _e('ws.dotted', 'Dotted', SamoaPlates.dotted, SamoaThemes.mint, <String?>['4', '205']),
        _e('ws.government', 'Government', SamoaPlates.government, SamoaThemes.government, <String?>[
          '502',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
