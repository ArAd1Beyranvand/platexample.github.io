import 'package:cyprus_plate/cyprus_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cyprus_plate`: Cyprus's plates, one entry per category.
class CyprusSource extends GallerySource {
  CyprusSource();

  @override
  String get countryName => 'Cyprus';

  @override
  String get packageName => 'cyprus_plate';

  @override
  String get note => "Cyprus's plates as drawn by cyprus_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const CyprusValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: CyprusCountry.cyprus,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'cy.standard_front',
          'Standard front',
          CyprusPlates.standard,
          CyprusThemes.front,
          <String?>['KQL', '343'],
        ),
        _e('cy.standard_rear', 'Standard rear', CyprusPlates.standard, CyprusThemes.rear, <String?>[
          'KQL',
          '343',
        ]),
        _e('cy.rental', 'Rental', CyprusPlates.standard, CyprusThemes.rental, <String?>[
          'KQL',
          '343',
        ]),
        _e('cy.historic', 'Historic', CyprusPlates.standard, CyprusThemes.historic, <String?>[
          'KQL',
          '343',
        ]),
        _e('cy.trailer', 'Trailer', CyprusPlates.trailer, CyprusThemes.front, <String?>['06800']),
        _e('cy.diplomatic', 'Diplomatic', CyprusPlates.diplomatic, CyprusThemes.front, <String?>[
          '49',
          'CD',
          '1',
        ]),
        _e('cy.sba', 'Sba', CyprusPlates.sba, CyprusThemes.sba, <String?>['22']),
        _e('cy.dealer', 'Dealer', CyprusPlates.dealer, CyprusThemes.dealer, <String?>['20', '125']),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
