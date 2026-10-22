import 'package:luxembourg_plate/luxembourg_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `luxembourg_plate`: Luxembourg's plates, one entry per category.
class LuxembourgSource extends GallerySource {
  LuxembourgSource();

  @override
  String get countryName => 'Luxembourg';

  @override
  String get packageName => 'luxembourg_plate';

  @override
  String get note => "Luxembourg's plates as drawn by luxembourg_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const LuxembourgValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: LuxembourgCountry.luxembourg,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'lu.standard',
          'Standard',
          LuxembourgPlates.standard,
          LuxembourgThemes.standard,
          <String?>['QV', '8043'],
        ),
        _e(
          'lu.diplomatic',
          'Diplomatic',
          LuxembourgPlates.diplomatic,
          LuxembourgThemes.diplomatic,
          <String?>['70', '05'],
        ),
        _e(
          'lu.military',
          'Military',
          LuxembourgPlates.military,
          LuxembourgThemes.military,
          <String?>['9015'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
