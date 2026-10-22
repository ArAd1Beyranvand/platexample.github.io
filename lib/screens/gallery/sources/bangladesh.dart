import 'package:bangladesh_plate/bangladesh_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bangladesh_plate`: Bangladeshi car plates: city, class letter, a two-digit series and a four-digit number, in private, commercial and electric liveries.
class BangladeshSource extends GallerySource {
  BangladeshSource();

  @override
  String get countryName => 'Bangladesh';

  @override
  String get packageName => 'bangladesh_plate';

  @override
  String get note =>
      'Bangladeshi car plates: city, class letter, a two-digit series and a four-digit number, in private, commercial and electric liveries.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'bd.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: BangladeshCountry.bangladesh,
        validator: const BangladeshValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'Bangladeshi car plates: city, class letter, a two-digit series and a four-digit number, in private, commercial and electric liveries.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private',
          BangladeshPlates.private,
          BangladeshThemes.private,
          'DHAKA GA 11 9999',
        ),
        _entry(
          'commercial',
          'Commercial',
          BangladeshPlates.commercial,
          BangladeshThemes.commercial,
          'DHAKA PA 11 9999',
        ),
        _entry(
          'electric',
          'Electric',
          BangladeshPlates.electric,
          BangladeshThemes.electric,
          'DHAKA KA 11 9999',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
