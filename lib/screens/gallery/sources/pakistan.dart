import 'dart:math';

import 'package:pakistan_plate/pakistan_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `pakistan_plate`: one design per province; white plates share a theme.
class PakistanSource extends GallerySource {
  PakistanSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1947);

  @override
  String get countryName => 'Pakistan';

  @override
  String get packageName => 'pakistan_plate';

  @override
  String get note =>
      'Latin letters (no I, O or U) and digits. Each province has its own '
      'design; black on white, except Sindh in yellow.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'pk.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: PakistanCountry.pakistan,
        validator: const PakistanValidator(),
        sampleValues: PakistanSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Provincial plates',
      note:
          'The provinces\' arms, Islamabad\'s mosque and Punjab\'s flower are '
          'not all drawn. The digits are about 60% of the real height: the '
          'plate face is condensed.',
      entries: <GalleryEntry>[
        _entry('balochistan', 'Balochistan', PakistanPlates.balochistan, PakistanThemes.white),
        _entry(
          'khyberPakhtunkhwa',
          'Khyber Pakhtunkhwa',
          PakistanPlates.khyberPakhtunkhwa,
          PakistanThemes.white,
        ),
        _entry(
          'azadJammuKashmir',
          'Azad Jammu & Kashmir',
          PakistanPlates.azadJammuKashmir,
          PakistanThemes.white,
          note: 'The chinar leaf strip is not drawn.',
        ),
        _entry(
          'islamabad',
          'Islamabad Capital Territory',
          PakistanPlates.islamabad,
          PakistanThemes.white,
        ),
        _entry(
          'punjab',
          'Punjab',
          PakistanPlates.punjab,
          PakistanThemes.white,
          note: 'Pre-2020 form: four digits and the year.',
        ),
        _entry('sindh', 'Sindh', PakistanPlates.sindh, PakistanThemes.sindh),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
