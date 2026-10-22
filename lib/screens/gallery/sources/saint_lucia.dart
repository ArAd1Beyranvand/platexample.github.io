import 'package:saint_lucia_plate/saint_lucia_plate.dart';

import '../catalogue.dart';

/// `saint_lucia_plate`: a letter prefix and up to four digits, one colour per category.
class SaintLuciaSource extends GallerySource {
  SaintLuciaSource();

  @override
  String get countryName => 'Saint Lucia';

  @override
  String get packageName => 'saint_lucia_plate';

  @override
  String get note =>
      'A letter prefix and up to four digits on the 300 × 152 mm blank. '
      'Not drawn: black-on-white private plates and the older owner-supplied styles.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Categories',
      note: 'Private, taxi, minibus, dealer, government and Member of Parliament.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'lc.private',
          label: 'Private',
          spec: SaintLuciaPlates.private,
          theme: SaintLuciaThemes.private,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'PA 1234'.split(' '),
        ),
        GalleryEntry(
          id: 'lc.taxi',
          label: 'Taxi',
          spec: SaintLuciaPlates.taxi,
          theme: SaintLuciaThemes.taxi,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'TX 1234'.split(' '),
        ),
        GalleryEntry(
          id: 'lc.minibus',
          label: 'Minibus',
          spec: SaintLuciaPlates.minibus,
          theme: SaintLuciaThemes.minibus,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'M 1234'.split(' '),
        ),
        GalleryEntry(
          id: 'lc.demonstration',
          label: 'Dealer',
          spec: SaintLuciaPlates.demonstration,
          theme: SaintLuciaThemes.demonstration,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'DM 123'.split(' '),
        ),
        GalleryEntry(
          id: 'lc.government',
          label: 'Government',
          spec: SaintLuciaPlates.government,
          theme: SaintLuciaThemes.government,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'SLG 1234'.split(' '),
        ),
        GalleryEntry(
          id: 'lc.parliament',
          label: 'Member of Parliament',
          spec: SaintLuciaPlates.parliament,
          theme: SaintLuciaThemes.parliament,
          country: SaintLuciaCountry.saint_lucia,
          validator: const SaintLuciaValidator(),
          sampleValues: 'MP 12'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
