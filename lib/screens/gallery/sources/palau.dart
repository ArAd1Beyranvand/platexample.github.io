import 'dart:math';

import 'package:palau_plate/palau_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `palau_plate`: every state issues its own plate, built from one design.
class PalauSource extends GallerySource {
  PalauSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1994);

  @override
  String get countryName => 'Palau';

  @override
  String get packageName => 'palau_plate';

  @override
  String get note =>
      'Latin letters and digits. Each state has its own colours and wording '
      'on one layout: state name, number, "Republic of Palau". Seals, '
      'stickers and the wavy diplomatic border are not drawn.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'pw.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: PalauCountry.palau,
        validator: const PalauValidator(),
        sampleValues: PalauSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'State plates',
      note:
          'Colours are from colour-balanced photos of worn plates. Rim and '
          'corner radius are one estimate for all.',
      entries: <GalleryEntry>[
        _entry('aimeliik', 'Aimeliik', PalauPlates.aimeliik, PalauThemes.aimeliik),
        _entry('airai', 'Airai', PalauPlates.airai, PalauThemes.airai),
        _entry('angaur', 'Angaur', PalauPlates.angaur, PalauThemes.angaur),
        _entry('kayangel', 'Kayangel', PalauPlates.kayangel, PalauThemes.kayangel),
        _entry('koror', 'Koror', PalauPlates.koror, PalauThemes.koror),
        _entry(
          'kororBlack',
          'Koror (black)',
          PalauPlates.kororBlack,
          PalauThemes.kororBlack,
          note: 'One mixed run, as printed: `2K5136`.',
        ),
        _entry('melekeok', 'Melekeok', PalauPlates.melekeok, PalauThemes.melekeok),
        _entry('ngaraard', 'Ngaraard', PalauPlates.ngaraard, PalauThemes.ngaraard),
        _entry('ngarchelong', 'Ngarchelong', PalauPlates.ngarchelong, PalauThemes.ngarchelong),
        _entry('ngardmau', 'Ngardmau', PalauPlates.ngardmau, PalauThemes.ngardmau),
        _entry(
          'ngardmauGovernment',
          'Ngardmau government',
          PalauPlates.ngardmauGovernment,
          PalauThemes.ngardmauGovernment,
        ),
        _entry('ngatpang', 'Ngatpang', PalauPlates.ngatpang, PalauThemes.ngatpang),
        _entry('ngeremlengui', 'Ngeremlengui', PalauPlates.ngeremlengui, PalauThemes.ngeremlengui),
        _entry('ngiwal', 'Ngiwal', PalauPlates.ngiwal, PalauThemes.ngiwal),
        _entry('peleliu', 'Peleliu', PalauPlates.peleliu, PalauThemes.peleliu),
      ],
    ),
    GallerySection(
      title: 'National plates',
      note: '',
      entries: <GalleryEntry>[
        _entry(
          'government',
          'Government',
          PalauPlates.government,
          PalauThemes.government,
          note: 'The flag at the right is drawn in the plate\'s two colours.',
        ),
        _entry(
          'judiciary',
          'Judiciary',
          PalauPlates.judiciary,
          PalauThemes.judiciary,
          note: 'Colours estimated from one worn photo; scales not drawn.',
        ),
        _entry('diplomatic', 'Diplomatic', PalauPlates.diplomatic, PalauThemes.diplomatic),
        _entry('museum', 'Belau National Museum', PalauPlates.museum, PalauThemes.museum),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
