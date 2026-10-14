import 'package:plate_core/plate_core.dart';
import 'package:india_plate/india_plate.dart';

import '../catalogue.dart';

/// `india_plate`: one layout, many formats, and the colour class as the theme
/// — so a transport and a rental plate are the same spec in two liveries.
class IndiaSource extends GallerySource {
  IndiaSource();

  @override
  String get countryName => 'India';

  @override
  String get packageName => 'india_plate';

  @override
  String get note =>
      'The HSRP plate: one row of characters, coloured by what the vehicle '
      'is for. Private plates carry the Ashoka Chakra hologram and IND.';

  /// One token per field, split on spaces.
  static List<String?> _values(String value) => value.split(' ');

  static GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String value, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: IndiaCountry.india,
    validator: const IndiaValidator(),
    sampleValues: _values(value),
    note: note,
  );

  /// Cached: the catalogue pairs highlights back to sections by identity.
  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Colour classes — 500 × 120',
      note:
          'State, RTO, series, number. The colour says who may drive it; '
          'only the private plate carries the badge.',
      entries: <GalleryEntry>[
        _entry(
          'in.private',
          'Private',
          IndiaPlates.private,
          IndiaThemes.private,
          'MH 20 DV 2366',
        ),
        _entry(
          'in.transport',
          'Commercial',
          IndiaPlates.standard,
          IndiaThemes.transport,
          'MH 12 DV 4353',
        ),
        _entry(
          'in.rental',
          'Rental',
          IndiaPlates.standard,
          IndiaThemes.rental,
          'MH 09 DV 5346',
        ),
        _entry(
          'in.electric',
          'Electric',
          IndiaPlates.standard,
          IndiaThemes.electric,
          'MH 04 DV 4321',
        ),
        _entry(
          'in.electric.transport',
          'Electric commercial',
          IndiaPlates.standard,
          IndiaThemes.electricTransport,
          'MH 04 DV 4321',
        ),
      ],
    ),
    GallerySection(
      title: 'Special series',
      note: 'Formats with printed letters of their own: BH, VA, TC, T and ↑.',
      entries: <GalleryEntry>[
        _entry(
          'in.bharat',
          'Bharat series',
          IndiaPlates.bharat,
          IndiaThemes.private,
          '21 2345 AA',
          note: 'Year, BH, number, series — valid in every state.',
        ),
        _entry(
          'in.vintage',
          'Vintage series',
          IndiaPlates.vintage,
          IndiaThemes.private,
          'MH AA 0001',
        ),
        _entry(
          'in.diplomatic',
          'Embassy',
          IndiaPlates.diplomatic,
          IndiaThemes.diplomatic,
          '52 CD 19',
        ),
        _entry(
          'in.consular',
          'Consulate',
          IndiaPlates.diplomatic,
          IndiaThemes.consular,
          '199 CC 0123',
        ),
        _entry(
          'in.military',
          'Armed forces',
          IndiaPlates.military,
          IndiaThemes.military,
          '02 B 084821 H',
        ),
        _entry(
          'in.military.police',
          'Military police',
          IndiaPlates.military,
          IndiaThemes.militaryPolice,
          '24 B 123456 Z',
        ),
        _entry(
          'in.temporary',
          'Temporary',
          IndiaPlates.temporary,
          IndiaThemes.temporary,
          '1123 KL 5986 KA',
        ),
        _entry(
          'in.trade',
          'Trade certificate',
          IndiaPlates.trade,
          IndiaThemes.trade,
          'UP 16 C 0002 0073',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
