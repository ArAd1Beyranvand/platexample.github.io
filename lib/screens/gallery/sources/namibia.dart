import 'package:namibia_plate/namibia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `namibia_plate`: the current series. Nothing on Namibia's plates is
/// Israel-specific (the article lists no mission codes), so nothing is refused.
class NamibiaSource extends GallerySource {
  NamibiaSource();

  @override
  String get countryName => 'Namibia';

  @override
  String get packageName => 'namibia_plate';

  @override
  String get note =>
      'N, a sequential number of one to six digits, and the town code — '
      'black on yellow. Personalised plates are blue on white with the flag '
      'and NA; government plates white on green behind a printed prefix.';

  static List<String?> _v(String s) => s.split('|');

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const NamibiaCompleteValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: NamibiaCountry.namibia,
    validator: validator,
    sampleValues: _v(values),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 520 × 110',
      note: 'The documented size; ink is ~76% of the reference height.',
      entries: <GalleryEntry>[
        _e(
          'na.standard.6.1',
          'Windhoek, six digits',
          NamibiaPlates.windhoek,
          NamibiaThemes.standard,
          '108|053|W',
          validator: const NamibiaPlateValidator(),
        ),
        _e(
          'na.standard.6.2',
          'Six digits, two-letter town',
          NamibiaPlates.sixTwoLetter,
          NamibiaThemes.standard,
          '123|456|WB',
          validator: const NamibiaPlateValidator(),
        ),
        _e(
          'na.standard.5.1',
          'Five digits',
          NamibiaPlates.fiveDigit,
          NamibiaThemes.standard,
          '12181|S',
          validator: const NamibiaPlateValidator(),
        ),
        _e(
          'na.standard.4.2',
          'Four digits, two-letter town',
          NamibiaPlates.fourDigitTwoLetter,
          NamibiaThemes.standard,
          '1234|KM',
          validator: const NamibiaPlateValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'Sizes not documented; laid out on the standard 520 × 110.',
      entries: <GalleryEntry>[
        _e(
          'na.personalised.6',
          'Personalised, six characters',
          NamibiaPlates.personalisedSix,
          NamibiaThemes.personalised,
          'OSAMA1',
        ),
        _e(
          'na.personalised.7',
          'Personalised, seven characters',
          NamibiaPlates.personalisedSeven,
          NamibiaThemes.personalised,
          'NAMIB24',
        ),
        _e(
          'na.diplomatic',
          'Diplomatic',
          NamibiaPlates.diplomatic,
          NamibiaThemes.diplomatic,
          '013|02',
        ),
        _e(
          'na.government.grn',
          'Government (GRN)',
          NamibiaPlates.grn,
          NamibiaThemes.government,
          '32872',
        ),
        _e(
          'na.government.pol',
          'Police (POL)',
          NamibiaPlates.police,
          NamibiaThemes.government,
          '8006',
        ),
        _e(
          'na.government.nam1',
          'Former president (NAM1)',
          NamibiaPlates.nam1,
          NamibiaThemes.government,
          '0001',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
