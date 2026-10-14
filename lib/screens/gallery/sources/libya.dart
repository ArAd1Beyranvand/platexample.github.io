import 'package:libya_plate/libya_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `libya_plate`: the 2013 series, 520 × 110 in one row and 270 × 150 in
/// two — private, foreign-owned, diplomatic and the five lettered classes.
class LibyaSource extends GallerySource {
  LibyaSource();

  @override
  String get countryName => 'Libya';

  @override
  String get packageName => 'libya_plate';

  @override
  String get note =>
      'A municipality code, a dash and a serial beside ليبيا, black on '
      'white; a blue box with the owner\'s country code for foreign cars, '
      'red for diplomats and yellow, with a class letter, for commercial '
      'vehicles. The digits read short: the plates use a condensed face.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'ly.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: LibyaCountry.libya,
    validator: const LibyaPlateValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    for (final (two, size) in const <(bool, String)>[
      (false, '520 × 110'),
      (true, '270 × 150'),
    ])
      GallerySection(
        title: two ? 'Two rows — $size' : 'One row — $size',
        note: two
            ? 'The municipality code and ليبيا over the serial.'
            : 'Everything on one line, ليبيا on the right.',
        entries: <GalleryEntry>[
          _entry(
            'private.${two ? 2 : 1}',
            'Private · black on white',
            LibyaPlates.private(twoRow: two),
            LibyaThemes.white,
            '8 616192',
          ),
          _entry(
            'foreign.${two ? 2 : 1}',
            'Foreign-owned · country code in blue',
            LibyaPlates.foreign(twoRow: two),
            LibyaThemes.white,
            '39 3 3123',
          ),
          _entry(
            'diplomatic.${two ? 2 : 1}',
            'Diplomatic · هيئة سياسية',
            LibyaPlates.diplomatic(twoRow: two),
            LibyaThemes.red,
            '11 13',
          ),
          for (final LibyaClass c in LibyaClass.values)
            _entry(
              '${c.id}.${two ? 2 : 1}',
              '${c.name} · ${c.letter}',
              LibyaPlates.lettered(c, twoRow: two),
              LibyaThemes.yellow,
              '8 123456',
            ),
        ],
      ),
  ];

  List<GallerySection>? _sections;
}
