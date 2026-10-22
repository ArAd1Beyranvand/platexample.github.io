import 'package:plate_core/plate_core.dart';
import 'package:china_plate/china_plate.dart';

import '../catalogue.dart';

/// `taiwan_plate`: the 380×160 plate in six colourways, the electric-vehicle
/// stripe, the 1992 plate and the 使 / 外 protocol plates.
class TaiwanSource extends GallerySource {
  TaiwanSource();

  @override
  String get countryName => 'Taiwan';

  @override
  String get packageName => 'taiwan_plate';

  @override
  String get note =>
      'Three letters (no I or O) and four digits, 380×160, in black, green or '
      'red on white, white on green or red, and black on yellow; the electric '
      'plates add a green 電動車 stripe. The 1992 320×150 plate and the 使 and '
      '外 protocol plates are included. Temporary, testing, military and '
      'machinery plates are left out.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    GatedPlateValidator validator,
  ) => GalleryEntry(
    id: 'tw.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TaiwanCountry.taiwan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Vehicles',
      note:
          'The field and ink say the class: white with black is private, '
          'red print is a taxi, green is business, red is a tour bus and '
          'yellow a shuttle.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private',
          TaiwanPlates.standard,
          TaiwanThemes.blackOnWhite,
          'BFG 9000',
          const TaiwanValidator(),
        ),
        _entry(
          'privateHeavy',
          'Private · heavy',
          TaiwanPlates.standard,
          TaiwanThemes.greenOnWhite,
          'KJN 0503',
          const TaiwanValidator(),
        ),
        _entry(
          'taxi',
          'Taxi',
          TaiwanPlates.standard,
          TaiwanThemes.redOnWhite,
          'TBZ 1023',
          const TaiwanValidator(),
        ),
        _entry(
          'business',
          'Business',
          TaiwanPlates.standard,
          TaiwanThemes.whiteOnGreen,
          'KKU 6665',
          const TaiwanValidator(),
        ),
        _entry(
          'tour',
          'Tour bus',
          TaiwanPlates.standard,
          TaiwanThemes.whiteOnRed,
          'KCX 2177',
          const TaiwanValidator(),
        ),
        _entry(
          'shuttle',
          'Shuttle',
          TaiwanPlates.standard,
          TaiwanThemes.blackOnYellow,
          'KQD 6306',
          const TaiwanValidator(),
        ),
        _entry(
          'electric',
          'Electric',
          TaiwanPlates.electric,
          TaiwanThemes.blackOnWhite,
          'EAH 7800',
          const TaiwanValidator(),
        ),
        _entry(
          'electricTaxi',
          'Electric · taxi',
          TaiwanPlates.electric,
          TaiwanThemes.redOnWhite,
          'EAM 2233',
          const TaiwanValidator(),
        ),
      ],
    ),
    GallerySection(
      title: '1992 and protocol',
      note:
          'The 320×150 plate, and the 使 (embassy) and 外 (foreign affairs) '
          'plates with their coloured block.',
      entries: <GalleryEntry>[
        _entry(
          'legacy',
          '1992',
          TaiwanPlates.legacy,
          TaiwanThemes.blackOnWhite,
          'AI 4329',
          const TaiwanLegacyValidator(),
        ),
        _entry(
          'embassy',
          'Embassy 使',
          TaiwanPlates.embassy,
          TaiwanThemes.blackOnWhite,
          '225',
          const TaiwanProtocolValidator(),
        ),
        _entry(
          'affairs',
          'Foreign affairs 外',
          TaiwanPlates.foreignAffairs,
          TaiwanThemes.blackOnWhite,
          '0872',
          const TaiwanProtocolValidator(minDigits: 4, maxDigits: 4),
        ),
        _entry(
          'affairsHeavy',
          'Foreign affairs · heavy',
          TaiwanPlates.foreignAffairsHeavy,
          TaiwanThemes.blackOnWhite,
          '0046',
          const TaiwanProtocolValidator(minDigits: 4, maxDigits: 4),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
