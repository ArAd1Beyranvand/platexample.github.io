import 'package:plate_core/plate_core.dart';
import 'package:thailand_plate/thailand_plate.dart';

import '../catalogue.dart';

/// `thailand_plate`: every registered category, each in its own livery, over
/// the three designs — the standard plate, the three-row motorcycle plate and
/// the square truck plate.
class ThailandSource extends GallerySource {
  ThailandSource();

  @override
  String get countryName => 'Thailand';

  @override
  String get packageName => 'thailand_plate';

  @override
  String get note =>
      'Thai series letters and up to four digits over the province name. The '
      'colour is the category: white for private, yellow for taxis, green for '
      'tourist hire. Not drawn: the provincial seal on the truck plate and the '
      'reserved-number auction series.';

  /// The package pairs each category with its geometry and livery, so a
  /// section is a walk over [ThailandCategory.values] rather than a second
  /// list naming all twelve.
  static GalleryEntry _e(ThailandCategory category, String values) {
    final PlateSpec spec = ThailandPlates.of(category);
    return GalleryEntry(
      id: 'th.${category.id}',
      label: category.name,
      spec: spec,
      theme: ThailandPlates.themeOf(category),
      country: ThailandCountry.thailand,
      validator: const ThailandValidator(),
      sampleValues: values.split(' '),
    );
  }

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 340 × 150',
      note: 'Two Thai series letters and four digits over the province.',
      entries: <GalleryEntry>[
        _e(ThailandCategory.private, 'ก ข 1234'),
        _e(ThailandCategory.van, 'ค ง 5678'),
        _e(ThailandCategory.pickup, 'จ ฉ 9012'),
        _e(ThailandCategory.tricycle, 'ช ฌ 3456'),
        _e(ThailandCategory.trailer, 'ฏ ฐ 7890'),
        _e(ThailandCategory.taxi, 'ณ ด 1122'),
        _e(ThailandCategory.tukTuk, 'ก ข 3344'),
        _e(ThailandCategory.tourist, 'ค ง 5566'),
      ],
    ),
    GallerySection(
      title: 'Trade and motorcycle',
      note:
          'The trade plate carries one series letter; the motorcycle plate '
          'puts the series, the province and the serial on three rows.',
      entries: <GalleryEntry>[
        _e(ThailandCategory.trade, 'ก 1234'),
        _e(ThailandCategory.motorcycle, 'ข ค ง 5678'),
      ],
    ),
    GallerySection(
      title: 'Truck and bus — 440 × 220',
      note: 'Two digits, a dash and four, the province beneath.',
      entries: <GalleryEntry>[
        _e(ThailandCategory.truckPrivate, '10 23 4567'),
        _e(ThailandCategory.truckHired, '30 87 6543'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
