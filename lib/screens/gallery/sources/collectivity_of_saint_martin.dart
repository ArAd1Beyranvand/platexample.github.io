import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `collectivity_of_saint_martin_plate`: The French-style plate of Saint Martin: three or four digits and two or three letters.
class CollectivityOfSaintMartinSource extends GallerySource {
  CollectivityOfSaintMartinSource();

  @override
  String get countryName => 'Collectivity of Saint Martin';

  @override
  String get packageName => 'collectivity_of_saint_martin_plate';

  @override
  String get note =>
      'The French-style plate of Saint Martin: three or four digits and two or three letters.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'mf.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: CollectivityOfSaintMartinCountry.collectivityOfSaintMartin,
        validator: const CollectivityOfSaintMartinValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note:
          'The French-style plate of Saint Martin: three or four digits and two or three letters.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private',
          CollectivityOfSaintMartinPlates.private,
          CollectivityOfSaintMartinThemes.private,
          '6467 AAB',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
