import 'package:china_plate/china_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `macau_plate`: the `MA-12-34` series in white and yellow, the moped plate
/// and the mainland supplement plate.
class MacauSource extends GallerySource {
  MacauSource();

  @override
  String get countryName => 'Macau';

  @override
  String get packageName => 'macau_plate';

  @override
  String get note =>
      'White on black, or yellow for buses and commercial vehicles, in two '
      'pairs of digits after a two-letter series; rectangular or square. '
      'Mopeds carry black on white with a fixed CM. Mainland China requires '
      'a supplement plate, 粤Z and 澳 around four characters. Only the '
      'current series is shown.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: MacauCountry.macau,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Rectangular — 520 × 110',
      note: 'Private and bus or commercial plates.',
      entries: <GalleryEntry>[
        _e('mo.private', 'Private', MacauPlates.row, MacauThemes.private, <String?>[
          'MA',
          '12',
          '34',
        ], const MacauValidator()),
        _e('mo.bus', 'Bus / commercial', MacauPlates.row, MacauThemes.yellow, <String?>[
          'MA',
          '12',
          '34',
        ], const MacauValidator()),
      ],
    ),
    GallerySection(
      title: 'Square — 340 × 216',
      note: 'Private and commercial plates in the square format.',
      entries: <GalleryEntry>[
        _e(
          'mo.private.square',
          'Private, square',
          MacauPlates.square,
          MacauThemes.privateSquare,
          <String?>['MA', '12', '34'],
          const MacauValidator(),
        ),
        _e(
          'mo.commercial.square',
          'Commercial, square',
          MacauPlates.square,
          MacauThemes.yellowSquare,
          <String?>['MA', '12', '34'],
          const MacauValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Other',
      note: 'The moped plate and the mainland supplement.',
      entries: <GalleryEntry>[
        _e('mo.moped', 'Moped (340 × 214)', MacauPlates.moped, MacauThemes.moped, <String?>[
          '12345',
        ], const MacauMopedValidator()),
        _e(
          'mo.mainland',
          'Mainland supplement (440 × 140)',
          MacauPlates.mainland,
          MacauThemes.mainland,
          <String?>['F023'],
          const MacauMainlandValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
