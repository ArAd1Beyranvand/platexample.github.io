import 'package:mongolia_plate/mongolia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `mongolia_plate`: four digits then three Cyrillic letters, with the Soyombo
/// in the oval and the MGL code.
class MongoliaSource extends GallerySource {
  MongoliaSource();

  @override
  String get countryName => 'Mongolia';

  @override
  String get packageName => 'mongolia_plate';

  @override
  String get note =>
      'Four digits then three Cyrillic letters, black on white, with the '
      'Soyombo in an oval and the MGL code. The two-row plate carries the same '
      'seven cells. Not drawn: the province sticker and the diplomatic and '
      'government series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'mn.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MongoliaCountry.mongolia,
    validator: const MongoliaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'One line, and the same register on two.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', MongoliaPlates.private, MongoliaThemes.private, '1234 АР А'),
        _e('two_row', 'Two-row plate', MongoliaPlates.twoRow, MongoliaThemes.twoRow, '5678 БН Б'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
