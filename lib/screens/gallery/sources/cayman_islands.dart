import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cayman_islands_plate`: three geometries, five liveries.
class CaymanIslandsSource extends GallerySource {
  CaymanIslandsSource();

  @override
  String get countryName => 'Cayman Islands';

  @override
  String get packageName => 'cayman_islands_plate';

  @override
  String get note =>
      'Digits only, with "CAYMAN ISLANDS" beneath. The colour of the plate '
      'names the class. The digits are shorter than the real ones: the '
      'plate face is condensed, and the engine\'s glyph is wider.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> sampleValues, {
    PlateValidator validator = const CaymanIslandsValidator(),
  }) => GalleryEntry(
    id: 'ky.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: CaymanIslandsCountry.cayman_islands,
    validator: validator,
    sampleValues: sampleValues,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'Two groups of three digits; the five-digit private plate is a '
          'single group. Taxis add a TAXI mark and a blue caption.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on yellow',
          CaymanIslandsPlates.pair,
          CaymanIslandsThemes.private,
          <String?>['123', '456'],
        ),
        _entry(
          'privateFive',
          'Private · five digits',
          CaymanIslandsPlates.single,
          CaymanIslandsThemes.private,
          <String?>['13578'],
          validator: const CaymanIslandsSingleValidator(),
        ),
        _entry(
          'disabled',
          'Disabled drivers · red on yellow',
          CaymanIslandsPlates.pair,
          CaymanIslandsThemes.disabled,
          <String?>['123', '456'],
        ),
        _entry(
          'heavy',
          'Heavy goods · black on orange',
          CaymanIslandsPlates.pair,
          CaymanIslandsThemes.heavy,
          <String?>['131', '996'],
        ),
        _entry(
          'hire',
          'Hire cars · black on white',
          CaymanIslandsPlates.pair,
          CaymanIslandsThemes.hire,
          <String?>['108', '165'],
        ),
        _entry(
          'taxi',
          'Taxi · red on white',
          CaymanIslandsPlates.taxi,
          CaymanIslandsThemes.taxi,
          <String?>['174', '159'],
        ),
      ],
    ),
  ];
  List<GallerySection>? _sections;
}
