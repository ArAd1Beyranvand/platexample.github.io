import 'dart:math';

import 'package:bolivia_plate/bolivia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bolivia_plate`: the 300 × 152 PTA plate in its three services, the
/// diplomatic, consular and international plates, and the Mercosur plate.
class BoliviaSource extends GallerySource {
  BoliviaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1825);

  @override
  String get countryName => 'Bolivia';

  @override
  String get packageName => 'bolivia_plate';

  @override
  String get note =>
      'Blue on white under BOLIVIA: the PTA number, the flag, and the '
      "department's letter in a box whose fill gives the service.";

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    PlateValidator validator = const BoliviaValidator(),
    List<String?>? values,
  }) => GalleryEntry(
    id: 'bo.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BoliviaCountry.bolivia,
    validator: validator,
    sampleValues: values ?? BoliviaSerialGenerator.generate(spec, random: _rng),
  );

  static final Map<BoliviaMission, PlateTheme> _missionThemes =
      <BoliviaMission, PlateTheme>{
        BoliviaMission.consular: BoliviaThemes.consular,
        BoliviaMission.diplomatic: BoliviaThemes.diplomatic,
        BoliviaMission.international: BoliviaThemes.mission,
        BoliviaMission.organization: BoliviaThemes.organization,
      };

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'PTA — 300 × 152',
      note:
          'Three or four digits and three letters. The department box is '
          'white for private cars, red for public service, yellow for the '
          'state. The serial reads about half the real height.',
      entries: <GalleryEntry>[
        _entry(
          'standard',
          'Private · 1852PHD',
          BoliviaPlates.standard(),
          BoliviaThemes.standard,
          values: <String?>['1', '8', '5', '2', 'P', 'H', 'D', 'L'],
        ),
        _entry(
          'standard3',
          'Private · three digits',
          BoliviaPlates.standard(digits: 3),
          BoliviaThemes.standard,
        ),
        _entry(
          'public',
          'Public service · red box',
          BoliviaPlates.standard(service: BoliviaService.public),
          BoliviaThemes.standard,
        ),
        _entry(
          'government',
          'Government · yellow box',
          BoliviaPlates.standard(service: BoliviaService.government),
          BoliviaThemes.standard,
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and international',
      note:
          "The mission's country, its status, and the vehicle's rank. Only "
          'the red CD plate is photographed; the other colours follow the '
          "article's wording.",
      entries: <GalleryEntry>[
        for (final BoliviaMission m in BoliviaMission.values)
          _entry(
            'special.${m.id}',
            '${m.english} · ${m.code}',
            BoliviaPlates.special(m),
            _missionThemes[m]!,
            validator: const BoliviaSpecialValidator(),
          ),
      ],
    ),
    GallerySection(
      title: 'Mercosur — 400 × 130',
      note: 'Two letters and five digits under the blue band.',
      entries: <GalleryEntry>[
        _entry(
          'mercosur',
          'Mercosur · AB 12345',
          BoliviaPlates.mercosur,
          BoliviaThemes.mercosur,
          validator: const BoliviaMercosurValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
