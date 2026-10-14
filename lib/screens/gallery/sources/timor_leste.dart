import 'package:plate_core/plate_core.dart';
import 'package:timor_leste_plate/timor_leste_plate.dart';

import '../catalogue.dart';

/// `timor_leste_plate`: the current five-digit plate, and the two formats the
/// country inherited — the Indonesian plate with its expiry and the
/// Portuguese plate with its letter prefix.
class TimorLesteSource extends GallerySource {
  TimorLesteSource();

  @override
  String get countryName => 'Timor-Leste';

  @override
  String get packageName => 'timor_leste_plate';

  @override
  String get note =>
      'The current plate is five digits with the diamond and the TLS code; the '
      'government plate closes with a class letter. The inherited Indonesian '
      'plate carries the expiry month and year in a boxed row, and the '
      'Portuguese plate leads with a letter. Not drawn: the crest and the '
      'UN-administration plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
    PlateValidator validator,
  ) => GalleryEntry(
    id: 'tl.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: TimorLesteCountry.timor_leste,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current',
      note: 'Five digits; the government plate adds the class letter.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car',
          TimorLestePlates.private,
          TimorLesteThemes.private,
          '12 345',
          const TimorLesteValidator(),
        ),
        _e(
          'government',
          'Government',
          TimorLestePlates.government,
          TimorLesteThemes.government,
          '67 890 G',
          const TimorLesteValidator(),
        ),
      ],
    ),
    GallerySection(
      title: 'Inherited formats',
      note:
          'The Indonesian plate prints the expiry under the number; the '
          'Portuguese plate leads with a letter.',
      entries: <GalleryEntry>[
        _e(
          'indonesian',
          'Indonesian · with expiry',
          TimorLestePlates.indonesian,
          TimorLesteThemes.indonesian,
          '0925 DF 1234 AB',
          const TimorLesteIndonesianValidator(),
        ),
        _e(
          'portuguese',
          'Portuguese',
          TimorLestePlates.portuguese,
          TimorLesteThemes.portuguese,
          'T 12 34',
          const TimorLestePortugueseValidator(),
        ),
        _e(
          'portuguese_stacked',
          'Portuguese · stacked',
          TimorLestePlates.portugueseStacked,
          TimorLesteThemes.portuguese,
          'T 56 78',
          const TimorLestePortugueseValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
