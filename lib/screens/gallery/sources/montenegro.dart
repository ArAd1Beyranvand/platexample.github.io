import 'package:montenegro_plate/montenegro_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `montenegro_plate`: the blue `MNE` band, the municipal code, the crest and
/// the serial, across the regular plate and four special series.
class MontenegroSource extends GallerySource {
  MontenegroSource();

  @override
  String get countryName => 'Montenegro';

  @override
  String get packageName => 'montenegro_plate';

  @override
  String get note =>
      'A blue MNE band, the two-letter municipal code, the crest on a red '
      'disc, two series letters and three digits. Diplomatic plates lead with '
      'the sending country code and are yellow for diplomats, black for press '
      'and companies. Not drawn: the police and military plates, the oldtimer '
      'plate, the oval CMD/CD extras and the map printed under the crest.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'me.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MontenegroCountry.montenegro,
    validator: const MontenegroValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'Municipal code, crest, two letters and three digits.',
      entries: <GalleryEntry>[
        _e('regular', 'Regular', MontenegroPlates.regular, MontenegroThemes.regular, 'PG QZ 581'),
        _e(
          'temporary',
          'Temporary · R over P, then the year',
          MontenegroPlates.temporary,
          MontenegroThemes.temporary,
          'HN 1 0 097',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Country code, series letter, number. Yellow ink for A, M and C.',
      entries: <GalleryEntry>[
        _e(
          'diplomatic',
          'Diplomat · Norway (53)',
          MontenegroPlates.diplomatic,
          MontenegroThemes.diplomatic,
          '53 A 002',
        ),
        _e(
          'press',
          'Press agency',
          MontenegroPlates.diplomatic,
          MontenegroThemes.press,
          '90 P 001',
        ),
      ],
    ),
    GallerySection(
      title: 'Two-row plates',
      note: 'Municipal code above the serial; the band covers the top row.',
      entries: <GalleryEntry>[
        _e(
          'agricultural',
          'Agricultural',
          MontenegroPlates.agricultural,
          MontenegroThemes.agricultural,
          'PG AA 02',
        ),
        _e('moped', 'Moped', MontenegroPlates.moped, MontenegroThemes.moped, 'HN AB18'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
