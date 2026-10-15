import 'package:mauritius_plate/mauritius_plate.dart';

import '../catalogue.dart';

/// `mauritius_plate`: the silver-on-black government plate.
class MauritiusSource extends GallerySource {
  MauritiusSource();

  @override
  String get countryName => 'Mauritius';

  @override
  String get packageName => 'mauritius_plate';

  @override
  String get note =>
      'Two letters and four digits in raised silver on black, with a MAURITIUS badge at the top. Only the government plate had a reference; no other category is drawn.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Government',
      note: 'Raised silver characters on a black field.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'mu.government',
          label: 'Government',
          spec: MauritiusPlates.government,
          theme: MauritiusThemes.government,
          country: MauritiusCountry.mauritius,
          validator: const MauritiusValidator(),
          sampleValues: <String?>['GM', '3345'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
