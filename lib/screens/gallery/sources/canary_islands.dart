import 'package:canary_islands_plate/canary_islands_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `canary_islands_plate`: Spain's national series as issued in the Canary
/// Islands. Diplomatic embassy code 83 is refused with "COUNTRY NOT FOUND" by
/// the spec and the validator.
class CanaryIslandsSource extends GallerySource {
  CanaryIslandsSource();

  @override
  String get countryName => 'Canary Islands';

  @override
  String get packageName => 'canary_islands_plate';

  @override
  String get note =>
      'The EU band and `1234 BCD` in black on white, with coloured fields for '
      'taxi, trailer, provisional, dealer, police and diplomatic plates. '
      'Embassy code 83 is refused in every layer with "COUNTRY NOT FOUND".';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: CanaryIslandsCountry.canary_islands,
    validator: const CanaryIslandsValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration — 500 × 110',
      note: 'Four digits and a three-consonant counter, one slot each.',
      entries: <GalleryEntry>[
        _e(
          'ic.private',
          'Private',
          CanaryIslandsPlates.private,
          CanaryIslandsThemes.private,
          <String?>['1234', 'BCD'],
        ),
        _e(
          'ic.historic',
          'Historic',
          CanaryIslandsPlates.historic,
          CanaryIslandsThemes.historic,
          <String?>['7010', 'BBD'],
        ),
        _e('ic.taxi', 'Taxi', CanaryIslandsPlates.taxi, CanaryIslandsThemes.taxi, <String?>[
          '6334',
          'HRD',
        ]),
        _e(
          'ic.trailer',
          'Trailer',
          CanaryIslandsPlates.trailer,
          CanaryIslandsThemes.trailer,
          <String?>['7286', 'BBW'],
        ),
        _e(
          'ic.provisional',
          'Provisional',
          CanaryIslandsPlates.provisional,
          CanaryIslandsThemes.provisional,
          <String?>['1588', 'BBS'],
        ),
        _e('ic.dealer', 'Dealer', CanaryIslandsPlates.dealer, CanaryIslandsThemes.dealer, <String?>[
          '1746',
          'BCD',
        ]),
      ],
    ),
    GallerySection(
      title: 'State and diplomatic',
      note: 'Police, diplomatic, consular and international-organisation plates.',
      entries: <GalleryEntry>[
        _e(
          'ic.police',
          'Mossos d\'Esquadra',
          CanaryIslandsPlates.police,
          CanaryIslandsThemes.police,
          <String?>['CME', '2342'],
        ),
        _e(
          'ic.diplomatic',
          'Diplomatic',
          CanaryIslandsPlates.diplomatic,
          CanaryIslandsThemes.diplomatic,
          <String?>['CD', '1', '001'],
        ),
        _e(
          'ic.consular',
          'Consular',
          CanaryIslandsPlates.diplomatic,
          CanaryIslandsThemes.consular,
          <String?>['CC', '10', '014'],
        ),
        _e(
          'ic.organisation',
          'International organisation',
          CanaryIslandsPlates.diplomatic,
          CanaryIslandsThemes.organisation,
          <String?>['OI', '303', '073'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
