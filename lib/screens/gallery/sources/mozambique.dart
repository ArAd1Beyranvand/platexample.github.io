import 'package:mozambique_plate/mozambique_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `mozambique_plate`: the modern plate's three-band field with the province
/// letters at the end, and the two older black-on-white formats.
class MozambiqueSource extends GallerySource {
  MozambiqueSource();

  @override
  String get countryName => 'Mozambique';

  @override
  String get packageName => 'mozambique_plate';

  @override
  String get note =>
      'The modern plate: three letters, three digits and the two province '
      'letters, over a field that fades from green through white to the foot '
      'band. The legacy plates are black on white, on two rows or one. Not '
      'drawn: the emblem\'s detail and the diplomatic and government series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const MozambiqueValidator(),
  }) => GalleryEntry(
    id: 'mz.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MozambiqueCountry.mozambique,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Modern',
      note: 'Letters, digits, then the province code.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car',
          MozambiquePlates.private,
          MozambiqueThemes.private,
          'AAB 123 MP',
        ),
      ],
    ),
    GallerySection(
      title: 'Legacy',
      note: 'Three letters and four digits, black on white.',
      entries: <GalleryEntry>[
        _e(
          'legacy',
          'Legacy · two rows',
          MozambiquePlates.legacy,
          MozambiqueThemes.legacy,
          'MBA 12 34',
          validator: const MozambiqueLegacyValidator(),
        ),
        _e(
          'legacy_one_row',
          'Legacy · one row',
          MozambiquePlates.legacyOneRow,
          MozambiqueThemes.legacyOneRow,
          'MCD 56 78',
          validator: const MozambiqueLegacyValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
