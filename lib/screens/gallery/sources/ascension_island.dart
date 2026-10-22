import 'package:saint_helena_plate/saint_helena_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ascension_island_plate`: one design in two liveries.
class AscensionIslandSource extends GallerySource {
  AscensionIslandSource();

  @override
  String get countryName => 'Ascension Island';

  @override
  String get packageName => 'ascension_island_plate';

  @override
  String get note =>
      'An A and digits, as on Saint Helena. Black on white at the front, '
      'black on yellow at the rear, UK dimensions.';

  GalleryEntry _entry(String id, String label, PlateTheme theme, List<String?> values) =>
      GalleryEntry(
        id: 'ac.$id',
        label: label,
        spec: AscensionIslandPlates.standard,
        theme: theme,
        country: AscensionIslandCountry.ascension_island,
        validator: const AscensionIslandValidator(),
        sampleValues: values,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private plates',
      note:
          'The article gives one sentence and no Ascension photograph, so the '
          'layout and the one-to-four digit run are the UK\'s and an '
          'estimate from the Saint Helena photo.',
      entries: <GalleryEntry>[
        _entry('front', 'Front · black on white', AscensionIslandThemes.front, <String?>[
          'A',
          '1234',
        ]),
        _entry('rear', 'Rear · black on yellow', AscensionIslandThemes.rear, <String?>['A', '260']),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
