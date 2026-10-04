import 'package:nicaragua_plate/nicaragua_plate.dart';

import '../catalogue.dart';

/// `nicaragua_plate`: the 2005 series in its three serial lengths.
class NicaraguaSource extends GallerySource {
  NicaraguaSource();

  @override
  String get countryName => 'Nicaragua';

  @override
  String get packageName => 'nicaragua_plate';

  @override
  String get note =>
      'The 2005 series: black on white, a department code of one or two '
      'letters, then the number. Managua runs six digits printed 3 + 3.';

  static List<String?> _chars(String value) => value.split('');

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 300 × 152',
      note: 'The map watermark and the coat-of-arms seal are not drawn.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ni.managua',
          label: 'Managua',
          spec: NicaraguaPlates.managua,
          theme: NicaraguaThemes.standard,
          country: NicaraguaCountry.nicaragua,
          validator: const NicaraguaValidator(),
          sampleValues: _chars('M027557'),
        ),
        GalleryEntry(
          id: 'ni.department',
          label: 'Department, four digits',
          spec: NicaraguaPlates.department,
          theme: NicaraguaThemes.standard,
          country: NicaraguaCountry.nicaragua,
          validator: const NicaraguaValidator(),
          sampleValues: _chars('CT4361'),
        ),
        GalleryEntry(
          id: 'ni.department_short',
          label: 'Department, three digits',
          spec: NicaraguaPlates.departmentShort,
          theme: NicaraguaThemes.standard,
          country: NicaraguaCountry.nicaragua,
          validator: const NicaraguaValidator(),
          sampleValues: _chars('MY142'),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
