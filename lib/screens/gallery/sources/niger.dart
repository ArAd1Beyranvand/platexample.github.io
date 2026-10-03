import 'package:core_plate/core_plate.dart';
import 'package:niger_plate/niger_plate.dart';

import '../catalogue.dart';

/// `niger_plate`: the 520 × 110 plate of 2005 in its two artwork liveries.
/// Each entry carries the value of its reference artwork.
class NigerSource extends GallerySource {
  NigerSource();

  @override
  String get countryName => 'Niger';

  @override
  String get packageName => 'niger_plate';

  @override
  String get note =>
      'Region digit and series letter, a mark, and four digits, beside the '
      'country map over RN.';

  GalleryEntry _entry(
    NigerUsage usage,
    PlateSpec spec,
    PlateCountry country,
    List<String?> values,
    String format,
  ) => GalleryEntry(
    id: 'ne.${usage.name}',
    label: '${usage.english} · $format',
    spec: spec,
    theme: NigerThemes.forUsage(usage),
    country: country,
    validator: const NigerValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '2005 series — 520 × 110',
      note:
          'The region is a digit from 1 (Agadez) to 8 (Niamey). The colour '
          'gives the usage. The digits read about 79% of the real height: '
          'the plate is only 110 tall and the engine sets a glyph at 72% of '
          'its box.',
      entries: <GalleryEntry>[
        _entry(
          NigerUsage.private,
          NigerPlates.privateSpec,
          NigerCountry.private,
          <String?>['8', 'H', '7', '6', '5', '4'],
          '8H-7654',
        ),
        _entry(
          NigerUsage.commercial,
          NigerPlates.commercialSpec,
          NigerCountry.commercial,
          <String?>['1', 'E', '2', '3', '4', '5'],
          '1E-2345',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
