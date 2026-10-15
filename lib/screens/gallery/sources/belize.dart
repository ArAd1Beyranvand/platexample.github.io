import 'package:belize_plate/belize_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `belize_plate`: the standard plate, its city and twin-town variants, and
/// the dealer, truck, defence and taxi series.
class BelizeSource extends GallerySource {
  BelizeSource();

  @override
  String get countryName => 'Belize';

  @override
  String get packageName => 'belize_plate';

  @override
  String get note =>
      'Black print on white for private plates; dealer, truck, defence and '
      'taxi plates have their own colours.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One entry per category.',
      entries: <GalleryEntry>[
        _entry(
          'bz.standard',
          'Standard',
          BelizePlates.standard,
          BelizeThemes.standard,
          'C 4198',
        ),
        _entry(
          'bz.city',
          'City',
          BelizePlates.city,
          BelizeThemes.standard,
          'C 14884',
        ),
        _entry(
          'bz.twin',
          'Twin town',
          BelizePlates.twin,
          BelizeThemes.twin,
          'C 00032',
        ),
        _entry(
          'bz.dealer',
          'Dealer',
          BelizePlates.dealer,
          BelizeThemes.dealer,
          '01148',
        ),
        _entry(
          'bz.truck',
          'Truck',
          BelizePlates.truck,
          BelizeThemes.truck,
          'A 816',
        ),
        _entry(
          'bz.defence',
          'Defence',
          BelizePlates.defence,
          BelizeThemes.defence,
          'DFS 041',
        ),
        _entry(
          'bz.taxi',
          'Taxi',
          BelizePlates.taxi,
          BelizeThemes.taxi,
          'D 3217',
        ),
      ],
    ),
  ];

  static GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String sample,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: BelizeCountry.belize,
    validator: const BelizeValidator(),
    sampleValues: sample.split(' '),
  );

  List<GallerySection>? _sections;
}
