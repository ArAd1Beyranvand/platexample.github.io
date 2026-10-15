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
        _e(
          'private',
          'Private',
          JordanPlates.private,
          JordanCountry.plain,
          '21 23456',
        ),
        _e(
          'transport',
          'Public transport · yellow',
          JordanPlates.transport,
          JordanCountry.yellow,
          '50 34567',
        ),
        _e(
          'rental',
          'Rental · green',
          JordanPlates.rental,
          JordanCountry.green,
          '70 56789',
        ),
        _e(
          'trailer',
          'Trailer',
          JordanPlates.trailer,
          JordanCountry.plain,
          '71 12233',
        ),
        _e(
          'temporary',
          'Temporary',
          JordanPlates.temporary,
          JordanCountry.plain,
          '69 87654',
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          JordanPlates.motorcycle,
          JordanCountry.plain,
          '46 1234',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'The letter series, and the red plates of the state.',
      entries: <GalleryEntry>[
        _e(
          'executive',
          'Executive',
          JordanPlates.executive,
          JordanCountry.red,
          'PM 12345',
        ),
        _e(
          'diplomatic',
          'Diplomatic',
          JordanPlates.diplomatic,
          JordanCountry.diplomatic,
          'CD 12345',
        ),
        _e(
          'aqaba',
          'Aqaba zone',
          JordanPlates.aqaba,
          JordanCountry.plain,
          'AQ 12345',
        ),
        _e(
          'police',
          'Police',
          JordanPlates.police,
          JordanCountry.red,
          '99 23456',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
