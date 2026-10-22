import 'package:nepal_plate/nepal_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `nepal_plate`: Nepal's plates, one entry per category.
class NepalSource extends GallerySource {
  NepalSource();

  @override
  String get countryName => 'Nepal';

  @override
  String get packageName => 'nepal_plate';

  @override
  String get note => "Nepal's plates as drawn by nepal_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const NepalValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: NepalCountry.nepal,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('np.heavy_front', 'Heavy front', NepalPlates.heavyFront, NepalThemes.current, <String?>[
          'BAGMATI',
          'G',
          'AB',
          '0123',
        ]),
        _e('np.car_front', 'Car front', NepalPlates.carFront, NepalThemes.current, <String?>[
          'BAGMATI',
          'B',
          'AB',
          '0123',
        ]),
        _e('np.heavy_rear', 'Heavy rear', NepalPlates.heavyRear, NepalThemes.current, <String?>[
          'BAGMATI',
          'G',
          'AB',
          '0123',
        ]),
        _e('np.car_rear', 'Car rear', NepalPlates.carRear, NepalThemes.current, <String?>[
          'BAGMATI',
          'B',
          'AB',
          '0123',
        ]),
        _e(
          'np.three_wheeler',
          'Three wheeler',
          NepalPlates.threeWheeler,
          NepalThemes.current,
          <String?>['BAGMATI', 'C', 'AB', '0123'],
        ),
        _e(
          'np.legacy_private',
          'Legacy private',
          NepalPlates.legacy,
          NepalThemes.legacyPrivate,
          <String?>['बा', '12', 'क', '3456'],
          const NepalLegacyValidator(),
        ),
        _e(
          'np.legacy_public',
          'Legacy public',
          NepalPlates.legacy,
          NepalThemes.legacyPublic,
          <String?>['बा', '1', 'ख', '3456'],
          const NepalLegacyValidator(),
        ),
        _e(
          'np.legacy_government',
          'Legacy government',
          NepalPlates.legacy,
          NepalThemes.legacyGovernment,
          <String?>['बा', '1', 'ग', '3456'],
          const NepalLegacyValidator(),
        ),
        _e(
          'np.legacy_corporation',
          'Legacy corporation',
          NepalPlates.legacy,
          NepalThemes.legacyCorporation,
          <String?>['बा', '1', 'घ', '3456'],
          const NepalLegacyValidator(),
        ),
        _e(
          'np.legacy_tourist',
          'Legacy tourist',
          NepalPlates.legacy,
          NepalThemes.legacyTourist,
          <String?>['बा', '1', 'य', '3456'],
          const NepalLegacyValidator(),
        ),
        _e(
          'np.legacy_diplomatic',
          'Legacy diplomatic',
          NepalPlates.legacyDiplomatic,
          NepalThemes.legacyDiplomatic,
          <String?>['01', '23'],
          const NepalDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
