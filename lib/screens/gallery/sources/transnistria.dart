import 'package:plate_core/plate_core.dart';
import 'package:russia_plate/russia_plate.dart';

import '../catalogue.dart';

/// `transnistria_plate`: the current series, a flag and no band. Every field
/// is one slot, so a value is one token per field (`['T', '001', 'AA']`).
class TransnistriaSource extends GallerySource {
  TransnistriaSource();

  @override
  String get countryName => 'Transnistria';

  @override
  String get packageName => 'transnistria_plate';

  @override
  String get note =>
      'Black on white with the red-green-red flag; the Ministry of Internal '
      'Affairs on blue, the diplomatic corps in blue ink. The pre-2015 '
      'plates, the 1992 military plates, the tractor and square plates are '
      'not drawn.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: TransnistriaCountry.transnistria,
    validator: const TransnistriaValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Vehicles — 520 × 112',
      note:
          'The first letter names the region: A Bender, B Grigoriopol, '
          'E Dubăsari, K Camenca, P Rîbnița, C Slobozia, T Tiraspol. Ink is '
          '~70% of the reference height.',
      entries: <GalleryEntry>[
        _e(
          'pmr.passenger',
          'Passenger (since 2015)',
          TransnistriaPlates.passenger,
          TransnistriaThemes.standard,
          <String?>['T', '001', 'AA'],
        ),
        _e(
          'pmr.neutral',
          'Neutral',
          TransnistriaPlates.neutral,
          TransnistriaThemes.standard,
          <String?>['ZJA', '043'],
        ),
        _e('pmr.army', 'Army', TransnistriaPlates.army, TransnistriaThemes.standard, <String?>[
          '381',
          'BY',
        ]),
      ],
    ),
    GallerySection(
      title: 'State and diplomatic — 520 × 112',
      note: 'A black divider follows the flag.',
      entries: <GalleryEntry>[
        _e(
          'pmr.interior',
          'Ministry of Internal Affairs',
          TransnistriaPlates.interior,
          TransnistriaThemes.interior,
          <String?>['MM', '001'],
        ),
        _e(
          'pmr.president',
          'President',
          TransnistriaPlates.president,
          TransnistriaThemes.standard,
          <String?>['001'],
        ),
        _e(
          'pmr.diplomatic',
          'Diplomatic',
          TransnistriaPlates.diplomatic,
          TransnistriaThemes.diplomatic,
          <String?>['CD', '001', '05'],
        ),
      ],
    ),
    GallerySection(
      title: 'Moped and trailer',
      note: 'Moped 520 × 180, trailer 520 × 376.',
      entries: <GalleryEntry>[
        _e(
          'pmr.moped',
          'Moped (Tiraspol)',
          TransnistriaPlates.moped,
          TransnistriaThemes.standard,
          <String?>['H', '364'],
        ),
        _e(
          'pmr.trailer',
          'Trailer',
          TransnistriaPlates.trailer,
          TransnistriaThemes.standard,
          <String?>['AC', 'C', '001'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
