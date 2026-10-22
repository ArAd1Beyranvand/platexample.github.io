import 'package:estonia_plate/estonia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `estonia_plate`: each field is one slot, in four liveries.
class EstoniaSource extends GallerySource {
  EstoniaSource();

  @override
  String get countryName => 'Estonia';

  @override
  String get packageName => 'estonia_plate';

  @override
  String get note =>
      'Three digits and three letters, black on white beside the EU panel. '
      'Diplomatic plates are white on blue with CD, AT or CMD and two to four '
      'digits; Defence Forces plates are light on slate with a K or EK letter '
      'group; the president\'s plate carries the coat of arms and no number. '
      'Not drawn: the pre-2004 and Soviet-era plates and the classes without '
      'a reference picture.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateCountry country = EstoniaCountry.estonia,
  }) => GalleryEntry(
    id: 'ee.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: country,
    validator: const EstoniaValidator(),
    sampleValues: values.isEmpty ? const <String?>[] : values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'Three digits and three letters.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', EstoniaPlates.private, EstoniaThemes.private, '307|RTB'),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Diplomatic, Defence Forces and presidential plates.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic corps',
          EstoniaPlates.diplomatic,
          EstoniaThemes.diplomatic,
          'CD|2345',
          country: EstoniaCountry.diplomatic,
        ),
        _e('defence', 'Defence Forces', EstoniaPlates.defence, EstoniaThemes.defence, '007|EKV'),
        _e('president', 'President', EstoniaPlates.president, EstoniaThemes.president, ''),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
