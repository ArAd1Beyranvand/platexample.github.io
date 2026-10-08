import 'package:burkina_faso_plate/burkina_faso_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `burkina_faso_plate`: the current series, one row on a 520 × 110 plate.
class BurkinaFasoSource extends GallerySource {
  BurkinaFasoSource();

  @override
  String get countryName => 'Burkina Faso';

  @override
  String get packageName => 'burkina_faso_plate';

  @override
  String get note =>
      'One row of embossed characters. Private plates are black on white '
      '(12 AB 1234), commercial plates white on blue (12 A 1234), police '
      '(PN 1234) and gendarmerie (1 2345 EMGN) plates white on black. The '
      'police emblem and the gendarmerie crest are not drawn: no vector of '
      'either is published. '
      'The article lists nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'bf.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BurkinaFasoCountry.burkinaFaso,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil',
      note:
          'Region digits, a letter code and a four-digit number, with BF '
          'at the right.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          BurkinaFasoPlates.private,
          BurkinaFasoThemes.private,
          const BurkinaFasoValidator.private(),
          '1 1 G K 1 8 4 4',
        ),
        _entry(
          'commercial',
          'Commercial · white on blue',
          BurkinaFasoPlates.commercial,
          BurkinaFasoThemes.commercial,
          const BurkinaFasoValidator.commercial(),
          '1 1 E 1 5 1 5',
        ),
      ],
    ),
    GallerySection(
      title: 'Security forces',
      note: 'White on black; the emblems are left blank.',
      entries: <GalleryEntry>[
        _entry(
          'police',
          'National Police',
          BurkinaFasoPlates.police,
          BurkinaFasoThemes.police,
          const BurkinaFasoValidator.police(),
          'P N 0 0 2 0',
        ),
        _entry(
          'gendarmerie',
          'National Gendarmerie · staff',
          BurkinaFasoPlates.gendarmerie,
          BurkinaFasoThemes.gendarmerie,
          const BurkinaFasoValidator.gendarmerie(),
          '2 0 3 0 4 E M G N',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
