import 'package:saint_kitts_and_nevis_plate/saint_kitts_and_nevis_plate.dart';

import '../catalogue.dart';

/// `saint_kitts_and_nevis_plate`: the `P` prefix and up to four digits.
class SaintKittsAndNevisSource extends GallerySource {
  SaintKittsAndNevisSource();

  @override
  String get countryName => 'Saint Kitts and Nevis';

  @override
  String get packageName => 'saint_kitts_and_nevis_plate';

  @override
  String get note =>
      'A `P` prefix (`P(A)` since 1997) and up to four digits, cream on '
      'black. Only the regular plate is documented with a reference photo.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The regular legal plate, with the small island caption on top.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'kn.private',
          label: 'Regular',
          spec: SaintKittsAndNevisPlates.private,
          theme: SaintKittsAndNevisThemes.private,
          country: SaintKittsAndNevisCountry.saint_kitts_and_nevis,
          validator: const SaintKittsAndNevisValidator(),
          sampleValues: 'P 884'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
