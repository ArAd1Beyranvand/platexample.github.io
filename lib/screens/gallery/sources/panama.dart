import 'package:panama_plate/panama_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `panama_plate`: the 2016 and 2008 car plates (six digits) and the 2018
/// motorcycle plate (`M`, five digits), all 300 × 150.
class PanamaSource extends GallerySource {
  PanamaSource();

  @override
  String get countryName => 'Panama';

  @override
  String get packageName => 'panama_plate';

  @override
  String get note =>
      'Black on white, with a caption row (PANAMA), the number and the year. '
      'The 2016 car has a blue band, the motorcycle a grey-green one. Month '
      'stickers and emblems are not drawn, and the 1942–1993 series and the '
      '2013 AB1234 format are not implemented. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'pa.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: PanamaCountry.panama,
        validator: const PanamaValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car',
      note: 'One design; the band and the field change.',
      entries: <GalleryEntry>[
        _entry('car', 'Car · 2016', PanamaPlates.car, PanamaThemes.car, '686120'),
        _entry('plain', 'Car · 2008', PanamaPlates.plain, PanamaThemes.cream, '703558'),
      ],
    ),
    GallerySection(
      title: 'Motorcycle',
      note: 'M, a diamond, five digits.',
      entries: <GalleryEntry>[
        _entry(
          'motorcycle',
          'Motorcycle · 2018',
          PanamaPlates.motorcycle,
          PanamaThemes.motorcycle,
          'M 42421',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
