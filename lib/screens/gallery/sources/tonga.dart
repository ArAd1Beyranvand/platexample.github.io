import 'package:tonga_plate/tonga_plate.dart';

import '../catalogue.dart';

/// `tonga_plate`: the current plate — a vehicle-type letter and up to five
/// digits, white on black, 372 × 134.
class TongaSource extends GallerySource {
  TongaSource();

  @override
  String get countryName => 'Tonga';

  @override
  String get packageName => 'tonga_plate';

  @override
  String get note =>
      'A vehicle-type letter (two for MC, motorcycles) and one to five '
      'digits, white on black, with TONGA beneath. The 1967 plate, the '
      'diplomatic plates and the royal and ministerial plates are not '
      'modelled. The article lists nothing Israel-specific, so nothing is '
      'refused.';

  GalleryEntry _entry(String id, String label, String values) => GalleryEntry(
    id: 'to.$id',
    label: label,
    spec: TongaPlates.standard,
    theme: TongaThemes.standard,
    country: TongaCountry.tonga,
    validator: const TongaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'One design; the number is one to five digits.',
      entries: <GalleryEntry>[
        _entry('private', 'Private car · five digits', 'C 10792'),
        _entry('motorcycle', 'Motorcycle · MC', 'MC 7'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
