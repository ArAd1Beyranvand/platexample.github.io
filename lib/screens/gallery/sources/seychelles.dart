import 'package:seychelles_plate/seychelles_plate.dart';

import '../catalogue.dart';

/// `seychelles_plate`: the white-on-black plates before and since 2018.
class SeychellesSource extends GallerySource {
  SeychellesSource();

  @override
  String get countryName => 'Seychelles';

  @override
  String get packageName => 'seychelles_plate';

  @override
  String get note =>
      'A series letter and up to five digits in white on black. Since 2018 a yellow tag at the right carries two letters and four digits. Not drawn: any other category.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Until 2018 and since 2018.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'sc.standard',
          label: 'Until 2018',
          spec: SeychellesPlates.standard,
          theme: SeychellesThemes.standard,
          country: SeychellesCountry.seychelles,
          validator: const SeychellesValidator(),
          sampleValues: <String?>['S', '11111'],
        ),
        GalleryEntry(
          id: 'sc.high_visibility',
          label: 'Since 2018',
          spec: SeychellesPlates.highVisibility,
          theme: SeychellesThemes.standard,
          country: SeychellesCountry.seychelles,
          validator: const SeychellesValidator(),
          sampleValues: <String?>['S', '11111', 'HV', '1111'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
