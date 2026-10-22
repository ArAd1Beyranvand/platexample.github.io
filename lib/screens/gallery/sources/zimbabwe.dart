import 'package:plate_core/plate_core.dart';
import 'package:zimbabwe_plate/zimbabwe_plate.dart';

import '../catalogue.dart';

/// `zimbabwe_plate`: the 2006 series — three letters and four digits, on one
/// row (520 × 110) or stacked (340 × 215).
class ZimbabweSource extends GallerySource {
  ZimbabweSource();

  @override
  String get countryName => 'Zimbabwe';

  @override
  String get packageName => 'zimbabwe_plate';

  @override
  String get note =>
      'Three letters and four digits. Private plates are black on yellow, '
      'or on white since 2006; commercial plates are red on white. The coat '
      'of arms some plates carry is not drawn, and the white, commercial and '
      'military colours are unsampled. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'zw.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: ZimbabweCountry.zimbabwe,
        validator: const ZimbabweValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One row',
      note: 'One design; the field and the ink change.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on yellow',
          ZimbabwePlates.row,
          ZimbabweThemes.yellow,
          'ADV 5517',
        ),
        _entry(
          'private_white',
          'Private · black on white',
          ZimbabwePlates.row,
          ZimbabweThemes.white,
          'ABC 1234',
        ),
        _entry(
          'commercial',
          'Commercial · red on white',
          ZimbabwePlates.row,
          ZimbabweThemes.commercial,
          'AED 1733',
        ),
      ],
    ),
    GallerySection(
      title: 'Stacked',
      note: 'The letters over the digits.',
      entries: <GalleryEntry>[
        _entry(
          'stacked',
          'Private · black on yellow',
          ZimbabwePlates.stacked,
          ZimbabweThemes.yellowStacked,
          'ABH 2411',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
