import 'package:new_zealand_plate/new_zealand_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `new_zealand_plate`: New Zealand's standard, legacy, personalised and Europlate-style plates.
class NewZealandSource extends GallerySource {
  NewZealandSource();

  @override
  String get countryName => 'New Zealand';

  @override
  String get packageName => 'new_zealand_plate';

  @override
  String get note => 'Standard, legacy, personalised and Europlate-style plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator? validator = const NewZealandValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: NewZealandCountry.new_zealand,
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
          'nz.standard',
          'Standard',
          NewZealandPlates.standard,
          NewZealandThemes.standard,
          <String?>['DMN', '112'],
        ),
        _e('nz.legacy', 'Legacy', NewZealandPlates.legacy, NewZealandThemes.black, <String?>[
          'GG',
          '9094',
        ], const NewZealandLegacyValidator()),
        _e(
          'nz.personalised',
          'Personalised',
          NewZealandPlates.personalised,
          NewZealandThemes.black,
          <String?>['ABC123'],
          const NewZealandPersonalisedValidator(),
        ),
        _e(
          'nz.europlate',
          'Europlate',
          NewZealandPlates.europlate,
          NewZealandThemes.europlate,
          <String?>['F430FI'],
          null,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
