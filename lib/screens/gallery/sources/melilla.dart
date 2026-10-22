import 'package:spain_plate/spain_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `melilla_plate`: Spain's national series as issued in Melilla. Diplomatic embassy
/// code 83 is refused with "COUNTRY NOT FOUND" by the spec and the validator.
class MelillaSource extends GallerySource {
  MelillaSource();

  @override
  String get countryName => 'Melilla';

  @override
  String get packageName => 'melilla_plate';

  @override
  String get note =>
      'Spain\'s national series as issued in Melilla. Diplomatic embassy code 83 is refused in every layer with "COUNTRY NOT FOUND".';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const MelillaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: MelillaCountry.melilla,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration — 500 × 110',
      note: 'Four digits and a three-consonant counter, one slot each.',
      entries: <GalleryEntry>[
        _e('me.private', 'Private', MelillaPlates.private, MelillaThemes.private, <String?>[
          '2008',
          'ZGZ',
        ]),
        _e('me.historic', 'Historic', MelillaPlates.historic, MelillaThemes.historic, <String?>[
          '7010',
          'BBD',
        ]),
        _e('me.taxi', 'Taxi', MelillaPlates.taxi, MelillaThemes.taxi, <String?>['6334', 'HRD']),
        _e('me.trailer', 'Trailer', MelillaPlates.trailer, MelillaThemes.trailer, <String?>[
          '7286',
          'BBW',
        ]),
        _e(
          'me.provisional',
          'Provisional',
          MelillaPlates.provisional,
          MelillaThemes.provisional,
          <String?>['1588', 'BBS'],
        ),
        _e('me.dealer', 'Dealer', MelillaPlates.dealer, MelillaThemes.dealer, <String?>[
          '1746',
          'BCD',
        ]),
      ],
    ),
    GallerySection(
      title: 'State and diplomatic',
      note: '',
      entries: <GalleryEntry>[
        _e('me.police', 'Police', MelillaPlates.police, MelillaThemes.police, <String?>[
          'CME',
          '2342',
        ]),
        _e(
          'me.diplomatic',
          'Diplomatic',
          MelillaPlates.diplomatic,
          MelillaThemes.diplomatic,
          <String?>['CD', '1', '001'],
        ),
        _e('me.consular', 'Consular', MelillaPlates.diplomatic, MelillaThemes.consular, <String?>[
          'CC',
          '10',
          '014',
        ]),
        _e(
          'me.organisation',
          'International organisation',
          MelillaPlates.diplomatic,
          MelillaThemes.organisation,
          <String?>['OI', '303', '073'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
