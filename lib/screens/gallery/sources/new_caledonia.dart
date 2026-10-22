import 'package:kanak_plate/kanak_plate.dart';

import '../catalogue.dart';

/// `new_caledonia_plate`: the six-digit serial followed by the printed `NC`.
class NewCaledoniaSource extends GallerySource {
  NewCaledoniaSource();

  @override
  String get countryName => 'New Caledonia';

  @override
  String get packageName => 'new_caledonia_plate';

  @override
  String get note =>
      'Six digits and the printed NC, black on white, on French dies. The '
      'infobox says white on black but the current photo is black on white, so '
      'the picture wins. Not drawn: the 1987 white-on-black series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 520 × 110',
      note: 'Ink is about 73% of the reference height.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'nc.private',
          label: 'Private car',
          spec: NewCaledoniaPlates.private,
          theme: NewCaledoniaThemes.private,
          country: NewCaledoniaCountry.new_caledonia,
          validator: const NewCaledoniaValidator(),
          sampleValues: const <String?>['312449'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
