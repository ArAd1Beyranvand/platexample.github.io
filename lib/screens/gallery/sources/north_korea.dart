import 'package:north_korea_plate/north_korea_plate.dart';

import '../catalogue.dart';

/// `north_korea_plate`: four specs, five liveries. Private and government
/// plates are one design — region, two digits, three digits — told apart only
/// by colour, so they share a spec under two themes.
class NorthKoreaSource extends GallerySource {
  NorthKoreaSource();

  @override
  String get countryName => 'North Korea';

  @override
  String get packageName => 'north_korea_plate';

  @override
  String get note =>
      'The 1990s liveries: a Hangul region code or 외/ㄱ/★ prefix, then '
      'digit groups. The digit 4 is avoided in class codes.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regional — 440 × 140',
      note: 'One design: amber for private cars, bare aluminium for the state.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'kp.private',
          label: 'Private · amber',
          spec: KPPlates.regional,
          theme: KPThemes.private,
          country: KPCountry.northKorea,
          validator: const KPValidator(),
          sampleValues: const <String?>['평남', '68', '366'],
        ),
        GalleryEntry(
          id: 'kp.government',
          label: 'Government · aluminium',
          spec: KPPlates.regional,
          theme: KPThemes.government,
          country: KPCountry.northKorea,
          validator: const KPValidator(),
          sampleValues: const <String?>['함북', '33', '968'],
        ),
      ],
    ),
    GallerySection(
      title: 'Special series',
      note: 'No region: 외 for diplomats, ㄱ for the army, a star for VIPs.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'kp.diplomatic',
          label: 'Diplomatic corps',
          spec: KPPlates.diplomatic,
          theme: KPThemes.diplomatic,
          country: KPCountry.northKorea,
          validator: const KPValidator(),
          sampleValues: const <String?>['07', '01'],
        ),
        GalleryEntry(
          id: 'kp.military',
          label: 'Military',
          spec: KPPlates.military,
          theme: KPThemes.military,
          country: KPCountry.northKorea,
          validator: const KPValidator(gateGroup: 'serial'),
          sampleValues: const <String?>['865607'],
        ),
        GalleryEntry(
          id: 'kp.vip',
          label: 'VIP · chauffeur-driven',
          spec: KPPlates.vip,
          theme: KPThemes.vip,
          country: KPCountry.northKorea,
          validator: const KPValidator(gateGroup: 'serial'),
          sampleValues: const <String?>['360'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
