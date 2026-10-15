import 'package:dominica_plate/dominica_plate.dart';

import '../catalogue.dart';

/// `dominica_plate`: the one plate the article shows, 300 × 93 — silver
/// digits on black.
class DominicaSource extends GallerySource {
  DominicaSource();

  @override
  String get countryName => 'Dominica';

  @override
  String get packageName => 'dominica_plate';

  @override
  String get note =>
      'Three digits, no frame or caption. The article also mentions a type '
      'letter and a yellow rear plate but shows neither, so they are not '
      'implemented. The article lists nothing Israel-specific, so nothing is '
      'refused.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '300 × 93',
      note: 'Silver digits on black.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'dm.regular',
          label: 'Regular · silver on black',
          spec: DominicaPlates.regular,
          theme: DominicaThemes.regular,
          country: DominicaCountry.dominica,
          validator: const DominicaValidator(),
          sampleValues: const <String?>['570'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
