import 'package:france_plate/france_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `france_plate`: the SIV plate (2009) with the EU band on the left and the
/// département band on the right, in one and two lines, plus the collection,
/// transit, temporary and diplomatic plates.
class FranceSource extends GallerySource {
  FranceSource();

  @override
  String get countryName => 'France';

  @override
  String get packageName => 'france_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters (no I, O, U or SS), black on '
      'white, with the département on the right. Three-digit overseas '
      'département codes are not modelled, and the regional logo is always '
      'Île-de-France. The two-line, transit and temporary plates are read from '
      'small images, so their positions are approximate. Not drawn: plates '
      'before 2009 and the police, military and overseas series. The '
      'diplomatic series refuses the mission code for Israel.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const FranceValidator(),
  }) => GalleryEntry(
    id: 'fr.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: FranceCountry.france,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 520 × 110',
      note: 'Ink is about 74% of the reference height.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private car',
          FrancePlates.private,
          FranceThemes.private,
          'AA 229 DB 95',
        ),
        _entry(
          'collection',
          'Collection vehicle',
          FrancePlates.collection,
          FranceThemes.collection,
          'AA 229 DB',
        ),
      ],
    ),
    GallerySection(
      title: 'Two lines',
      note: 'The prefix above the number and suffix; read from a 330 px image.',
      entries: <GalleryEntry>[
        _entry(
          'twoline',
          'Two-line car · 340 × 204',
          FrancePlates.twoLine,
          FranceThemes.twoLine,
          'AA 229 DB 95',
        ),
      ],
    ),
    GallerySection(
      title: 'Transit and temporary',
      note: 'A month and year stand where the département would be.',
      entries: <GalleryEntry>[
        _entry(
          'transit',
          'Transit (WW)',
          FrancePlates.transit,
          FranceThemes.transit,
          'WW 324 TJ 05 26',
          validator: const FranceValidator(temporary: true),
        ),
        _entry(
          'temporary',
          'Temporary',
          FrancePlates.temporary,
          FranceThemes.temporary,
          'WW 324 TJ 05 26',
          validator: const FranceValidator(temporary: true),
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Embassy code, status letters (C, CD, CMD, K) and series.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic',
          FrancePlates.diplomatic,
          FranceThemes.diplomatic,
          '168 CD 66',
          validator: const FranceDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
