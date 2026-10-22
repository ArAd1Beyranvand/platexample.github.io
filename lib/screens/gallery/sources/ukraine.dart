import 'package:plate_core/plate_core.dart';
import 'package:russia_plate/russia_plate.dart';

import '../catalogue.dart';

/// `ukraine_plate`: the 2015 and 2004 designs, one line, two lines and three
/// lines. Mission code 012 is refused with "COUNTRY NOT FOUND".
class UkraineSource extends GallerySource {
  UkraineSource();

  @override
  String get countryName => 'Ukraine';

  @override
  String get packageName => 'ukraine_plate';

  @override
  String get note =>
      'Letters from the twelve that read the same in Latin and Cyrillic, '
      'with a band at the left: dark blue with a flag since 2015, the flag '
      'itself before. Diplomatic mission code 012 is refused in every layer '
      'with "COUNTRY NOT FOUND". Not drawn: the 2026 olive diplomatic design, '
      'pre-2004 plates, oblast flags, stickers and the personalised plate\'s '
      'user sticker.';

  /// Entries the country's shared validator does not cover.
  static const Set<String> _unvalidated = <String>{'ua.diplomatic_1997', 'ua.companies'};

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ua.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: UkraineCountry.ukraine,
        validator: _unvalidated.contains('ua.$id') ? null : const UkraineValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One line — 520 × 110',
      note:
          'The 2015 band (dark blue, flag, white UA) and the 2004 band (the flag itself, black UA).',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · 2015',
          UkrainePlates.private,
          UkraineThemes.private,
          'AK 1234 KK',
        ),
        _entry(
          'private_legacy',
          'Private · 2004',
          UkrainePlates.privateLegacy,
          UkraineThemes.private,
          'AK 1234 KK',
        ),
        _entry(
          'transport',
          'Transport · 2015',
          UkrainePlates.transport,
          UkraineThemes.transport,
          'AK 1234 KK',
        ),
        _entry(
          'transport_legacy',
          'Transport · 2004',
          UkrainePlates.transportLegacy,
          UkraineThemes.legacyYellow,
          'AK 1234 KK',
        ),
        _entry(
          'personalised',
          'Personalised',
          UkrainePlates.personalised,
          UkraineThemes.private,
          'ПЕТРО',
        ),
        _entry(
          'temporary',
          'Temporary · 2015',
          UkrainePlates.temporary,
          UkraineThemes.red,
          'T1 CP5140',
        ),
        _entry(
          'temporary_legacy',
          'Temporary · 2004',
          UkrainePlates.temporaryLegacy,
          UkraineThemes.red,
          'T1 CP5140',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note:
          'Police carry the star and a region code on the band; military and volunteer plates have no band.',
      entries: <GalleryEntry>[
        _entry('police', 'Police · 2015', UkrainePlates.police, UkraineThemes.police, '16 1564'),
        _entry(
          'police_legacy',
          'Police · 2004',
          UkrainePlates.policeLegacy,
          UkraineThemes.police,
          '16 1564',
        ),
        _entry('military', 'Military', UkrainePlates.military, UkraineThemes.military, '00 04 E6'),
        _entry(
          'volunteers',
          'Volunteers',
          UkrainePlates.volunteers,
          UkraineThemes.volunteers,
          'KB 0004',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and companies',
      note: 'Mission code 012 is refused in every layer with "COUNTRY NOT FOUND".',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic',
          UkrainePlates.diplomatic,
          UkraineThemes.private,
          'D 036 036',
        ),
        _entry(
          'diplomatic_1997',
          'Diplomatic · 1997',
          UkrainePlates.diplomatic1997,
          UkraineThemes.red,
          '005 DP 0041',
        ),
        _entry(
          'companies',
          'Companies · 1997',
          UkrainePlates.companies,
          UkraineThemes.legacyYellow,
          '004 F 40915',
        ),
      ],
    ),
    GallerySection(
      title: 'Two lines and motorcycles',
      note:
          'Non-standard 220 × 110 (band positions estimated) and the 220 × 174 motorcycle plates.',
      entries: <GalleryEntry>[
        _entry(
          'non_standard',
          'Non-standard · 2015',
          UkrainePlates.nonStandard,
          UkraineThemes.private,
          'AK KA 8608',
        ),
        _entry(
          'non_standard_legacy',
          'Non-standard · 2004',
          UkrainePlates.nonStandardLegacy,
          UkraineThemes.private,
          'AK KA 8608',
        ),
        _entry(
          'motorcycle',
          'Motorcycle · 2015',
          UkrainePlates.motorcycle,
          UkraineThemes.motorcycle,
          'AK 2015 CE',
        ),
        _entry(
          'motorcycle_legacy',
          'Motorcycle · 2004',
          UkrainePlates.motorcycleLegacy,
          UkraineThemes.motorcycle,
          'AK 2015 CE',
        ),
        _entry(
          'military_motorcycle',
          'Military motorcycle',
          UkrainePlates.militaryMotorcycle,
          UkraineThemes.militaryMotorcycle,
          '02 35 A3',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
