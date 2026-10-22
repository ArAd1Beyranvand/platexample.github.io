import 'package:lithuania_plate/lithuania_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `lithuania_plate`: each field is one slot, in seven liveries.
class LithuaniaSource extends GallerySource {
  LithuaniaSource();

  @override
  String get countryName => 'Lithuania';

  @override
  String get packageName => 'lithuania_plate';

  @override
  String get note =>
      'Three letters and three digits, black on white beside the EU panel and '
      'the coat of arms. Taxi (T), dealer (P) and temporary plates, a military '
      'plate with the flag, green-on-white agricultural plates and green '
      'diplomatic plates are shown. Diplomatic mission code 41 is refused '
      '(COUNTRY NOT FOUND). Not drawn: the pre-2018 liveries, electric, '
      'trailer, motorcycle, moped and vintage formats.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'lt.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: LithuaniaCountry.lithuania,
    validator: const LithuaniaValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'Three letters and three digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', LithuaniaPlates.private, LithuaniaThemes.private, 'NFB|338'),
        _e('taxi', 'Taxi', LithuaniaPlates.taxi, LithuaniaThemes.taxi, 'T|06868'),
        _e(
          'agricultural',
          'Agricultural',
          LithuaniaPlates.agricultural,
          LithuaniaThemes.agricultural,
          'T|030|T',
        ),
      ],
    ),
    GallerySection(
      title: 'Temporary and trade',
      note: 'Red characters and frame.',
      entries: <GalleryEntry>[
        _e('dealer', 'Dealer', LithuaniaPlates.dealer, LithuaniaThemes.dealer, 'P|03159'),
        _e(
          'temporary',
          'Temporary',
          LithuaniaPlates.temporary,
          LithuaniaThemes.temporary,
          '3463|CI',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Military and diplomatic plates. Try typing 41.',
      entries: <GalleryEntry>[
        _e(
          'military',
          'Armed Forces',
          LithuaniaPlates.military,
          LithuaniaThemes.military,
          'LK|006|D',
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          LithuaniaPlates.diplomatic,
          LithuaniaThemes.diplomatic,
          '37|3|001',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
