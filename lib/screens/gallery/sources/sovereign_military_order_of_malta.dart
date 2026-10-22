import 'package:sovereign_military_order_of_malta_plate/sovereign_military_order_of_malta_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `sovereign_military_order_of_malta_plate`: the Order's standard plate.
class SovereignMilitaryOrderOfMaltaSource extends GallerySource {
  SovereignMilitaryOrderOfMaltaSource();

  @override
  String get countryName => 'Sovereign Military Order of Malta';

  @override
  String get packageName => 'sovereign_military_order_of_malta_plate';

  @override
  String get note => 'The SMOM plate: the SMOM prefix and a number.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const SovereignMilitaryOrderOfMaltaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SovereignMilitaryOrderOfMaltaCountry.sovereign_military_order_of_malta,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'so.standard',
          'Standard',
          SovereignMilitaryOrderOfMaltaPlates.standard,
          SovereignMilitaryOrderOfMaltaThemes.standard,
          <String?>['SMOM', '60'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
