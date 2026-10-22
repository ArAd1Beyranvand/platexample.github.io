import 'package:china_plate/china_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `china_plate`: the GA 36 single-line plate, New Energy and diplomatic.
/// Diplomatic mission code 157 (Israel) is refused in every layer with
/// "COUNTRY NOT FOUND".
class ChinaSource extends GallerySource {
  ChinaSource();

  @override
  String get countryName => 'China';

  @override
  String get packageName => 'china_plate';

  @override
  String get note =>
      'A province character and a city letter, a dot, and a five-character '
      'serial, in blue, yellow or black; New Energy plates are green and '
      'six-character. Diplomatic mission code 157 is refused in every layer '
      'with "COUNTRY NOT FOUND". Ink is ~73% of the reference height.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    PlateValidator validator = const ChinaValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: ChinaCountry.china,
    validator: validator,
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Single line — 440 × 140',
      note: 'One spec; the livery is the theme.',
      entries: <GalleryEntry>[
        _e('cn.private', 'Small vehicle (blue)', ChinaPlates.standard, ChinaThemes.blue, <String?>[
          '京',
          'A',
          'F0236',
        ]),
        _e(
          'cn.large',
          'Large vehicle (yellow)',
          ChinaPlates.standard,
          ChinaThemes.yellow,
          <String?>['京', 'A', 'F0236'],
        ),
        _e(
          'cn.coach',
          'Driving-school car (学)',
          ChinaPlates.standard,
          ChinaThemes.yellow,
          <String?>['京', 'A', 'F023学'],
          note: 'The last place of the serial is a Hanzi suffix.',
        ),
        _e(
          'cn.crossBorder',
          'Hong Kong cross-border (港)',
          ChinaPlates.standard,
          ChinaThemes.black,
          <String?>['粤', 'Z', '3288港'],
        ),
      ],
    ),
    GallerySection(
      title: 'New Energy — 480 × 140',
      note: 'The emblem is an approximation of the logo.',
      entries: <GalleryEntry>[
        _e(
          'cn.energy.small',
          'Small New Energy',
          ChinaPlates.newEnergySmall,
          ChinaThemes.newEnergySmall,
          <String?>['粤', 'B', 'D12345'],
          validator: const ChinaNewEnergyValidator(),
        ),
        _e(
          'cn.energy.large',
          'Large New Energy',
          ChinaPlates.newEnergyLarge,
          ChinaThemes.newEnergyLarge,
          <String?>['粤', 'B', '12345D'],
          validator: const ChinaNewEnergyValidator(large: true),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic — 440 × 140',
      note: 'The pre-2017 photographed layout, 使 first.',
      entries: <GalleryEntry>[
        _e(
          'cn.diplomatic',
          'Embassy (使)',
          ChinaPlates.diplomatic,
          ChinaThemes.diplomatic,
          <String?>['使', '132', '003'],
          validator: const ChinaDiplomaticValidator(),
          note: 'Digits 1–3 are the mission code. Try typing 157.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
