import 'package:gabon_plate/gabon_plate.dart';

import '../catalogue.dart';

/// `gabon_plate`: the regular plate, `AB-123-CD`.
class GabonSource extends GallerySource {
  GabonSource();

  @override
  String get countryName => 'Gabon';

  @override
  String get packageName => 'gabon_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters, black on yellow, with the '
      'CEMAC emblem, the national map and RG. Not drawn: the pre-2013 plate '
      'and the taxi, military and diplomatic series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'The regular plate introduced in 2013.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ga.private',
          label: 'Regular · black on yellow',
          spec: GabonPlates.private,
          theme: GabonThemes.private,
          country: GabonCountry.gabon,
          validator: const GabonValidator(),
          sampleValues: 'CC 444 AA'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
