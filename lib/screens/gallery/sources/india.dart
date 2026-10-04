import 'package:plate_core/core_plate.dart';
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

  /// A space is an empty cell: diplomatic numbers are written without
  /// leading zeros, so a short one leaves its cells blank.
  static List<String?> _values(String value) => <String?>[
    for (final c in value.split('')) c == ' ' ? null : c,
  ];

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
          'MH20DV2366',
        ),
        _entry(
          'in.transport',
          'Commercial',
          IndiaPlates.standard,
          IndiaThemes.transport,
          'MH12DV4353',
        ),
        _entry(
          'in.rental',
          'Rental',
          IndiaPlates.standard,
          IndiaThemes.rental,
          'MH09DV5346',
        ),
        _entry(
          'in.electric',
          'Electric',
          IndiaPlates.standard,
          IndiaThemes.electric,
          'MH04DV4321',
        ),
        _entry(
          'in.electric.transport',
          'Electric commercial',
          IndiaPlates.standard,
          IndiaThemes.electricTransport,
          'MH04DV4321',
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
          '212345AA',
          note: 'Year, BH, number, series — valid in every state.',
        ),
        _entry(
          'in.vintage',
          'Vintage series',
          IndiaPlates.vintage,
          IndiaThemes.private,
          'MHAA0001',
        ),
        _entry(
          'in.diplomatic',
          'Embassy',
          IndiaPlates.diplomatic,
          IndiaThemes.diplomatic,
          ' 52CD  19',
        ),
        _entry(
          'in.consular',
          'Consulate',
          IndiaPlates.diplomatic,
          IndiaThemes.consular,
          '199CC0123',
        ),
        _entry(
          'in.military',
          'Armed forces',
          IndiaPlates.military,
          IndiaThemes.military,
          '02B084821H',
        ),
        _entry(
          'in.military.police',
          'Military police',
          IndiaPlates.military,
          IndiaThemes.militaryPolice,
          '24B123456Z',
        ),
        _entry(
          'in.temporary',
          'Temporary',
          IndiaPlates.temporary,
          IndiaThemes.temporary,
          '1123KL5986KA',
        ),
        _entry(
          'in.trade',
          'Trade certificate',
          IndiaPlates.trade,
          IndiaThemes.trade,
          'UP16C00020073',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
