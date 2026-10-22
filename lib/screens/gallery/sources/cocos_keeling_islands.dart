import 'package:indian_ocean_plate/indian_ocean_plate.dart';

import '../catalogue.dart';

/// `cocos_keeling_islands_plate`: blue on pale grey, `C · 400`.
class CocosKeelingIslandsSource extends GallerySource {
  CocosKeelingIslandsSource();

  @override
  String get countryName => 'Cocos (Keeling) Islands';

  @override
  String get packageName => 'cocos_keeling_islands_plate';

  @override
  String get note =>
      'One letter, a diamond and three digits, blue on pale grey, with the '
      'territory name under the number, on the Australian-standard '
      '372 × 134 mm plate. The article shows one design only. It lists '
      'nothing Israel-specific, so nothing is refused.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One design.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'cc.general',
          label: 'General issue · blue on grey',
          spec: CocosKeelingIslandsPlates.general,
          theme: CocosKeelingIslandsThemes.general,
          country: CocosKeelingIslandsCountry.cocos_keeling_islands,
          validator: const CocosKeelingIslandsValidator(),
          sampleValues: const <String>['C', '400'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
