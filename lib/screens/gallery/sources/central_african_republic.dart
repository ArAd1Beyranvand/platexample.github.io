import 'package:central_african_republic_plate/central_african_republic_plate.dart';
import '../catalogue.dart';

/// `central_african_republic_plate`: the private plate, two letters, three
/// digits and two letters, with RCA on the right.
class CentralAfricanRepublicSource extends GallerySource {
  CentralAfricanRepublicSource();

  @override
  String get countryName => 'Central African Republic';

  @override
  String get packageName => 'central_african_republic_plate';

  @override
  String get note =>
      'Two letters, three digits and a two-letter area code, black on white '
      'with RCA on the right. Not drawn: the government, diplomatic and '
      'motorcycle series.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Series letters, digits and the area code.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'cf.private',
          label: 'Private car',
          spec: CentralAfricanRepublicPlates.private,
          theme: CentralAfricanRepublicThemes.private,
          country:
              CentralAfricanRepublicCountry.centralAfricanRepublic,
          validator: const CentralAfricanRepublicValidator(),
          sampleValues: 'AB 123 CD'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
