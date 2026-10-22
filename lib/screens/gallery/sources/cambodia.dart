import 'package:cambodia_plate/cambodia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cambodia_plate`: the province-captioned plates — private on one and two
/// lines, police, diplomatic, NGO and the international motorcycle plate.
class CambodiaSource extends GallerySource {
  CambodiaSource();

  @override
  String get countryName => 'Cambodia';

  @override
  String get packageName => 'cambodia_plate';

  @override
  String get note =>
      'A class digit, a series letter and four digits under the province name '
      'in Khmer and Latin. Police plates are red, diplomatic plates carry a '
      'two-letter mission code, and NGO plates three letters over six digits. '
      'Not drawn: the 25 provinces as pickable captions beyond the default.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const CambodiaValidator(),
  }) => GalleryEntry(
    id: 'kh.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: CambodiaCountry.cambodia,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The one-line plate, and the long plate with two series letters.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', CambodiaPlates.private, CambodiaThemes.private, '2 A 1234'),
        _e(
          'privatelong',
          'Private · long',
          CambodiaPlates.privateLong,
          CambodiaThemes.privateLong,
          '2 AB 1234',
        ),
      ],
    ),
    GallerySection(
      title: 'Official and stacked',
      note: 'Police, diplomatic, NGO and the two-row motorcycle plate.',
      entries: <GalleryEntry>[
        _e('police', 'Police · red', CambodiaPlates.police, CambodiaThemes.police, '1 2345'),
        _e(
          'diplomatic',
          'Diplomatic',
          CambodiaPlates.diplomatic,
          CambodiaThemes.diplomatic,
          'CD 12 345',
          validator: const CambodiaStackedValidator(),
        ),
        _e(
          'ngo',
          'Non-governmental',
          CambodiaPlates.nonGovernmental,
          CambodiaThemes.ngo,
          'ONG 123 4 567',
          validator: const CambodiaStackedValidator(),
        ),
        _e(
          'intlmotorcycle',
          'International motorcycle',
          CambodiaPlates.internationalMotorcycle,
          CambodiaThemes.internationalMotorcycle,
          '12 345',
          validator: const CambodiaStackedValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
