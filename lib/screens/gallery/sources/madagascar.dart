import 'package:madagascar_plate/madagascar_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `madagascar_plate`: standard, legacy white, temporary, dealer, military and
/// diplomatic plates.
class MadagascarSource extends GallerySource {
  MadagascarSource();

  @override
  String get countryName => 'Madagascar';

  @override
  String get packageName => 'madagascar_plate';

  @override
  String get note =>
      'One row, white on black: four digits and two or three letters, the '
      'first the province. Not drawn: the red government plates (the article '
      'has no picture) and the dealer frame around the standard photograph.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'mg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MadagascarCountry.madagascar,
    validator: const MadagascarValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note:
          'The first letter of the series is the province: A Toamasina, '
          'D Antsiranana, F Fianarantsoa, M Mahajanga, T Antananarivo, '
          'U Toliara. Black on white was used until 2014.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Standard · white on black',
          MadagascarPlates.standard,
          MadagascarThemes.standard,
          <String?>['8847', 'TAK'],
        ),
        _e(
          'legacy',
          'Standard · black on white (until 2014)',
          MadagascarPlates.standard,
          MadagascarThemes.legacy,
          <String?>['0265', 'AF'],
        ),
        _e(
          'temporary',
          'Temporary · WW',
          MadagascarPlates.temporary,
          MadagascarThemes.temporary,
          <String?>['0554', 'WWT'],
        ),
        _e(
          'dealer',
          'Dealer · W',
          MadagascarPlates.dealer,
          MadagascarThemes.dealer,
          <String?>['474', 'T'],
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note:
          'Military plates carry the flag and Z (gendarmerie) or T (army); '
          'diplomatic plates a three-digit country code, CD, CMD, CMC or PE, '
          'then a serial.',
      entries: <GalleryEntry>[
        _e(
          'military',
          'Military · Z',
          MadagascarPlates.military,
          MadagascarThemes.military,
          <String?>['Z', '4878'],
        ),
        _e(
          'diplomatic',
          'Diplomatic · PE',
          MadagascarPlates.diplomatic,
          MadagascarThemes.diplomatic,
          <String?>['009', 'PE', '895'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
