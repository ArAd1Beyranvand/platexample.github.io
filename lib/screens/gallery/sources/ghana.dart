import 'package:ghana_plate/ghana_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ghana_plate`: private, commercial and motorcycle plates.
class GhanaSource extends GallerySource {
  GhanaSource();

  @override
  String get countryName => 'Ghana';

  @override
  String get packageName => 'ghana_plate';

  @override
  String get note =>
      'Region code, one to four digits and the two-digit year, with a small '
      'flag and GH. Black on white is private, black on yellow commercial, '
      'white on blue motorcycles. Not drawn: agricultural, diplomatic and '
      'government plates, which the article does not picture.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'gh.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GhanaCountry.ghana,
    validator: const GhanaValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars',
      note:
          'GS is a Greater Accra supplementary code; AS is Ashanti. The '
          'number runs from 1 to 9999.',
      entries: <GalleryEntry>[
        _e('private', 'Private', GhanaPlates.twoRow, GhanaThemes.private, <String?>[
          'GS',
          '3493',
          '13',
        ]),
        _e('commercial', 'Commercial', GhanaPlates.twoRow, GhanaThemes.commercial, <String?>[
          'GN',
          '4516',
          '10',
        ]),
        _e(
          'commercialOneRow',
          'Commercial · one row',
          GhanaPlates.oneRow,
          GhanaThemes.commercialOneRow,
          <String?>['AS', '5387', '12'],
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycles',
      note: 'M, the year and the region, over the number.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', GhanaPlates.motorcycle, GhanaThemes.motorcycle, <String?>[
          'M',
          '10',
          'AS',
          '1620',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
