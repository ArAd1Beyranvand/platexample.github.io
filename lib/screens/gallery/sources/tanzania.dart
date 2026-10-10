import 'package:plate_core/plate_core.dart';
import 'package:tanzania_plate/tanzania_plate.dart';

import '../catalogue.dart';

/// `tanzania_plate`: three digits and three letters behind the T and the flag,
/// on one row or two, with the digit-only organisation plate.
class TanzaniaSource extends GallerySource {
  TanzaniaSource();

  @override
  String get countryName => 'Tanzania';

  @override
  String get packageName => 'tanzania_plate';

  @override
  String get note =>
      'Three digits then three letters, black on yellow, led by the T and the '
      'flag. The organisation plate is digits only. Not drawn: the flag\'s '
      'detail and the diplomatic and government series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'tz.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TanzaniaCountry.tanzania,
    validator: const TanzaniaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The same register on one row and on two.',
      entries: <GalleryEntry>[
        _e('private', 'Private car · one row', TanzaniaPlates.private,
            TanzaniaThemes.private, '1 2 3 A B C'),
        _e('private_two_row', 'Private car · two rows',
            TanzaniaPlates.privateTwoRow, TanzaniaThemes.privateTwoRow,
            '4 5 6 D E F'),
      ],
    ),
    GallerySection(
      title: 'Organisation',
      note: 'Six digits, no letter block.',
      entries: <GalleryEntry>[
        _e('organisation', 'Organisation', TanzaniaPlates.organisation,
            TanzaniaThemes.organisation, '2 5 0 1 2 3'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
