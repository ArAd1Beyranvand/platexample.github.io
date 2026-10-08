import 'package:plate_core/plate_core.dart';
import 'package:republic_of_ireland_plate/republic_of_ireland_plate.dart';

import '../catalogue.dart';

/// `republic_of_ireland_plate`: the current `YYH-CC-NNNNN` plate, 520 × 110,
/// in its standard and electric-vehicle forms.
class RepublicOfIrelandSource extends GallerySource {
  RepublicOfIrelandSource();

  @override
  String get countryName => 'Republic of Ireland';

  @override
  String get packageName => 'republic_of_ireland_plate';

  @override
  String get note =>
      'Year and half-year, county code, then the sequence number, black on '
      'white with the EU band, and the Irish name of the county above. The '
      'caption follows the county the spec is built for. Not drawn: the '
      'square plate, temporary, diplomatic, trade and historic plates. The '
      'article lists nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, String values) =>
      GalleryEntry(
        id: 'ie.$id',
        label: label,
        spec: spec,
        theme: RepublicOfIrelandThemes.standard,
        country: RepublicOfIrelandCountry.republic_of_ireland,
        validator: const RepublicOfIrelandValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'One design; the county sets the caption and the code length.',
      entries: <GalleryEntry>[
        _entry(
          'dublin',
          'Dublin',
          RepublicOfIrelandPlates.standard,
          '2 5 2 D 2 3 4 5 6',
        ),
        _entry(
          'waterford',
          'Waterford',
          RepublicOfIrelandPlates.standardFor('W'),
          '1 3 1 W 1 2 3 4 5',
        ),
        _entry(
          'clare',
          'Clare',
          RepublicOfIrelandPlates.standardFor('CE'),
          '2 4 1 C E 6 7 8 9 0',
        ),
      ],
    ),
    GallerySection(
      title: 'Electric',
      note: 'The optional green strip at the right edge, from July 2025.',
      entries: <GalleryEntry>[
        _entry(
          'electric',
          'Dublin · electric',
          RepublicOfIrelandPlates.electric,
          '2 5 2 D 2 3 4 5 6',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
