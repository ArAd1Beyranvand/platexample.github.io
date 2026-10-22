import 'package:suriname_plate/suriname_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `suriname_plate`: Suriname's plates, one entry per category.
class SurinameSource extends GallerySource {
  SurinameSource();

  @override
  String get countryName => 'Suriname';

  @override
  String get packageName => 'suriname_plate';

  @override
  String get note => "Suriname's plates as drawn by suriname_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const SurinameValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: SurinameCountry.suriname,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('sr.private', 'Private', SurinamePlates.private, SurinameThemes.private, <String?>[
          'PA',
          '1234',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
