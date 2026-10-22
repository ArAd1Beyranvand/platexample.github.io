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
      title: 'Foreign missions · 1995 series',
      note: 'White on a blue band; the first letter names the category.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic · D',
          ArgentinaPlates.diplomatic,
          ArgentinaThemes.banded,
          'D 059 CPX',
          const ArgentinaMissionValidator('D'),
        ),
        _e(
          'consular',
          'Consular · C',
          ArgentinaPlates.consular,
          ArgentinaThemes.banded,
          'C 905 DMP',
          const ArgentinaMissionValidator('C'),
        ),
        _e(
          'specialmission',
          'Special missions · M',
          ArgentinaPlates.specialMission,
          ArgentinaThemes.banded,
          'M 043 ACD',
          const ArgentinaMissionValidator('M'),
        ),
        _e(
          'international',
          'International organisations · I',
          ArgentinaPlates.international,
          ArgentinaThemes.banded,
          'I 037 RXC',
          const ArgentinaMissionValidator('I'),
        ),
        _e(
          'administrative',
          'Administrative staff · A',
          ArgentinaPlates.administrative,
          ArgentinaThemes.banded,
          'A 004 DCM',
          const ArgentinaMissionValidator('A'),
        ),
      ],
    ),
    GallerySection(
      title: 'Foreign missions · 1985 series',
      note: 'Black on white for diplomatic, red on teal for the rest.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic1985',
          'Diplomatic · CD',
          ArgentinaPlates.diplomatic1985,
          ArgentinaThemes.diplomatic1985,
          'CD 0607',
          const ArgentinaMission1985Validator('CD'),
        ),
        _e(
          'consular1985',
          'Consular · CC',
          ArgentinaPlates.consular1985,
          ArgentinaThemes.mission1985,
          'CC 7609',
          const ArgentinaMission1985Validator('CC'),
        ),
        _e(
          'specialmission1985',
          'Special missions · ME',
          ArgentinaPlates.specialMission1985,
          ArgentinaThemes.mission1985,
          'ME 0970',
          const ArgentinaMission1985Validator('ME'),
        ),
        _e(
          'international1985',
          'International organisations · OI',
          ArgentinaPlates.international1985,
          ArgentinaThemes.mission1985,
          'OI 2897',
          const ArgentinaMission1985Validator('OI'),
        ),
        _e(
          'administrative1985',
          'Administrative staff · PA',
          ArgentinaPlates.administrative1985,
          ArgentinaThemes.mission1985,
          'PA 8786',
          const ArgentinaMission1985Validator('PA'),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
