import 'package:andorra_plate/andorra_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `andorra_plate`: one letter and four digits under the coat of arms, and the
/// temporary plate with its red expiry boxes.
class AndorraSource extends GallerySource {
  AndorraSource();

  @override
  String get countryName => 'Andorra';

  @override
  String get packageName => 'andorra_plate';

  @override
  String get note =>
      'One letter and four digits, black on white, with the coat of arms, '
      '"AND" and "Principat d\'Andorra" in blue. The temporary plate is MT, '
      'four digits and a month and year in red boxes. Not drawn: the older '
      'series, the dealer, diplomatic and special-vehicle plates (no '
      'reference picture), and the standard plate\'s faint mountain pattern.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'ad.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: AndorraCountry.andorra,
    validator: const AndorraValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 340 × 120',
      note: 'A letter and four digits.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Standard',
          AndorraPlates.standard,
          AndorraThemes.standard,
          'L 3705',
        ),
      ],
    ),
    GallerySection(
      title: 'Temporary',
      note: 'MT, four digits, and the expiry month and year.',
      entries: <GalleryEntry>[
        _e(
          'temporary',
          'Temporary',
          AndorraPlates.temporary,
          AndorraThemes.temporary,
          '0137 XI 12',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
