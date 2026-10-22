import 'package:plate_core/plate_core.dart';
import 'package:rwanda_plate/rwanda_plate.dart';

import '../catalogue.dart';

/// `rwanda_plate`: the European-size plate (520 × 110), a register of three
/// letters and a serial of three digits and a letter.
class RwandaSource extends GallerySource {
  RwandaSource();

  @override
  String get countryName => 'Rwanda';

  @override
  String get packageName => 'rwanda_plate';

  @override
  String get note =>
      'One design in two fields: a register of three letters starting with R '
      'and a serial of three digits and a letter. The front plate is black on '
      'white, the back plate black on yellow. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateTheme theme, String values) => GalleryEntry(
    id: 'rw.$id',
    label: label,
    spec: RwandaPlates.plate,
    theme: theme,
    country: RwandaCountry.rwanda,
    validator: const RwandaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Front and back',
      note: 'One design; the field changes.',
      entries: <GalleryEntry>[
        _entry('front', 'Front · black on white', RwandaThemes.front, 'RAB 123C'),
        _entry('back', 'Back · black on yellow', RwandaThemes.back, 'RAB 175C'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
