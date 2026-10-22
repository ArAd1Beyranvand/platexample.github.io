import 'package:somalia_plate/somalia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `somaliland_plate`: Somaliland's plates, one entry per category.
class SomalilandSource extends GallerySource {
  SomalilandSource();

  @override
  String get countryName => 'Somaliland';

  @override
  String get packageName => 'somaliland_plate';

  @override
  String get note => "Somaliland's plates as drawn by somaliland_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const SomalilandValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SomalilandCountry.somaliland,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('sl.private', 'Private', SomalilandPlates.private, SomalilandThemes.private, <String?>[
          'A1234',
          'AW',
        ]),
        _e(
          'sl.government',
          'Government',
          SomalilandPlates.government,
          SomalilandThemes.government,
          <String?>['B1234'],
        ),
        _e('sl.ngo', 'Ngo', SomalilandPlates.ngo, SomalilandThemes.ngo, <String?>['C1234']),
        _e('sl.un', 'Un', SomalilandPlates.un, SomalilandThemes.un, <String?>['D1234']),
        _e(
          'sl.diplomatic',
          'Diplomatic',
          SomalilandPlates.diplomatic,
          SomalilandThemes.diplomatic,
          <String?>['E1234'],
        ),
        _e('sl.bilingual', 'Bilingual', SomalilandPlates.bilingual, SomalilandThemes.ngo, <String?>[
          'B',
          '366',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
