import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:singapore_plate/singapore_plate.dart';

import '../catalogue.dart';

/// `singapore_plate`: a one-line geometry in six liveries, two two-tone
/// variants of it, and a two-line geometry.
class SingaporeSource extends GallerySource {
  SingaporeSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1965);

  @override
  String get countryName => 'Singapore';

  @override
  String get packageName => 'singapore_plate';

  @override
  String get note =>
      'A prefix of one to three letters, a number of one to four digits and '
      'a checksum letter computed from them. White on black as standard.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    String? prefix,
    String? note,
  }) => GalleryEntry(
    id: 'sg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SingaporeCountry.singapore,
    validator: const SingaporeValidator(),
    sampleValues: SingaporeSerialGenerator.generate(spec, random: _rng, prefix: prefix),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard plates',
      note:
          'One design. The prefix names the class: S_ private, SH taxis, G_ '
          'light goods, Y_ heavy goods, X_ very heavy goods, W_ plant, P_ '
          'private buses, QX emergency. Digits are about 80% of the real '
          'height: the plate face is condensed and the slot is capped by the '
          'plate.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · white on black',
          SingaporePlates.line,
          SingaporeThemes.private,
          prefix: 'SNB',
        ),
        _entry(
          'front',
          'Front · black on white',
          SingaporePlates.line,
          SingaporeThemes.front,
          prefix: 'SBS',
        ),
        _entry(
          'rear',
          'Rear · black on yellow',
          SingaporePlates.line,
          SingaporeThemes.rear,
          prefix: 'GT',
        ),
        _entry('taxi', 'Taxi', SingaporePlates.line, SingaporeThemes.private, prefix: 'SHC'),
        _entry(
          'emergency',
          'Emergency · QX',
          SingaporePlates.line,
          SingaporeThemes.private,
          prefix: 'QX',
        ),
      ],
    ),
    GallerySection(
      title: 'Special plates',
      note:
          'Off-peak cars are white on red; hazardous cargo vehicles, since '
          '2005, black on orange; Pulau Ubin vehicles gold on green. '
          'Classic and vintage plates are half red, half yellow; '
          'restricted-use plates are split on the diagonal, red and green.',
      entries: <GalleryEntry>[
        _entry('offPeak', 'Off-peak', SingaporePlates.line, SingaporeThemes.offPeak, prefix: 'SBA'),
        _entry(
          'hazardous',
          'Hazardous cargo',
          SingaporePlates.line,
          SingaporeThemes.hazardous,
          prefix: 'YB',
        ),
        _entry(
          'pulauUbin',
          'Pulau Ubin',
          SingaporePlates.line,
          SingaporeThemes.pulauUbin,
          prefix: 'PU',
        ),
        _entry(
          'classic',
          'Classic and vintage',
          SingaporePlates.classic,
          SingaporeThemes.classic,
          prefix: 'SV',
        ),
        _entry(
          'restricted',
          'Restricted use',
          SingaporePlates.restricted,
          SingaporeThemes.restricted,
          prefix: 'RU',
        ),
      ],
    ),
    GallerySection(
      title: 'Two-line plates',
      note: 'Motorcycles (F_) and engineering plant (W_): 325 × 160 mm.',
      entries: <GalleryEntry>[
        _entry(
          'motorcycle',
          'Motorcycle',
          SingaporePlates.twoLine,
          SingaporeThemes.rear,
          prefix: 'FW',
        ),
        _entry(
          'plant',
          'Engineering plant',
          SingaporePlates.twoLine,
          SingaporeThemes.front,
          prefix: 'WC',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
