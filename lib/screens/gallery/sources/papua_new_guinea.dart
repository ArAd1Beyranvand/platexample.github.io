import 'package:papua_new_guinea_plate/papua_new_guinea_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `papua_new_guinea_plate`: the current one-row plates, a letters field and a
/// digits field with a dot between and "PNG" above.
class PapuaNewGuineaSource extends GallerySource {
  PapuaNewGuineaSource();

  @override
  String get countryName => 'Papua New Guinea';

  @override
  String get packageName => 'papua_new_guinea_plate';

  @override
  String get note =>
      'The current Australian-standard plates, 372×134 mm. Not drawn: the '
      '"Euro Flag" variants, Prime Minister and Governor-General emblem '
      'plates, Bougainville, Defence Force, personalised and commemorative '
      'plates and the pre-1975 series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PapuaNewGuineaValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'pg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: PapuaNewGuineaCountry.papua_new_guinea,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'General issue',
      note:
          'Black on white; the Australian standard 372×134 mm. AA-000 motorcycles share the size.',
      entries: <GalleryEntry>[
        _e(
          'general',
          'General issue',
          PapuaNewGuineaPlates.general,
          PapuaNewGuineaThemes.general,
          const PapuaNewGuineaValidator.general(),
          'BAA 000',
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          PapuaNewGuineaPlates.motorcycle,
          PapuaNewGuineaThemes.general,
          const PapuaNewGuineaValidator.motorcycle(),
          'AA 582',
        ),
      ],
    ),
    GallerySection(
      title: 'Commercial',
      note: 'Taxi and hire yellow, trailer teal, PMV blue (no set route) and orange (buses).',
      entries: <GalleryEntry>[
        _e(
          'taxi',
          'Taxi',
          PapuaNewGuineaPlates.taxi,
          PapuaNewGuineaThemes.taxi,
          const PapuaNewGuineaValidator.taxi(),
          'T 01456',
        ),
        _e(
          'hire',
          'Hire vehicle',
          PapuaNewGuineaPlates.hire,
          PapuaNewGuineaThemes.hire,
          const PapuaNewGuineaValidator.hire(),
          'H 4999',
        ),
        _e(
          'trailer',
          'Trailer',
          PapuaNewGuineaPlates.trailer,
          PapuaNewGuineaThemes.trailer,
          const PapuaNewGuineaValidator.trailer(),
          'TR 0007',
        ),
        _e(
          'pmv_blue',
          'PMV · blue',
          PapuaNewGuineaPlates.publicMotorVehicle,
          PapuaNewGuineaThemes.pmvBlue,
          const PapuaNewGuineaValidator.publicMotorVehicle(),
          'P 0001',
        ),
        _e(
          'pmv_orange',
          'PMV · orange',
          PapuaNewGuineaPlates.publicMotorVehicle,
          PapuaNewGuineaThemes.pmvOrange,
          const PapuaNewGuineaValidator.publicMotorVehicle(),
          'P 6870',
        ),
      ],
    ),
    GallerySection(
      title: 'Government and corps',
      note: 'Red letters on government plates; consular black, diplomatic maroon with PNG stacked.',
      entries: <GalleryEntry>[
        _e(
          'government',
          'Government',
          PapuaNewGuineaPlates.government,
          PapuaNewGuineaThemes.government,
          const PapuaNewGuineaValidator.government(),
          'ZPD 001',
        ),
        _e(
          'provincial',
          'Provincial government',
          PapuaNewGuineaPlates.provincial,
          PapuaNewGuineaThemes.provincial,
          const PapuaNewGuineaValidator.provincial(),
          'PAD 000',
        ),
        _e(
          'consular',
          'Consular corps',
          PapuaNewGuineaPlates.consular,
          PapuaNewGuineaThemes.consular,
          const PapuaNewGuineaValidator.consular(),
          'CC 199',
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          PapuaNewGuineaPlates.diplomatic,
          PapuaNewGuineaThemes.diplomatic,
          const PapuaNewGuineaValidator.diplomatic(),
          'DC 053',
        ),
      ],
    ),
    GallerySection(
      title: 'Trade',
      note: 'Red on pale blue-grey.',
      entries: <GalleryEntry>[
        _e(
          'trade',
          'Trade',
          PapuaNewGuineaPlates.trade,
          PapuaNewGuineaThemes.trade,
          const PapuaNewGuineaValidator.trade(),
          'TT 3447',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
