import 'package:plate_core/plate_core.dart';
import 'package:portugal_plate/portugal_plate.dart';

import '../catalogue.dart';

/// `portugal_plate`: the current `AA 00 AA` plate, its dated predecessors,
/// the US Forces, GNR, trailer and diplomatic plates and the 1937 black plate,
/// all 520 × 110.
class PortugalSource extends GallerySource {
  PortugalSource();

  @override
  String get countryName => 'Portugal';

  @override
  String get packageName => 'portugal_plate';

  @override
  String get note =>
      'Three fields of two characters, black on white with the EU band. The '
      '2005 and US Forces plates add a yellow month/year ribbon; GNR, trailer '
      'and diplomatic plates have their own field splits; the 1937 plate is '
      'white on black. Cape Verde, Mozambique and Angola plates belong to '
      'their own packages.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'pt.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: PortugalCountry.portugal,
        validator: const PortugalValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Current series first, then the dated and older series.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Current · AA 00 AA',
          PortugalPlates.private,
          PortugalThemes.private,
          'AA 07 AA',
        ),
        _entry(
          'dated',
          '2005–2020 · with ribbon',
          PortugalPlates.dated,
          PortugalThemes.private,
          '41 BE 81 06 01',
        ),
        _entry(
          'legacy',
          '1992 · 00 00 AA',
          PortugalPlates.legacy,
          PortugalThemes.private,
          '72 93 FQ',
        ),
        _entry(
          'historic',
          '1937–1992 · white on black',
          PortugalPlates.historic,
          PortugalThemes.historic,
          'DL 84 15',
        ),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'US Forces at Lajes, GNR, trailers and diplomatic plates.',
      entries: <GalleryEntry>[
        _entry(
          'us_forces',
          'US Forces · Lajes',
          PortugalPlates.usForces,
          PortugalThemes.private,
          'A1 23 BC 05 01',
        ),
        _entry('gnr', 'GNR', PortugalPlates.gnr, PortugalThemes.private, 'J 2558'),
        _entry('trailer', 'Trailer', PortugalPlates.trailer, PortugalThemes.private, 'L 186880'),
        _entry(
          'diplomatic',
          'Diplomatic · CD',
          PortugalPlates.diplomatic,
          PortugalThemes.diplomatic,
          '200 CD 530',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
