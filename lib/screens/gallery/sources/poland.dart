import 'package:plate_core/plate_core.dart';
import 'package:poland_plate/poland_plate.dart';

import '../catalogue.dart';

/// `poland_plate`: each field is one slot, in thirteen designs.
class PolandSource extends GallerySource {
  PolandSource();

  @override
  String get countryName => 'Poland';

  @override
  String get packageName => 'poland_plate';

  @override
  String get note =>
      'A two- or three-letter county code and a series, black on white beside '
      'the EU panel. Electric, custom, professional, temporary, test, classic, '
      'motorcycle and reduced-size plates, the flag-block police, border guard '
      'and military plates, and the white-on-blue diplomatic plate are shown. '
      'Diplomatic mission codes 049 and 095 are refused (COUNTRY NOT FOUND). '
      'Not drawn: pre-2000 series, the hologram stickers and the vintage-car '
      'picture on classic plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'pl.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: spec.country,
    validator: const PolandValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Regular — 520 × 110',
      note: 'County code and series; the code is two or three letters.',
      entries: <GalleryEntry>[
        _e('private', 'Private car', PolandPlates.private, PolandThemes.private, 'WI|255RY'),
        _e(
          'electric',
          'Electric and hydrogen',
          PolandPlates.electric,
          PolandThemes.electric,
          'DWR|7545G',
        ),
        _e('custom', 'Custom', PolandPlates.custom, PolandThemes.custom, 'P0|KAZIK'),
        _e('classic', 'Classic car', PolandPlates.classic, PolandThemes.classic, 'SZ|08A'),
      ],
    ),
    GallerySection(
      title: 'Temporary and trade',
      note: 'Red or green characters and frame.',
      entries: <GalleryEntry>[
        _e('temporary', 'Temporary', PolandPlates.temporary, PolandThemes.temporary, 'D6|5889'),
        _e('test', 'Testing', PolandPlates.test, PolandThemes.test, 'S1|355|B'),
        _e(
          'professional',
          'Professional',
          PolandPlates.professional,
          PolandThemes.professional,
          'P35|01P07',
        ),
      ],
    ),
    GallerySection(
      title: 'Small plates',
      note: 'Motorcycle (two rows) and reduced-size car plates.',
      entries: <GalleryEntry>[
        _e(
          'motorcycle',
          'Motorcycle',
          PolandPlates.motorcycle,
          PolandThemes.motorcycle,
          'CBY|F55N',
        ),
        _e('reduced', 'Reduced size', PolandPlates.reduced, PolandThemes.reduced, 'C|009'),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Flag-block service plates and diplomatic. Try typing 049.',
      entries: <GalleryEntry>[
        _e('police', 'Police', PolandPlates.police, PolandThemes.police, 'HPP|E057'),
        _e(
          'border_guard',
          'Border guard',
          PolandPlates.borderGuard,
          PolandThemes.borderGuard,
          'HWA|A105',
        ),
        _e('military', 'Military', PolandPlates.military, PolandThemes.military, 'UA|03271'),
        _e(
          'diplomatic',
          'Diplomatic corps',
          PolandPlates.diplomatic,
          PolandThemes.diplomatic,
          'W|005|761',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
