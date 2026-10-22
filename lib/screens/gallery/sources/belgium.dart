import 'package:belgium_plate/belgium_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `belgium_plate`: Belgium's plates, one entry per category.
class BelgiumSource extends GallerySource {
  BelgiumSource();

  @override
  String get countryName => 'Belgium';

  @override
  String get packageName => 'belgium_plate';

  @override
  String get note => "Belgium's plates as drawn by belgium_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const BelgiumValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: BelgiumCountry.belgium,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('be.private', 'Private', BelgiumPlates.private, BelgiumThemes.private, <String?>[
          '1',
          'ABC',
          '003',
        ]),
        _e('be.dealer', 'Dealer', BelgiumPlates.dealer, BelgiumThemes.dealer, <String?>[
          '1',
          'ZAV',
          '257',
        ]),
        _e('be.trailer', 'Trailer', BelgiumPlates.trailer, BelgiumThemes.private, <String?>[
          '1',
          'QAA',
          '620',
        ]),
        _e('be.temporary', 'Temporary', BelgiumPlates.temporary, BelgiumThemes.temporary, <String?>[
          'XA',
          '16',
          'DRN',
        ]),
        _e('be.vintage', 'Vintage', BelgiumPlates.vintage, BelgiumThemes.private, <String?>[
          '000',
          '200',
        ]),
        _e(
          'be.diplomatic',
          'Diplomatic',
          BelgiumPlates.diplomatic,
          BelgiumThemes.private,
          <String?>['AT', '119'],
        ),
        _e('be.royal', 'Royal', BelgiumPlates.royal, BelgiumThemes.private, <String?>['2']),
        _e('be.military', 'Military', BelgiumPlates.military, BelgiumThemes.military, <String?>[
          '26287',
        ]),
        _e(
          'be.motorcycle',
          'Motorcycle',
          BelgiumPlates.motorcycle,
          BelgiumThemes.private,
          <String?>['M', 'AXJ', '464'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
