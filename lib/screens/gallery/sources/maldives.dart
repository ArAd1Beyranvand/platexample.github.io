import 'package:maldives_plate/maldives_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `maldives_plate`: the 2003 series, 461 × 273 — six categories on one
/// design: black private, commercial, government and police, yellow taxi and
/// blue diplomatic.
class MaldivesSource extends GallerySource {
  MaldivesSource();

  @override
  String get countryName => 'Maldives';

  @override
  String get packageName => 'maldives_plate';

  @override
  String get note =>
      'A letter, a vehicle category code and a letter over the category\'s '
      'type letter and a serial, in a floating frame. The field colour and '
      'the type letter tell the category apart. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(MaldivesCategory c, String label, PlateTheme theme) =>
      GalleryEntry(
        id: 'mv.${c.id}',
        label: label,
        spec: MaldivesPlates.of(c),
        theme: theme,
        country: MaldivesCountry.maldives,
        validator: const MaldivesPlateValidator(),
        sampleValues: 'A B 1 A 3665'.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '461 × 273',
      note: 'One design; only the field, the ink and the type letter change.',
      entries: <GalleryEntry>[
        _entry(MaldivesCategory.private, 'Private · P', MaldivesThemes.black),
        _entry(
          MaldivesCategory.commercial,
          'Commercial · C',
          MaldivesThemes.black,
        ),
        _entry(
          MaldivesCategory.government,
          'Government · G',
          MaldivesThemes.black,
        ),
        _entry(MaldivesCategory.police, 'Police · S', MaldivesThemes.black),
        _entry(
          MaldivesCategory.taxi,
          'Taxi · T · black on yellow',
          MaldivesThemes.yellow,
        ),
        _entry(
          MaldivesCategory.diplomatic,
          'Diplomatic · D · white on blue',
          MaldivesThemes.blue,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
