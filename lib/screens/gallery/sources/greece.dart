import 'dart:math';

import 'package:greece_plate/greece_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `greece_plate`: the euro plate in two liveries, then three unbanded plates.
class GreeceSource extends GallerySource {
  GreeceSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(2004);

  @override
  String get countryName => 'Greece';

  @override
  String get packageName => 'greece_plate';

  @override
  String get note =>
      'Prefecture letters, a dash and four digits, black on white with the '
      'euroband. Only the fourteen Greek capitals that look Latin are used.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    String? note,
  }) => GalleryEntry(
    id: 'gr.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: GreeceCountry.greece,
    validator: const GreeceValidator(),
    sampleValues: GreeceSerialGenerator.generate(spec, random: _rng),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Euro plates',
      note:
          'Since 2004: the Flag of Europe over GR on a blue band, the state '
          'seal above the dash. The trailer plate has one letter and five '
          'digits.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · ΑΒΓ-1234',
          GreecePlates.private,
          GreeceThemes.private,
        ),
        _entry(
          'trailer',
          'Trailer over 3.5 t',
          GreecePlates.trailer,
          GreeceThemes.trailer,
        ),
      ],
    ),
    GallerySection(
      title: 'Special plates',
      note:
          'Government (orange), police (blue) and the US forces\' AFG '
          'motorcycle plate, whose digits run from one to three.',
      entries: <GalleryEntry>[
        _entry(
          'government',
          'Government',
          GreecePlates.government,
          GreeceThemes.government,
        ),
        _entry('police', 'Police', GreecePlates.police, GreeceThemes.police),
        _entry('afg', 'AFG motorcycle', GreecePlates.afg, GreeceThemes.afg),
      ],
    ),
  ];
  List<GallerySection>? _sections;
}
