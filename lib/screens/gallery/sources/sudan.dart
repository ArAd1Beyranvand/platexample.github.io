import 'package:plate_core/core_plate.dart';
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
    id: 'sd.${usage.name}.${spec.slotCount - 2}',
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
        _entry(SudanUsage.private, SudanPlates.serial5, <String?>[
          '7', 'KH', '1', '0', '3', '4', '6', //
        ], '7KH-10346'),
        _entry(SudanUsage.transport, SudanPlates.serial4, <String?>[
          '4', 'KH', '1', '2', '0', '9', //
        ], '4KH-1209'),
        _entry(SudanUsage.commercial, SudanPlates.serial5, <String?>[
          '8', 'RS', '2', '0', '3', '6', '8', //
        ], '8RS-20368'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
