import 'package:plate_core/plate_core.dart';
import 'package:uruguay_plate/uruguay_plate.dart';

import '../catalogue.dart';

/// `uruguay_plate`: the department letter, two series letters and four digits,
/// recoloured for each usage, plus the Mercosur plate.
class UruguaySource extends GallerySource {
  UruguaySource();

  @override
  String get countryName => 'Uruguay';

  @override
  String get packageName => 'uruguay_plate';

  @override
  String get note =>
      'The first letter is the department, then two series letters and four '
      'digits. Every usage shares that register and changes only the field '
      'colour, which is why they are one geometry here. The Mercosur plate '
      'moves the number behind the regional band. Not drawn: the department '
      'caption and the motorcycle plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'uy.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: UruguayCountry.uruguay,
    validator: const UruguayValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and Mercosur',
      note: 'The current plate and the regional one.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', UruguayPlates.private,
            UruguayThemes.private, 'A B C 1 2 3 4'),
        _e('mercosur', 'Mercosur', UruguayPlates.mercosur,
            UruguayThemes.mercosur, 'A D E 5 6 7 8'),
      ],
    ),
    GallerySection(
      title: 'Usage colours',
      note: 'One register, recoloured; the caption names the usage.',
      entries: <GalleryEntry>[
        _e('taxi', 'Taxi · yellow', UruguayPlates.taxi,
            UruguayThemes.yellow, 'B F G 1 1 2 2'),
        _e('school', 'School transport', UruguayPlates.school,
            UruguayThemes.yellow, 'C H J 3 3 4 4'),
        _e('truck', 'Truck', UruguayPlates.truck,
            UruguayThemes.truck, 'D K L 5 5 6 6'),
        _e('rental', 'Rental', UruguayPlates.rental,
            UruguayThemes.rental, 'E M N 7 7 8 8'),
        _e('ambulance', 'Ambulance', UruguayPlates.ambulance,
            UruguayThemes.medical, 'F P Q 9 9 0 0'),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'The official, assembly, diplomatic and presidential registers.',
      entries: <GalleryEntry>[
        _e('official', 'Official', UruguayPlates.official,
            UruguayThemes.official, 'A R S 1 2 3 4'),
        _e('assembly', 'General Assembly', UruguayPlates.assembly,
            UruguayThemes.assembly, 'A T U 5 6 7 8'),
        _e('diplomatic', 'Diplomatic corps', UruguayPlates.diplomatic,
            UruguayThemes.diplomatic, 'A V W 9 0 1 2'),
        _e('president', 'Presidential', UruguayPlates.president,
            UruguayThemes.president, 'A X Y 1'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
