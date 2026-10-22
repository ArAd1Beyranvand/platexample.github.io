import 'package:iceland_plate/iceland_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `iceland_plate`: Iceland's plates, one entry per category.
class IcelandSource extends GallerySource {
  IcelandSource();

  @override
  String get countryName => 'Iceland';

  @override
  String get packageName => 'iceland_plate';

  @override
  String get note => "Iceland's plates as drawn by iceland_plate, one entry per category.";

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const IcelandValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: IcelandCountry.iceland,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: '',
      entries: <GalleryEntry>[
        _e('is.standard', 'Standard', IcelandPlates.standard, IcelandThemes.standard, <String?>[
          'IU',
          '405',
        ]),
        _e('is.tractor', 'Tractor', IcelandPlates.plain, IcelandThemes.standard, <String?>[
          'UO',
          'C77',
        ]),
        _e(
          'is.commercial',
          'Commercial',
          IcelandPlates.commercial,
          IcelandThemes.commercial,
          <String?>['EM', '123'],
        ),
        _e(
          'is.diplomatic',
          'Diplomatic',
          IcelandPlates.diplomatic,
          IcelandThemes.diplomatic,
          <String?>['CD', 'J12'],
        ),
        _e('is.oil', 'Oil', IcelandPlates.plain, IcelandThemes.oil, <String?>['DH', 'Y28']),
        _e('is.temporary', 'Temporary', IcelandPlates.temporary, IcelandThemes.temporary, <String?>[
          'RN',
          '374',
        ]),
        _e('is.vanity', 'Vanity', IcelandPlates.vanity, IcelandThemes.standard, <String?>[
          'ZZZZZZ',
        ], const IcelandVanityValidator()),
        _e('is.off_road', 'Off road', IcelandPlates.stacked, IcelandThemes.offRoad, <String?>[
          'MJ',
          '769',
        ]),
        _e('is.moped', 'Moped', IcelandPlates.stacked, IcelandThemes.moped, <String?>['OB', 'G48']),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
