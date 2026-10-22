import 'package:fiji_plate/fiji_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `fiji_plate`: Fiji's general, government, legacy and motorcycle plates.
class FijiSource extends GallerySource {
  FijiSource();

  @override
  String get countryName => 'Fiji';

  @override
  String get packageName => 'fiji_plate';

  @override
  String get note => 'General, government, legacy and motorcycle plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator? validator = const FijiValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: FijiCountry.fiji,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('fj.general', 'General', FijiPlates.general, FijiThemes.general, <String?>['FQ', '587']),
        _e('fj.government', 'Government', FijiPlates.government, FijiThemes.government, <String?>[
          'GI',
          '001',
        ]),
        _e('fj.legacy', 'Legacy', FijiPlates.legacy, FijiThemes.legacy, <String?>['E', '0845']),
        _e('fj.motorcycle', 'Motorcycle', FijiPlates.motorcycle, FijiThemes.motorcycle, <String?>[
          '535',
          'F',
        ], null),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
