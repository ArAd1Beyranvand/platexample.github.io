import 'package:gambia_plate/gambia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `gambia_plate`: the current plates, a region code (2 or 3 letters), four
/// digits and a letter, with the flag and "GPF" at the left.
class GambiaSource extends GallerySource {
  GambiaSource();

  @override
  String get countryName => 'Gambia';

  @override
  String get packageName => 'gambia_plate';

  @override
  String get note =>
      'Black on white for passenger cars and motorcycles, black on yellow '
      'for commercial vehicles, in a one-row and a two-row size; motorcycles '
      'add MC. Not drawn: the pre-2019 series, rickshaw and diplomatic '
      'plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'gm.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GambiaCountry.gambia,
    validator: const GambiaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Passenger',
      note: 'Black on white; 520×110 mm and 270×200 mm.',
      entries: <GalleryEntry>[
        _e(
          'private_line',
          'Passenger · one row',
          GambiaPlates.line,
          GambiaThemes.private,
          'BJL 0123 A',
        ),
        _e(
          'private_square',
          'Passenger · two rows',
          GambiaPlates.square,
          GambiaThemes.private,
          'KM 0123 A',
        ),
      ],
    ),
    GallerySection(
      title: 'Commercial',
      note: 'Black on yellow; the same two sizes.',
      entries: <GalleryEntry>[
        _e(
          'commercial_line',
          'Commercial · one row',
          GambiaPlates.line,
          GambiaThemes.commercial,
          'KM 0123 A',
        ),
        _e(
          'commercial_square',
          'Commercial · two rows',
          GambiaPlates.square,
          GambiaThemes.commercial,
          'BJL 0123 A',
        ),
      ],
    ),
    GallerySection(
      title: 'Motorcycle',
      note: 'Black on white, 240×130 mm, with MC before the region.',
      entries: <GalleryEntry>[
        _e('motorcycle', 'Motorcycle', GambiaPlates.motorcycle, GambiaThemes.private, 'BJL 0123 A'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
