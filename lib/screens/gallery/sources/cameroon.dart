import 'package:cameroon_plate/cameroon_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cameroon_plate`: the regular black-on-orange plate and the diplomatic
/// white-on-green one, both with the CEMAC emblem and `CMR`.
class CameroonSource extends GallerySource {
  CameroonSource();

  @override
  String get countryName => 'Cameroon';

  @override
  String get packageName => 'cameroon_plate';

  @override
  String get note =>
      'The regular plate: a region code, a number and a series in black on '
      'orange, with the CEMAC emblem and CMR at the left. Diplomatic plates '
      'are the same layout in white on green. Not drawn: the state, postal, '
      'military and police plates, for which no measured plate exists.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'cm.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: CameroonCountry.cameroon,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular',
      note: 'Region code, number, series.',
      entries: <GalleryEntry>[
        _e('private', 'Private', CameroonPlates.private,
            CameroonThemes.private, 'LT 128 AB',
            const CameroonValidator()),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'CM D, a mission code and a suffix, white on green.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic', CameroonPlates.diplomatic,
            CameroonThemes.diplomatic, 'CM D 38 2',
            const CameroonDiplomaticValidator()),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
