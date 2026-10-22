import 'dart:math';

import 'package:cyprus_plate/cyprus_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `northern_cyprus_plate`: the 2018 blue-strip series.
class NorthernCyprusSource extends GallerySource {
  NorthernCyprusSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1983);

  @override
  String get countryName => 'Northern Cyprus';

  @override
  String get packageName => 'northern_cyprus_plate';

  @override
  String get note =>
      'One design in seven liveries: a blue registrar\'s strip, letters, '
      'then up to four digits. The 1973–2018 yellow-and-white plates, taxi '
      'and presidential plates are not modelled.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'xn.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: NorthernCyprusCountry.northern_cyprus,
        validator: const NorthernCyprusValidator(),
        sampleValues: NorthernCyprusSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil plates',
      note:
          'Black on white for private cars, black on red for rental. The '
          'digits are about 89% of the real height: a 110 mm plate cannot '
          'hold the slot the engine would need.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · AB 123',
          NorthernCyprusPlates.private,
          NorthernCyprusThemes.private,
        ),
        _entry(
          'rental',
          'Rental · ZAB 123',
          NorthernCyprusPlates.rental,
          NorthernCyprusThemes.rental,
        ),
      ],
    ),
    GallerySection(
      title: 'Official and special plates',
      note:
          'Government and police share one design, inverted. Visitor and '
          'temporary plates are printed in red; diplomatic plates are black '
          'on teal with a small CD.',
      entries: <GalleryEntry>[
        _entry(
          'government',
          'Government · RHA 1234',
          NorthernCyprusPlates.government,
          NorthernCyprusThemes.government,
        ),
        _entry(
          'police',
          'Police · white on black',
          NorthernCyprusPlates.government,
          NorthernCyprusThemes.police,
        ),
        _entry(
          'visitor',
          'Visitor · ZZ 1234',
          NorthernCyprusPlates.visitor,
          NorthernCyprusThemes.visitor,
        ),
        _entry(
          'temporary',
          'Temporary · ZT 1234 A',
          NorthernCyprusPlates.temporary,
          NorthernCyprusThemes.visitor,
        ),
        _entry(
          'diplomatic',
          'Diplomatic · CD BE 123',
          NorthernCyprusPlates.diplomatic,
          NorthernCyprusThemes.diplomatic,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
