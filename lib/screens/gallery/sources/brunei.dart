import 'package:brunei_plate/brunei_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `brunei_plate`: one single-row design on three liveries, and the
/// diplomatic plate.
class BruneiSource extends GallerySource {
  BruneiSource();

  @override
  String get countryName => 'Brunei';

  @override
  String get packageName => 'brunei_plate';

  @override
  String get note =>
      'One 533×152 single-row plate in white on black, taxi green and BX '
      'yellow, and the white NN·NN·DC diplomatic plate. Dealer and royal '
      'plates are left out: the article gives no image to measure. No '
      'Israel-specific value exists, so nothing is restricted.';

  GalleryEntry _single(
    String id,
    String label,
    String values,
    int prefix,
    int digits,
    PlateTheme theme, {
    bool suffix = false,
    String? note,
  }) {
    final PlateSpec spec = BruneiPlates.singleRow(
      prefix: prefix,
      digits: digits,
      suffix: suffix,
    );
    return GalleryEntry(
      id: 'bn.$id',
      label: label,
      spec: spec,
      theme: theme,
      country: BruneiCountry.brunei,
      validator: const BruneiValidator(),
      sampleValues: values.split(''),
      note: note,
    );
  }

  GalleryEntry _diplomatic(
    String id,
    String label,
    String values,
    int missionDigits,
  ) => GalleryEntry(
    id: 'bn.$id',
    label: label,
    spec: BruneiPlates.diplomatic(missionDigits: missionDigits),
    theme: BruneiThemes.diplomatic,
    country: BruneiCountry.brunei,
    validator: const BruneiDiplomaticValidator(),
    sampleValues: values.split(''),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Single row',
      note:
          'B for Brunei-Muara, K for Kuala Belait; letters then up to four '
          'digits, no leading zero, I and O never issued. The cells shrink '
          'as the registration grows so every glyph stays full size. Ink is '
          'about three quarters of the real height, which the engine cannot '
          'reach on a 152 mm plate.',
      entries: <GalleryEntry>[
        _single(
          'private',
          'Private · white on black',
          'KA51',
          2,
          2,
          BruneiThemes.standard,
        ),
        _single(
          'long',
          'Private · three letters',
          'BAA1234',
          3,
          4,
          BruneiThemes.standard,
        ),
        _single(
          'military',
          'Military · MOD',
          'MOD1925A',
          3,
          4,
          BruneiThemes.standard,
          suffix: true,
          note: 'MOD, the number and a letter for the branch.',
        ),
        _single(
          'taxi',
          'Taxi and bus · white on green',
          'KP4708',
          2,
          4,
          BruneiThemes.taxi,
          note: 'Sampled from one small photograph of a bus.',
        ),
        _single(
          'yellow',
          'BX series · black on yellow',
          'BX9096',
          2,
          4,
          BruneiThemes.yellow,
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'A sequential number, the mission’s number (the United States is '
          '9) and DC for diplomat’s car, black on white with a thin rim.',
      entries: <GalleryEntry>[
        _diplomatic('dc', 'Diplomatic · 03·26·DC', '0326', 2),
        _diplomatic('dc1', 'Diplomatic · 01·2·DC', '012', 1),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
