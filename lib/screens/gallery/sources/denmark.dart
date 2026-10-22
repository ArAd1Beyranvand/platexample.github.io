import 'package:denmark_plate/denmark_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `denmark_plate`: private, parrot, commercial, diplomatic, temporary,
/// vanity, Greenland and Faroese plates. One token per field.
class DenmarkSource extends GallerySource {
  DenmarkSource();

  @override
  String get countryName => 'Denmark';

  @override
  List<String> get countryNames => <String>['Denmark', 'Faroe Islands'];

  @override
  String get packageName => 'denmark_plate';

  @override
  String get note =>
      'Two letters and five digits in three fields, black on white in a red '
      'frame, with or without the EU stripe and its hologram. Parrot plates '
      'print the letters on yellow, commercial plates are yellow throughout, '
      'diplomatic plates white on blue. Greenland and the Faroe Islands '
      'have plates of their own.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateCountry country = DenmarkCountry.denmark,
    PlateValidator validator = const DenmarkValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: country,
    validator: validator,
    sampleValues: values.split(' '),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and commercial — 520 × 110',
      note: 'The EU stripe is optional and chosen at issuance.',
      entries: <GalleryEntry>[
        _e(
          'dk.privateEu',
          'Private, EU stripe',
          DenmarkPlates.privateEu,
          DenmarkThemes.private,
          'AB 12 345',
        ),
        _e('dk.private', 'Private', DenmarkPlates.private, DenmarkThemes.private, 'AB 12 345'),
        _e(
          'dk.parrotEu',
          'Parrot, EU stripe',
          DenmarkPlates.parrotEu,
          DenmarkThemes.parrot,
          'AB 12 345',
        ),
        _e('dk.parrot', 'Parrot', DenmarkPlates.parrot, DenmarkThemes.parrot, 'AB 12 345'),
        _e(
          'dk.commercial',
          'Commercial',
          DenmarkPlates.commercial,
          DenmarkThemes.commercial,
          'AB 12 345',
        ),
        _e(
          'dk.vanityEu',
          'Vanity, EU stripe',
          DenmarkPlates.vanityEu,
          DenmarkThemes.private,
          'FNUGGI',
          validator: const DenmarkVanityValidator(),
        ),
        _e(
          'dk.vanity',
          'Vanity',
          DenmarkPlates.vanity,
          DenmarkThemes.private,
          'ØZDEMIR',
          validator: const DenmarkVanityValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Official and temporary',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'dk.diplomatic',
          'Diplomatic',
          DenmarkPlates.diplomatic,
          DenmarkThemes.diplomatic,
          'DD 76 312',
        ),
        _e(
          'dk.fixedTemporary',
          'Fixed temporary',
          DenmarkPlates.fixedTemporary,
          DenmarkThemes.fixedTemporary,
          'DD 12',
          validator: const DenmarkValidator.fixedTemporary(),
        ),
        _e(
          'dk.exportTemporary',
          'Temporary export',
          DenmarkPlates.exportTemporary,
          DenmarkThemes.private,
          '17 14 880',
          validator: const DenmarkValidator.exportTemporary(),
        ),
      ],
    ),
    GallerySection(
      title: 'Greenland and the Faroe Islands',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'dk.greenland',
          'Greenland',
          DenmarkPlates.greenland,
          DenmarkThemes.greenland,
          'GR 35 383',
          validator: const DenmarkValidator.greenland(),
        ),
        _e(
          'dk.faroeIslands',
          'Faroe Islands',
          DenmarkPlates.faroeIslands,
          DenmarkThemes.faroeIslands,
          'BG 339',
          country: DenmarkCountry.faroeIslands,
          validator: const DenmarkValidator.faroeIslands(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
