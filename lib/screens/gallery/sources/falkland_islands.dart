import 'package:argentina_plate/argentina_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `falkland_islands_plate`: black on yellow at the rear, black on white at
/// the front, and the four-digit government plate.
class FalklandIslandsSource extends GallerySource {
  FalklandIslandsSource();

  @override
  String get countryName => 'Falkland Islands';

  @override
  String get packageName => 'falkland_islands_plate';

  @override
  String get note =>
      'F, up to three digits and a serial letter; government vehicles use F '
      'and four digits. Not drawn: the earlier white-on-black series and the '
      'stacked two-line private plate. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'fk.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: FalklandIslandsCountry.falkland_islands,
    validator: const FalklandIslandsValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Private plates front and rear, and government.',
      entries: <GalleryEntry>[
        _e(
          'private_rear',
          'Private · rear',
          FalklandIslandsPlates.private,
          FalklandIslandsThemes.rear,
          'F 458 B',
        ),
        _e(
          'private_front',
          'Private · front',
          FalklandIslandsPlates.private,
          FalklandIslandsThemes.front,
          'F 458 B',
        ),
        _e(
          'government',
          'Government',
          FalklandIslandsPlates.government,
          FalklandIslandsThemes.rear,
          'F 1234',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
