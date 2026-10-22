import 'dart:math';

import 'package:australia_plate/australia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `australia_plate`: the current plate of each state and territory plus the
/// heavy-vehicle, Federal Interstate and Commonwealth plates. One slot per
/// field.
class AustraliaSource extends GallerySource {
  AustraliaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1901);

  @override
  String get countryName => 'Australia';

  @override
  String get packageName => 'australia_plate';

  @override
  String get note =>
      'Latin capitals and digits. Each state issues its own format and '
      'colours; a field is a run typed as a unit (`DT`, `00`, `CC`). State '
      'logos and emblems are not drawn.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'au.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: AustraliaCountry.australia,
        validator: const AustraliaValidator(),
        sampleValues: AustraliaSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'States and territories',
      note:
          'The current standard plate of each. Colours are sampled from '
          'photographs. The serial is about three quarters of the real '
          'height: the engine\'s glyph is wider than the plates\' face.',
      entries: <GalleryEntry>[
        _entry('nsw', 'New South Wales', AustraliaPlates.nsw, AustraliaThemes.nsw),
        _entry('act', 'Australian Capital Territory', AustraliaPlates.act, AustraliaThemes.act),
        _entry('nt', 'Northern Territory', AustraliaPlates.nt, AustraliaThemes.nt),
        _entry('qld', 'Queensland', AustraliaPlates.qld, AustraliaThemes.qld),
        _entry('sa', 'South Australia', AustraliaPlates.sa, AustraliaThemes.sa),
        _entry(
          'tas',
          'Tasmania',
          AustraliaPlates.tas,
          AustraliaThemes.tas,
          note: 'The thylacine logo between the letter and the digits is not drawn.',
        ),
        _entry(
          'vic',
          'Victoria',
          AustraliaPlates.vic,
          AustraliaThemes.vic,
          note: 'The V logo between the two fields is not drawn.',
        ),
        _entry(
          'wa',
          'Western Australia',
          AustraliaPlates.wa,
          AustraliaThemes.wa,
          note: 'The sun motif in the top band is not drawn.',
        ),
      ],
    ),
    GallerySection(
      title: 'National and Commonwealth',
      note:
          'The heavy-vehicle plate carries a blue band; Federal Interstate '
          'ran 1987–2018. Defence plates have a prefix letter and five '
          'characters; diplomatic ones a `DC` or `DX` prefix and four or '
          'five digits.',
      entries: <GalleryEntry>[
        _entry(
          'heavy',
          'National Heavy Vehicle',
          AustraliaPlates.nationalHeavyVehicle,
          AustraliaThemes.nationalHeavyVehicle,
        ),
        _entry(
          'firs',
          'Federal Interstate (to 2018)',
          AustraliaPlates.federalInterstate,
          AustraliaThemes.federalInterstate,
        ),
        _entry('army', 'Army', AustraliaPlates.army, AustraliaThemes.army),
        _entry(
          'air_force',
          'Air Force',
          AustraliaPlates.airForce,
          AustraliaThemes.airForce,
          note: 'The roundel left of the digits is not drawn.',
        ),
        _entry('defence', 'Defence Organisation', AustraliaPlates.defence, AustraliaThemes.defence),
        _entry(
          'diplomatic',
          'Diplomatic Corps',
          AustraliaPlates.diplomatic,
          AustraliaThemes.diplomatic,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
