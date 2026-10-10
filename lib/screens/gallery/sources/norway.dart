import 'package:norway_plate/norway_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `norway_plate`: two letters and five digits behind the blue flag stripe,
/// and the blue diplomatic plate.
class NorwaySource extends GallerySource {
  NorwaySource();

  @override
  String get countryName => 'Norway';

  @override
  String get packageName => 'norway_plate';

  @override
  String get note =>
      'Two letters and five digits, black on white, with the flag and the N '
      'code on a blue stripe at the left. The electric series shares the '
      'geometry; the diplomatic plate is white on blue and leads with C or D. '
      'Not drawn: the registration sticker and the shorter four-digit series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'no.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: NorwayCountry.norway,
    validator: const NorwayValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 110',
      note: 'Two letters then five digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', NorwayPlates.private,
            NorwayThemes.private, 'B C 1 2 3 4 5'),
        _e('electric', 'Electric vehicle', NorwayPlates.electric,
            NorwayThemes.private, 'E K 5 4 3 2 1'),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'White on blue; the two letters are the status code.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic corps', NorwayPlates.diplomatic,
            NorwayThemes.diplomatic, 'C D 0 1 2 3 4'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
