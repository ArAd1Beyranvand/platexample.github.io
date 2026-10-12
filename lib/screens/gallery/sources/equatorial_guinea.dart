import 'package:equatorial_guinea_plate/equatorial_guinea_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `equatorial_guinea_plate`: the regular `AB-123-C` plate with the CEMAC
/// emblem.
class EquatorialGuineaSource extends GallerySource {
  EquatorialGuineaSource();

  @override
  String get countryName => 'Equatorial Guinea';

  @override
  String get packageName => 'equatorial_guinea_plate';

  @override
  String get note =>
      'A province code, three digits and a series letter, black on white, '
      'with the CEMAC emblem and GE at the left and a sticker at the right. '
      'Not drawn: the older plates without the emblem.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'The one current plate, for every vehicle.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'gq.regular',
          label: 'Regular · black on white',
          spec: EquatorialGuineaPlates.regular,
          theme: EquatorialGuineaThemes.regular,
          country: EquatorialGuineaCountry.equatorial_guinea,
          validator: const EquatorialGuineaValidator(),
          sampleValues: 'L T 5 5 7 G'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
