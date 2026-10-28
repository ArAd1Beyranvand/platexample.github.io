import 'package:maldives_plate/maldives_plate.dart';

import '../catalogue.dart';

/// `maldives_plate`: the 2003 series, 461 × 273 — one spec; the type
/// letter (P, C, G, S, T, D) picks black, yellow taxi or blue diplomatic.
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

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '461 × 273',
      note: 'One design; the type letter picks black, yellow (T) or blue (D).',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'mv.standard',
          label: 'Private · P',
          spec: MaldivesPlates.standard,
          theme: MaldivesThemes.black,
          country: MaldivesCountry.maldives,
          validator: const MaldivesPlateValidator(),
          sampleValues: 'A B 1 A 3665 P'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
