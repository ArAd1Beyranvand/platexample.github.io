import 'package:polynesia_plate/polynesia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `wallis_and_futuna_plate`: Four digits and the WF mark; yellow at the front and white at the rear.
class WallisAndFutunaSource extends GallerySource {
  WallisAndFutunaSource();

  @override
  String get countryName => 'Wallis and Futuna';

  @override
  String get packageName => 'wallis_and_futuna_plate';

  @override
  String get note => 'Four digits and the WF mark; yellow at the front and white at the rear.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'wf.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: WallisAndFutunaCountry.wallis_and_futuna,
        validator: const WallisAndFutunaValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Four digits and the WF mark; yellow at the front and white at the rear.',
      entries: <GalleryEntry>[
        _entry(
          'front',
          'Front · yellow',
          WallisAndFutunaPlates.private,
          WallisAndFutunaThemes.front,
          '1234',
        ),
        _entry(
          'rear',
          'Rear · white',
          WallisAndFutunaPlates.private,
          WallisAndFutunaThemes.rear,
          '1234',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
