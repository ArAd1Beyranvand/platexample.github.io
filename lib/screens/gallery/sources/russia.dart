import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:russia_plate/russia_plate.dart';

import '../catalogue.dart';

/// `russia_plate`: the one-row plates, the diplomatic plate and the motorcycle
/// plate.
class RussiaSource extends GallerySource {
  RussiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(2002);

  @override
  String get countryName => 'Russia';

  @override
  String get packageName => 'russia_plate';

  @override
  String get note =>
      'Letters, digits and a region code with RUS and the flag. Only the '
      'twelve Cyrillic capitals that look Latin are used. Mission code 127 '
      'is refused (COUNTRY NOT FOUND).';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'ru.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: RussiaCountry.russia,
        validator: const RussiaValidator(),
        sampleValues: RussiaSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Road plates',
      note:
          'Black on white, with the region and flag at the right. Taxi is '
          'black on yellow, police white on blue.',
      entries: <GalleryEntry>[
        _entry('private', 'Private · У199ХА 78', RussiaPlates.private, RussiaThemes.private),
        _entry('trailer', 'Trailer', RussiaPlates.trailer, RussiaThemes.trailer),
        _entry('taxi', 'Taxi', RussiaPlates.taxi, RussiaThemes.taxi),
        _entry('police', 'Police', RussiaPlates.police, RussiaThemes.police),
        _entry('motorcycle', 'Motorcycle', RussiaPlates.motorcycle, RussiaThemes.motorcycle),
      ],
    ),
    GallerySection(
      title: 'Special plates',
      note:
          'Military and diplomatic plates are white on black and red. The '
          'diplomatic number is one digit after CD and three after D or T; '
          'the region field holds the mission code. Transit and export plates '
          'are paper.',
      entries: <GalleryEntry>[
        _entry('military', 'Military', RussiaPlates.military, RussiaThemes.military),
        _entry(
          'diplomatic',
          'Diplomatic',
          RussiaPlates.diplomatic,
          RussiaThemes.diplomatic,
          note: 'Digits 1–3 are the mission code. Code 127 is refused.',
        ),
        _entry('transit', 'Transit', RussiaPlates.transit, RussiaThemes.transit),
        _entry('exported', 'Export', RussiaPlates.exported, RussiaThemes.exported),
      ],
    ),
  ];
  List<GallerySection>? _sections;
}
