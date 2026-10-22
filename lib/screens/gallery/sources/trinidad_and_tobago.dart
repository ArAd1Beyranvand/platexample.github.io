import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:trinidad_and_tobago_plate/trinidad_and_tobago_plate.dart';

import '../catalogue.dart';

/// `trinidad_and_tobago_plate`: the three designs the photographs show.
class TrinidadAndTobagoSource extends GallerySource {
  TrinidadAndTobagoSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1962);

  @override
  String get countryName => 'Trinidad and Tobago';

  @override
  String get packageName => 'trinidad_and_tobago_plate';

  @override
  String get note =>
      'One to three series letters (the first is the vehicle class) and one '
      'to four digits. The law allows white on black or black on white. '
      'Rental, hired, dealer, visitor, plant and military plates have no '
      'photograph and are not drawn.';

  /// Entries the country's shared validator does not cover.
  static const Set<String> _unvalidated = <String>{'tt.square'};

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: TrinidadAndTobagoCountry.trinidad_and_tobago,
    validator: _unvalidated.contains(id) ? null : const TrinidadAndTobagoValidator(),
    sampleValues: TrinidadAndTobagoSerialGenerator.generate(spec, random: _rng),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Rectangular',
      note:
          'Ink is about 70% of the real height: a glyph box cannot leave the '
          'canvas, and ink is roughly 0.55 of it.',
      entries: <GalleryEntry>[
        _entry(
          'tt.private',
          'Private · white on black',
          TrinidadAndTobagoPlates.private,
          TrinidadAndTobagoThemes.private,
        ),
        _entry(
          'tt.commercial',
          'Commercial · silver on black',
          TrinidadAndTobagoPlates.commercial,
          TrinidadAndTobagoThemes.commercial,
        ),
      ],
    ),
    GallerySection(
      title: 'Square',
      note: '',
      entries: <GalleryEntry>[
        _entry(
          'tt.square',
          'Square · black on white',
          TrinidadAndTobagoPlates.square,
          TrinidadAndTobagoThemes.square,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
