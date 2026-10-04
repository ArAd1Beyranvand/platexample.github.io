import 'package:plate_core/plate_core.dart';
import 'package:germany_plate/germany_plate.dart';

import '../catalogue.dart';

/// `germany_plate` is one face in many shapes, and then four formats that are
/// not registrations at all.
///
/// The car plate is not a fixed geometry: the area code runs to three letters,
/// the identifier to two letters and four digits, and the whole thing is capped
/// at eight characters — so `GermanPlates.carFor` builds 23 legal shapes and a
/// plate with few characters is a *shorter plate*, not a wider-tracked one.
/// The first section shows that with five of the shapes rather than all 23:
/// the rest are the same story with different counts, and the package's own
/// `allCars` is there for a caller that wants them.
///
/// What the other sections are for is the opposite point — a German plate is
/// not one design. The green tax-exempt plate, the `H` and `E` suffixes and the
/// seasonal block are the car plate re-inked and re-printed; the `06`, `07`,
/// `04`, export and Bundeswehr numbers are their own geometries, and none of
/// them is judged by [GermanPlateValidator]. Every entry here asks
/// [GermanPlates.validatorFor] which rule applies rather than naming one, which
/// is exactly the mistake the package added that method to prevent: handing a
/// dealer plate the registration validator paints a correct plate red.
class GermanySource extends GallerySource {
  const GermanySource();

  @override
  String get countryName => 'Germany';

  @override
  String get packageName => 'germany_plate';

  @override
  String get note =>
      'Every registration length from three characters to eight, the green, '
      'historic, electric and seasonal variants, and the plates that are not '
      'registrations: 06 dealer, 07 collector, 04 short-term, export and '
      'Bundeswehr. Each format has its own validator.';

  /// One entry, with the rule the package itself picks for the spec.
  ///
  /// No `theme:` and no `country:` anywhere in this adapter: the ink a green or
  /// a red plate is printed in is `PlateSpec.inkOverride`, and the Bundeswehr's
  /// flag block is `GermanyCountry.bundeswehr` on its own spec. Both are
  /// properties of the format rather than liveries a host chooses, which is the
  /// inverse of Lebanon.
  static GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    validator: GermanPlates.validatorFor(spec),
    sampleValues: values,
    note: note,
  );

  /// Built once, and returned by identity: the pickers select by equality.
  @override
  List<GallerySection> get sections => _sections;

  /// Three plates, not one per section: the plain car, Bundeswehr, then the
  /// numbers that expire. "Car — the variants" (green tax-exempt, historic,
  /// electric, seasonal) and "Not registrations — the 06 and 07 numbers" are
  /// left off the shelf entirely — a first-time visitor reads those as
  /// damaged or mis-issued registrations rather than the deliberate variants
  /// and non-registration formats they are. Both stay in `sections` and so
  /// still surface on the country's own "More" screen.
  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    _sections[0].entries.first, // Car — the shapes: the plain car.
    _sections[4].entries.first, // Bundeswehr: Y-751 957.
    _sections[3].entries.first, // Numbers that expire: short-term · 04.
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Car — the shapes',
      note:
          'An area code of one to three letters, the two round stickers, then '
          'an identifier of one or two letters and one to four digits — eight '
          'characters at the very most. The character sizes are fixed by law, '
          'so a shorter registration is a shorter plate: watch the canvas end '
          'where the last digit does.',
      entries: <GalleryEntry>[
        _entry('de.car', 'Car · DA X 1953', GermanPlates.car, const <String?>[
          'D',
          'A',
          'X',
          '1',
          '9',
          '5',
          '3',
        ], note: 'The common shape: two letters, group d. `GermanPlates.car`.'),
        _entry(
          'de.car.a',
          'Short · M A 1',
          GermanPlates.carFor(
            districtLetters: 1,
            group: GermanIdentifierGroup.a,
            digits: 1,
          ),
          const <String?>['M', 'A', '1'],
          note: 'Three characters — the shortest plate the law issues.',
        ),
        _entry(
          'de.car.b',
          'Two letters, two digits · FR OM 93',
          GermanPlates.carFor(
            districtLetters: 2,
            group: GermanIdentifierGroup.b,
            digits: 2,
          ),
          const <String?>['F', 'R', 'O', 'M', '9', '3'],
        ),
        _entry(
          'de.car.c',
          'Three-letter area code · CUX DP 150',
          GermanPlates.carFor(
            districtLetters: 3,
            group: GermanIdentifierGroup.c,
          ),
          const <String?>['C', 'U', 'X', 'D', 'P', '1', '5', '0'],
          note:
              'Eight characters, the cap. Group e behind a three-letter code would be nine, and throws.',
        ),
        _entry(
          'de.car.e',
          'Longest identifier · KA AB 1234',
          GermanPlates.carFor(
            districtLetters: 2,
            group: GermanIdentifierGroup.e,
          ),
          const <String?>['K', 'A', 'A', 'B', '1', '2', '3', '4'],
        ),
      ],
    ),
    GallerySection(
      title: 'Car — the variants',
      note:
          'Still registrations, still GermanPlateValidator, still the same '
          'geometry underneath: what changes is the ink, a printed suffix, or '
          'a block of months at the right-hand end. The suffixes are labels '
          'rather than slots — an H that could be typed over would invite a '
          'plate reading "…39Q" — and they count against the eight-character '
          'cap, because on a real plate they do.',
      entries: <GalleryEntry>[
        _entry(
          'de.car.green',
          'Tax-exempt · green ink',
          GermanPlates.greenFor(),
          const <String?>['G', 'T', 'A', '7', '4', '2', '1'],
          note:
              'An ambulance, a tractor, a farm trailer. Only the ink changes — the euroband stays blue.',
        ),
        _entry(
          'de.car.historic',
          'Historic · HL TL 15H',
          GermanPlates.historicFor(
            districtLetters: 2,
            group: GermanIdentifierGroup.b,
            digits: 2,
          ),
          const <String?>['H', 'L', 'T', 'L', '1', '5'],
          note:
              'Thirty years old and preservation-worthy. The H is printed hard against the serial.',
        ),
        _entry(
          'de.car.electric',
          'Electric · LER OO 39E',
          GermanPlates.electricFor(
            districtLetters: 3,
            group: GermanIdentifierGroup.b,
            digits: 2,
          ),
          const <String?>['L', 'E', 'R', 'O', 'O', '3', '9'],
          note:
              'Plug-in, per the 2015 Electric Mobility Act. Eight characters with the E counted.',
        ),
        _entry(
          'de.car.seasonal',
          'Seasonal · March to October',
          GermanPlates.seasonalFor(),
          const <String?>[
            'M',
            'K',
            'S',
            '8',
            '1',
            '1',
            '2',
            '0',
            '3',
            '1',
            '0',
          ],
          note:
              'Two months, rule between them. 11 over 03 is a winter vehicle — neither has to precede the other.',
        ),
      ],
    ),
    GallerySection(
      title: 'Not registrations — the 06 and 07 numbers',
      note:
          'Red on white, no identifier letters, and a five-digit number that '
          'opens with a leading zero — three things a registration may never '
          'do. Held by a garage or a collector rather than issued against a '
          'vehicle, so GermanSerialPlateValidator judges them and the '
          'registration rules do not apply.',
      entries: <GalleryEntry>[
        _entry(
          'de.dealer',
          'Dealer · 06',
          GermanPlates.dealerFor(),
          const <String?>['D', 'A', '0', '6', '7', '4', '1'],
          note: 'Moved between vehicles for test drives and transfers.',
        ),
        _entry(
          'de.collector',
          'Collector · 07',
          GermanPlates.collectorFor(),
          const <String?>['S', 'B', '0', '7', '2', '1', '9'],
          note:
              'The seal alone, no inspection sticker: these vehicles are not in regular service.',
        ),
      ],
    ),
    GallerySection(
      title: 'Numbers that expire',
      note:
          'No euroband at all, and a full-height coloured band at the right '
          'carrying the expiry date stacked DD over MM over YY. The date is '
          'slots, not print: a plate whose whole point is that it expires has '
          'no business printing a fixed day. GermanDatedPlateValidator checks '
          'the day against the month, so 31/04 is rejected.',
      entries: <GalleryEntry>[
        _entry(
          'de.shortterm',
          'Short-term · 04 · yellow band',
          GermanPlates.shortTermFor(),
          const <String?>[
            'M',
            'K',
            '0',
            '4',
            '4',
            '0',
            '1',
            '2',
            '9',
            '0',
            '9',
            '2',
            '6',
          ],
          note:
              'Four weeks at most — transfers, test drives, temporary registration.',
        ),
        _entry(
          'de.export',
          'Export · red band',
          GermanPlates.exportFor(),
          const <String?>[
            'H',
            'H',
            '1',
            '7',
            '8',
            '2',
            '3',
            '3',
            '1',
            '1',
            '2',
            '2',
            '6',
          ],
          note:
              'Ausfuhrkennzeichen, up to a year. The same plate as the 04; the band colour is the difference.',
        ),
      ],
    ),
    GallerySection(
      title: 'Bundeswehr',
      note:
          'The flag printed straight onto the white face where the blue block '
          'would be — a military plate is not an EU registration — then a Y, a '
          'printed hyphen, and six digits in two triples. The Y has been the '
          'armed forces\' mark since 1956 and stands for nothing: it was '
          'picked because no district used it.',
      entries: <GalleryEntry>[
        _entry(
          'de.bundeswehr',
          'Y-751 957',
          GermanPlates.bundeswehrFor(),
          const <String?>['Y', '7', '5', '1', '9', '5', '7'],
          note:
              'The Y is a slot, and GermanBundeswehrValidator is what says it must read Y.',
        ),
      ],
    ),
  ];
}
