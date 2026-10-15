import 'package:guinea_plate/guinea_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `guinea_plate`: the current blue-on-white plates in three shapes and the
/// 1994 red and black series.
class GuineaSource extends GallerySource {
  GuineaSource();

  @override
  String get countryName => 'Guinea';

  @override
  String get packageName => 'guinea_plate';

  @override
  String get note =>
      'The 2021 plates are blue on white: a two-letter series, four digits '
      'and the two-digit region code, with the flag-map and RG at the left. '
      'The 1994 plates are white on red (private) or black (taxis, trucks), '
      'led by the region letters. The QR code is not drawn.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'gn.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GuineaCountry.guinea,
    validator: const GuineaValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current (2021–)',
      note: 'Blue on white; the region code (02 is Conakry) ends the number.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Standard · one row',
          GuineaPlates.standard,
          GuineaThemes.standard,
          <String?>['AB', '0123', '02'],
        ),
        _e(
          'standard_square',
          'Standard · two rows',
          GuineaPlates.standardSquare,
          GuineaThemes.standardSquare,
          <String?>['AB', '0123', '02'],
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          GuineaPlates.motorcycle,
          GuineaThemes.motorcycle,
          <String?>['AB', '02', '012', 'A'],
        ),
      ],
    ),
    GallerySection(
      title: 'Earlier (1994–2021)',
      note: 'White on red for private vehicles, on black for taxis and trucks.',
      entries: <GalleryEntry>[
        _e(
          'legacy',
          'Private · one row',
          GuineaPlates.legacy,
          GuineaThemes.legacy,
          <String?>['RC', '0123', 'AB'],
        ),
        _e(
          'legacy_square',
          'Private · two rows',
          GuineaPlates.legacySquare,
          GuineaThemes.legacySquare,
          <String?>['RC', '0123', 'AB'],
        ),
        _e(
          'taxi',
          'Taxi · one row',
          GuineaPlates.taxi,
          GuineaThemes.taxi,
          <String?>['RC', '0123', 'Z'],
        ),
        _e(
          'taxi_square',
          'Taxi · two rows',
          GuineaPlates.taxiSquare,
          GuineaThemes.taxiSquare,
          <String?>['RC', '0123', 'Z'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
