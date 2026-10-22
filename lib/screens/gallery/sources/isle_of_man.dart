import 'package:united_kingdom_plate/united_kingdom_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `isle_of_man_plate`: white front, yellow rear and the white-on-black
/// classic plate, all with the red Manx flag strip over `GBM`.
class IsleOfManSource extends GallerySource {
  IsleOfManSource();

  @override
  String get countryName => 'Isle of Man';

  @override
  String get packageName => 'isle_of_man_plate';

  @override
  String get note =>
      'A letter then MN, one to three digits and a letter (`NMN-835-H`). '
      'Not drawn: older formats (`MN 1234`, `MAN 123`) and the plain plate '
      'without the flag strip. The article lists nothing Israel-specific, so '
      'nothing is refused.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'im.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: IsleOfManCountry.isle_of_man,
    validator: const IsleOfManValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Front, rear, and the classic plate for pre-1990 vehicles.',
      entries: <GalleryEntry>[
        _e(
          'front',
          'Front · black on white',
          IsleOfManPlates.front,
          IsleOfManThemes.front,
          'DMN 452 H',
        ),
        _e(
          'rear',
          'Rear · black on yellow',
          IsleOfManPlates.rear,
          IsleOfManThemes.rear,
          'NMN 835 H',
        ),
        _e(
          'classic',
          'Classic · white on black',
          IsleOfManPlates.classic,
          IsleOfManThemes.classic,
          'BMN 7 K',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
