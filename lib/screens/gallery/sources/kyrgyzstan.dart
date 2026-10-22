import 'package:kyrgyzstan_plate/kyrgyzstan_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `kyrgyzstan_plate`: the 2015 plates, 520 × 110, in every category the
/// article shows.
class KyrgyzstanSource extends GallerySource {
  KyrgyzstanSource();

  @override
  String get countryName => 'Kyrgyzstan';

  @override
  String get packageName => 'kyrgyzstan_plate';

  @override
  String get note =>
      'A two-digit region code over the flag and KG, a divider, then three '
      'digits and two or three letters, black on white; electric vehicles add '
      'a green strip. Foreign vehicles are black on yellow, diplomatic ones '
      'white on red or (UN) blue with a dated box. Not drawn: the 1980, 1994 '
      'and 2009 formats, which the article calls superseded.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator? validator,
  }) => GalleryEntry(
    id: 'kg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: KyrgyzstanCountry.kyrgyzstan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Region code, digits and letters; the divider is painted by the background.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private · black on white',
          KyrgyzstanPlates.private,
          KyrgyzstanThemes.private,
          '01 123 ABC',
          validator: const KyrgyzstanValidator(),
        ),
        _e(
          'government',
          'Government · PT',
          KyrgyzstanPlates.government,
          KyrgyzstanThemes.private,
          '02 012 PT',
          validator: const KyrgyzstanValidator(),
        ),
        _e(
          'eco',
          'Electric · green strip',
          KyrgyzstanPlates.eco,
          KyrgyzstanThemes.eco,
          '01 923 ARX',
          validator: const KyrgyzstanValidator(),
        ),
        _e(
          'president',
          'President · flag block',
          KyrgyzstanPlates.president,
          KyrgyzstanThemes.private,
          '01',
        ),
      ],
    ),
    GallerySection(
      title: 'Foreign vehicles — black on yellow',
      note:
          'The class letter says who owns the vehicle: H citizen, K media, M firm, P resident over six months.',
      entries: <GalleryEntry>[
        _e(
          'foreign_h',
          'Foreign citizen (H)',
          KyrgyzstanPlates.foreign,
          KyrgyzstanThemes.foreign,
          '01 1234 H',
          validator: const KyrgyzstanForeignValidator(),
        ),
        _e(
          'foreign_k',
          'Foreign media (K)',
          KyrgyzstanPlates.foreign,
          KyrgyzstanThemes.foreign,
          '01 1234 K',
          validator: const KyrgyzstanForeignValidator(),
        ),
        _e(
          'foreign_m',
          'Foreign firm (M)',
          KyrgyzstanPlates.foreign,
          KyrgyzstanThemes.foreign,
          '01 1234 M',
          validator: const KyrgyzstanForeignValidator(),
        ),
        _e(
          'foreign_p',
          'Foreign resident (P)',
          KyrgyzstanPlates.foreign,
          KyrgyzstanThemes.foreign,
          '01 1234 P',
          validator: const KyrgyzstanForeignValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic — white on red or blue',
      note:
          'Class letter, mission code (01–19 countries, 50–64 organisations), number, and the month over year of issue. Blue is for UN missions.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomatic (D)',
          KyrgyzstanPlates.diplomatic,
          KyrgyzstanThemes.diplomatic,
          'D 01 001 05 16',
          validator: KyrgyzstanDiplomaticValidator.diplomatic,
        ),
        _e(
          'consular',
          'Consular (C)',
          KyrgyzstanPlates.diplomatic,
          KyrgyzstanThemes.diplomatic,
          'C 01 001 05 16',
          validator: KyrgyzstanDiplomaticValidator.diplomatic,
        ),
        _e(
          'technical',
          'Technical staff (T)',
          KyrgyzstanPlates.diplomatic,
          KyrgyzstanThemes.diplomatic,
          'T 01 001 05 16',
          validator: KyrgyzstanDiplomaticValidator.diplomatic,
        ),
        _e(
          'diplomatic_un',
          'Diplomatic, UN (D)',
          KyrgyzstanPlates.diplomatic,
          KyrgyzstanThemes.unitedNations,
          'D 01 001 05 16',
          validator: KyrgyzstanDiplomaticValidator.diplomatic,
        ),
        _e(
          'technical_un',
          'Technical staff, UN (T)',
          KyrgyzstanPlates.diplomatic,
          KyrgyzstanThemes.unitedNations,
          'T 01 001 05 16',
          validator: KyrgyzstanDiplomaticValidator.diplomatic,
        ),
        _e(
          'honorary',
          'Honorary consul (HC)',
          KyrgyzstanPlates.honorary,
          KyrgyzstanThemes.diplomatic,
          'HC 1001 05 16',
          validator: KyrgyzstanDiplomaticValidator.honorary,
        ),
        _e(
          'mission',
          'Head of mission (CMD)',
          KyrgyzstanPlates.mission,
          KyrgyzstanThemes.diplomatic,
          'CMD 001',
          validator: KyrgyzstanDiplomaticValidator.mission,
        ),
        _e(
          'mission_un',
          'Head of mission, UN (CMD)',
          KyrgyzstanPlates.mission,
          KyrgyzstanThemes.unitedNations,
          'CMD 001',
          validator: KyrgyzstanDiplomaticValidator.mission,
        ),
      ],
    ),
    GallerySection(
      title: 'Two row',
      note:
          'The article gives no size for these; the canvases keep the artwork aspect (320 × 160 and 276 × 200).',
      entries: <GalleryEntry>[
        _e(
          'square',
          'Square · private',
          KyrgyzstanPlates.square,
          KyrgyzstanThemes.square,
          '01 123 ABC',
          validator: const KyrgyzstanValidator(),
        ),
        _e(
          'square_government',
          'Square · government',
          KyrgyzstanPlates.squareGovernment,
          KyrgyzstanThemes.square,
          '02 012 PT',
          validator: const KyrgyzstanValidator(),
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          KyrgyzstanPlates.motorcycle,
          KyrgyzstanThemes.motorcycle,
          '01 123 DQ',
          validator: const KyrgyzstanValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
