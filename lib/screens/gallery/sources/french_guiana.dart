import 'package:guyana_plate/guyana_plate.dart';

import '../catalogue.dart';

/// `french_guiana_plate`: the French SIV plate with the département 973 and
/// the Guyane logo on the right band.
class FrenchGuianaSource extends GallerySource {
  FrenchGuianaSource();

  @override
  String get countryName => 'French Guiana';

  @override
  String get packageName => 'french_guiana_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters (no I, O, U or SS), black on '
      'white, with the département code 973 on the right. The article '
      'pictures only a close-up of the regional block, so the layout is '
      "France's and the Guyane logo is a simplified drawing, not a trace. "
      'Not drawn: older plates.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 520 × 110',
      note: 'Ink is about 74% of the reference height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'gf.private',
          label: 'Private car',
          spec: FrenchGuianaPlates.private,
          theme: FrenchGuianaThemes.private,
          country: FrenchGuianaCountry.french_guiana,
          validator: const FrenchGuianaValidator(),
          sampleValues: const <String?>['AB', '123', 'CD', '973'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
