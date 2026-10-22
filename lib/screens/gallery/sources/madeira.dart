import 'package:madeira_plate/madeira_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `madeira_plate`: Madeira is registered in the Portuguese national system,
/// so these are Portugal's plates, all 520 × 110.
class MadeiraSource extends GallerySource {
  MadeiraSource();

  @override
  String get countryName => 'Madeira';

  @override
  String get packageName => 'madeira_plate';

  @override
  String get note =>
      'No plate of its own: Madeira uses the national Portuguese series, '
      'which carries no regional code. The one Madeiran value is the district '
      'code M (Funchal) on trailer and export plates.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ma.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: MadeiraCountry.madeira,
        validator: const MadeiraValidator(),
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
          MadeiraPlates.private,
          MadeiraThemes.private,
          'AA 16 AA',
        ),
        _entry(
          'dated',
          '2005–2020 · with ribbon',
          MadeiraPlates.dated,
          MadeiraThemes.private,
          '41 BE 81 06 01',
        ),
        _entry(
          'legacy',
          '1992 · 00 00 AA',
          MadeiraPlates.legacy,
          MadeiraThemes.private,
          '72 93 FQ',
        ),
        _entry(
          'historic',
          '1937–1992 · white on black',
          MadeiraPlates.historic,
          MadeiraThemes.historic,
          'DL 84 15',
        ),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'US Forces, GNR, trailers (district M) and diplomatic plates.',
      entries: <GalleryEntry>[
        _entry(
          'us_forces',
          'US Forces · Lajes',
          MadeiraPlates.usForces,
          MadeiraThemes.private,
          'A1 23 BC 05 01',
        ),
        _entry('gnr', 'GNR', MadeiraPlates.gnr, MadeiraThemes.private, 'J 2558'),
        _entry(
          'trailer',
          'Trailer · M Funchal',
          MadeiraPlates.trailer,
          MadeiraThemes.private,
          'M 186880',
        ),
        _entry(
          'diplomatic',
          'Diplomatic · CD',
          MadeiraPlates.diplomatic,
          MadeiraThemes.diplomatic,
          '200 CD 530',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
