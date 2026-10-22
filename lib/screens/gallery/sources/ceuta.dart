import 'package:spain_plate/spain_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ceuta_plate`: Spain's national series as issued in Ceuta. Diplomatic embassy
/// code 83 is refused with "COUNTRY NOT FOUND" by the spec and the validator.
class CeutaSource extends GallerySource {
  CeutaSource();

  @override
  String get countryName => 'Ceuta';

  @override
  String get packageName => 'ceuta_plate';

  @override
  String get note =>
      'Spain\'s national series as issued in Ceuta. Diplomatic embassy code 83 is refused in every layer with "COUNTRY NOT FOUND".';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const CeutaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: CeutaCountry.ceuta,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration — 500 × 110',
      note: 'Four digits and a three-consonant counter, one slot each.',
      entries: <GalleryEntry>[
        _e('ce.private', 'Private', CeutaPlates.private, CeutaThemes.private, <String?>[
          '2008',
          'ZGZ',
        ]),
        _e('ce.historic', 'Historic', CeutaPlates.historic, CeutaThemes.historic, <String?>[
          '7010',
          'BBD',
        ]),
        _e('ce.taxi', 'Taxi', CeutaPlates.taxi, CeutaThemes.taxi, <String?>['6334', 'HRD']),
        _e('ce.trailer', 'Trailer', CeutaPlates.trailer, CeutaThemes.trailer, <String?>[
          '7286',
          'BBW',
        ]),
        _e(
          'ce.provisional',
          'Provisional',
          CeutaPlates.provisional,
          CeutaThemes.provisional,
          <String?>['1588', 'BBS'],
        ),
        _e('ce.dealer', 'Dealer', CeutaPlates.dealer, CeutaThemes.dealer, <String?>['1746', 'BCD']),
      ],
    ),
    GallerySection(
      title: 'State and diplomatic',
      note: '',
      entries: <GalleryEntry>[
        _e('ce.police', 'Police', CeutaPlates.police, CeutaThemes.police, <String?>['CME', '2342']),
        _e('ce.diplomatic', 'Diplomatic', CeutaPlates.diplomatic, CeutaThemes.diplomatic, <String?>[
          'CD',
          '1',
          '001',
        ]),
        _e('ce.consular', 'Consular', CeutaPlates.diplomatic, CeutaThemes.consular, <String?>[
          'CC',
          '10',
          '014',
        ]),
        _e(
          'ce.organisation',
          'International organisation',
          CeutaPlates.diplomatic,
          CeutaThemes.organisation,
          <String?>['OI', '303', '073'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
