import 'package:china_plate/china_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `hong_kong_plate`: Front and rear private plates, the personalised scheme and the cross-border Guangdong plate.
class HongKongSource extends GallerySource {
  HongKongSource();

  @override
  String get countryName => 'Hong Kong';

  @override
  String get packageName => 'hong_kong_plate';

  @override
  String get note =>
      'Front and rear private plates, the personalised scheme and the cross-border Guangdong plate.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'hk.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: HongKongCountry.hong_kong,
        validator: const HongKongValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'Front and rear private plates, the personalised scheme and the cross-border Guangdong plate.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · front',
          HongKongPlates.private,
          HongKongThemes.private,
          'NS 1234',
        ),
        _entry(
          'privaterear',
          'Private · rear',
          HongKongPlates.private,
          HongKongThemes.rear,
          'NS 1234',
        ),
        _entry('rear', 'Rear · two-line', HongKongPlates.rear, HongKongThemes.rear, 'KX 9038'),
        _entry(
          'personalised',
          'Personalised',
          HongKongPlates.personalised,
          HongKongThemes.private,
          'SIUSIU',
        ),
        _entry(
          'crossborder',
          'Cross-border',
          HongKongPlates.crossBorder,
          HongKongThemes.crossBorder,
          'A123',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
