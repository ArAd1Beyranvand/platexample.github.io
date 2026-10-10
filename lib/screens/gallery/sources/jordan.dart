import 'package:jordan_plate/jordan_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `jordan_plate`: the code-and-serial plate across its usages, where the
/// field colour is the *country block* — plain, green, yellow, diplomatic
/// and red — over one monochrome theme.
class JordanSource extends GallerySource {
  JordanSource();

  @override
  String get countryName => 'Jordan';

  @override
  String get packageName => 'jordan_plate';

  @override
  String get note =>
      'A usage code, a dash and up to five digits, with the usage named in '
      'Arabic and Latin on the strip. Rental plates are green, public '
      'transport yellow, diplomatic blue and official red; the letter series '
      'carry two Latin letters instead of a code. Not drawn: the trailer and '
      'temporary stickers.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateCountry country,
    String values,
  ) => GalleryEntry(
    id: 'jo.$id',
    label: label,
    spec: spec,
    theme: JordanThemes.standard,
    country: country,
    validator: const JordanValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil',
      note: 'The code-and-serial plate; the colour is the usage.',
      entries: <GalleryEntry>[
        _e('private', 'Private', JordanPlates.private,
            JordanCountry.plain, '2 1 2 3 4 5 6'),
        _e('transport', 'Public transport · yellow', JordanPlates.transport,
            JordanCountry.yellow, '5 0 3 4 5 6 7'),
        _e('rental', 'Rental · green', JordanPlates.rental,
            JordanCountry.green, '7 0 5 6 7 8 9'),
        _e('trailer', 'Trailer', JordanPlates.trailer,
            JordanCountry.plain, '7 1 1 2 2 3 3'),
        _e('temporary', 'Temporary', JordanPlates.temporary,
            JordanCountry.plain, '6 9 8 7 6 5 4'),
        _e('motorcycle', 'Motorcycle', JordanPlates.motorcycle,
            JordanCountry.plain, '4 6 1 2 3 4'),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'The letter series, and the red plates of the state.',
      entries: <GalleryEntry>[
        _e('executive', 'Executive', JordanPlates.executive,
            JordanCountry.red, 'P M 1 2 3 4 5'),
        _e('diplomatic', 'Diplomatic', JordanPlates.diplomatic,
            JordanCountry.diplomatic, 'C D 1 2 3 4 5'),
        _e('aqaba', 'Aqaba zone', JordanPlates.aqaba,
            JordanCountry.plain, 'A Q 1 2 3 4 5'),
        _e('police', 'Police', JordanPlates.police,
            JordanCountry.red, '9 9 2 3 4 5 6'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
