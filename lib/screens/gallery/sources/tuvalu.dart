import 'package:tuvalu_plate/tuvalu_plate.dart';

import '../catalogue.dart';

/// `tuvalu_plate`: white on black, `AB 1234`.
class TuvaluSource extends GallerySource {
  TuvaluSource();

  @override
  String get countryName => 'Tuvalu';

  @override
  String get packageName => 'tuvalu_plate';

  @override
  String get note =>
      'Two letters and four digits, white on black, in a framed row on the '
      'Australian-standard 372 × 134 mm plate. The article shows one design '
      'only. It lists nothing Israel-specific, so nothing is refused.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One design.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'tv.standard',
          label: 'Standard · white on black',
          spec: TuvaluPlates.standard,
          theme: TuvaluThemes.standard,
          country: TuvaluCountry.tuvalu,
          validator: const TuvaluValidator(),
          sampleValues: const <String>['AO', '1792'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
