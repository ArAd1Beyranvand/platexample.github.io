import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bonaire_plate`: the Caribbean Netherlands' plates — the 2013 white plate,
/// the navy 2005–2007 plate and the St. Eustatius and Saba island plates
/// (520 × 256).
class BonaireSource extends GallerySource {
  BonaireSource();

  @override
  String get countryName => 'Bonaire';

  @override
  String get packageName => 'bonaire_plate';

  @override
  String get note =>
      'A type prefix and up to five digits. The 2013 landscape, the '
      'St. Eustatius coat of arms and the Saba island and flag are not drawn. '
      'The 1976, 1978 and 1994 plates are not implemented. The article lists '
      'nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateValidator validator,
    List<String?> values,
  ) => GalleryEntry(
    id: 'bq.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BonaireCountry.bonaire,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Bonaire',
      note: 'One or two type letters, a dash and three to five digits.',
      entries: <GalleryEntry>[
        _entry(
          'trucks',
          'Trucks · 2013',
          BonairePlates.bonaire,
          BonaireThemes.bonaire,
          const BonaireValidator(),
          <String?>['V', '5169'],
        ),
        _entry(
          'moto',
          'Motorcycles · 2005',
          BonairePlates.blue,
          BonaireThemes.blue,
          const BonaireValidator(),
          <String?>['MF', '630'],
        ),
      ],
    ),
    GallerySection(
      title: 'Islands',
      note: 'The island letter and the digits.',
      entries: <GalleryEntry>[
        _entry(
          'statia',
          'St. Eustatius · 2007',
          BonairePlates.statia,
          BonaireThemes.statia,
          const BonaireIslandValidator(island: 'E'),
          <String?>['E', '30'],
        ),
        _entry(
          'saba',
          'Saba · 2011',
          BonairePlates.saba,
          BonaireThemes.saba,
          const BonaireIslandValidator(island: 'S', minDigits: 3),
          <String?>['S', '240'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
