import 'package:plate_core/plate_core.dart';
import 'package:senegal_plate/senegal_plate.dart';

import '../catalogue.dart';

/// `senegal_plate`: the 1989–2019 plate and the current front, truck-rear and
/// motorcycle plates.
class SenegalSource extends GallerySource {
  SenegalSource();

  @override
  String get countryName => 'Senegal';

  @override
  String get packageName => 'senegal_plate';

  @override
  String get note =>
      'Regional code, number and series. The old plate is white on blue; the '
      'current ones are black on white with a blue strip (flag and SN) and '
      'the region and department stacked at the right. Not drawn: the pre-2009 '
      'Ziguinchor plate and the 2000s version with a country strip.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'sn.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SenegalCountry.senegal,
    validator: const SenegalValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '1989–2019',
      note:
          'Region code, four digits and one or two letters, white on blue; '
          'DK is Dakar.',
      entries: <GalleryEntry>[
        _e(
          'old',
          'Old · two letters',
          SenegalPlates.old,
          SenegalThemes.old,
          'DK 1234 AB',
        ),
        _e(
          'oldSingle',
          'Old · one letter',
          SenegalPlates.old,
          SenegalThemes.old,
          'TH 1234 A',
        ),
      ],
    ),
    GallerySection(
      title: 'Current',
      note:
          'Series, three digits and two letters, with the region (DK) and '
          'department (01) codes. Trucks and buses carry the front plate in '
          'front and the two-row plate behind; motorcycles the small two-row '
          'plate.',
      entries: <GalleryEntry>[
        _e(
          'current',
          'Front',
          SenegalPlates.current,
          SenegalThemes.current,
          'AA 012 BC DK 01',
        ),
        _e(
          'truckRear',
          'Truck and bus rear',
          SenegalPlates.truckRear,
          SenegalThemes.twoRow,
          'AA 012 BC DK 01',
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          SenegalPlates.motorcycle,
          SenegalThemes.twoRow,
          'AA 123 BC DK 01',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
