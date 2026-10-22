import 'package:guyana_plate/guyana_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `guyana_plate`: each field is one slot, in four plates.
class GuyanaSource extends GallerySource {
  GuyanaSource();

  @override
  String get countryName => 'Guyana';

  @override
  String get packageName => 'guyana_plate';

  @override
  String get note =>
      'White letters on black: a series of two or three letters, then one to '
      'four digits with no leading zero, on one row or two. The Presidential '
      'plate is a gold Cacique\'s crown and the Prime Minister\'s the coat of '
      'arms, neither with a number. Not drawn: the special series (DPL, DC, '
      'DFB, CRG, GUY), which have no reference picture.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'gy.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GuyanaCountry.guyana,
    validator: const GuyanaValidator(),
    sampleValues: values.isEmpty ? const <String?>[] : values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'One row (520 × 110) and two rows (1.54:1).',
      entries: <GalleryEntry>[
        _e('singleLine', 'One row', GuyanaPlates.singleLine, GuyanaThemes.standard, 'PSS|2345'),
        _e('twoRow', 'Two rows', GuyanaPlates.twoRow, GuyanaThemes.standard, 'PCC|9140'),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'The Presidential and Prime Minister\'s plates.',
      entries: <GalleryEntry>[
        _e('president', 'President', GuyanaPlates.president, GuyanaThemes.president, ''),
        _e(
          'primeMinister',
          'Prime Minister',
          GuyanaPlates.primeMinister,
          GuyanaThemes.primeMinister,
          '',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
