import 'package:latvia_plate/latvia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `latvia_plate`: each field is one slot, in five liveries.
class LatviaSource extends GallerySource {
  LatviaSource();

  @override
  String get countryName => 'Latvia';

  @override
  String get packageName => 'latvia_plate';

  @override
  String get note =>
      'Two letters, a hyphen and one to four digits, black on white beside '
      'the EU panel. Taxis are black on yellow (TX, TQ), electric cars blue '
      'on white (EX), diplomatic plates black on red (CD) with no panel, and '
      'motorcycles stack the letters over the digits. Not drawn: the '
      'president\'s, square, small and trailer plates and the pre-2004 '
      'plates with the flag.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'lv.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: LatviaCountry.latvia,
    validator: const LatviaValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'Two letters and one to four digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', LatviaPlates.private, LatviaThemes.private, 'FM|4763'),
        _e('taxi', 'Taxi', LatviaPlates.taxi, LatviaThemes.taxi, 'TX|1234'),
        _e('electric', 'Electric', LatviaPlates.electric, LatviaThemes.electric, 'EX|1234'),
        _e(
          'diplomatic',
          'Diplomatic corps',
          LatviaPlates.diplomatic,
          LatviaThemes.diplomatic,
          'CD|1234',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycle',
      note: 'Letters over digits.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', LatviaPlates.motorcycle, LatviaThemes.motorcycle, 'TC|7924'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
