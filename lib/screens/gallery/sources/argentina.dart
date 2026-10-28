import 'package:argentina_plate/argentina_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `argentina_plate`: the Mercosur plate, the 1995 series, the trailer and the
/// foreign-mission plates of both generations.
class ArgentinaSource extends GallerySource {
  ArgentinaSource();

  @override
  String get countryName => 'Argentina';

  @override
  String get packageName => 'argentina_plate';

  @override
  String get note =>
      'The Mercosur plate has a blue top band with REPÚBLICA ARGENTINA, '
      'MERCOSUR and the flag; the 1995 series is white on black; the trailer '
      'and the 1995 foreign-mission plates carry the serial in white on a '
      'band. Not drawn: the historic and 1972–94 series, the motorcycle, '
      'temporary and Transporte Nacional de Cargas plates, and the coat of '
      'arms on the 1995 plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'ar.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: ArgentinaCountry.argentina,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'Mercosur `AB 123 CD`, and the 1995 series `ABC 123`.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Mercosur',
          ArgentinaPlates.standard,
          ArgentinaThemes.standard,
          'AG 759 LH',
          const ArgentinaStandardValidator(),
        ),
        _e(
          'legacy',
          '1995 series',
          ArgentinaPlates.legacy,
          ArgentinaThemes.legacy,
          'NVZ 087',
          const ArgentinaLegacyValidator(),
        ),
        _e(
          'trailer',
          'Trailer',
          ArgentinaPlates.trailer,
          ArgentinaThemes.banded,
          '101 NVZ 087',
          const ArgentinaTrailerValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Foreign missions',
      note:
          'The category is a chosen slot. 1995: white on a blue band, D, C, M, '
          'I or A. 1985: black on white for CD, red on teal for the rest.',
      entries: <GalleryEntry>[
        _e(
          'mission',
          'Foreign missions · 1995',
          ArgentinaPlates.mission,
          ArgentinaThemes.banded,
          'D 059 CPX',
          const ArgentinaMissionValidator(),
        ),
        _e(
          'mission1985',
          'Foreign missions · 1985',
          ArgentinaPlates.mission1985,
          ArgentinaThemes.diplomatic1985,
          'CD 0607',
          const ArgentinaMission1985Validator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
