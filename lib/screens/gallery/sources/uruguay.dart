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
        _e('private', 'Private car', UruguayPlates.private, UruguayThemes.private, 'A BC 1234'),
        _e('mercosur', 'Mercosur', UruguayPlates.mercosur, UruguayThemes.mercosur, 'A DE 5678'),
      ],
    ),
    GallerySection(
      title: 'Usage colours',
      note: 'One register, recoloured; the caption names the usage.',
      entries: <GalleryEntry>[
        _e('taxi', 'Taxi · yellow', UruguayPlates.taxi, UruguayThemes.yellow, 'B FG 1122'),
        _e('school', 'School transport', UruguayPlates.school, UruguayThemes.yellow, 'C HJ 3344'),
        _e('doctor', 'Doctor', UruguayPlates.doctor, UruguayThemes.medical, 'L ME 1096'),
        _e('remise', 'Remise', UruguayPlates.remise, UruguayThemes.yellow, 'L RE 1058'),
        _e(
          'transport',
          'Public transport',
          UruguayPlates.publicTransport,
          UruguayThemes.yellow,
          'L TC 1033',
        ),
        _e('tourist', 'Tourist', UruguayPlates.tourist, UruguayThemes.yellow, 'L MT 1002'),
        _e('truck', 'Truck', UruguayPlates.truck, UruguayThemes.truck, 'D KL 5566'),
        _e('rental', 'Rental', UruguayPlates.rental, UruguayThemes.rental, 'E MN 7788'),
        _e('ambulance', 'Ambulance', UruguayPlates.ambulance, UruguayThemes.medical, 'F PQ 9900'),
      ],
    ),
    GallerySection(
      title: 'State',
      note: 'The official, assembly, diplomatic and presidential registers.',
      entries: <GalleryEntry>[
        _e('official', 'Official', UruguayPlates.official, UruguayThemes.official, 'A RS 1234'),
        _e(
          'assembly',
          'General Assembly',
          UruguayPlates.assembly,
          UruguayThemes.assembly,
          'A TU 5678',
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          UruguayPlates.diplomatic,
          UruguayThemes.diplomatic,
          'A VW 9012',
        ),
        _e('president', 'Presidential', UruguayPlates.president, UruguayThemes.president, 'A XY 1'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
