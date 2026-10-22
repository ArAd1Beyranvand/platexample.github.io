import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `british_virgin_islands_plate`: 300 × 152 — a class prefix and a serial
/// between `VIRGIN ISLANDS` and `NATURE'S LITTLE SECRETS`, one colour per class.
class BritishVirginIslandsSource extends GallerySource {
  BritishVirginIslandsSource();

  @override
  String get countryName => 'British Virgin Islands';

  @override
  String get packageName => 'british_virgin_islands_plate';

  @override
  String get note =>
      'Private (PV), government (GV), commercial (CM) and taxi (TAXI or TX) '
      'plates. Rental plates (RT, black on green) have no picture and are not '
      'drawn, nor are the pre-1995 numerals-only and 1995-96 VI plates. The '
      'article lists nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'vg.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: BritishVirginIslandsCountry.british_virgin_islands,
        validator: const BritishVirginIslandsValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One design; colour, prefix and digit count change.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · PV 18107',
          BritishVirginIslandsPlates.private,
          BritishVirginIslandsThemes.private,
          'PV 18107',
        ),
        _entry(
          'government',
          'Government · GV-0603',
          BritishVirginIslandsPlates.government,
          BritishVirginIslandsThemes.government,
          'GV 0603',
        ),
        _entry(
          'commercial',
          'Commercial · CM-6242',
          BritishVirginIslandsPlates.commercial,
          BritishVirginIslandsThemes.commercial,
          'CM 6242',
        ),
        _entry(
          'taxi',
          'Taxi · TAXI-801',
          BritishVirginIslandsPlates.taxi,
          BritishVirginIslandsThemes.taxi,
          'TAXI 801',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
