import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `caribbean_plate`: One type letter and up to four digits.
class MontserratSource extends GallerySource {
  MontserratSource();

  @override
  String get countryName => 'Montserrat';

  @override
  String get packageName => 'caribbean_plate';

  @override
  String get note => 'One type letter and up to four digits.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ms.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: MontserratCountry.montserrat,
        validator: const MontserratValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One type letter and up to four digits.',
      entries: <GalleryEntry>[
        _entry('private', 'Private', MontserratPlates.private, MontserratThemes.private, 'M 1667'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
