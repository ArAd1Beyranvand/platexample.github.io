import 'package:austria_plate/austria_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `austria_plate`: the current series. The diplomatic entry's spec and
/// validator both refuse mission code 33 with "COUNTRY NOT FOUND".
class AustriaSource extends GallerySource {
  AustriaSource();

  @override
  String get countryName => 'Austria';

  @override
  String get packageName => 'austria_plate';

  @override
  String get note =>
      'Euroband and a red-white-red triband around black on white; the '
      'district letters, the state\'s arms, digits, letters. Diplomatic '
      'mission code 33 is refused in every layer with "COUNTRY NOT FOUND".';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: AustriaCountry.austria,
    validator: const AustriaValidator(),
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One line — 520 × 120',
      note:
          'The documented size. Each plate carries the arms in its reference '
          'photo, not its own district\'s; ink is ~97% of reference height.',
      entries: <GalleryEntry>[
        _e('at.private', 'Ordinary', AustriaPlates.private, AustriaThemes.standard, <String?>[
          'S',
          '578',
          'IL',
        ]),
        _e('at.electric', 'Electric', AustriaPlates.electric, AustriaThemes.electric, <String?>[
          'FK',
          '112',
          'FZ',
        ]),
        _e(
          'at.personalised',
          'Personalised',
          AustriaPlates.personalised,
          AustriaThemes.standard,
          <String?>['DO', 'BUS', '3'],
        ),
        _e('at.federal', 'Federal', AustriaPlates.federal, AustriaThemes.standard, <String?>[
          'A',
          '1000',
        ]),
        _e('at.fire', 'Fire brigade', AustriaPlates.fire, AustriaThemes.standard, <String?>[
          'FW',
          '200',
          'B',
        ]),
        _e(
          'at.diplomatic',
          'Diplomatic (WD)',
          AustriaPlates.diplomatic,
          AustriaThemes.standard,
          <String?>['WD', '15'],
          note: 'The number is the mission code. Try typing 33.',
        ),
        _e('at.trailer', 'Foreign trailer', AustriaPlates.trailer, AustriaThemes.trailer, <String?>[
          'B',
          '611',
          'IM',
        ]),
        _e('at.export', 'Export transit', AustriaPlates.export, AustriaThemes.export, <String?>[
          'B',
          '10',
          'VB',
        ], note: 'The round validity sticker is not drawn.'),
        _e('at.temporary', 'Temporary', AustriaPlates.temporary, AustriaThemes.temporary, <String?>[
          'FK',
          '19',
          'YM',
          '24',
        ], note: 'Estimated from a partial, tilted photo.'),
      ],
    ),
    GallerySection(
      title: 'Two line',
      note: 'The moped shield is drawn as a rectangle, estimated from a photo.',
      entries: <GalleryEntry>[
        _e('at.moped', 'Moped', AustriaPlates.moped, AustriaThemes.moped, <String?>[
          'UU',
          '3',
          'XHW',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
