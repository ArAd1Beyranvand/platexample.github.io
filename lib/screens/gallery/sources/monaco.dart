import 'package:monaco_plate/monaco_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `monaco_plate`: a four-character serial beside the lozenge badge; the
/// motorcycle plate has two letters and two digits.
class MonacoSource extends GallerySource {
  MonacoSource();

  @override
  String get countryName => 'Monaco';

  @override
  String get packageName => 'monaco_plate';

  @override
  String get note =>
      'Light blue on white with the arms of Monaco at the left. Not drawn: '
      'the provisional, pending, CC/CD diplomatic, IAEA/IHB, tourist and '
      'Italian consulate plates have no picture in the article.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'mc.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MonacoCountry.monaco,
    validator: const MonacoValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars',
      note:
          'A letter and three digits, four digits, or three digits and a '
          'letter.',
      entries: <GalleryEntry>[
        _e('car_rear', 'Rear', MonacoPlates.carRear, MonacoThemes.car, <String?>['7756']),
        _e('car_front', 'Front', MonacoPlates.carFront, MonacoThemes.car, <String?>['7756']),
      ],
    ),
    GallerySection(
      title: 'Motorcycles',
      note: 'Two letters and two digits.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', MonacoPlates.motorcycle, MonacoThemes.motorcycle, <String?>[
          'KN',
          '66',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
