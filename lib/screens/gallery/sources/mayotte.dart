import 'package:comoros_plate/comoros_plate.dart';

import '../catalogue.dart';

/// `mayotte_plate`: the French SIV plate with the département 976 and the
/// Mayotte logo on the right band.
class MayotteSource extends GallerySource {
  MayotteSource();

  @override
  String get countryName => 'Mayotte';

  @override
  String get packageName => 'mayotte_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters (no I, O, U or SS), black on '
      'white, with the département code 976 on the right. The Wikipedia '
      "article has no pictures, so the layout is France's and the Mayotte "
      'logo is a simplified drawing, not a trace. Not drawn: the 1976–1989 '
      'AMTE plates and the 1990 black, white and yellow series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 520 × 110',
      note: 'Ink is about 74% of the reference height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'yt.private',
          label: 'Private car',
          spec: MayottePlates.private,
          theme: MayotteThemes.private,
          country: MayotteCountry.mayotte,
          validator: const MayotteValidator(),
          sampleValues: const <String?>['CE', '683', 'HR', '976'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
