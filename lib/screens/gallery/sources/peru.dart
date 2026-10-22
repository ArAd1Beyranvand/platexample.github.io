import 'package:peru_plate/peru_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `peru_plate`: the 2010 series — three layouts (regular, motorcycle,
/// special) in fifteen category colourways.
class PeruSource extends GallerySource {
  PeruSource();

  @override
  String get countryName => 'Peru';

  @override
  String get packageName => 'peru_plate';

  @override
  String get note =>
      'The 2010 series only: PERU, the flag without the shield and a '
      'holographic label on every plate, with colour naming the category. '
      'The 1963, 1966, 1994 and 1995–2009 series and the 2018 papal-visit '
      'plate are not drawn. The article lists nothing Israel-specific, so '
      'nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'pe.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: PeruCountry.peru,
        validator: const PeruValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular · `ABC-123`',
      note: 'The six regular categories share one layout; only the header and body colours change.',
      entries: <GalleryEntry>[
        _entry('automobile', 'Automobile', PeruPlates.regular, PeruThemes.automobile, 'ABC 123'),
        _entry(
          'city_bus',
          'City and interurban bus · green header',
          PeruPlates.regular,
          PeruThemes.cityBus,
          'A1B 734',
        ),
        _entry(
          'interprovincial_bus',
          'Interprovincial bus · orange header',
          PeruPlates.regular,
          PeruThemes.interprovincialBus,
          'AB1 955',
        ),
        _entry('taxi', 'Taxi · yellow header', PeruPlates.regular, PeruThemes.taxi, 'A1B 634'),
        _entry('truck', 'Truck · black on yellow', PeruPlates.regular, PeruThemes.truck, 'ABC 123'),
        _entry(
          'trailer',
          'Trailer · yellow body',
          PeruPlates.regular,
          PeruThemes.trailer,
          'ABC 123',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycle · `AB-1234`',
      note: 'Small motorcycles take numbers 0000–5999, large 6000–9999.',
      entries: <GalleryEntry>[
        _entry(
          'small_motorcycle',
          'Small motorcycle · cyan',
          PeruPlates.motorcycle,
          PeruThemes.smallMotorcycle,
          'AB 1234',
        ),
        _entry(
          'large_motorcycle',
          'Large motorcycle · yellow header',
          PeruPlates.motorcycle,
          PeruThemes.largeMotorcycle,
          'AB 7234',
        ),
      ],
    ),
    GallerySection(
      title: 'Special · `E UA-123`',
      note: 'The small E marks the special series; the two letters after it name the category.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic · CD',
          PeruPlates.special,
          PeruThemes.diplomatic,
          'CD 123',
        ),
        _entry('emergency', 'Emergency · UA', PeruPlates.special, PeruThemes.emergency, 'UA 123'),
        _entry(
          'exhibition',
          'Exhibition · EX',
          PeruPlates.special,
          PeruThemes.exhibition,
          'EX 123',
        ),
        _entry(
          'government',
          'Government · GA',
          PeruPlates.special,
          PeruThemes.government,
          'GA 123',
        ),
        _entry('police', 'Police · PA', PeruPlates.special, PeruThemes.police, 'PA 123'),
        _entry('temporary', 'Temporary · ZA', PeruPlates.special, PeruThemes.temporary, 'ZA 123'),
        _entry('imported', 'Used imported · RM', PeruPlates.special, PeruThemes.imported, 'RM 123'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
