import 'package:marshall_islands_plate/marshall_islands_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `marshall_islands_plate`: the 6 × 12 in plate, the green Majuro Atoll
/// design and the 1972 Trust Territory one.
class MarshallIslandsSource extends GallerySource {
  MarshallIslandsSource();

  @override
  String get countryName => 'Marshall Islands';

  @override
  String get packageName => 'marshall_islands_plate';

  @override
  String get note =>
      'REPUBLIC OF THE MARSHALL ISLANDS over four digits and MAJURO ATOLL, '
      'white on green with a grey sticker patch; the 1972 Trust Territory '
      'plate carries one to three digits, a ring of six stars and the year, '
      'black on cream. Each colour is sampled from one picture. The article '
      'lists nothing Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'mh.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: MarshallIslandsCountry.marshall_islands,
        validator: const MarshallIslandsValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Two designs; each has its own theme.',
      entries: <GalleryEntry>[
        _entry(
          'current',
          'Majuro Atoll · white on green',
          MarshallIslandsPlates.current,
          MarshallIslandsThemes.current,
          '3425',
        ),
        _entry(
          'trust_territory',
          '1972 Trust Territory · black on cream',
          MarshallIslandsPlates.trustTerritory,
          MarshallIslandsThemes.trustTerritory,
          '606',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
