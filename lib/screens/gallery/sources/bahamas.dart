import 'dart:math';

import 'package:bahamas_plate/bahamas_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bahamas_plate`: the five series the article photographs, one design in
/// five liveries and wordings.
class BahamasSource extends GallerySource {
  BahamasSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1973);

  @override
  String get countryName => 'Bahamas';

  @override
  String get packageName => 'bahamas_plate';

  @override
  String get note =>
      'Historic series only: the page shows no image of the 2016 plates. '
      'An island caption over a numeric serial, with the country below; the '
      'truck series prefixes a T. Validity stickers and the 1992 tourism logo '
      'are not drawn.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme) => GalleryEntry(
    id: 'bs.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BahamasCountry.bahamas,
    validator: const BahamasValidator(),
    sampleValues: BahamasSerialGenerator.generate(spec, random: _rng),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Series',
      note:
          'The serial is about 75% of the real height: the plate face is '
          'condensed and a run wider than its box is scaled down.',
      entries: <GalleryEntry>[
        _entry('yellow', '1987 · black on yellow', BahamasPlates.yellow, BahamasThemes.yellow),
        _entry('green', '1990 · white on green', BahamasPlates.green, BahamasThemes.green),
        _entry('pale', '1977 · truck, black on pale cyan', BahamasPlates.pale, BahamasThemes.pale),
        _entry(
          'landfall',
          '1992 · First Landfall truck',
          BahamasPlates.landfall,
          BahamasThemes.landfall,
        ),
        _entry('blue', '1997 · gold on blue', BahamasPlates.blue, BahamasThemes.blue),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
