import 'package:bhutan_plate/bhutan_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bhutan_plate`: the BP series by usage colour, the three-letter police and
/// royal guard plates, and the four-digit diplomatic plate.
class BhutanSource extends GallerySource {
  BhutanSource();

  @override
  String get countryName => 'Bhutan';

  @override
  String get packageName => 'bhutan_plate';

  @override
  String get note =>
      'A BP prefix, a region digit, a class letter and four digits, in a '
      'colour per usage: white for private, red for government, yellow for '
      'taxis. Police and the royal guard take three letters, and diplomatic '
      'plates four digits. Not drawn: the two-line and motorcycle plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const BhutanValidator(),
  }) => GalleryEntry(
    id: 'bt.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: BhutanCountry.bhutan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil',
      note: 'BP, a region digit, a class letter and four digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private · white', BhutanPlates.private, BhutanThemes.private, 'BP 1 A 2345'),
        _e(
          'government',
          'Government · red',
          BhutanPlates.government,
          BhutanThemes.government,
          'BG 2 B 3456',
        ),
        _e('taxi', 'Taxi · yellow', BhutanPlates.taxi, BhutanThemes.taxi, 'BT 3 C 4567'),
      ],
    ),
    GallerySection(
      title: 'Official',
      note:
          'Three letters for police and the royal guard; digits for '
          'diplomatic missions.',
      entries: <GalleryEntry>[
        _e(
          'police',
          'Police · blue',
          BhutanPlates.police,
          BhutanThemes.police,
          'RBP 1234',
          validator: const BhutanValidator.police(),
        ),
        _e(
          'royalguard',
          'Royal guard',
          BhutanPlates.royalGuard,
          BhutanThemes.royalGuard,
          'RBG 5678',
          validator: const BhutanValidator.royalGuard(),
        ),
        _e(
          'diplomatic',
          'Diplomatic',
          BhutanPlates.diplomatic,
          BhutanThemes.diplomatic,
          '12 34',
          validator: const BhutanDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
