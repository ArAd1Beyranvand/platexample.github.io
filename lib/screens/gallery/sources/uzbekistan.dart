import 'package:plate_core/plate_core.dart';
import 'package:uzbekistan_plate/uzbekistan_plate.dart';

import '../catalogue.dart';

/// `uzbekistan_plate`: the two-digit region, the series letter and the number,
/// over the passenger, foreign, diplomatic and trailer registers.
class UzbekistanSource extends GallerySource {
  UzbekistanSource();

  @override
  String get countryName => 'Uzbekistan';

  @override
  String get packageName => 'uzbekistan_plate';

  @override
  String get note =>
      'The region number leads, then the series letter, the serial and the '
      'closing letters. The foreign and temporary plates are digits only, the '
      'diplomatic plate leads with D or T. Not drawn: the UZ oval and the '
      'older Soviet-era formats.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const UzbekistanValidator(),
  }) => GalleryEntry(
    id: 'uz.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: UzbekistanCountry.uzbekistan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Passenger',
      note: 'Region, series letter, serial, then the closing letters.',
      entries: <GalleryEntry>[
        _e('passenger', 'Passenger car', UzbekistanPlates.passenger,
            UzbekistanThemes.passenger, '0 1 A 1 2 3 B C'),
      ],
    ),
    GallerySection(
      title: 'Foreign and temporary',
      note: 'Digits only, on a coloured field.',
      entries: <GalleryEntry>[
        _e('foreign_citizen', 'Foreign citizen',
            UzbekistanPlates.foreignCitizen, UzbekistanThemes.foreignCitizen,
            '1 0 1 2 3 4 5 6'),
        _e('foreign_company', 'Foreign company',
            UzbekistanPlates.foreignCompany, UzbekistanThemes.foreignCompany,
            '2 0 6 5 4 3 2 1'),
        _e('temporary', 'Temporary', UzbekistanPlates.temporary,
            UzbekistanThemes.temporary, '3 0 1 1 2 2 3 3'),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'The ambassador, diplomat and United Nations registers.',
      entries: <GalleryEntry>[
        _e('ambassador', 'Ambassador', UzbekistanPlates.ambassador,
            UzbekistanThemes.diplomatic, '0 0 1 0 0 1',
            validator: const UzbekistanDiplomaticValidator()),
        _e('diplomat', 'Diplomat', UzbekistanPlates.diplomat,
            UzbekistanThemes.diplomatic, 'D 0 0 2 0 1 5',
            validator: const UzbekistanDiplomaticValidator()),
        _e('united_nations', 'United Nations',
            UzbekistanPlates.unitedNations, UzbekistanThemes.unitedNations,
            '1 2 3 4',
            validator: const UzbekistanUnitedNationsValidator()),
      ],
    ),
    GallerySection(
      title: 'Trailer and motorcycle',
      note: 'Shorter faces, the number stacked on two rows.',
      entries: <GalleryEntry>[
        _e('trailer', 'Trailer', UzbekistanPlates.trailer,
            UzbekistanThemes.trailer, '0 1 2 3 A B 4 5'),
        _e('motorcycle', 'Motorcycle', UzbekistanPlates.motorcycle,
            UzbekistanThemes.motorcycle, '0 1 2 C D 3 4'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
