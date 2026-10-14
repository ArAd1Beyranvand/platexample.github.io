import 'package:plate_core/plate_core.dart';
import 'package:niger_plate/niger_plate.dart';

import '../catalogue.dart';

/// `niger_plate`: the 520 × 110 plate of 2005 in its two artwork liveries,
/// then the article's other formats, which have no artwork. Each artwork
/// entry carries the value of its reference.
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
    String format, [
    PlateValidator validator = const NigerValidator(),
  ]) => GalleryEntry(
    id: 'ne.${usage.name}',
    label: '${usage.english} · $format',
    spec: spec,
    theme: NigerThemes.forUsage(usage),
    country: country,
    validator: validator,
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
          <String?>['8', 'H', '7654'],
          '8H-7654',
        ),
        _entry(
          NigerUsage.commercial,
          NigerPlates.commercialSpec,
          NigerCountry.commercial,
          <String?>['1', 'E', '2345'],
          '1E-2345',
        ),
      ],
    ),
    GallerySection(
      title: 'Other formats — unverified',
      note:
          'No image of these four was found. They follow the article\'s '
          'formats and colour words on the private plate\'s digit height and '
          'pitch; positions and colours are approximations.',
      entries: <GalleryEntry>[
        _entry(
          NigerUsage.stateTransport,
          NigerOtherPlates.state,
          NigerCountry.plain,
          <String?>['12345', '6'],
          '12345ARN6',
          const NigerStateValidator(),
        ),
        _entry(
          NigerUsage.military,
          NigerOtherPlates.military,
          NigerCountry.military,
          <String?>['12345'],
          '12345',
          const NigerMilitaryValidator(),
        ),
        _entry(
          NigerUsage.diplomaticChief,
          NigerOtherPlates.diplomaticChief,
          NigerCountry.plain,
          <String?>['123'],
          '123CMD RN',
          const NigerDiplomaticValidator(),
        ),
        _entry(
          NigerUsage.diplomaticStaff,
          NigerOtherPlates.diplomaticStaff,
          NigerCountry.plain,
          <String?>['123', '4'],
          '123CD4 RN',
          const NigerDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
