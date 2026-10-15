import 'package:canada_plate/canada_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `canada_plate`: the federal (DND) plate and Ontario's 10-day permit, the
/// two Canadian categories with a measured reference picture.
class CanadaSource extends GallerySource {
  CanadaSource();

  @override
  String get countryName => 'Canada';

  @override
  String get packageName => 'canada_plate';

  @override
  String get note =>
      'Plates are issued per province and territory. Only the federal plate '
      'and Ontario\'s temporary permit have a measured reference here.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: CanadaCountry.canada,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Federal — 300 × 150',
      note:
          'Canadian Forces Registration: the last five digits, under CANADA '
          'and two maple leaves.',
      entries: <GalleryEntry>[
        _e(
          'ca.federal',
          'Federal (DND)',
          CanadaPlates.federal,
          CanadaThemes.federal,
          <String?>['78759'],
          const CanadaFederalValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Ontario permit — 300 × 150',
      note:
          'The 10-day temporary permit: a letter and six digits. The '
          'barcode, expiry date and VIN lines are not drawn.',
      entries: <GalleryEntry>[
        _e(
          'ca.permit',
          'Ontario 10-day permit',
          CanadaPlates.permit,
          CanadaThemes.permit,
          <String?>['A', '086511'],
          const CanadaPermitValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
