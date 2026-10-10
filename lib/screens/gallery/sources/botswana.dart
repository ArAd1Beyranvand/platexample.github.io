import 'package:botswana_plate/botswana_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `botswana_plate`: the B-prefixed private plate front and rear, the blue
/// public service plate and the red government plate.
class BotswanaSource extends GallerySource {
  BotswanaSource();

  @override
  String get countryName => 'Botswana';

  @override
  String get packageName => 'botswana_plate';

  @override
  String get note =>
      'A B prefix, three digits and three letters, black on white at the '
      'front and black on yellow at the rear. Public service plates are '
      'white on blue; government plates white on red with two letters and '
      'six digits. Not drawn: the two-line and motorcycle plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const BotswanaValidator(),
  }) => GalleryEntry(
    id: 'bw.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BotswanaCountry.botswana,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'White at the front, yellow at the rear — one geometry, two '
          'liveries.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private · front',
          BotswanaPlates.private,
          BotswanaThemes.private,
          'B 1 2 3 A B C',
        ),
        _e(
          'privaterear',
          'Private · rear',
          BotswanaPlates.private,
          BotswanaThemes.privateRear,
          'B 1 2 3 A B C',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Blue for public service, red for government.',
      entries: <GalleryEntry>[
        _e(
          'publicservice',
          'Public service · blue',
          BotswanaPlates.publicService,
          BotswanaThemes.publicService,
          'B 4 5 6 D E F',
        ),
        _e(
          'government',
          'Government · red',
          BotswanaPlates.government,
          BotswanaThemes.government,
          'B X 1 2 3 4 5 6',
          validator: const BotswanaGovernmentValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
