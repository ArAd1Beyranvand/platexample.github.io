import 'package:plate_core/plate_core.dart';
import 'package:saint_helena_plate/saint_helena_plate.dart';

import '../catalogue.dart';

/// `saint_helena_plate`: private and government plates in two liveries.
class SaintHelenaSource extends GallerySource {
  SaintHelenaSource();

  @override
  String get countryName => 'Saint Helena';

  @override
  String get packageName => 'saint_helena_plate';

  @override
  String get note =>
      'Digits only, with SHG before them on government vehicles. Black on '
      'white at the front, black on yellow at the rear, UK dimensions. The '
      'Governor\'s crown plate is not drawn.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'sh.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SaintHelenaCountry.saint_helena,
    validator: const SaintHelenaValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private plates',
      note:
          'The article\'s photograph of Saint Helena plates is a car park, so '
          'the layout and the one-to-four digit run are the UK\'s and an '
          'estimate from it.',
      entries: <GalleryEntry>[
        _entry(
          'front',
          'Front · black on white',
          SaintHelenaPlates.private,
          SaintHelenaThemes.front,
          <String?>['3998'],
        ),
        _entry(
          'rear',
          'Rear · black on yellow',
          SaintHelenaPlates.private,
          SaintHelenaThemes.rear,
          <String?>['260'],
        ),
      ],
    ),
    GallerySection(
      title: 'Government',
      note: 'The government plate.',
      entries: <GalleryEntry>[
        _entry(
          'government',
          'Government · SHG',
          SaintHelenaPlates.government,
          SaintHelenaThemes.rear,
          <String?>['SHG', '12'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
