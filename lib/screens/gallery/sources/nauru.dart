import 'package:nauru_plate/nauru_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `nauru_plate`: the Australian-standard 372 × 134 mm plate in three series.
class NauruSource extends GallerySource {
  NauruSource();

  @override
  String get countryName => 'Nauru';

  @override
  String get packageName => 'nauru_plate';

  @override
  String get note =>
      'NAURU over one row of fields. Since 2015 three letters and three '
      'digits, black on white; 1975–2015 four digits; 1970–75 one digit, a '
      'diamond and three digits, white on black. Each colour is sampled from '
      'one photo. The article lists nothing Israel-specific, so nothing is '
      'refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'nr.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: NauruCountry.nauru,
        validator: const NauruValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Three series; each has its own design and theme.',
      entries: <GalleryEntry>[
        _entry(
          'current',
          '2015– · black on white',
          NauruPlates.current,
          NauruThemes.current,
          'AAA 595',
        ),
        _entry(
          'legacy',
          '1975–2015 · black on white',
          NauruPlates.legacy,
          NauruThemes.legacy,
          '7827',
        ),
        _entry(
          'classic',
          '1970–75 · white on black',
          NauruPlates.classic,
          NauruThemes.classic,
          '2 601',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
