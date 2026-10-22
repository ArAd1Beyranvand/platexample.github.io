import 'package:albania_plate/albania_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `albania_plate`: every category on its one-line plate, and again on the
/// two-line plate, plus the motorcycle plate.
class AlbaniaSource extends GallerySource {
  AlbaniaSource();

  @override
  String get countryName => 'Albania';

  @override
  String get packageName => 'albania_plate';

  @override
  String get note =>
      'A blue national strip with the eagle and AL on the left, a hologram '
      'between the series and the number, and a blue sticker strip on the '
      'right of the civil plates. Ink and frame are one colour: black for '
      'private, red for repetitive, taxi, temporary and test, navy for '
      'police, green for diplomatic and military (white on green for '
      'agricultural and trailer). Diplomatic mission code 79 is refused '
      '(COUNTRY NOT FOUND). Not drawn: the 1995–2002 DIN 1451 series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'al.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: AlbaniaCountry.albania,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'Black on white; the repetitive plate is the same in red.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private',
          AlbaniaPlates.private,
          AlbaniaThemes.private,
          'AB 123 FG',
          const AlbaniaPrivateValidator(),
        ),
        _e(
          'privatetwoline',
          'Private · two-line',
          AlbaniaPlates.privateTwoLine,
          AlbaniaThemes.private,
          'AB 123 FG',
          const AlbaniaPrivateValidator(),
        ),
        _e(
          'repetitive',
          'Repetitive',
          AlbaniaPlates.private,
          AlbaniaThemes.repetitive,
          'AB 123 FG',
          const AlbaniaPrivateValidator(),
        ),
        _e(
          'repetitivetwoline',
          'Repetitive · two-line',
          AlbaniaPlates.privateTwoLine,
          AlbaniaThemes.repetitive,
          'AB 123 FG',
          const AlbaniaPrivateValidator(),
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          AlbaniaPlates.motorcycle,
          AlbaniaThemes.private,
          'AB 123',
          const AlbaniaPrivateValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Agricultural and trailer',
      note: 'White on green. The class is MB, MT, RB, RT or R.',
      entries: <GalleryEntry>[
        _e(
          'agricultural',
          'Agricultural',
          AlbaniaPlates.agricultural,
          AlbaniaThemes.agricultural,
          'AB MB 78',
          const AlbaniaAgriculturalValidator(),
        ),
        _e(
          'agriculturaltwoline',
          'Agricultural · two-line',
          AlbaniaPlates.agriculturalTwoLine,
          AlbaniaThemes.agricultural,
          'AB MB 78',
          const AlbaniaAgriculturalValidator(),
        ),
        _e(
          'trailer',
          'Trailer',
          AlbaniaPlates.agricultural,
          AlbaniaThemes.agricultural,
          'AB R 456',
          const AlbaniaAgriculturalValidator(),
        ),
        _e(
          'trailertwoline',
          'Trailer · two-line',
          AlbaniaPlates.agriculturalTwoLine,
          AlbaniaThemes.agricultural,
          'AB R 456',
          const AlbaniaAgriculturalValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'State',
      note:
          'Green on white for diplomatic, service-diplomatic and military '
          'plates, navy for police. None has a sticker strip.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic · CD',
          AlbaniaPlates.diplomatic,
          AlbaniaThemes.diplomatic,
          'CD 12 03 A',
          const AlbaniaDiplomaticValidator(),
        ),
        _e(
          'diplomatictwoline',
          'Diplomatic · two-line',
          AlbaniaPlates.diplomaticTwoLine,
          AlbaniaThemes.diplomatic,
          'CD 12 03 A',
          const AlbaniaDiplomaticValidator(),
        ),
        _e(
          'service',
          'Service-diplomatic · TR',
          AlbaniaPlates.diplomatic,
          AlbaniaThemes.diplomatic,
          'TR 12 03 A',
          const AlbaniaDiplomaticValidator(),
        ),
        _e(
          'military',
          'Military',
          AlbaniaPlates.military,
          AlbaniaThemes.diplomatic,
          'MM 123 PU',
          const AlbaniaMilitaryValidator(),
        ),
        _e(
          'militarytwoline',
          'Military · two-line',
          AlbaniaPlates.militaryTwoLine,
          AlbaniaThemes.diplomatic,
          'MM 123 PU',
          const AlbaniaMilitaryValidator(),
        ),
        _e(
          'police',
          'Police',
          AlbaniaPlates.police,
          AlbaniaThemes.police,
          'MB 123 FG',
          const AlbaniaPoliceValidator(),
        ),
        _e(
          'policetwoline',
          'Police · two-line',
          AlbaniaPlates.policeTwoLine,
          AlbaniaThemes.police,
          'MB 123 FG',
          const AlbaniaPoliceValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Taxi, temporary and test',
      note: 'Red ink; the taxi on yellow, temporary and test on white.',
      entries: <GalleryEntry>[
        _e(
          'taxi',
          'Taxi',
          AlbaniaPlates.taxi,
          AlbaniaThemes.taxi,
          'AB 123 T',
          const AlbaniaTaxiValidator(),
        ),
        _e(
          'taxitwoline',
          'Taxi · two-line',
          AlbaniaPlates.taxiTwoLine,
          AlbaniaThemes.taxi,
          'AB 123 T',
          const AlbaniaTaxiValidator(),
        ),
        _e(
          'temporary',
          'Temporary · PRK',
          AlbaniaPlates.provisional,
          AlbaniaThemes.temporary,
          'AB 0 PRK',
          const AlbaniaProvisionalValidator(),
        ),
        _e(
          'temporarytwoline',
          'Temporary · two-line',
          AlbaniaPlates.temporaryTwoLine,
          AlbaniaThemes.temporary,
          'AB 0 PRK',
          const AlbaniaProvisionalValidator(),
        ),
        _e(
          'test',
          'Test · PROV',
          AlbaniaPlates.provisional,
          AlbaniaThemes.temporary,
          'AB 0 PROV',
          const AlbaniaProvisionalValidator(),
        ),
        _e(
          'testtwoline',
          'Test · two-line',
          AlbaniaPlates.testTwoLine,
          AlbaniaThemes.temporary,
          'AB 0 PROV',
          const AlbaniaProvisionalValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
