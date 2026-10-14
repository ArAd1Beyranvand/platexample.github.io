import 'package:plate_core/plate_core.dart';
import 'package:sudan_plate/sudan_plate.dart';

import '../catalogue.dart';

/// `sudan_plate`: the 320 × 160 bilingual 2009 plate in its three
/// photographed liveries. Every entry carries the value of its reference
/// photograph, so the page can be held up against it.
class SudanSource extends GallerySource {
  SudanSource();

  @override
  String get countryName => 'Sudan';

  @override
  String get packageName => 'sudan_plate';

  @override
  String get note =>
      'One value printed twice: Arabic above, Latin below — type in either '
      'row and the other follows. The grey strip is the hologram.';

  GalleryEntry _entry(
    SudanUsage usage,
    PlateSpec spec,
    List<String?> values,
    String format,
  ) => GalleryEntry(
    id: 'sd.${usage.name}',
    label: '${usage.english} · $format',
    spec: spec,
    theme: SudanThemes.forUsage(usage),
    country: SudanCountry.sudan,
    validator: const SudanValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: '2009 series — 320 × 160',
      note:
          'Class digit and state code (KH Khartoum, G Al Jazirah, RS Red Sea) '
          'beside a four- or five-digit serial. The colour gives the usage. '
          'The Arabic serial reads about 72% of the real height: the stamped '
          'face is taller and narrower than any font drawn here.',
      entries: <GalleryEntry>[
        _entry(SudanUsage.private, SudanPlates.standard, <String?>[
          '7',
          'KH',
          '10346',
        ], '7KH-10346'),
        _entry(SudanUsage.transport, SudanPlates.standard, <String?>[
          '4',
          'KH',
          '1209',
        ], '4KH-1209'),
        _entry(SudanUsage.commercial, SudanPlates.standard, <String?>[
          '8',
          'RS',
          '20368',
        ], '8RS-20368'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
