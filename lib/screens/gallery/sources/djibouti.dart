import 'dart:math';

import 'package:djibouti_plate/djibouti_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `djibouti_plate`: the one plate the article documents, in both liveries.
class DjiboutiSource extends GallerySource {
  DjiboutiSource();

  final Random _rng = Random(1977);

  @override
  String get countryName => 'Djibouti';

  @override
  String get packageName => 'djibouti_plate';

  @override
  String get note =>
      'Three digits, the letter D and two digits in Latin, divided from the '
      'same value mirrored in Arabic. The serial reads about three quarters '
      'of the real height.';

  GalleryEntry _entry(String id, String label, PlateTheme theme, String note) =>
      GalleryEntry(
        id: 'dj.$id',
        label: label,
        spec: DjiboutiPlates.standard,
        theme: theme,
        country: DjiboutiCountry.djibouti,
        validator: const DjiboutiValidator(),
        sampleValues: DjiboutiSerialGenerator.generate(
          DjiboutiPlates.standard,
          random: _rng,
        ),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard — 520 × 110',
      note:
          'The article\'s lead gives black on white since 2023; its infobox '
          'and the only artwork show light grey on black.',
      entries: <GalleryEntry>[
        _entry(
          'current',
          'Standard · black on white',
          DjiboutiThemes.current,
          'Colours from the article\'s text; no image of this plate.',
        ),
        _entry(
          'legacy',
          'Standard · grey on black',
          DjiboutiThemes.legacy,
          'Colours sampled from the 1990s artwork.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
