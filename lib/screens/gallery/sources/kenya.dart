import 'package:kenya_plate/kenya_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `kenya_plate`: the 2022 series — three letters, three digits and a letter,
/// on one row (520 × 110) or stacked (250 × 200), plus the diplomatic plate.
class KenyaSource extends GallerySource {
  KenyaSource();

  @override
  String get countryName => 'Kenya';

  @override
  String get packageName => 'kenya_plate';

  @override
  String get note =>
      'Black on white at the front, black on yellow at the rear, white on '
      'green for electric vehicles, blue on white for county governments. '
      'Measured on one photograph, so the ink runs about 60% of the '
      'reference height and the diplomatic layout and its red are unmeasured. '
      'Mission 24 is Israel in the article\'s table and is refused: '
      'COUNTRY NOT FOUND.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const KenyaValidator(),
  }) => GalleryEntry(
    id: 'ke.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: KenyaCountry.kenya,
    validator: validator,
    sampleValues: values.contains(' ') ? values.split(' ') : values.split(''),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One row',
      note: 'One design; the field and the ink change.',
      entries: <GalleryEntry>[
        _entry('front', 'Front · black on white', KenyaPlates.row, KenyaThemes.white, 'KDK101A'),
        _entry('rear', 'Rear · black on yellow', KenyaPlates.row, KenyaThemes.yellow, 'KBX194M'),
        _entry(
          'electric',
          'Electric · white on green',
          KenyaPlates.row,
          KenyaThemes.electric,
          'EVA001A',
        ),
        _entry(
          'county',
          'County government · blue on white',
          KenyaPlates.row,
          KenyaThemes.county,
          'CGX001V',
        ),
      ],
    ),
    GallerySection(
      title: 'Square',
      note: 'The letters over the number.',
      entries: <GalleryEntry>[
        _entry(
          'square',
          'Rear · black on yellow',
          KenyaPlates.square,
          KenyaThemes.yellow,
          'KDK102A',
        ),
        _entry(
          'square_electric',
          'Electric motorcycle · white on green',
          KenyaPlates.square,
          KenyaThemes.electric,
          'EMA001A',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Mission number, CD or UN, serial, two letters.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic · white on red',
          KenyaPlates.diplomatic,
          KenyaThemes.diplomatic,
          '1 CD 1 AK',
          validator: const KenyaDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
