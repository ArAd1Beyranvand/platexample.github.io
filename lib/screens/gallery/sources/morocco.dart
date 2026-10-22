import 'package:morocco_plate/morocco_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `morocco_plate`: the 2026 registration plates, the service, trade,
/// diplomatic and military plates.
class MoroccoSource extends GallerySource {
  MoroccoSource();

  @override
  String get countryName => 'Morocco';

  @override
  String get packageName => 'morocco_plate';

  @override
  String get note =>
      'Digits, an Arabic series letter with its Latin twin, and a region '
      'number on white; service plates are black blocks with a red Arabic '
      'marking. Ink is about 65–75% of the reference height.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'ma.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MoroccoCountry.morocco,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration, 2026',
      note:
          'Series letter (Arabic over Latin), region digits and the MA badge; the number is one to five digits. The two-row and motorcycle forms follow the 2026 artwork.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'One line',
          MoroccoPlates.standard,
          MoroccoThemes.standard,
          '12345 T 72',
          MoroccoValidator.standard,
        ),
        _e(
          'legacy',
          'One line, before the MA badge',
          MoroccoPlates.legacy,
          MoroccoThemes.standard,
          '12345 A 21',
          MoroccoValidator.standard,
        ),
        _e(
          'car2',
          'Two rows (300 × 150)',
          MoroccoPlates.car2,
          MoroccoThemes.standard,
          '12345 B 26',
          MoroccoValidator.standard,
        ),
        _e(
          'moto',
          'Motorcycle (220 × 150)',
          MoroccoPlates.motorcycle,
          MoroccoThemes.standard,
          '12345 H 7',
          MoroccoValidator.standard,
        ),
      ],
    ),
    GallerySection(
      title: 'Service',
      note:
          'Six digits and the service marking in red: ج government, ش police, ق س auxiliary forces, و م civil protection (black on white). Government’s state-owned M variant is not drawn.',
      entries: <GalleryEntry>[
        _e(
          'government',
          'Government',
          MoroccoPlates.government,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'government.rows',
          'Government, two rows',
          MoroccoPlates.governmentRows,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'police',
          'Police',
          MoroccoPlates.police,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'police.rows',
          'Police, two rows',
          MoroccoPlates.policeRows,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'auxiliary',
          'Auxiliary forces',
          MoroccoPlates.auxiliary,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'auxiliary.rows',
          'Auxiliary forces, two rows',
          MoroccoPlates.auxiliaryRows,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'protection',
          'Civil protection',
          MoroccoPlates.civilProtection,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
        _e(
          'protection.rows',
          'Civil protection, two rows',
          MoroccoPlates.civilProtectionRows,
          MoroccoThemes.standard,
          '102345',
          MoroccoValidator.service,
        ),
      ],
    ),
    GallerySection(
      title: 'Trade and temporary',
      note: 'White on red trailer plate, red dealer plate with W 18, and the temporary WW plate.',
      entries: <GalleryEntry>[
        _e(
          'trailer',
          'Trailer',
          MoroccoPlates.trailer,
          MoroccoThemes.trailer,
          '1234 09',
          MoroccoValidator.trailer,
        ),
        _e(
          'dealer',
          'Dealer (W 18)',
          MoroccoPlates.dealer,
          MoroccoThemes.dealer,
          '12345',
          MoroccoValidator.dealer,
        ),
        _e(
          'temporary',
          'Temporary (WW)',
          MoroccoPlates.temporary,
          MoroccoThemes.standard,
          '134567',
          MoroccoValidator.temporary,
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and military',
      note:
          'Yellow CD and CI plates (CI has been out of use since 2021), and the army and navy plates with the flag at the right. The navy crest and the army plate’s outer outline are not drawn.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic (CD)',
          MoroccoPlates.diplomatic,
          MoroccoThemes.diplomatic,
          '123 45',
          MoroccoValidator.mission,
        ),
        _e(
          'cooperation',
          'International cooperation (CI)',
          MoroccoPlates.cooperation,
          MoroccoThemes.diplomatic,
          '123 45',
          MoroccoValidator.mission,
        ),
        _e(
          'army',
          'Army',
          MoroccoPlates.army,
          MoroccoThemes.military,
          '102345',
          MoroccoValidator.service,
        ),
        _e('navy', 'Navy', MoroccoPlates.navy, MoroccoThemes.navy, '1234', MoroccoValidator.navy),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
