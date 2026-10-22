import 'package:plate_core/plate_core.dart';
import 'package:sahara_plate/sahara_plate.dart';

import '../catalogue.dart';

/// `sahrawi_arab_democratic_republic_plate`: private and government plates
/// (a prefix, two digits, five digits) and the army's nine digits.
class SahrawiArabDemocraticRepublicSource extends GallerySource {
  SahrawiArabDemocraticRepublicSource();

  @override
  String get countryName => 'Sahrawi Arab Democratic Republic';

  @override
  String get packageName => 'sahrawi_arab_democratic_republic_plate';

  @override
  String get note =>
      'Private plates are SH, two digits and five, black on yellow (or '
      'white); government plates add a G and are black on green (or white). '
      'The army plate is nine digits beside the flag. Government and army '
      'geometry is read by eye off small photographs. Not drawn: the pre-1976 '
      'Spanish series and MINURSO plates (no picture).';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'eh.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SahrawiArabDemocraticRepublicCountry.sahrawi_arab_democratic_republic,
    validator: const SahrawiArabDemocraticRepublicValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 110',
      note: 'SH, two digits and five digits.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private, yellow',
          SahrawiArabDemocraticRepublicPlates.private,
          SahrawiArabDemocraticRepublicThemes.private,
          'SH 30 13581',
        ),
        _e(
          'private_white',
          'Private, white',
          SahrawiArabDemocraticRepublicPlates.private,
          SahrawiArabDemocraticRepublicThemes.privateWhite,
          'SH 50 17321',
        ),
      ],
    ),
    GallerySection(
      title: 'Government — 520 × 110',
      note: 'GSH, two digits and five digits.',
      entries: <GalleryEntry>[
        _e(
          'government',
          'Government, green',
          SahrawiArabDemocraticRepublicPlates.government,
          SahrawiArabDemocraticRepublicThemes.government,
          'GSH 27 15316',
        ),
        _e(
          'government_white',
          'Government, white',
          SahrawiArabDemocraticRepublicPlates.government,
          SahrawiArabDemocraticRepublicThemes.governmentWhite,
          'GSH 21 14663',
        ),
      ],
    ),
    GallerySection(
      title: 'Army — 520 × 170',
      note: "Sahrawi People's Liberation Army: nine digits and the flag.",
      entries: <GalleryEntry>[
        _e(
          'army',
          'Army',
          SahrawiArabDemocraticRepublicPlates.army,
          SahrawiArabDemocraticRepublicThemes.army,
          '141101364',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
