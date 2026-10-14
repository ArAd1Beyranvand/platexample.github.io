import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:tunisia_plate/tunisia_plate.dart';

import '../catalogue.dart';

/// `tunisia_plate`: the 520 × 110 series plate and its square rear, the
/// government, military, diplomatic and temporary plates.
class TunisiaSource extends GallerySource {
  TunisiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1956);

  @override
  String get countryName => 'Tunisia';

  @override
  String get packageName => 'tunisia_plate';

  @override
  String get note =>
      'A series number and a registration either side of تونس, in white on '
      'black; blue for rental cars, red on white for the state, and the '
      'flag on military plates.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    PlateValidator validator = const TunisiaValidator(),
    List<String?>? values,
    String? note,
  }) => GalleryEntry(
    id: 'tn.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TunisiaCountry.tunisia,
    validator: validator,
    sampleValues: values ?? TunisiaSerialGenerator.generate(spec, random: _rng),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and rental — 520 × 110',
      note:
          'Series on the left, registration on the right. The square rear '
          'stacks the registration over the series. The serial reads about three quarters of the real height.',
      entries: <GalleryEntry>[
        _entry(
          'standard',
          'Private · white on black',
          TunisiaPlates.standard,
          TunisiaThemes.standard,
        ),
        _entry(
          'standard2',
          'Private · two-digit series',
          TunisiaPlates.standard,
          TunisiaThemes.standard,
          values: <String?>['73', '3294'],
        ),
        _entry(
          'rental',
          'Rental · white on blue',
          TunisiaPlates.standard,
          TunisiaThemes.rental,
        ),
        _entry(
          'square',
          'Square rear · 275 × 200',
          TunisiaPlates.square,
          TunisiaThemes.standard,
        ),
      ],
    ),
    GallerySection(
      title: 'State',
      note:
          'Red on white with a dash for ministries; white on black behind the flag for the army.',
      entries: <GalleryEntry>[
        _entry(
          'government',
          'Government · ministry and number',
          TunisiaPlates.government,
          TunisiaThemes.government,
          validator: const TunisiaGovernmentValidator(),
        ),
        _entry(
          'military',
          'Military · the flag and five digits',
          TunisiaPlates.military,
          TunisiaThemes.military,
          validator: const TunisiaSerialValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'The country\'s number, the status in Latin and Arabic, and the '
          'vehicle\'s; the head of mission is always 01.',
      entries: <GalleryEntry>[
        for (final TunisiaMission m in TunisiaMission.values)
          _entry(
            'diplomatic.${m.id}',
            '${m.latin} · ${m.arabic}',
            TunisiaPlates.diplomatic(m),
            TunisiaThemes.diplomatic,
            validator: TunisiaDiplomaticValidator(
              chief: m == TunisiaMission.chief,
            ),
            values: <String?>[
              '46',
              if (m == TunisiaMission.chief) '01' else '02',
            ],
          ),
      ],
    ),
    GallerySection(
      title: 'Temporary',
      note: 'Suspended registration: five digits and ن ت.',
      entries: <GalleryEntry>[
        _entry(
          'temporary',
          'Suspended · ن ت',
          TunisiaPlates.temporary(),
          TunisiaThemes.standard,
          validator: const TunisiaSerialValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
