import 'package:laos_plate/laos_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `laos_plate`: the 2001 series, 340 × 150 — thirteen categories on three
/// designs: provincial, temporary and prefixed.
class LaosSource extends GallerySource {
  LaosSource();

  @override
  String get countryName => 'Laos';

  @override
  String get packageName => 'laos_plate';

  @override
  String get note =>
      'The province\'s name over two consonants and four digits; the first '
      'consonant is the vehicle class. Field and ink tell private, government '
      'and company plates apart, and electric cars carry a green EV badge '
      'since 2024. The article lists nothing Israel-specific, so nothing is '
      'refused.';

  GalleryEntry _entry(
    LaosCategory c,
    String label,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'la.${c.id}',
    label: label,
    spec: LaosPlates.of(c),
    theme: LaosPlates.themeOf(c),
    country: LaosCountry.laos,
    validator: validator,
    sampleValues: values.split(' '),
  );

  GalleryEntry _provincial(LaosCategory c, String label, String values) =>
      _entry(c, label, values, const LaosValidator());

  GalleryEntry _prefixed(LaosCategory c, String values) => _entry(
    c,
    '${c.meaning} · ${c.prefix}',
    values,
    const LaosPrefixedValidator(),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Provincial',
      note: 'One design; the field, the ink and the EV badge change.',
      entries: <GalleryEntry>[
        _provincial(
          LaosCategory.private,
          'Private · black on yellow',
          'ຮ ຍ 8 1 1 8',
        ),
        _provincial(
          LaosCategory.privateEv,
          'Private EV · black on amber',
          'ຂ ກ 4 7 1 4',
        ),
        _provincial(
          LaosCategory.government,
          'Government · white on blue',
          'ກ ກ 6 8 8 4',
        ),
        _provincial(
          LaosCategory.company,
          'Private company · black on white',
          'ອ ທ 1 2 3 4',
        ),
        _provincial(
          LaosCategory.companyEv,
          'Private company EV',
          'ອ ທ 0 0 0 4',
        ),
        _provincial(
          LaosCategory.taxableCompany,
          'Company (1% tax) · blue on white',
          'ກ ກ 2 6 6 2',
        ),
      ],
    ),
    GallerySection(
      title: 'Temporary',
      note: 'A large register over ໝົດກຳນົດ, the expiry date.',
      entries: <GalleryEntry>[
        _entry(
          LaosCategory.temporary,
          'Temporary',
          'ຊ ຄ 3 2 4 8 1 0 2 0 2 4 0 1',
          const LaosTemporaryValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'International, police and defence',
      note: 'A fixed prefix before the digits; no province.',
      entries: <GalleryEntry>[
        _prefixed(LaosCategory.diplomatic, '2 3 1 4'),
        _prefixed(LaosCategory.foreignGuest, '1 2 3 4'),
        _prefixed(LaosCategory.unitedNations, '1 2 3 4'),
        _prefixed(LaosCategory.financialInstitution, '1 2 3 4'),
        _prefixed(LaosCategory.publicSecurity, '0 5 4 9'),
        _prefixed(LaosCategory.nationalDefence, '1 2 3 4'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
