import 'package:plate_core/plate_core.dart';
import 'package:syria_plate/syria_plate.dart';

import '../catalogue.dart';

/// `syria_plate`: the transitional government's plate and the AANES plates.
/// Classes are themes on shared specs; an AANES region is its own spec,
/// because the region's names are printed on the face.
class SyriaSource extends GallerySource {
  SyriaSource();

  @override
  String get countryName => 'Syria';

  @override
  String get packageName => 'syria_plate';

  @override
  String get note =>
      'The transitional government plate — two digits, the flag between '
      'سورية and SYR, five digits — in black or maroon; and the AANES plate, '
      'six digits over their Eastern Arabic echo beside SYR and B✷S, in four '
      'colours, plus the motorcycle plate. Not drawn: the 1997 series and the '
      'opposition-held territories\' plates.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'sy.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SyriaCountry.syria,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Transitional government',
      note: 'A two-digit code and a five-digit serial.',
      entries: <GalleryEntry>[
        for (final (id, label, theme) in <(String, String, PlateTheme)>[
          ('private', 'Private · black', SyriaThemes.private),
          ('commercial', 'Commercial · maroon', SyriaThemes.commercial),
        ])
          _entry(
            id,
            label,
            SyriaPlates.transitional,
            theme,
            const SyriaTransitionalValidator(),
            '12 12345',
          ),
      ],
    ),
    GallerySection(
      title: 'AANES',
      note:
          'Six digits; the region in Kurdish code, Arabic, and Syriac where '
          'the district has a Syriac name.',
      entries: <GalleryEntry>[
        for (final (id, label, region, theme)
            in <(String, String, AanesRegion, PlateTheme)>[
              (
                'aanes.private',
                'Private · blue on white · Qamishli',
                AanesRegion.qamishli,
                SyriaThemes.aanesPrivate,
              ),
              (
                'aanes.commercial',
                'Commercial · red on white · Hasaka',
                AanesRegion.hasaka,
                SyriaThemes.aanesCommercial,
              ),
              (
                'aanes.security',
                'Security · white on blue · Qamishli',
                AanesRegion.qamishli,
                SyriaThemes.aanesSecurity,
              ),
              (
                'aanes.administrative',
                'Administrative · white on green · Hasaka',
                AanesRegion.hasaka,
                SyriaThemes.aanesAdministrative,
              ),
              (
                'aanes.bilingual',
                'Administrative · bilingual · Tabqa',
                AanesRegion.tabqa,
                SyriaThemes.aanesAdministrative,
              ),
              (
                'aanes.kobani',
                'Private · bilingual · Kobani',
                AanesRegion.kobani,
                SyriaThemes.aanesPrivate,
              ),
            ])
          _entry(
            id,
            label,
            SyriaPlates.aanes(region),
            theme,
            const AanesValidator(),
            '123456',
          ),
        _entry(
          'aanes.motorcycle',
          'Motorcycle · Qamishli',
          SyriaPlates.motorcycle(AanesRegion.qamishli),
          SyriaThemes.aanesPrivate,
          const AanesMotorcycleValidator(),
          'A 1234',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
