import 'package:benin_plate/benin_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `benin_plate`: the private and commercial plates, two letters and four
/// digits, with the sticker panel on the right.
class BeninSource extends GallerySource {
  BeninSource();

  @override
  String get countryName => 'Benin';

  @override
  String get packageName => 'benin_plate';

  @override
  String get note =>
      'A two-letter series and four digits, black on white for private '
      'vehicles and black on orange for commercial ones, with RB and the '
      'sticker panel on the right. Not drawn: the government, diplomatic '
      'and motorcycle series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'bj.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BeninCountry.benin,
    validator: const BeninValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'White for private vehicles, orange for commercial ones.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private · black on white',
          BeninPlates.private,
          BeninThemes.private,
          'A B 1 2 3 4',
        ),
        _e(
          'commercial',
          'Commercial · black on orange',
          BeninPlates.commercial,
          BeninThemes.commercial,
          'C D 5 6 7 8',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
