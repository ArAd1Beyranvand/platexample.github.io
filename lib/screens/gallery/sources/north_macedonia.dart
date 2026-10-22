import 'package:north_macedonia_plate/north_macedonia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `north_macedonia_plate`: the area code, a red block echoing it in Cyrillic,
/// four digits and two letters, plus the two-row and diplomatic plates.
class NorthMacedoniaSource extends GallerySource {
  NorthMacedoniaSource();

  @override
  String get countryName => 'North Macedonia';

  @override
  String get packageName => 'north_macedonia_plate';

  @override
  String get note =>
      'An area code, the red emblem block that repeats the code and the series '
      'in Cyrillic, four digits and two letters, on a white plate with a blue '
      'side band. The band reads NMK on the 2019 plate and MK on the earlier '
      'one, which is still on the road. The Cyrillic echo is drawn in black; '
      'the real block prints it in yellow. The diplomatic plate is white on '
      'black, and the mission code 35 is refused (COUNTRY NOT FOUND). Not drawn: '
      'the three-row motorcycle plates, the police, dealer and temporary '
      'series, and the pre-2012 plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'mk.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: NorthMacedoniaCountry.north_macedonia,
    validator: const NorthMacedoniaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 520 × 110',
      note: 'Area code, four digits, two letters; the band says NMK or MK.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Standard · NMK (2019)',
          NorthMacedoniaPlates.standard,
          NorthMacedoniaThemes.standard,
          'SK 1234 AB',
        ),
        _e(
          'legacy',
          'Standard · MK (2012–2019)',
          NorthMacedoniaPlates.legacy,
          NorthMacedoniaThemes.standard,
          'BT 1234 AB',
        ),
      ],
    ),
    GallerySection(
      title: 'Two rows',
      note: 'The short plate: area code over the number and series.',
      entries: <GalleryEntry>[
        _e(
          'two_row',
          'Two-row',
          NorthMacedoniaPlates.twoRow,
          NorthMacedoniaThemes.twoRow,
          'KS 1234 AB',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Mission code, CC / CD / CMD, then two or three digits.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic corps',
          NorthMacedoniaPlates.diplomatic,
          NorthMacedoniaThemes.diplomatic,
          '92 CMD 01',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
