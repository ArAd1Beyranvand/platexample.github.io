import 'package:plate_core/plate_core.dart';
import 'package:slovakia_plate/slovakia_plate.dart';

import '../catalogue.dart';

/// `slovakia_plate`: the one-row plates (520 × 110, EU band, coat of arms) and
/// the two-row temporary, dealer and import plates.
class SlovakiaSource extends GallerySource {
  SlovakiaSource();

  @override
  String get countryName => 'Slovakia';

  @override
  String get packageName => 'slovakia_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters, black on white with the EU '
      'band and the coat of arms; since 2023 the first two letters are '
      'arbitrary, not a district. Diplomatic plates are yellow on blue, '
      'temporary yellow, dealer red and import green on two rows. Not drawn: '
      'the 1997–2004 design, the 2025 and 2023-electric variants (no '
      'photograph), sports, trailer and motorcycle plates, the temporary '
      'date stickers and the officials town arms.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'sk.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SlovakiaCountry.slovakia,
    validator: const SlovakiaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Code, digits and letters; the band is painted by the background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · with arms',
          SlovakiaPlates.private,
          SlovakiaThemes.private,
          'AA 328 AD',
        ),
        _entry(
          'private_dash',
          'Private · dash',
          SlovakiaPlates.privateDash,
          SlovakiaThemes.private,
          'TN 221 BS',
        ),
        _entry(
          'personalised',
          'Personalised',
          SlovakiaPlates.personalised,
          SlovakiaThemes.private,
          'LV JULIA',
        ),
        _entry(
          'electric',
          'Electric · green',
          SlovakiaPlates.personalised,
          SlovakiaThemes.electric,
          'BT TSLA1',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Officials carry an X after the code.',
      entries: <GalleryEntry>[
        _entry(
          'officials',
          'Officials · X',
          SlovakiaPlates.officials,
          SlovakiaThemes.private,
          'BA X 171',
        ),
        _entry(
          'military',
          'Military',
          SlovakiaPlates.military,
          SlovakiaThemes.private,
          '60 14108',
        ),
        _entry(
          'diplomatic',
          'Diplomatic · yellow on blue',
          SlovakiaPlates.diplomatic,
          SlovakiaThemes.diplomatic,
          'ZZ 00052',
        ),
      ],
    ),
    GallerySection(
      title: 'Two rows',
      note: 'Code above, serial below.',
      entries: <GalleryEntry>[
        _entry(
          'temporary',
          'Temporary · yellow',
          SlovakiaPlates.temporary,
          SlovakiaThemes.temporary,
          'TS V 356',
        ),
        _entry(
          'dealer',
          'Dealer · red',
          SlovakiaPlates.dealer,
          SlovakiaThemes.dealer,
          'PP M 082',
        ),
        _entry(
          'imported',
          'Import · green',
          SlovakiaPlates.imported,
          SlovakiaThemes.imported,
          'C 13231',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
