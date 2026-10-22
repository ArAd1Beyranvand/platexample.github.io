import 'package:eswatini_plate/eswatini_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `eswatini_plate`: the 2010 South-African-style `JSD 884 BM` plate, front
/// (one row) and rear (two rows).
class EswatiniSource extends GallerySource {
  EswatiniSource();

  @override
  String get countryName => 'Eswatini';

  @override
  String get packageName => 'eswatini_plate';

  @override
  String get note =>
      'A letter plus SD, three digits, then a letter and the region initial. '
      'The rear plate geometry is estimated from a cropped photograph. Not '
      'drawn: the printed landscape and stickers, and the pre-2010, royal, '
      'government and diplomatic plates.';

  static GalleryEntry _e(String id, String label, PlateSpec spec, String values) => GalleryEntry(
    id: 'sz.$id',
    label: label,
    spec: spec,
    theme: EswatiniThemes.standard,
    country: EswatiniCountry.eswatini,
    validator: const EswatiniValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current plates',
      note: 'Dark grey-brown on a pale printed landscape.',
      entries: <GalleryEntry>[
        _e('front', 'Front', EswatiniPlates.front, 'JSD 884 BM'),
        _e('rear', 'Rear', EswatiniPlates.rear, 'HSD 205 AH'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
