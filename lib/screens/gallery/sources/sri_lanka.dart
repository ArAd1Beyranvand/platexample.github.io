import 'package:plate_core/plate_core.dart';
import 'package:sri_lanka_plate/sri_lanka_plate.dart';

import '../catalogue.dart';

/// `sri_lanka_plate`: the white front plate and the yellow rear plate, the
/// province code leading the letter block.
class SriLankaSource extends GallerySource {
  SriLankaSource();

  @override
  String get countryName => 'Sri Lanka';

  @override
  String get packageName => 'sri_lanka_plate';

  @override
  String get note =>
      'A province code, the class letters and four digits. The front plate is '
      'black on white and carries the province code; the rear is black on '
      'yellow and drops it. Not drawn: the Sinhala caption and the diplomatic '
      'and military series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'lk.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SriLankaCountry.sri_lanka,
    validator: const SriLankaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Front and rear',
      note: 'The rear plate is yellow and carries one fewer letter.',
      entries: <GalleryEntry>[
        _e(
          'front',
          'Front · white',
          SriLankaPlates.front,
          SriLankaThemes.front,
          'WP CAB 1234',
        ),
        _e(
          'rear',
          'Rear · yellow',
          SriLankaPlates.rear,
          SriLankaThemes.rear,
          'WP AB 5678',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
