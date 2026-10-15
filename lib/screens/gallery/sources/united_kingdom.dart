import 'package:plate_core/plate_core.dart';
import 'package:united_kingdom_plate/united_kingdom_plate.dart';

import '../catalogue.dart';

/// `united_kingdom_plate`: the 2001 `AA11 AAA` format and its variants. Every
/// field is one slot, so a sample value is one string per field.
class UnitedKingdomSource extends GallerySource {
  UnitedKingdomSource();

  @override
  String get countryName => 'United Kingdom';

  @override
  String get packageName => 'united_kingdom_plate';

  @override
  String get note =>
      'Black on white at the front, black on yellow at the rear; the optional '
      'left band is UK, a nation, or zero-emission green. Historic, forces, '
      'trailer, trade and diplomatic designs differ in fields and colour only.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    PlateCountry country = UnitedKingdomCountry.united_kingdom,
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: country,
    validator: const UnitedKingdomValidator(),
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current format — AA11 AAA',
      note:
          'Area code, age identifier, three random letters. Ink is ~60% of '
          'the reference height (glyph engine limit).',
      entries: <GalleryEntry>[
        _e(
          'gb.rear',
          'Rear (yellow)',
          UnitedKingdomPlates.standard,
          UnitedKingdomThemes.rear,
          <String?>['BD', '51', 'SMR'],
        ),
        _e(
          'gb.front',
          'Front (white)',
          UnitedKingdomPlates.standard,
          UnitedKingdomThemes.front,
          <String?>['BD', '51', 'SMR'],
          country: UnitedKingdomCountry.front,
        ),
        _e(
          'gb.band.uk',
          'Rear with UK band',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.rear,
          <String?>['BD', '51', 'SMR'],
        ),
        _e(
          'gb.band.zev',
          'Zero-emission rear',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.rear,
          <String?>['BD', '51', 'SMR'],
          country: UnitedKingdomCountry.zev,
        ),
        _e(
          'gb.band.zev.front',
          'Zero-emission front',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.front,
          <String?>['BD', '51', 'SMR'],
          country: UnitedKingdomCountry.zev,
        ),
        _e(
          'gb.band.eng',
          'England band',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.rear,
          <String?>['PA', '51', 'ABC'],
          country: UnitedKingdomCountry.england,
        ),
        _e(
          'gb.band.sco',
          'Scotland band',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.rear,
          <String?>['SA', '51', 'ABC'],
          country: UnitedKingdomCountry.scotland,
        ),
        _e(
          'gb.band.cym',
          'Wales band',
          UnitedKingdomPlates.banded,
          UnitedKingdomThemes.rear,
          <String?>['CA', '51', 'ABC'],
          country: UnitedKingdomCountry.wales,
        ),
      ],
    ),
    GallerySection(
      title: 'Other designs',
      note:
          'The motorcycle layout is the regulation 229 × 178, estimated; '
          'the trade plate omits the DVLA crest.',
      entries: <GalleryEntry>[
        _e(
          'gb.motorcycle',
          'Motorcycle',
          UnitedKingdomPlates.motorcycle,
          UnitedKingdomThemes.rear,
          <String?>['BD', '51', 'SMR'],
        ),
        _e(
          'gb.ni',
          'Northern Ireland',
          UnitedKingdomPlates.northernIreland,
          UnitedKingdomThemes.rear,
          <String?>['BTZ', '1999'],
        ),
        _e(
          'gb.historic',
          'Historic (pre-1980)',
          UnitedKingdomPlates.historic,
          UnitedKingdomThemes.historic,
          <String?>['KAF', '762', 'L'],
        ),
        _e(
          'gb.diplomatic',
          'Diplomatic',
          UnitedKingdomPlates.diplomatic,
          UnitedKingdomThemes.rear,
          <String?>['127', 'D', '932'],
        ),
        _e(
          'gb.forces',
          'Armed forces',
          UnitedKingdomPlates.armedForces,
          UnitedKingdomThemes.armedForces,
          <String?>['JJ', '33', 'PP'],
        ),
        _e(
          'gb.trailer',
          'Trailer',
          UnitedKingdomPlates.trailer,
          UnitedKingdomThemes.rear,
          <String?>['C', '335004'],
        ),
        _e(
          'gb.trade',
          'Trade',
          UnitedKingdomPlates.trade,
          UnitedKingdomThemes.trade,
          <String?>['65591'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
