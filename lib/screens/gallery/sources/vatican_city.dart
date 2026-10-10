import 'package:plate_core/plate_core.dart';
import 'package:vatican_city_plate/vatican_city_plate.dart';

import '../catalogue.dart';

/// `vatican_city_plate`: the SCV and CV prefixes over the serial, with the
/// papal plate reading SCV 1.
class VaticanCitySource extends GallerySource {
  VaticanCitySource();

  @override
  String get countryName => 'Vatican City';

  @override
  String get packageName => 'vatican_city_plate';

  @override
  String get note =>
      'The prefix is the register: CV for a private vehicle, SCV for the state, '
      'and SCV 1 for the papal car. Not drawn: the keys and tiara emblem and '
      'the historical plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'va.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: VaticanCityCountry.vatican_city,
    validator: const VaticanCityValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and state',
      note: 'CV for private, SCV for the state.',
      entries: <GalleryEntry>[
        _e('private', 'Private · CV', VaticanCityPlates.private,
            VaticanCityThemes.private, 'C V 1 2 3 4 5'),
        _e('government', 'State · SCV', VaticanCityPlates.government,
            VaticanCityThemes.government, 'S C V 0 0 1 2 3'),
        _e('official', 'Official', VaticanCityPlates.official,
            VaticanCityThemes.official, 'S C V 4 5 6 A'),
      ],
    ),
    GallerySection(
      title: 'Papal',
      note: 'SCV 1, the Pope\'s own car.',
      entries: <GalleryEntry>[
        _e('papal', 'Papal car', VaticanCityPlates.papal,
            VaticanCityThemes.papal, 'S C V 1'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
