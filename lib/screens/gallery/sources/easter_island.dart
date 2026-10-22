import 'package:chile_plate/chile_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `easter_island_plate`: the two provincial plates, 520 × 259.
class EasterIslandSource extends GallerySource {
  EasterIslandSource();

  @override
  String get countryName => 'Easter Island';

  @override
  String get packageName => 'easter_island_plate';

  @override
  String get note =>
      'Three letters and three digits (`ABC 123`) under the provincial '
      'caption, as on the pre-1984 plates the article pictures; colours are '
      'sampled from the references. Canvas height follows the photos (aspect '
      '2.01), not the infobox. Ink is about 70% of the reference height.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ea.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: EasterIslandCountry.easter_island,
        validator: const EasterIslandValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Provincial plates — 520 × 259',
      note: 'Red on grey for Easter Island, blue on orange for Juan Fernández.',
      entries: <GalleryEntry>[
        _entry(
          'easter_island',
          'Easter Island',
          EasterIslandPlates.easterIsland,
          EasterIslandThemes.easterIsland,
          'FZU 026',
        ),
        _entry(
          'juan_fernandez',
          'Juan Fernández',
          EasterIslandPlates.juanFernandez,
          EasterIslandThemes.juanFernandez,
          'FPA 094',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
