import 'package:el_salvador_plate/el_salvador_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `el_salvador_plate`: the 1976 car and motorcycle plates, black on tan.
class ElSalvadorSource extends GallerySource {
  ElSalvadorSource();

  @override
  String get countryName => 'El Salvador';

  @override
  String get packageName => 'el_salvador_plate';

  @override
  String get note =>
      'A class letter, dashes and digits in black on tan: P-0000 on cars, '
      'M-7-845 on motorcycles with the year printed below. The 2011 design '
      '(flag in the background) is not drawn: the article shows no photo of '
      'it. The motorcycle size is assumed from the photo. The article lists '
      'nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    PlateValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'sv.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: ElSalvadorCountry.el_salvador,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '1976',
      note: 'The car plate and the smaller motorcycle plate.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Car · black on tan',
          ElSalvadorPlates.private,
          ElSalvadorThemes.private,
          const ElSalvadorValidator(),
          'P 0000',
        ),
        _entry(
          'motorcycle',
          'Motorcycle · black on tan',
          ElSalvadorPlates.motorcycle,
          ElSalvadorThemes.motorcycle,
          const ElSalvadorMotorcycleValidator(),
          'M 7 845',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
