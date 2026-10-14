import 'package:italy_plate/italy_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `italy_plate`: the 1999 plate with the EU band on the left and a blue band
/// with a yellow ring on the right, as the one-line car plate, the two-line
/// plate and the square motorcycle plate.
class ItalySource extends GallerySource {
  ItalySource();

  @override
  String get countryName => 'Italy';

  @override
  String get packageName => 'italy_plate';

  @override
  String get note =>
      'Two letters, three digits and two letters (no I, O, Q or U), black on '
      'white between two blue bands. The two-line and motorcycle plates are '
      'read from stretched photographs, so their positions are approximate. '
      'Not drawn: the Republic emblem, the year in the ring, the front plate '
      'and the special series (police, military, fire brigade, diplomatic and '
      'the rest).';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'it.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: ItalyCountry.italy,
    validator: const ItalyValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Car — 520 × 110',
      note: 'The rear plate; ink is ~70% of the reference height.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private car',
          ItalyPlates.private,
          ItalyThemes.private,
          'CZ 889 KF',
        ),
      ],
    ),
    GallerySection(
      title: 'Two lines and motorcycle',
      note:
          'The prefix above the number and suffix; the motorcycle plate '
          'has two letters over five digits.',
      entries: <GalleryEntry>[
        _entry(
          'twoline',
          'Two-line car · 360 × 220',
          ItalyPlates.twoLine,
          ItalyThemes.twoLine,
          'ZA 198 SG',
        ),
        _entry(
          'motorcycle',
          'Motorcycle · 177 × 177',
          ItalyPlates.motorcycle,
          ItalyThemes.motorcycle,
          'BB 03813',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
