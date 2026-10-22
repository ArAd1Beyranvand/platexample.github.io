import 'package:russia_plate/russia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `belarus_plate`: the 2004 series. The diplomatic entry's validator and
/// spec both refuse mission code 09 with "COUNTRY NOT FOUND".
class BelarusSource extends GallerySource {
  BelarusSource();

  @override
  String get countryName => 'Belarus';

  @override
  String get packageName => 'belarus_plate';

  @override
  String get note =>
      'Flag and BY on white, Latin letters that read the same in Cyrillic, '
      'a region digit after the dash. Diplomatic mission code 09 is refused '
      'in every layer with "COUNTRY NOT FOUND".';

  static List<String?> _v(String s) => s.split('');

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const BelarusPlateValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: BelarusCountry.belarus,
    validator: validator,
    sampleValues: _v(values),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One line — 520 × 110',
      note: 'The documented size; ink is ~75% of the reference height.',
      entries: <GalleryEntry>[
        _e('by.car', 'Private car', BelarusPlates.car, BelarusThemes.standard, '1234AB7'),
        _e(
          'by.car.electric',
          'Electric car',
          BelarusPlates.electricCar,
          BelarusThemes.electric,
          'E123AB7',
        ),
        _e('by.truck', 'Truck / bus', BelarusPlates.truck, BelarusThemes.standard, 'AB12347'),
        _e(
          'by.truck.electric',
          'Electric truck',
          BelarusPlates.electricTruck,
          BelarusThemes.electric,
          'EB12347',
        ),
        _e('by.trailer', 'Trailer', BelarusPlates.trailer, BelarusThemes.standard, 'A1234B5'),
        _e('by.taxi', 'Taxi', BelarusPlates.taxi, BelarusThemes.taxi, '71234'),
        _e(
          'by.diplomatic',
          'Diplomatic (CD / CC)',
          BelarusPlates.diplomatic,
          BelarusThemes.diplomatic,
          'CD31237',
          validator: const BelarusDiplomaticValidator(),
          note: 'Digits 3–4 are the mission code. Try typing 09.',
        ),
        _e(
          'by.service.mo',
          'Service — armed forces (MO)',
          BelarusPlates.service,
          BelarusThemes.mo,
          '1234MO',
          validator: const BelarusServiceValidator(),
        ),
        _e(
          'by.service.pv',
          'Service — border guard (PV)',
          BelarusPlates.service,
          BelarusThemes.pv,
          '1234PB',
          validator: const BelarusServiceValidator(),
        ),
        _e(
          'by.service.mvd',
          'Service — interior ministry',
          BelarusPlates.service,
          BelarusThemes.mvd,
          '1234MK',
          validator: const BelarusServiceValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Two line',
      note: '280 × 200 and 280 × 156 are estimated from the artwork.',
      entries: <GalleryEntry>[
        _e(
          'by.car.square',
          'Car, square (280 × 200)',
          BelarusPlates.carSquare,
          BelarusThemes.standard,
          '1234AO7',
        ),
        _e(
          'by.truck.square',
          'Truck, square (280 × 200)',
          BelarusPlates.truckSquare,
          BelarusThemes.standard,
          '1234AO7',
        ),
        _e(
          'by.motorcycle',
          'Motorcycle (280 × 156)',
          BelarusPlates.motorcycle,
          BelarusThemes.standard,
          '1234AE7',
        ),
        _e(
          'by.tractor',
          'Tractor (280 × 156)',
          BelarusPlates.tractor,
          BelarusThemes.standard,
          '1234AE7',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
