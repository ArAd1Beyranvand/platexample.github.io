import 'package:plate_core/plate_core.dart';
import 'package:togo_plate/togo_plate.dart';

import '../catalogue.dart';

/// `togo_plate`: the regular and the commercial plate.
class TogoSource extends GallerySource {
  TogoSource();

  @override
  String get countryName => 'Togo';

  @override
  String get packageName => 'togo_plate';

  @override
  String get note =>
      'Four digits, a grey dot and a two-letter series, with the flag over '
      'TG at the left. Not drawn: the two-line variant, and the government '
      'and diplomatic plates, which the article describes but does not '
      'picture.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'tg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TogoCountry.togo,
    validator: const TogoValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Blue on white for private vehicles, red on yellow for commercial.',
      entries: <GalleryEntry>[
        _e('regular', 'Regular', TogoPlates.regular, TogoThemes.regular, '9867 AE'),
        _e('commercial', 'Commercial', TogoPlates.commercial, TogoThemes.commercial, '2574 AL'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
