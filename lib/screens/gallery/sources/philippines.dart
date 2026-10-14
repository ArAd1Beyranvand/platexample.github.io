import 'package:philippines_plate/philippines_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `philippines_plate`: the 2018 series. The diplomatic entry's validator and
/// spec both refuse mission code 036 with "COUNTRY NOT FOUND".
class PhilippinesSource extends GallerySource {
  PhilippinesSource();

  @override
  String get countryName => 'Philippines';

  @override
  String get packageName => 'philippines_plate';

  @override
  String get note =>
      'Three letters and up to four digits, black on white, the category in '
      'the colour. Motorcycles carry six characters and, outside Metro '
      'Manila, a regional colour strip. Diplomatic mission code 036 is '
      'refused in every layer with "COUNTRY NOT FOUND".';

  static List<String?> _v(String s) => s.split('');

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const PhilippinesValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: PhilippinesCountry.philippines,
    validator: validator,
    sampleValues: _v(values),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 390 × 140',
      note:
          'The serial is ~60% of the reference height: the reference face '
          'is condensed and the bundled one is not.',
      entries: <GalleryEntry>[
        _e(
          'ph.car',
          'Private',
          PhilippinesPlates.car(),
          PhilippinesThemes.private,
          'NBC1234',
        ),
        _e(
          'ph.car.3',
          'Vanity, three digits',
          PhilippinesPlates.car(digits: 3),
          PhilippinesThemes.private,
          'ABC888',
        ),
        _e(
          'ph.car.2',
          'Vanity, two digits',
          PhilippinesPlates.car(digits: 2),
          PhilippinesThemes.private,
          'ABC01',
        ),
        _e(
          'ph.car.electric',
          'Electric / hybrid',
          PhilippinesPlates.car(),
          PhilippinesThemes.electric,
          'NEV1234',
        ),
        _e(
          'ph.car.puv',
          'Public utility',
          PhilippinesPlates.car(),
          PhilippinesThemes.publicUtility,
          'NBC1234',
        ),
        _e(
          'ph.car.government',
          'Government',
          PhilippinesPlates.car(),
          PhilippinesThemes.government,
          'SAB1234',
          validator: const PhilippinesValidator(government: true),
        ),
        _e(
          'ph.vintage',
          'Vintage',
          PhilippinesPlates.vintage,
          PhilippinesThemes.private,
          'NTX10061965',
        ),
        _e(
          'ph.diplomatic',
          'Diplomatic',
          PhilippinesPlates.diplomatic,
          PhilippinesThemes.diplomatic,
          '0020020',
          validator: const PhilippinesDiplomaticValidator(),
          note: 'The first three digits are the mission code. Try typing 036.',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycle — 235 × 135',
      note: 'Metro Manila and government motorcycles carry no strip.',
      entries: <GalleryEntry>[
        _e(
          'ph.motorcycle',
          'Metro Manila',
          PhilippinesPlates.motorcycle(),
          PhilippinesThemes.private,
          '321NBC',
          validator: const PhilippinesMotorcycleValidator(),
        ),
        for (final PhilippinesStrip strip in PhilippinesStrips.all)
          _e(
            'ph.motorcycle.${strip.id}',
            strip.region,
            PhilippinesPlates.motorcycle(strip: strip),
            PhilippinesThemes.private,
            '123ABC',
            validator: const PhilippinesMotorcycleValidator(),
          ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
