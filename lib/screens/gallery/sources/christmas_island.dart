import 'package:indian_ocean_plate/indian_ocean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `christmas_island_plate`: the current `CI•1234` series, 372 × 134 mm.
class ChristmasIslandSource extends GallerySource {
  ChristmasIslandSource();

  @override
  String get countryName => 'Christmas Island';

  @override
  String get packageName => 'christmas_island_plate';

  @override
  String get note =>
      'Two letters and four digits. The graphic is black on white; the '
      'issued plate is navy on yellow with the island\'s emblem and captions.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: ChristmasIslandCountry.christmas_island,
    validator: const ChristmasIslandValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current series — 372 × 134',
      note: 'The 1972 white-on-blue series is not modelled.',
      entries: <GalleryEntry>[
        _e(
          'cx.standard',
          'Graphic',
          ChristmasIslandPlates.standard,
          ChristmasIslandThemes.standard,
          <String?>['CI', '6259'],
        ),
        _e(
          'cx.yellow',
          'Issued',
          ChristmasIslandPlates.yellow,
          ChristmasIslandThemes.yellow,
          <String?>['CI', '1337'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
