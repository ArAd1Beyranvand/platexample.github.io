import 'package:chad_plate/chad_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `chad_plate`: the regular and the temporary plate, `12A3456B`, with the
/// CEMAC roundel's place and "TCH" on the right.
class ChadSource extends GallerySource {
  ChadSource();

  @override
  String get countryName => 'Chad';

  @override
  String get packageName => 'chad_plate';

  @override
  String get note =>
      'Region code, vehicle-type letter, four digits and a series letter, '
      'black on white; temporary plates are light on red and end in TT. '
      'Not drawn: the CEMAC roundel, and the taxi, state, police, military '
      'and diplomatic plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'td.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: ChadCountry.chad,
    validator: const ChadValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Black on white for regular vehicles, red for temporary ones.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Regular · black on white',
          ChadPlates.private,
          ChadThemes.private,
          '23 V 1234 A',
        ),
        _e(
          'temporary',
          'Temporary · light on red',
          ChadPlates.temporary,
          ChadThemes.temporary,
          '09 C 0329 TT',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
