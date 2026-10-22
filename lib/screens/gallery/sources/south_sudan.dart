import 'package:plate_core/plate_core.dart';
import 'package:south_sudan_plate/south_sudan_plate.dart';

import '../catalogue.dart';

/// `south_sudan_plate`: the 2017 series — `SSD`, three digits and one or two
/// letters (340 × 180).
class SouthSudanSource extends GallerySource {
  SouthSudanSource();

  @override
  String get countryName => 'South Sudan';

  @override
  String get packageName => 'south_sudan_plate';

  @override
  String get note =>
      'The 2017 series: the flag, `SSD`, three digits and one or two letters. '
      'The size is not documented and the geometry is off two photographs. '
      'The 2005 regional plates, the NGO and 2020 plates (with the JB '
      'rhino roundel) are not implemented. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ss.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: SouthSudanCountry.south_sudan,
        validator: const SouthSudanValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '2017 series',
      note: 'One design; the ink changes and the taxi text sits further right.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          SouthSudanPlates.private,
          SouthSudanThemes.private,
          '560 AT',
        ),
        _entry(
          'taxi',
          'Taxi · green on white',
          SouthSudanPlates.taxi,
          SouthSudanThemes.taxi,
          '584 C',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
