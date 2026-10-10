import 'package:bosnia_and_herzegovina_plate/bosnia_and_herzegovina_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bosnia_and_herzegovina_plate`: the 2009 letter-digit plate and the
/// all-digit taxi, temporary, EUPM and diplomatic series.
class BosniaAndHerzegovinaSource extends GallerySource {
  BosniaAndHerzegovinaSource();

  @override
  String get countryName => 'Bosnia and Herzegovina';

  @override
  String get packageName => 'bosnia_and_herzegovina_plate';

  @override
  String get note =>
      'A letter, two digits, a letter and three digits, black on white — the '
      'letters come from the seven shared by Cyrillic and Latin, so the plate '
      'reads the same in both scripts. Taxi, temporary, EUPM and diplomatic '
      'plates drop the letters. Not drawn: the motorcycle plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'ba.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BosniaAndHerzegovinaCountry.bosnia_and_herzegovina,
    validator: const BosniaAndHerzegovinaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'The script-neutral letters A, E, J, K, M, O and T.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private',
          BosniaAndHerzegovinaPlates.private,
          BosniaAndHerzegovinaThemes.private,
          'A 1 2 K 3 4 5',
        ),
        _e(
          'agricultural',
          'Agricultural',
          BosniaAndHerzegovinaPlates.agricultural,
          BosniaAndHerzegovinaThemes.agricultural,
          'E 6 7 M 8 9 0',
        ),
      ],
    ),
    GallerySection(
      title: 'Digit series',
      note: 'Taxi, temporary, EUPM and diplomatic plates carry no letters.',
      entries: <GalleryEntry>[
        _e(
          'taxi',
          'Taxi',
          BosniaAndHerzegovinaPlates.taxi,
          BosniaAndHerzegovinaThemes.taxi,
          '1 2 3 4 5 6',
        ),
        _e(
          'temporary',
          'Temporary',
          BosniaAndHerzegovinaPlates.temporary,
          BosniaAndHerzegovinaThemes.temporary,
          '6 5 4 3 2 1',
        ),
        _e(
          'eupm',
          'EUPM',
          BosniaAndHerzegovinaPlates.eupm,
          BosniaAndHerzegovinaThemes.eupm,
          '1 2 3 4',
        ),
        _e(
          'diplomatic',
          'Diplomatic',
          BosniaAndHerzegovinaPlates.diplomatic,
          BosniaAndHerzegovinaThemes.diplomatic,
          '1 2 A 3 4 5',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
