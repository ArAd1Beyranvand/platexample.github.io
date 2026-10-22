import 'package:plate_core/plate_core.dart';
import 'package:caribbean_plate/caribbean_plate.dart';

import '../catalogue.dart';

/// `turks_and_caicos_islands_plate`: the modern five-digit plate under
/// "Beautiful by Nature", and the `TC`-prefixed series.
class TurksAndCaicosIslandsSource extends GallerySource {
  TurksAndCaicosIslandsSource();

  @override
  String get countryName => 'Turks and Caicos Islands';

  @override
  String get packageName => 'turks_and_caicos_islands_plate';

  @override
  String get note =>
      'Not drawn: the island graphics (shell, flamingo, lobster, cactus), '
      'the taxi plate, the Governor\'s plate and the 1970s white-on-black '
      'series. The article lists nothing Israel-specific, so nothing is '
      'refused.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'tc.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TurksAndCaicosIslandsCountry.turks_and_caicos_islands,
    validator: const TurksAndCaicosIslandsValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'Five digits, black since December 2022, red before.',
      entries: <GalleryEntry>[
        _e(
          'private_black',
          'Private · black',
          TurksAndCaicosIslandsPlates.modern,
          TurksAndCaicosIslandsThemes.privateBlack,
          '12345',
        ),
        _e(
          'private_red',
          'Private · red',
          TurksAndCaicosIslandsPlates.modern,
          TurksAndCaicosIslandsThemes.privateRed,
          '41400',
        ),
        _e(
          'private_legacy',
          'Private · TC series',
          TurksAndCaicosIslandsPlates.prefixed,
          TurksAndCaicosIslandsThemes.privateRed,
          'TC 1234',
        ),
      ],
    ),
    GallerySection(
      title: 'Other',
      note: 'Commercial, government and self-drive.',
      entries: <GalleryEntry>[
        _e(
          'commercial',
          'Commercial',
          TurksAndCaicosIslandsPlates.prefixed,
          TurksAndCaicosIslandsThemes.commercial,
          'TC 1234',
        ),
        _e(
          'government',
          'Government',
          TurksAndCaicosIslandsPlates.prefixed,
          TurksAndCaicosIslandsThemes.government,
          'TC 1234',
        ),
        _e(
          'self_drive',
          'Self-drive',
          TurksAndCaicosIslandsPlates.selfDrive,
          TurksAndCaicosIslandsThemes.selfDrive,
          'TC 1234',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
