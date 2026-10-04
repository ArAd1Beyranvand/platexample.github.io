import 'package:nicaragua_plate/nicaragua_plate.dart';

import '../catalogue.dart';

/// `nicaragua_plate`: two specs for standard and state-owned (estatal) vehicles.
class NicaraguaSource extends GallerySource {
  NicaraguaSource();

  @override
  String get countryName => 'Nicaragua';

  @override
  String get packageName => 'nicaragua_plate';

  @override
  String get note =>
      'Black on white plates with brown frame. Standard format: 1–2 region '
      'letters followed by 5 digits. State vehicles marked "ESTATAL".';

  static List<String?> _values(List<String> items) =>
      items.map((e) => e.length == 1 ? e : null).toList();

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 335 × 155',
      note: 'Standard Nicaraguan plates. Two variants: standard and estatal.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ni.standard',
          label: 'Standard vehicle',
          spec: NicaraguaPlates.standard,
          theme: NicaraguaThemes.standard,
          country: NicaraguaCountry.nicaragua,
          validator: null,
          sampleValues: _values(['M', 'Q', '0', '0', '2', '9', '3']),
        ),
        GalleryEntry(
          id: 'ni.estatal',
          label: 'State vehicle (Estatal)',
          spec: NicaraguaPlates.estatal,
          theme: NicaraguaThemes.standard,
          country: NicaraguaCountry.nicaragua,
          validator: null,
          sampleValues: _values(['M', 'Q', '0', '0', '2', '9', '3']),
          note: 'State-owned vehicles display "ESTATAL" at the bottom.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
