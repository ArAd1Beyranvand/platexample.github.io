import 'dart:math';

import 'package:russia_plate/russia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `abkhazia_plate`: the standard plate and the diplomatic plate.
class AbkhaziaSource extends GallerySource {
  AbkhaziaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1992);

  @override
  String get countryName => 'Abkhazia';

  @override
  String get packageName => 'abkhazia_plate';

  @override
  String get note =>
      'A letter, three digits and two letters, then ABH and the flag. Only '
      'thirteen Cyrillic capitals that look Latin are used, as in Russia, '
      'but without a region code.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'ab.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: AbkhaziaCountry.abkhazia,
        validator: const AbkhaziaValidator(),
        sampleValues: AbkhaziaSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'Black on white with the flag, and the diplomatic plate in silver '
          'on dark red.',
      entries: <GalleryEntry>[
        _entry('private', 'Private · А377АБ', AbkhaziaPlates.private, AbkhaziaThemes.private),
        _entry(
          'diplomatic',
          'Diplomatic · 002 CD 1',
          AbkhaziaPlates.diplomatic,
          AbkhaziaThemes.diplomatic,
          note: 'Status letters and number length are assumed from Russia.',
        ),
      ],
    ),
  ];
  List<GallerySection>? _sections;
}
