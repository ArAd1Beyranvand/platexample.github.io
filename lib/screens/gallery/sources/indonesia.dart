import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:indonesia_plate/indonesia_plate.dart';

import '../catalogue.dart';

/// `indonesia_plate`: three geometries from the 2023 series, with the usage
/// classes and the electric-vehicle band as themes on them.
class IndonesiaSource extends GallerySource {
  IndonesiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1945);

  @override
  String get countryName => 'Indonesia';

  @override
  String get packageName => 'indonesia_plate';

  @override
  String get note =>
      'The 2023 series: FE-Schrift car plates and DIN motorcycle plates in '
      'four usage colours, a blue expiry band for electric vehicles, and the '
      'CD diplomatic plate.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    String? area,
    String? note,
  }) => GalleryEntry(
    id: 'id.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: IndonesiaCountry.indonesia,
    validator: const IndonesiaValidator(),
    sampleValues: IndonesiaSerialGenerator.generate(
      spec,
      random: _rng,
      area: area,
    ),
    note: note,
  );

  GalleryEntry _diplomatic(String id, String label, PlateTheme theme) =>
      GalleryEntry(
        id: 'id.$id',
        label: label,
        spec: IndonesiaPlates.diplomatic(countryDigits: 2),
        theme: theme,
        country: IndonesiaCountry.indonesia,
        validator: const IndonesiaDiplomaticValidator(),
        sampleValues: const <String?>[
          'CD', '1', '9', '0', '0', '1', '0', '8', '2', '8', //
        ],
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars — 460 × 135',
      note:
          'Area code, a number up to 9999, up to three suffix letters, and the '
          'month and year of expiry. The colour is the vehicle\'s use. The '
          'serial reads about two thirds of the real height: the gallery\'s '
          'bold face is wider than FE-Schrift.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          IndonesiaPlates.car(prefix: 1),
          IndonesiaThemes.private,
          area: 'B',
        ),
        _entry(
          'public',
          'Public · black on yellow',
          IndonesiaPlates.car(),
          IndonesiaThemes.public,
        ),
        _entry(
          'government',
          'Government · white on red',
          IndonesiaPlates.car(),
          IndonesiaThemes.government,
        ),
        _entry(
          'ftz',
          'Free-trade zone · black on green',
          IndonesiaPlates.car(),
          IndonesiaThemes.freeTradeZone,
          area: 'BP',
        ),
        _entry(
          'ev',
          'Electric · private',
          IndonesiaPlates.car(prefix: 1, band: true),
          IndonesiaThemes.privateEv,
          area: 'B',
        ),
        _entry(
          'publicEv',
          'Electric · public',
          IndonesiaPlates.car(band: true),
          IndonesiaThemes.publicEv,
        ),
        _entry(
          'governmentEv',
          'Electric · government',
          IndonesiaPlates.car(band: true),
          IndonesiaThemes.governmentEv,
        ),
        _entry(
          'ftzEv',
          'Electric · free-trade zone',
          IndonesiaPlates.car(band: true),
          IndonesiaThemes.freeTradeZoneEv,
          area: 'BP',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycles — 275 × 115',
      note: 'The same registration in DIN, with the expiry set to the right.',
      entries: <GalleryEntry>[
        _entry(
          'motoPrivate',
          'Private',
          IndonesiaPlates.motorcycle(),
          IndonesiaThemes.private,
        ),
        _entry(
          'motoPublic',
          'Public',
          IndonesiaPlates.motorcycle(),
          IndonesiaThemes.public,
        ),
        _entry(
          'motoGovernment',
          'Government',
          IndonesiaPlates.motorcycle(),
          IndonesiaThemes.government,
        ),
        _entry(
          'motoFtz',
          'Free-trade zone',
          IndonesiaPlates.motorcycle(),
          IndonesiaThemes.freeTradeZone,
          area: 'BP',
        ),
        _entry(
          'motoEv',
          'Electric · private',
          IndonesiaPlates.motorcycle(band: true),
          IndonesiaThemes.privateEv,
        ),
        _entry(
          'motoGovernmentEv',
          'Electric · government',
          IndonesiaPlates.motorcycle(band: true),
          IndonesiaThemes.governmentEv,
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'CD (consular: CC), the mission\'s number — 19 is Norway — and the '
          'vehicle\'s, over a black trim; white on black over the blue band '
          'for an electric vehicle.',
      entries: <GalleryEntry>[
        _diplomatic('cd', 'Diplomatic corps', IndonesiaThemes.diplomatic),
        _diplomatic(
          'cdEv',
          'Diplomatic · electric',
          IndonesiaThemes.diplomaticEv,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
