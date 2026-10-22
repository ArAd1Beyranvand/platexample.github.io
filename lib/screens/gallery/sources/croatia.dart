import 'package:croatia_plate/croatia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `croatia_plate`: Croatia's plates, one entry per category.
class CroatiaSource extends GallerySource {
  CroatiaSource();

  @override
  String get countryName => 'Croatia';

  @override
  String get packageName => 'croatia_plate';

  @override
  String get note => "Croatia's plates as drawn by croatia_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator? validator = const CroatiaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: CroatiaCountry.croatia,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('hr.private', 'Private', CroatiaPlates.private, CroatiaThemes.private, <String?>[
          'ZG',
          '543',
          'AA',
        ]),
        _e(
          'hr.customized',
          'Customized',
          CroatiaPlates.customized,
          CroatiaThemes.private,
          <String?>['ZD', 'EROSS', '8'],
        ),
        _e('hr.classic', 'Classic', CroatiaPlates.classic, CroatiaThemes.private, <String?>[
          'KA',
          '881',
          'EB',
        ]),
        _e('hr.army', 'Army', CroatiaPlates.army, CroatiaThemes.army, <String?>[
          'HV',
          '489',
          'LV',
        ], null),
        _e('hr.export', 'Export', CroatiaPlates.exportPlate, CroatiaThemes.exportPlate, <String?>[
          'RH',
          '599',
          'AE',
        ], null),
        _e('hr.oversize', 'Oversize', CroatiaPlates.oversize, CroatiaThemes.oversize, <String?>[
          'ST',
          '401',
          'NR',
        ]),
        _e('hr.police', 'Police', CroatiaPlates.police, CroatiaThemes.police, <String?>[
          '010',
          '631',
        ]),
        _e(
          'hr.diplomatic',
          'Diplomatic',
          CroatiaPlates.diplomatic,
          CroatiaThemes.diplomatic,
          <String?>['023', 'A', '002'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
