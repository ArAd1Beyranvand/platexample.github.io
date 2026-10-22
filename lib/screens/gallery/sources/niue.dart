import 'package:polynesia_plate/polynesia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `niue_plate`: Four digits beside the NIUE caption.
class NiueSource extends GallerySource {
  NiueSource();

  @override
  String get countryName => 'Niue';

  @override
  String get packageName => 'niue_plate';

  @override
  String get note => 'Four digits beside the NIUE caption.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'nu.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: NiueCountry.niue,
        validator: const NiueValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Four digits beside the NIUE caption.',
      entries: <GalleryEntry>[
        _entry('standard', 'Standard', NiuePlates.standard, NiueThemes.standard, '4085'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
