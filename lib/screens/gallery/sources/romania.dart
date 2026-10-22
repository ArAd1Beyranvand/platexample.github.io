import 'package:plate_core/plate_core.dart';
import 'package:romania_plate/romania_plate.dart';

import '../catalogue.dart';

/// `romania_plate`: the 2007 Euroband plates and the plates without one.
class RomaniaSource extends GallerySource {
  RomaniaSource();

  @override
  String get countryName => 'Romania';

  @override
  String get packageName => 'romania_plate';

  @override
  String get note =>
      'County code, two digits (three in Bucharest) and three letters, black '
      'on white beside the blue Euroband. Each field is one slot. The ink is '
      '~60 units of a 110 plate against ~94 in the photographs. Not drawn: '
      'the 1992–2007 series with the flag, the long-term temporary plate, the '
      'army ring-and-dash, the Timișoara crest and the other plate sizes.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator? validator,
  }) => GalleryEntry(
    id: 'ro.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: RomaniaCountry.romania,
    validator: validator ?? const RomaniaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 110',
      note: 'The electric plate is the same spec with a green ink.',
      entries: <GalleryEntry>[
        _entry('standard', 'Standard', RomaniaPlates.standard, RomaniaThemes.standard, 'CJ 27 UJM'),
        _entry(
          'bucharest',
          'Bucharest, three digits',
          RomaniaPlates.standard,
          RomaniaThemes.standard,
          'B 123 PKW',
        ),
        _entry(
          'electric',
          'Electric vehicle',
          RomaniaPlates.standard,
          RomaniaThemes.electric,
          'BC 74 PPK',
        ),
      ],
    ),
    GallerySection(
      title: 'Temporary and test',
      note: 'Short-term temporary and test plates.',
      entries: <GalleryEntry>[
        _entry(
          'temporary',
          'Short-term temporary',
          RomaniaPlates.temporary,
          RomaniaThemes.temporary,
          'TM 069357',
          validator: const RomaniaTemporaryValidator(),
        ),
        _entry(
          'test',
          'Test vehicle',
          RomaniaPlates.test,
          RomaniaThemes.test,
          'TL 613',
          validator: const RomaniaTestValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'CD, TC and CO share the plate; the mission code is not checked '
          'against a list.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic corps (CD)',
          RomaniaPlates.diplomatic,
          RomaniaThemes.diplomatic,
          'CD 205 113',
          validator: const RomaniaDiplomaticValidator(),
        ),
        _entry(
          'consular',
          'Consular transport (TC)',
          RomaniaPlates.diplomatic,
          RomaniaThemes.diplomatic,
          'TC 157 123',
          validator: const RomaniaDiplomaticValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'No Euroband',
      note: 'Plates issued without the Euroband.',
      entries: <GalleryEntry>[
        _entry(
          'mai',
          'Ministry of Interior',
          RomaniaPlates.ministryOfInterior,
          RomaniaThemes.ministryOfInterior,
          '29573',
        ),
        _entry('army', 'Armed Forces', RomaniaPlates.army, RomaniaThemes.army, '88601'),
        _entry(
          'local',
          'Local administration',
          RomaniaPlates.localAdministration,
          RomaniaThemes.localAdministration,
          'TIMIȘOARA 03036',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
