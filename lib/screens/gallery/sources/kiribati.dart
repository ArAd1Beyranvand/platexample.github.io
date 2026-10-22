import 'package:kiribati_plate/kiribati_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `kiribati_plate`: white on black, `ABC 123`, plain and Betio.
class KiribatiSource extends GallerySource {
  KiribatiSource();

  @override
  String get countryName => 'Kiribati';

  @override
  String get packageName => 'kiribati_plate';

  @override
  String get note =>
      'Three letters and three digits, white on black. The standard plate is '
      'one framed row; the Betio plate stacks the two fields beside the coat '
      'of arms. Plates are hand painted, so both are measured off one '
      'drawing each. The article lists nothing Israel-specific, so nothing '
      'is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ki.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: KiribatiCountry.kiribati,
        validator: const KiribatiValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'Two designs; each has its own theme.',
      entries: <GalleryEntry>[
        _entry(
          'standard',
          'Standard · white on black',
          KiribatiPlates.standard,
          KiribatiThemes.standard,
          'XMS 247',
        ),
        _entry(
          'betio',
          'Betio · coat of arms',
          KiribatiPlates.betio,
          KiribatiThemes.betio,
          'BTC 313',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
