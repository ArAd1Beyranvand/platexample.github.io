import 'package:serbia_plate/serbia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `kosovo_plate`: the RKS series. One entry per design and livery; the
/// UNMIK-style plate appears in white and in the customs-guard blue.
class KosovoSource extends GallerySource {
  KosovoSource();

  @override
  String get countryName => 'Kosovo';

  @override
  String get packageName => 'kosovo_plate';

  @override
  String get note =>
      'A blue RKS strip, the arms, a district code, three digits and two '
      'letters. The diplomatic and EULEX plates are estimated from small '
      'photographs; the Kosovo Protection Corps, Irish KFOR and Yugoslav-era '
      'plates are not issued and not drawn.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: KosovoCountry.kosovo,
    validator: const KosovoValidator(),
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One line — 520 × 110',
      note: 'The documented size; ink is ~77% of the reference height.',
      entries: <GalleryEntry>[
        _e('xk.private', 'Private car', KosovoPlates.private, KosovoThemes.private, <String?>[
          '01',
          '999',
          'AD',
        ]),
        _e('xk.government', 'Government', KosovoPlates.government, KosovoThemes.private, <String?>[
          '3Z',
          '107',
          '07',
        ]),
        _e('xk.police', 'Police', KosovoPlates.police, KosovoThemes.police, <String?>['999', '01']),
        _e(
          'xk.emergency',
          'Emergency service',
          KosovoPlates.emergency,
          KosovoThemes.emergency,
          <String?>['112', '001', '01'],
        ),
        _e('xk.customs', 'Customs', KosovoPlates.customs, KosovoThemes.customs, <String?>[
          '001',
          'DG',
        ]),
        _e('xk.military', 'Security Force', KosovoPlates.military, KosovoThemes.military, <String?>[
          'KSF',
          '000',
          '01',
        ], note: "The Force's own emblem at the right is not drawn."),
        _e('xk.unmik', 'UNMIK-style KS', KosovoPlates.unmik, KosovoThemes.plain, <String?>[
          '648',
          'KS',
          '678',
        ]),
        _e(
          'xk.unmik.customs',
          'UNMIK customs guard',
          KosovoPlates.unmik,
          KosovoThemes.unmikCustoms,
          <String?>['095', 'KS', '001'],
        ),
        _e(
          'xk.diplomatic',
          'Diplomatic',
          KosovoPlates.diplomatic,
          KosovoThemes.diplomatic,
          <String?>['16', 'CD', '009'],
          note: 'Estimated from a small photograph.',
        ),
        _e('xk.eulex', 'EULEX', KosovoPlates.eulex, KosovoThemes.eulex, <String?>[
          '5250',
        ], note: 'Estimated from a small photograph.'),
      ],
    ),
    GallerySection(
      title: 'Stacked',
      note: 'Drawn at the photographs\' aspect, not 520 × 110.',
      entries: <GalleryEntry>[
        _e(
          'xk.agriculture',
          'Agriculture',
          KosovoPlates.agriculture,
          KosovoThemes.agriculture,
          <String?>['01', '101', 'VA'],
        ),
        _e('xk.trailer', 'Trailer', KosovoPlates.trailer, KosovoThemes.trailer, <String?>[
          '01',
          '427',
          'TA',
        ]),
        _e('xk.moped', 'Moped', KosovoPlates.moped, KosovoThemes.plain, <String?>[
          '04',
          '138',
          'RA',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
