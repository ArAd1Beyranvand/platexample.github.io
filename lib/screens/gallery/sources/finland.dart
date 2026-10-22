import 'package:finland_plate/finland_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `finland_plate`: letters and digits as two fields with a painted dash, in
/// five liveries.
class FinlandSource extends GallerySource {
  FinlandSource();

  @override
  String get countryName => 'Finland';

  @override
  String get packageName => 'finland_plate';

  @override
  String get note =>
      'Two or three letters, a dash and one to three digits, black on white '
      'beside the EU panel. Motorcycles stack the two fields on a high plate; '
      'export plates are one letter and up to four digits with a red stamp '
      'zone; Åland plates are blue on grey under an ÅLAND caption; diplomatic '
      'plates are white on blue with C or CD. Not drawn: the pre-2001 plate '
      'and the black museum plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'fi.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: FinlandCountry.finland,
    validator: const FinlandValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'Letters (two or three) and digits (one to three).',
      entries: <GalleryEntry>[
        _e('private', 'Private car', FinlandPlates.private, FinlandThemes.private, 'BZM|184'),
        _e('export', 'Export', FinlandPlates.export, FinlandThemes.private, 'A|6432'),
      ],
    ),
    GallerySection(
      title: 'Motorcycle — 164 × 200',
      note: 'Two letters over up to three digits.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', FinlandPlates.motorcycle, FinlandThemes.private, 'CU|939'),
      ],
    ),
    GallerySection(
      title: 'Åland and diplomatic',
      note: 'Blue ink on grey for Åland; white on blue for the corps.',
      entries: <GalleryEntry>[
        _e('aland', 'Åland', FinlandPlates.aland, FinlandThemes.aland, 'ÅLG|798'),
        _e(
          'diplomatic',
          'Diplomatic corps',
          FinlandPlates.diplomatic,
          FinlandThemes.diplomatic,
          'CD|3901',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
