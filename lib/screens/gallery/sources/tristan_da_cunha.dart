import 'package:plate_core/plate_core.dart';
import 'package:saint_helena_plate/saint_helena_plate.dart';

import '../catalogue.dart';

/// `tristan_da_cunha_plate`: "T.D.C." and up to three digits in one row.
class TristanDaCunhaSource extends GallerySource {
  TristanDaCunhaSource();

  @override
  String get countryName => 'Tristan da Cunha';

  @override
  String get packageName => 'tristan_da_cunha_plate';

  @override
  String get note =>
      'The prefix T.D.C. and one to three digits, white on black since '
      '1969, with black on white and black on yellow also seen. Geometry '
      'and colours are estimated from sister territories: no Tristan plate '
      'is pictured.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'sh.tdc.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TristanDaCunhaCountry.tristan_da_cunha,
    validator: const TristanDaCunhaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'One layout in three liveries.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Standard · white on black',
          TristanDaCunhaPlates.standard,
          TristanDaCunhaThemes.standard,
          '123',
        ),
        _e(
          'on_white',
          'Black on white',
          TristanDaCunhaPlates.onWhite,
          TristanDaCunhaThemes.onWhite,
          '45',
        ),
        _e(
          'on_yellow',
          'Black on yellow',
          TristanDaCunhaPlates.onYellow,
          TristanDaCunhaThemes.onYellow,
          '7',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
