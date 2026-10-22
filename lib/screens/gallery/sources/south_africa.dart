import 'package:plate_core/plate_core.dart';
import 'package:south_africa_plate/south_africa_plate.dart';

import '../catalogue.dart';

/// `south_africa_plate`: the provincial `ABC 123 EC` plates in their colours
/// and the Gauteng/KwaZulu-Natal `AB 12 CD GP` format.
class SouthAfricaSource extends GallerySource {
  SouthAfricaSource();

  @override
  String get countryName => 'South Africa';

  @override
  String get packageName => 'south_africa_plate';

  @override
  String get note =>
      'Three letters, up to three digits and the province suffix; Gauteng and '
      'KwaZulu-Natal use two letters, two digits, two letters and the suffix. '
      'Not drawn: provincial emblems and landscapes, the Western Cape dashed '
      'plate, diplomatic and police plates, and the obsolete 1963–1980 '
      'Cape, Transvaal and homeland plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'za.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SouthAfricaCountry.south_africa,
    validator: const SouthAfricaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Provincial',
      note:
          'Series, number and province suffix (MP Mpumalanga, L Limpopo, NC '
          'Northern Cape, EC Eastern Cape, FS Free State, NW North West).',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Black on white',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.standard,
          'BCD 123 MP',
        ),
        _e(
          'northernCape',
          'Northern Cape',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.northernCape,
          'BBC 123 NC',
        ),
        _e(
          'easternCape',
          'Eastern Cape',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.easternCape,
          'FMJ 541 EC',
        ),
        _e(
          'freeState',
          'Free State',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.freeState,
          'BCY 375 FS',
        ),
        _e(
          'northWest',
          'North West',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.northWest,
          'DSM 631 NW',
        ),
        _e(
          'government',
          'Government',
          SouthAfricaPlates.standard,
          SouthAfricaThemes.government,
          'RKN 329 G',
        ),
      ],
    ),
    GallerySection(
      title: 'Gauteng and KwaZulu-Natal',
      note: 'Two letters, two digits, two letters and GP or ZN, in blue.',
      entries: <GalleryEntry>[
        _e('gauteng', 'Gauteng', SouthAfricaPlates.modern, SouthAfricaThemes.blue, 'BS 24 LD GP'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
