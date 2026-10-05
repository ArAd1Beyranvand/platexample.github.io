import 'package:plate_core/plate_core.dart';
import 'package:vietnam_plate/vietnam_plate.dart';

import '../catalogue.dart';

/// `vietnam_plate`: the QCVN 08 long, short and motorcycle plates in white,
/// yellow and blue, the diplomatic family, and the military plates.
class VietnamSource extends GallerySource {
  VietnamSource();

  @override
  String get countryName => 'Vietnam';

  @override
  String get packageName => 'vietnam_plate';

  @override
  String get note =>
      'Long 520×110, short 330×165 and motorcycle 190×140 plates in white, '
      'yellow and blue, the temporary and NG/QT/NN plates, and the military '
      'plates in white on red (their sizes are read off one scan, not a '
      'regulation). Diplomatic country codes 336–340 are Israel’s and are '
      'refused with COUNTRY NOT FOUND. Trailer and machinery plates are left '
      'out.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    GatedPlateValidator validator, {
    String? note,
  }) => GalleryEntry(
    id: 'vn.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: VietnamCountry.vietnam,
    validator: validator,
    sampleValues: values.split(''),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars',
      note:
          'Province code, series letter and a five-digit number. White is '
          'private, yellow commercial and blue state. Ink is about 90% of '
          'the real height on the long plate and 78% on the short one.',
      entries: <GalleryEntry>[
        _entry(
          'long',
          'Private · long',
          VietnamPlates.long(),
          VietnamThemes.white,
          '30F25658',
          const VietnamValidator(),
        ),
        _entry(
          'short',
          'Private · short',
          VietnamPlates.short(),
          VietnamThemes.white,
          '30F25658',
          const VietnamValidator(),
        ),
        _entry(
          'yellow',
          'Commercial · yellow',
          VietnamPlates.long(),
          VietnamThemes.yellow,
          '51K12345',
          const VietnamValidator(),
        ),
        _entry(
          'blue',
          'State · blue',
          VietnamPlates.long(),
          VietnamThemes.blue,
          '80A00123',
          const VietnamValidator(),
        ),
        _entry(
          'ld',
          'Special series · two letters',
          VietnamPlates.long(serial: 2),
          VietnamThemes.blue,
          '80LD12345',
          const VietnamValidator(),
        ),
        _entry(
          'temporary',
          'Temporary · T',
          VietnamPlates.temporary(),
          VietnamThemes.white,
          'T8023588',
          const VietnamValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycles',
      note: 'Two rows on a 190×140 plate; ink is 70–80% of the real height.',
      entries: <GalleryEntry>[
        _entry(
          'moto',
          'Private · motorcycle',
          VietnamPlates.motorcycle(),
          VietnamThemes.white,
          '29AB22658',
          const VietnamValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and foreign',
      note:
          'Province, the mission’s code, NG (diplomat), QT (international '
          'organisation) or NN (foreigner) and a number. NG and QT are red.',
      entries: <GalleryEntry>[
        _entry(
          'ng',
          'Diplomatic · NG',
          VietnamPlates.foreignLong(),
          VietnamThemes.white,
          '80441NG45',
          const VietnamForeignValidator(),
        ),
        _entry(
          'qt',
          'International organisation · QT',
          VietnamPlates.foreignLong(codeFirst: true),
          VietnamThemes.white,
          '27QT54745',
          const VietnamForeignValidator(),
        ),
        _entry(
          'nn',
          'Foreigner · NN',
          VietnamPlates.foreignLong(statusColor: null),
          VietnamThemes.white,
          '80441NN45',
          const VietnamForeignValidator(),
        ),
        _entry(
          'ngShort',
          'Diplomatic · short',
          VietnamPlates.foreignShort(),
          VietnamThemes.white,
          '80441NG45',
          const VietnamForeignValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Military',
      note: 'White on red; a unit code and the number.',
      entries: <GalleryEntry>[
        _entry(
          'milLong',
          'Military · long',
          VietnamPlates.militaryLong(),
          VietnamThemes.red,
          'AB1234',
          const VietnamMilitaryValidator(),
        ),
        _entry(
          'milShort',
          'Military · short',
          VietnamPlates.militaryShort(),
          VietnamThemes.red,
          'AB1234',
          const VietnamMilitaryValidator(),
        ),
        _entry(
          'milMoto',
          'Military · motorcycle',
          VietnamPlates.militaryMotorcycle(),
          VietnamThemes.red,
          'AB123',
          const VietnamMilitaryValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
