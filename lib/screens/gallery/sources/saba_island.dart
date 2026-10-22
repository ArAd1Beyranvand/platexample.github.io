import 'package:plate_core/plate_core.dart';
import 'package:caribbean_plate/caribbean_plate.dart';

import '../catalogue.dart';

/// `saba_island_plate`: Saba's 2011 green plate and 1978 cream plate
/// (520 × 256).
class SabaIslandSource extends GallerySource {
  SabaIslandSource();

  @override
  String get countryName => 'Saba (island)';

  @override
  String get packageName => 'saba_island_plate';

  @override
  String get note =>
      'A prefix letter and three or four digits. The island silhouette and '
      'flag disc of the 2011 plate are not drawn; the Bonaire and St. '
      'Eustatius plates live in bonaire_plate. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateValidator validator,
    List<String?> values,
  ) => GalleryEntry(
    id: 'sab.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SabaIslandCountry.saba_island,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Saba',
      note: 'The island letter and the digits.',
      entries: <GalleryEntry>[
        _entry(
          'current',
          'Current · 2011',
          SabaIslandPlates.current,
          SabaIslandThemes.current,
          const SabaIslandValidator(),
          <String?>['S', '240'],
        ),
        _entry(
          'classic1978',
          'Historic · 1978',
          SabaIslandPlates.classic1978,
          SabaIslandThemes.classic1978,
          const SabaIslandValidator.classic1978(),
          <String?>['S', '163'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
