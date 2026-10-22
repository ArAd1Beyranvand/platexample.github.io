import 'package:nigeria_plate/nigeria_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `nigeria_plate`: the 2011 series — three letters, three digits and two
/// letters under a flag sticker and the state's name and slogan (300 × 152).
class NigeriaSource extends GallerySource {
  NigeriaSource();

  @override
  String get countryName => 'Nigeria';

  @override
  String get packageName => 'nigeria_plate';

  @override
  String get note =>
      'Three letters, three digits and two letters, blue on white for '
      'private vehicles and red for commercial ones; only the state caption '
      'changes between states. The skyline and map behind the number are not '
      'drawn, the captions are placed from a contact sheet, and the Kogi and '
      'Niger layouts are not modelled. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'ng.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: NigeriaCountry.nigeria,
        validator: const NigeriaValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'States',
      note: 'One design; the caption is the state\'s.',
      entries: <GalleryEntry>[
        _entry(
          'lagos',
          'Lagos · private',
          NigeriaPlates.lagos,
          NigeriaThemes.private,
          'GGE 123 ZY',
        ),
        _entry(
          'lagos_commercial',
          'Lagos · commercial',
          NigeriaPlates.lagos,
          NigeriaThemes.commercial,
          'FKJ 254 XA',
        ),
        _entry(
          'fct',
          'Federal Capital Territory',
          NigeriaPlates.federalCapital,
          NigeriaThemes.private,
          'FWA 799 AB',
        ),
        _entry('adamawa', 'Adamawa', NigeriaPlates.adamawa, NigeriaThemes.private, 'YLA 291 EL'),
        _entry('benue', 'Benue', NigeriaPlates.benue, NigeriaThemes.private, 'TKP 973 AR'),
        _entry('sokoto', 'Sokoto', NigeriaPlates.sokoto, NigeriaThemes.private, 'WRN 479 AA'),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
