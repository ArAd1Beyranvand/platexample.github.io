import 'package:guatemala_plate/guatemala_plate.dart';

import '../catalogue.dart';

/// `guatemala_plate`: the 2021 plate, a class letter, three digits and three
/// letters under a blue header.
class GuatemalaSource extends GallerySource {
  GuatemalaSource();

  @override
  String get countryName => 'Guatemala';

  @override
  String get packageName => 'guatemala_plate';

  @override
  String get note =>
      'One format for every type: a class letter (P private, C commercial), '
      'three digits and three letters. Not drawn: the coat of arms and '
      'sticker, and the retired 1988 series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current plate',
      note: 'Black on white, introduced in 2021.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'gt.private',
          label: 'Private car',
          spec: GuatemalaPlates.private,
          theme: GuatemalaThemes.private,
          country: GuatemalaCountry.guatemala,
          validator: const GuatemalaValidator(),
          sampleValues: const <String?>['P', '123', 'ABC'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
