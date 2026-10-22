import 'package:iranshahr_plate/iranshahr_plate.dart';
import 'package:plate_core/plate_core.dart';

import 'sources.dart';

/// The Iranshahr umbrella source, showing every country in the package at once
/// on the Discover index. When users click "All plates", they navigate to
/// `/iranshahr`, which displays the countries as separate groups like the
/// Discover page itself.
class IranshahirSource extends GallerySource {
  const IranshahirSource();

  @override
  String get countryName => 'Iranshahr';

  @override
  List<String> get countryNames => <String>[
    for (final GallerySource member in members) ...member.countryNames,
  ];

  @override
  String get packageName => 'iranshahr_plate';

  @override
  List<GallerySource> get members => iranshahirCountries;

  @override
  String get overviewTitle => 'Fourteen countries, one package';

  @override
  String get note =>
      'Fourteen countries in one package: Bahrain, Azerbaijan, Afghanistan, '
      'Armenia, Tajikistan, Kuwait, Qatar, Iraq, the UAE, Turkey, Oman, '
      'Kazakhstan, Uzbekistan and Turkmenistan. They share no design; each '
      'has its own specs, colours and country block.';

  /// Built once, and returned by identity: the pickers select a section by
  /// equality, and a fresh list per read would make the selected one never
  /// equal the one in the list.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    for (final GallerySection section in sections)
      if (section.entries.isNotEmpty) section.entries[0],
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Bahrain',
      note:
          'Left-to-right Latin digits, a grey security band down the right on '
          'every class, and the wording set at both ends as labels. The panel '
          'is the flag on the civilian plates and a colour band on the other '
          'two.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'bh.eu',
          label: 'Civilian (EU size)',
          spec: BahrainPlates.eu,
          theme: BahrainThemes.civilian,
          sampleValues: const <String?>['123456'],
        ),
        GalleryEntry(
          id: 'bh.us',
          label: 'Civilian (US size)',
          spec: BahrainPlates.us,
          theme: BahrainThemes.civilian,
          note: 'Same six digits as the EU size, re-laid in two bands.',
          sampleValues: const <String?>['407219'],
        ),
        GalleryEntry(
          id: 'bh.bicycle',
          label: 'Bicycle',
          spec: BahrainPlates.bicycle,
          theme: BahrainThemes.civilian,
          sampleValues: const <String?>['8135'],
        ),
        GalleryEntry(
          id: 'bh.diplomatic',
          label: 'Diplomatic corps',
          spec: BahrainPlates.diplomatic,
          theme: BahrainThemes.diplomatic,
          note: 'Green head band, wording reversed out white.',
          sampleValues: const <String?>['042'],
        ),
        GalleryEntry(
          id: 'bh.police',
          label: 'Police',
          spec: BahrainPlates.police,
          theme: BahrainThemes.police,
          sampleValues: const <String?>['2609'],
        ),
      ],
    ),
    GallerySection(
      title: 'Azerbaijan',
      note:
          'Five plates over four specs. The class is the colour of the field '
          'and the grouping of the serial, and nothing else: no divider, no '
          'band, no sticker, and the same white flag-over-AZ block on every '
          'one. The blue transport plate is the car spec in another theme — '
          'which is why two entries here share `AzerbaijanPlates.car`.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'az.car',
          label: 'Car',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.civilian,
          sampleValues: const <String?>['88', 'BE', '114'],
        ),
        GalleryEntry(
          id: 'az.car.transport',
          label: 'Bus / taxi',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.transport,
          note: 'The car spec, printed blue. Privately owned public transport.',
          sampleValues: const <String?>['10', 'TH', '308'],
        ),
        GalleryEntry(
          id: 'az.bicycle',
          label: 'Motorcycle',
          spec: AzerbaijanPlates.bicycle,
          theme: AzerbaijanThemes.civilian,
          note: 'The same groups as the car, in two rows and one letter short.',
          sampleValues: const <String?>['07', 'T', '096'],
        ),
        GalleryEntry(
          id: 'az.diplomatic',
          label: 'Diplomatic corps',
          spec: AzerbaijanPlates.diplomatic,
          theme: AzerbaijanThemes.diplomatic,
          note: 'Mission code, class letter, serial — told apart by gaps, not hyphens.',
          sampleValues: const <String?>['013', 'D', '004'],
        ),
        GalleryEntry(
          id: 'az.foreign',
          label: 'Foreign-owned company',
          spec: AzerbaijanPlates.foreign,
          theme: AzerbaijanThemes.foreign,
          note: 'The one coloured field that keeps the civilian black ink.',
          sampleValues: const <String?>['H', '023', '149'],
        ),
      ],
    ),
    GallerySection(
      title: 'Afghanistan',
      note:
          'Fifteen plates over eleven specs, and the only bilingual design in '
          'this package: the serial is printed twice — iranian Arabic numerals '
          'over Latin figures — and so is the class, as a Persian letter over '
          'its Latin code. Both pairs are one value echoed by a `PlateMirror`, '
          'which is why the last sample value of most entries below is a '
          'single letter and two things on the plate change with it. The block '
          'at the hoist end is the province, passed per entry — name over the '
          'Darul Aman emblem over a three-letter code — so `af.car5` is a '
          'Herat plate and a Kabul taxi without being two specs.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'af.car5.private',
          label: 'Private (five figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note: 'The ordinary plate: `ش` over `PRV`, and Herat\'s block.',
          sampleValues: const <String?>['12346', 'P'],
        ),
        GalleryEntry(
          id: 'af.car4.private',
          label: 'Private (four figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.zabul.country(),
          note: 'Same design, one figure shorter — the figures sit centred in the same field.',
          sampleValues: const <String?>['1234', 'P'],
        ),
        GalleryEntry(
          id: 'af.car3.private',
          label: 'Private (three figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.takhar.country(),
          sampleValues: const <String?>['123', 'P'],
        ),
        GalleryEntry(
          id: 'af.kabul6',
          label: 'Kabul (six figures)',
          spec: AfghanistanPlates.kabul6,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          note:
              'Kabul exhausted five figures. The sixth is printed once, in Persian only, between two hyphens.',
          sampleValues: const <String?>['5', '12346', 'P'],
        ),
        GalleryEntry(
          id: 'af.car5.taxi',
          label: 'Taxi',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The private geometry, printed yellow, with `ت` over `T`.',
          sampleValues: const <String?>['12346', 'T'],
        ),
        GalleryEntry(
          id: 'af.car5.bus',
          label: 'Bus',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The same yellow field as the taxi. One character tells them apart: `ب` over `B`.',
          sampleValues: const <String?>['12346', 'B'],
        ),
        GalleryEntry(
          id: 'af.car5.lorry',
          label: 'Lorry',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          sampleValues: const <String?>['12346', 'L'],
        ),
        GalleryEntry(
          id: 'af.car5.duplicate',
          label: 'Private duplicate',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note:
              'The one class the Persian register cannot distinguish: `ش` above on both, `DUPL` below.',
          sampleValues: const <String?>['12346', 'D'],
        ),
        GalleryEntry(
          id: 'af.cycle3',
          label: 'Motorcycle',
          spec: AfghanistanPlates.cycle,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nimruz.country(),
          note: 'The two-wheeler plate: a longer, shallower rectangle, not a shrunk car plate.',
          sampleValues: const <String?>['123', 'M'],
        ),
        GalleryEntry(
          id: 'af.cycle4',
          label: 'Rickshaw',
          spec: AfghanistanPlates.cycle,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nangarhar.country(),
          sampleValues: const <String?>['1234', 'R'],
        ),
        GalleryEntry(
          id: 'af.diplomatic',
          label: 'Diplomatic corps',
          spec: AfghanistanPlates.diplomatic,
          theme: AfghanistanThemes.diplomatic,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note:
              'The only hyphenated Afghan number, and the only `CD` — printed once, with no Persian counterpart.',
          sampleValues: const <String?>['12', '34'],
        ),
        GalleryEntry(
          id: 'af.governmental',
          label: 'Governmental',
          spec: AfghanistanPlates.governmental,
          theme: AfghanistanThemes.governmental,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note: 'A government vehicle\'s type is not printed: a dash stands in both registers.',
          sampleValues: const <String?>['1234'],
        ),
        GalleryEntry(
          id: 'af.un',
          label: 'United Nations',
          spec: AfghanistanPlates.un,
          theme: AfghanistanThemes.un,
          country: AfghanistanProvince.kabul.country(),
          note:
              'The plainest of the eleven: the province block and the number, and nothing at the head.',
          sampleValues: const <String?>['1234'],
        ),
        GalleryEntry(
          id: 'af.temporary',
          label: 'Private temporary',
          spec: AfghanistanPlates.temporary,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(showCode: false),
          note: 'Issued from 2023, valid three years. The one Afghan plate printed in two inks.',
          sampleValues: const <String?>['12346'],
        ),
        GalleryEntry(
          id: 'af.international',
          label: 'Cross-border (Herat, 2026)',
          spec: AfghanistanPlates.international,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note:
              'Latin figures and a spelled-out category, no Persian half. Reconstructed from text — no photograph exists.',
          sampleValues: const <String?>['12346', 'B'],
        ),
      ],
    ),
    GallerySection(
      title: 'Armenia',
      note:
          'Ten designs on a German-style face: flag over `AM`, a silver '
          'identifier band, and `NN LL NNN` told apart by gaps alone — no '
          'hyphen, no divider. Two things here are rules rather than shapes. '
          'The letters are Latin because the four the system opened with in '
          '1996 were Armenian letters chosen to *look* Latin (`Ս` as `U`, `Տ` '
          'as `S`, `Օ` as `O`), and `G` and `I` are still issued to the Police '
          'and the Prosecutor alone. And a state plate reverses the number to '
          '`NNN LL NN`, where the trailing four characters are not a serial '
          'but an institution: `NN 01` is the Security Council, `GG 01` the '
          'Prosecutor\'s office.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'am.car',
          label: 'Private car',
          spec: ArmeniaPlates.car,
          theme: ArmeniaThemes.civilian,
          note:
              'The 2014 design: region code, two letters, three digits, and the silver band beside the flag.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.carTwoRow',
          label: 'Private car (two-row)',
          spec: ArmeniaPlates.carTwoRow,
          theme: ArmeniaThemes.civilian,
          note: 'The same seven characters in the same three groups, on a deeper canvas.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.motorcycle',
          label: 'Motorcycle',
          spec: ArmeniaPlates.motorcycle,
          theme: ArmeniaThemes.civilian,
          note:
              'The two-row plate was found too cumbersome to carry; the gap between region and letters was closed.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.public',
          label: 'State-owned (Security Council)',
          spec: ArmeniaPlates.public,
          theme: ArmeniaThemes.civilian,
          note:
              'The number reversed: `NN 01` names the institution, and only fourteen pairs are issued at all.',
          sampleValues: const <String?>['001', 'NN', '01'],
        ),
        GalleryEntry(
          id: 'am.trailer',
          label: 'Trailer',
          spec: ArmeniaPlates.trailer,
          theme: ArmeniaThemes.civilian,
          note:
              'A pre-2014 design: no identifier band, and the letter count cut to one — most often `L`.',
          sampleValues: const <String?>['290', 'L', '01'],
        ),
        GalleryEntry(
          id: 'am.bus',
          label: 'Bus',
          spec: ArmeniaPlates.bus,
          theme: ArmeniaThemes.bus,
          note:
              'The Soviet public-transport format Armenia kept: `S` for a city bus, `L` for a long-range coach.',
          sampleValues: const <String?>['1234', 'S'],
        ),
        GalleryEntry(
          id: 'am.diplomatic',
          label: 'Diplomatic corps',
          spec: ArmeniaPlates.diplomatic,
          theme: ArmeniaThemes.diplomatic,
          note:
              'Mission code, `D` for a diplomat or `T` for a technician, serial, and Armenia\'s own code at the tail.',
          sampleValues: const <String?>['04', 'D', '057'],
        ),
        GalleryEntry(
          id: 'am.diplomaticArm',
          label: 'Diplomatic corps (current)',
          spec: ArmeniaPlates.diplomaticArm,
          theme: ArmeniaThemes.diplomatic,
          note: 'The same design; newer plates print `ARM` where the older ones print `AM`.',
          sampleValues: const <String?>['04', 'T', '057'],
        ),
        GalleryEntry(
          id: 'am.un',
          label: 'United Nations',
          spec: ArmeniaPlates.un,
          theme: ArmeniaThemes.un,
          note:
              'Three digits between two printed words. Nothing on this plate is chosen but the serial.',
          sampleValues: const <String?>['080'],
        ),
        GalleryEntry(
          id: 'am.military',
          label: 'Ministry of Defence',
          spec: ArmeniaPlates.military,
          theme: ArmeniaThemes.military,
          note:
              'The one Armenian plate with no Latin on it: `ՊՆ` for the ministry, '
              '`Մ` for a passenger vehicle, `Տ` for a transport one.',
          sampleValues: const <String?>['1007', 'M'],
        ),
      ],
    ),
    _tajikistanSection(),
    _kuwaitSection(),
    _qatarSection(),
    _iraqSection(),
    _uaeSection(),
    _turkeySection(),
    _omanSection(),
    _kazakhstanSection(),
    _uzbekistanSection(),
    _turkmenistanSection(),
  ];
}

/// Qatar's section.
///
/// A fresh [GallerySection] each call, for the same reason as Tajikistan's and
/// Kuwait's: [catalogueItems] resolves a [GalleryEntry] back to its
/// [CatalogueItem] by identity, so the umbrella source and [QatarSource] each
/// build their own.
GallerySection _qatarSection() => GallerySection(
  title: 'Qatar',
  note:
      'Three designs, and the only country block in this package that is not a '
      'rectangle. A Qatari car plate opens with the hoist end of the flag '
      'itself — a maroon column cut down its inboard edge by the flag\'s '
      'nine-point serration, with `QATAR` reversed out of it one letter per '
      'line — so the block carries no flag image at all. The shape is '
      '`QatarFlagEdgeClipper`, and its geometry is the official flag\'s own: '
      'nine triangles whose tips reach inboard of a spine at 22/28 of the '
      'block\'s width. After the block the plate is plain — `قطر`, then the '
      'serial, one field of three to five digits. The other two '
      'designs drop the block entirely: the motorcycle plate is near-square and '
      'names the country twice, and the police plate is a blue field ruled into '
      'a serial row over two wording cells.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'qa.civilian',
      label: 'Civilian (five digits)',
      spec: QatarPlates.civilian,
      theme: QatarThemes.civilian,
      note:
          'The everyday registration, and the longest Qatar issues: the serrated maroon block, `قطر`, five digits.',
      sampleValues: const <String?>['25777'],
    ),
    GalleryEntry(
      id: 'qa.civilian4',
      label: 'Civilian (four digits)',
      spec: QatarPlates.civilian,
      theme: QatarThemes.civilian,
      note:
          'Identical furniture. The serial is one field, so a shorter run sits centred in the same room.',
      sampleValues: const <String?>['4071'],
    ),
    GalleryEntry(
      id: 'qa.civilian3',
      label: 'Civilian (three digits)',
      spec: QatarPlates.civilian,
      theme: QatarThemes.civilian,
      note:
          'The shortest ordinary registration — below this, a serial belongs to the royal family.',
      sampleValues: const <String?>['411'],
    ),
    GalleryEntry(
      id: 'qa.motorcycle',
      label: 'Motorcycle',
      spec: QatarPlates.motorcycle,
      theme: QatarThemes.civilian,
      note:
          'A different plate, not a shorter one: near-square, no hoist block, `قطر` over the serial over `QATAR`.',
      sampleValues: const <String?>['25777'],
    ),
    GalleryEntry(
      id: 'qa.police',
      label: 'Police',
      spec: QatarPlates.police,
      theme: QatarThemes.police,
      note:
          'No block and no serration: a blue field ruled into a serial row over `قطر` and `شرطة`.',
      sampleValues: const <String?>['7464'],
    ),
  ],
);

/// Tajikistan's section.
///
/// A fresh [GallerySection] each call: the umbrella source and [TajikistanSource]
/// each build their own, because [catalogueItems] resolves a [GalleryEntry] back
/// to its [CatalogueItem] by identity — sharing one set of entries across the
/// two sources would make that lookup ambiguous, exactly as it would for the
/// other four countries, which duplicate their entries the same way.
GallerySection _tajikistanSection() => GallerySection(
  title: 'Tajikistan',
  note:
      'Nine designs on a European face: the flag over TJ at the hoist end, '
      'Latin letters that are really the shared Cyrillic register wearing Latin '
      'shapes, and the region printed as two digits of the number itself — no '
      'panel, no divider on the civilian plates, told apart by the gaps alone. '
      'Colour is a theme, not a class: the amber transport plate and the blue '
      'police plate are the same geometry printed differently. The foreign, '
      'diplomatic and governmental classes drop the flag and carry their own '
      'arrangement.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'tj.car',
      label: 'Private car',
      spec: TajikistanPlates.car,
      theme: TajikistanThemes.civilian,
      note:
          'The commonest plate: `NNNN LL NN` — serial, two letters, region — with the flag block at the hoist end.',
      sampleValues: const <String?>['9999', 'MK', '02'],
    ),
    GalleryEntry(
      id: 'tj.carTwoRow',
      label: 'Private car (two-row)',
      spec: TajikistanPlates.carTwoRow,
      theme: TajikistanThemes.civilian,
      note:
          'The same eight characters and groups, broken across two rows for a vehicle with no room for a 520 mm plate.',
      sampleValues: const <String?>['9999', 'MK', '02'],
    ),
    GalleryEntry(
      id: 'tj.motorcycle',
      label: 'Motorcycle',
      spec: TajikistanPlates.motorcycle,
      theme: TajikistanThemes.civilian,
      note: 'A three-digit serial over one letter and the region.',
      sampleValues: const <String?>['304', 'A', '03'],
    ),
    GalleryEntry(
      id: 'tj.trailer',
      label: 'Trailer',
      spec: TajikistanPlates.trailer,
      theme: TajikistanThemes.civilian,
      note:
          'The one two-row plate that leads with its region: `NN LL` up top, the four-digit serial to itself below.',
      sampleValues: const <String?>['07', 'AA', '0776'],
    ),
    GalleryEntry(
      id: 'tj.publicTransport',
      label: 'Public transport',
      spec: TajikistanPlates.publicTransport,
      theme: TajikistanThemes.transport,
      note:
          'Black on amber, with the fixed `TT` marker printed between serial and region — a label, not a value anyone enters.',
      sampleValues: const <String?>['9006', '05'],
    ),
    GalleryEntry(
      id: 'tj.police',
      label: 'Police',
      spec: TajikistanPlates.police,
      theme: TajikistanThemes.police,
      note:
          'White on blue: the flag block over the blue field, `TJ` reversed out white, one letter between serial and region.',
      sampleValues: const <String?>['0245', 'M', '01'],
    ),
    GalleryEntry(
      id: 'tj.foreign',
      label: 'Foreign vehicle',
      spec: TajikistanPlates.foreign,
      theme: TajikistanThemes.foreign,
      note:
          'Black on yellow, no flag: a foreign vehicle carries no region, so the hoist end is bare and the number is `NNN L NNN`.',
      sampleValues: const <String?>['200', 'P', '005'],
    ),
    GalleryEntry(
      id: 'tj.diplomatic',
      label: 'Diplomatic corps',
      spec: TajikistanPlates.diplomatic,
      theme: TajikistanThemes.diplomatic,
      note:
          'White on red, no flag: a serial, a class code — `CD`, `CMD`, `D`, `T` or `S` chosen as one glyph group — and a trailing digit.',
      sampleValues: const <String?>['091', 'CMD', '1'],
    ),
    GalleryEntry(
      id: 'tj.governmental',
      label: 'Governmental',
      spec: TajikistanPlates.governmental,
      theme: TajikistanThemes.governmental,
      note:
          'The old Russian-derived layout: serial, two letters, then the region boxed off by a divider with `RT` beneath it.',
      sampleValues: const <String?>['001', 'CO', '04'],
    ),
  ],
);

/// Bahrain source — one of the four countries under the Iranshahr umbrella.
class BahrainSource extends GallerySource {
  const BahrainSource();

  @override
  String get countryName => 'Bahrain';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Left-to-right Latin digits, a grey security band down the right on '
      'every class, and the wording set at both ends as labels. The panel '
      'is the flag on the civilian plates and a colour band on the other two.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'bh.police',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Bahrain',
      note:
          'Left-to-right Latin digits, a grey security band down the right on '
          'every class, and the wording set at both ends as labels. The panel '
          'is the flag on the civilian plates and a colour band on the other '
          'two.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'bh.eu',
          label: 'Civilian (EU size)',
          spec: BahrainPlates.eu,
          theme: BahrainThemes.civilian,
          sampleValues: const <String?>['123456'],
        ),
        GalleryEntry(
          id: 'bh.us',
          label: 'Civilian (US size)',
          spec: BahrainPlates.us,
          theme: BahrainThemes.civilian,
          note: 'Same six digits as the EU size, re-laid in two bands.',
          sampleValues: const <String?>['407219'],
        ),
        GalleryEntry(
          id: 'bh.bicycle',
          label: 'Bicycle',
          spec: BahrainPlates.bicycle,
          theme: BahrainThemes.civilian,
          sampleValues: const <String?>['8135'],
        ),
        GalleryEntry(
          id: 'bh.diplomatic',
          label: 'Diplomatic corps',
          spec: BahrainPlates.diplomatic,
          theme: BahrainThemes.diplomatic,
          note: 'Green head band, wording reversed out white.',
          sampleValues: const <String?>['042'],
        ),
        GalleryEntry(
          id: 'bh.police',
          label: 'Police',
          spec: BahrainPlates.police,
          theme: BahrainThemes.police,
          sampleValues: const <String?>['2609'],
        ),
      ],
    ),
  ];
}

/// Azerbaijan source — one of the four countries under the Iranshahr umbrella.
class AzerbaijanSource extends GallerySource {
  const AzerbaijanSource();

  @override
  String get countryName => 'Azerbaijan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Five plates over four specs. The class is the colour of the field '
      'and the grouping of the serial, and nothing else: no divider, no '
      'band, no sticker, and the same white flag-over-AZ block on every one.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'az.car.transport',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Azerbaijan',
      note:
          'Five plates over four specs. The class is the colour of the field '
          'and the grouping of the serial, and nothing else: no divider, no '
          'band, no sticker, and the same white flag-over-AZ block on every '
          'one. The blue transport plate is the car spec in another theme — '
          'which is why two entries here share `AzerbaijanPlates.car`.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'az.car',
          label: 'Car',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.civilian,
          sampleValues: const <String?>['88', 'BE', '114'],
        ),
        GalleryEntry(
          id: 'az.car.transport',
          label: 'Bus / taxi',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.transport,
          note: 'The car spec, printed blue. Privately owned public transport.',
          sampleValues: const <String?>['10', 'TH', '308'],
        ),
        GalleryEntry(
          id: 'az.bicycle',
          label: 'Motorcycle',
          spec: AzerbaijanPlates.bicycle,
          theme: AzerbaijanThemes.civilian,
          note: 'The same groups as the car, in two rows and one letter short.',
          sampleValues: const <String?>['07', 'T', '096'],
        ),
        GalleryEntry(
          id: 'az.diplomatic',
          label: 'Diplomatic corps',
          spec: AzerbaijanPlates.diplomatic,
          theme: AzerbaijanThemes.diplomatic,
          note: 'Mission code, class letter, serial — told apart by gaps, not hyphens.',
          sampleValues: const <String?>['013', 'D', '004'],
        ),
        GalleryEntry(
          id: 'az.foreign',
          label: 'Foreign-owned company',
          spec: AzerbaijanPlates.foreign,
          theme: AzerbaijanThemes.foreign,
          note: 'The one coloured field that keeps the civilian black ink.',
          sampleValues: const <String?>['H', '023', '149'],
        ),
      ],
    ),
  ];
}

/// Afghanistan source — one of the four countries under the Iranshahr umbrella.
class AfghanistanSource extends GallerySource {
  const AfghanistanSource();

  @override
  String get countryName => 'Afghanistan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Fifteen plates over eleven specs. The serial is printed twice, in '
      'Eastern Arabic numerals over Latin figures, and typed once.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'af.governmental',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Afghanistan',
      note:
          'Fifteen plates over eleven specs, and the only bilingual design in '
          'this package: the serial is printed twice — iranian Arabic numerals '
          'over Latin figures — and so is the class, as a Persian letter over '
          'its Latin code. Both pairs are one value echoed by a `PlateMirror`, '
          'which is why the last sample value of most entries below is a '
          'single letter and two things on the plate change with it. The block '
          'at the hoist end is the province, passed per entry — name over the '
          'Darul Aman emblem over a three-letter code — so `af.car5` is a '
          'Herat plate and a Kabul taxi without being two specs.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'af.car5.private',
          label: 'Private (five figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note: 'The ordinary plate: `ش` over `PRV`, and Herat\'s block.',
          sampleValues: const <String?>['12346', 'P'],
        ),
        GalleryEntry(
          id: 'af.car4.private',
          label: 'Private (four figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.zabul.country(),
          note: 'Same design, one figure shorter — the figures sit centred in the same field.',
          sampleValues: const <String?>['1234', 'P'],
        ),
        GalleryEntry(
          id: 'af.car3.private',
          label: 'Private (three figures)',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.takhar.country(),
          sampleValues: const <String?>['123', 'P'],
        ),
        GalleryEntry(
          id: 'af.kabul6',
          label: 'Kabul (six figures)',
          spec: AfghanistanPlates.kabul6,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          note:
              'Kabul exhausted five figures. The sixth is printed once, in Persian only, between two hyphens.',
          sampleValues: const <String?>['5', '12346', 'P'],
        ),
        GalleryEntry(
          id: 'af.car5.taxi',
          label: 'Taxi',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The private geometry, printed yellow, with `ت` over `T`.',
          sampleValues: const <String?>['12346', 'T'],
        ),
        GalleryEntry(
          id: 'af.car5.bus',
          label: 'Bus',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The same yellow field as the taxi. One character tells them apart: `ب` over `B`.',
          sampleValues: const <String?>['12346', 'B'],
        ),
        GalleryEntry(
          id: 'af.car5.lorry',
          label: 'Lorry',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          sampleValues: const <String?>['12346', 'L'],
        ),
        GalleryEntry(
          id: 'af.car5.duplicate',
          label: 'Private duplicate',
          spec: AfghanistanPlates.car,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note:
              'The one class the Persian register cannot distinguish: `ش` above on both, `DUPL` below.',
          sampleValues: const <String?>['12346', 'D'],
        ),
        GalleryEntry(
          id: 'af.cycle3',
          label: 'Motorcycle',
          spec: AfghanistanPlates.cycle,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nimruz.country(),
          note: 'The two-wheeler plate: a longer, shallower rectangle, not a shrunk car plate.',
          sampleValues: const <String?>['123', 'M'],
        ),
        GalleryEntry(
          id: 'af.cycle4',
          label: 'Rickshaw',
          spec: AfghanistanPlates.cycle,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nangarhar.country(),
          sampleValues: const <String?>['1234', 'R'],
        ),
        GalleryEntry(
          id: 'af.diplomatic',
          label: 'Diplomatic corps',
          spec: AfghanistanPlates.diplomatic,
          theme: AfghanistanThemes.diplomatic,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note:
              'The only hyphenated Afghan number, and the only `CD` — printed once, with no Persian counterpart.',
          sampleValues: const <String?>['12', '34'],
        ),
        GalleryEntry(
          id: 'af.governmental',
          label: 'Governmental',
          spec: AfghanistanPlates.governmental,
          theme: AfghanistanThemes.governmental,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note: 'A government vehicle\'s type is not printed: a dash stands in both registers.',
          sampleValues: const <String?>['1234'],
        ),
        GalleryEntry(
          id: 'af.un',
          label: 'United Nations',
          spec: AfghanistanPlates.un,
          theme: AfghanistanThemes.un,
          country: AfghanistanProvince.kabul.country(),
          note:
              'The plainest of the eleven: the province block and the number, and nothing at the head.',
          sampleValues: const <String?>['1234'],
        ),
        GalleryEntry(
          id: 'af.temporary',
          label: 'Private temporary',
          spec: AfghanistanPlates.temporary,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(showCode: false),
          note: 'Issued from 2023, valid three years. The one Afghan plate printed in two inks.',
          sampleValues: const <String?>['12346'],
        ),
        GalleryEntry(
          id: 'af.international',
          label: 'Cross-border (Herat, 2026)',
          spec: AfghanistanPlates.international,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note:
              'Latin figures and a spelled-out category, no Persian half. Reconstructed from text — no photograph exists.',
          sampleValues: const <String?>['12346', 'B'],
        ),
      ],
    ),
  ];
}

/// Armenia source — one of the four countries under the Iranshahr umbrella.
class ArmeniaSource extends GallerySource {
  const ArmeniaSource();

  @override
  String get countryName => 'Armenia';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Ten designs on a German-style face: flag over AM, a silver '
      'identifier band, and NN LL NNN told apart by gaps alone.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'am.military',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Armenia',
      note:
          'Ten designs on a German-style face: flag over `AM`, a silver '
          'identifier band, and `NN LL NNN` told apart by gaps alone — no '
          'hyphen, no divider. Two things here are rules rather than shapes. '
          'The letters are Latin because the four the system opened with in '
          '1996 were Armenian letters chosen to *look* Latin (`Ս` as `U`, `Տ` '
          'as `S`, `Օ` as `O`), and `G` and `I` are still issued to the Police '
          'and the Prosecutor alone. And a state plate reverses the number to '
          '`NNN LL NN`, where the trailing four characters are not a serial '
          'but an institution: `NN 01` is the Security Council, `GG 01` the '
          'Prosecutor\'s office.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'am.car',
          label: 'Private car',
          spec: ArmeniaPlates.car,
          theme: ArmeniaThemes.civilian,
          note:
              'The 2014 design: region code, two letters, three digits, and the silver band beside the flag.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.carTwoRow',
          label: 'Private car (two-row)',
          spec: ArmeniaPlates.carTwoRow,
          theme: ArmeniaThemes.civilian,
          note: 'The same seven characters in the same three groups, on a deeper canvas.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.motorcycle',
          label: 'Motorcycle',
          spec: ArmeniaPlates.motorcycle,
          theme: ArmeniaThemes.civilian,
          note:
              'The two-row plate was found too cumbersome to carry; the gap between region and letters was closed.',
          sampleValues: const <String?>['01', 'AD', '234'],
        ),
        GalleryEntry(
          id: 'am.public',
          label: 'State-owned (Security Council)',
          spec: ArmeniaPlates.public,
          theme: ArmeniaThemes.civilian,
          note:
              'The number reversed: `NN 01` names the institution, and only fourteen pairs are issued at all.',
          sampleValues: const <String?>['001', 'NN', '01'],
        ),
        GalleryEntry(
          id: 'am.trailer',
          label: 'Trailer',
          spec: ArmeniaPlates.trailer,
          theme: ArmeniaThemes.civilian,
          note:
              'A pre-2014 design: no identifier band, and the letter count cut to one — most often `L`.',
          sampleValues: const <String?>['290', 'L', '01'],
        ),
        GalleryEntry(
          id: 'am.bus',
          label: 'Bus',
          spec: ArmeniaPlates.bus,
          theme: ArmeniaThemes.bus,
          note:
              'The Soviet public-transport format Armenia kept: `S` for a city bus, `L` for a long-range coach.',
          sampleValues: const <String?>['1234', 'S'],
        ),
        GalleryEntry(
          id: 'am.diplomatic',
          label: 'Diplomatic corps',
          spec: ArmeniaPlates.diplomatic,
          theme: ArmeniaThemes.diplomatic,
          note:
              'Mission code, `D` for a diplomat or `T` for a technician, serial, and Armenia\'s own code at the tail.',
          sampleValues: const <String?>['04', 'D', '057'],
        ),
        GalleryEntry(
          id: 'am.diplomaticArm',
          label: 'Diplomatic corps (current)',
          spec: ArmeniaPlates.diplomaticArm,
          theme: ArmeniaThemes.diplomatic,
          note: 'The same design; newer plates print `ARM` where the older ones print `AM`.',
          sampleValues: const <String?>['04', 'T', '057'],
        ),
        GalleryEntry(
          id: 'am.un',
          label: 'United Nations',
          spec: ArmeniaPlates.un,
          theme: ArmeniaThemes.un,
          note:
              'Three digits between two printed words. Nothing on this plate is chosen but the serial.',
          sampleValues: const <String?>['080'],
        ),
        GalleryEntry(
          id: 'am.military',
          label: 'Ministry of Defence',
          spec: ArmeniaPlates.military,
          theme: ArmeniaThemes.military,
          note:
              'The one Armenian plate with no Latin on it: `ՊՆ` for the ministry, '
              '`Մ` for a passenger vehicle, `Տ` for a transport one.',
          sampleValues: const <String?>['1007', 'M'],
        ),
      ],
    ),
  ];
}

/// Kuwait's section.
///
/// A fresh [GallerySection] each call: the umbrella source and [KuwaitSource]
/// each build their own, because [catalogueItems] resolves a [GalleryEntry] back
/// to its [CatalogueItem] by identity — sharing one set of entries across the
/// two sources would make that lookup ambiguous, exactly as it would for the
/// other five countries, which duplicate their entries the same way.
GallerySection _kuwaitSection() => GallerySection(
  title: 'Kuwait',
  note:
      'Sixteen plates over sixteen specs, transcribed from the "Vehicle types" '
      'table on Wikipedia\'s "Vehicle registration plates of Kuwait" article. '
      'Only private, public transport and police carry a class-serial number '
      'split by a hyphen (private and public "12-45678", police a plain six '
      'digits); every other class prints a plain 5-digit serial with no class '
      'prefix, and the diplomatic plate splits its six digits "123-456". The '
      'country block at the hoist end shows the flag and "دولة الكويت" on the '
      'flag-carrying classes; several classes (police, army, commercial, '
      'construction, firefighting, export, customs, diplomatic, emiri, emiri '
      'guard) print their own wording with no flag instead. Field colour is '
      'the class: white for private and diplomatic, yellow for public '
      'transport, black for police, blue for government/Emiri Bureau/Emiri '
      'Guard, green for national guard/export, beige for army, pink for '
      'commercial, orange for construction, red for firefighting, purple for '
      'temporary customs.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'kw.civilian',
      label: 'Civilian private vehicle',
      spec: KuwaitPlates.civilian,
      theme: KuwaitThemes.civilian,
      note: 'Standard private vehicle: black text on white field with flag block. Codes 1-89.',
      sampleValues: const <String?>['12', '45678'],
    ),
    GalleryEntry(
      id: 'kw.transport',
      label: 'Public transport',
      spec: KuwaitPlates.transport,
      theme: KuwaitThemes.transport,
      note: 'Taxis, buses, goods export: black text on yellow field. Codes 90-99.',
      sampleValues: const <String?>['92', '12345'],
    ),
    GalleryEntry(
      id: 'kw.police',
      label: 'Police',
      spec: KuwaitPlates.police,
      theme: KuwaitThemes.police,
      note: 'Police vehicles: white text on black field, "POLICE شرطة" caption.',
      sampleValues: const <String?>['50123'],
    ),
    GalleryEntry(
      id: 'kw.policemotorcycle',
      label: 'Police motorcycle',
      spec: KuwaitPlates.policeMotorcycle,
      theme: KuwaitThemes.police,
      note: 'Police motorcycles: white text on black field, "شرطة" caption only.',
      sampleValues: const <String?>['0123'],
    ),
    GalleryEntry(
      id: 'kw.government',
      label: 'Government',
      spec: KuwaitPlates.government,
      theme: KuwaitThemes.government,
      note: 'Government vehicles: black text on blue field, "دولة الكويت — حكومة" caption.',
      sampleValues: const <String?>['23456'],
    ),
    GalleryEntry(
      id: 'kw.diplomatic',
      label: 'Corps Diplomatique',
      spec: KuwaitPlates.diplomatic,
      theme: KuwaitThemes.diplomatic,
      note:
          'Diplomatic vehicles: blue text on white field, red band at the bottom, "هيئة دبلوماسية / C.D" caption.',
      sampleValues: const <String?>['123', '456'],
    ),
    GalleryEntry(
      id: 'kw.nationalguard',
      label: 'National guard',
      spec: KuwaitPlates.nationalGuard,
      theme: KuwaitThemes.nationalGuard,
      note: 'National guard vehicles: yellow text on green field, "الحرس الوطني" caption.',
      sampleValues: const <String?>['34567'],
    ),
    GalleryEntry(
      id: 'kw.army',
      label: 'Military / Army',
      spec: KuwaitPlates.army,
      theme: KuwaitThemes.army,
      note: 'Military vehicles: black text on beige field, "الجيش الكويتي" caption.',
      sampleValues: const <String?>['70123'],
    ),
    GalleryEntry(
      id: 'kw.commercial',
      label: 'Commercial',
      spec: KuwaitPlates.commercial,
      theme: KuwaitThemes.commercial,
      note: 'Commercial vehicles: black text on pink field, "دولة الكويت — تجاري" caption.',
      sampleValues: const <String?>['80123'],
    ),
    GalleryEntry(
      id: 'kw.construction',
      label: 'Construction',
      spec: KuwaitPlates.construction,
      theme: KuwaitThemes.construction,
      note: 'Construction vehicles: black text on orange field, "دولة الكويت — إنشاءت" caption.',
      sampleValues: const <String?>['95123'],
    ),
    GalleryEntry(
      id: 'kw.firefighting',
      label: 'General firefighting',
      spec: KuwaitPlates.firefighting,
      theme: KuwaitThemes.firefighting,
      note: 'Firefighting vehicles: black text on red field, "FIRE — الإطفاء العام" caption.',
      sampleValues: const <String?>['45123'],
    ),
    GalleryEntry(
      id: 'kw.export',
      label: 'Export / Goods export',
      spec: KuwaitPlates.exportPlate,
      theme: KuwaitThemes.export,
      note: 'Export vehicles: black text on green field, "دولة الكويت — تصدير" caption.',
      sampleValues: const <String?>['95512'],
    ),
    GalleryEntry(
      id: 'kw.customs',
      label: 'Temporary / Customs',
      spec: KuwaitPlates.customs,
      theme: KuwaitThemes.customs,
      note:
          'Temporary and customs vehicles: black text on purple field, "دولة الكويت — جمرك مؤقت" caption.',
      sampleValues: const <String?>['99123'],
    ),
    GalleryEntry(
      id: 'kw.emiri',
      label: 'Emiri Bureau',
      spec: KuwaitPlates.emiri,
      theme: KuwaitThemes.emiri,
      note:
          'Emiri Bureau vehicles: white text on blue field, "دولة الكويت — الديوان الأميري" caption.',
      sampleValues: const <String?>['10123'],
    ),
    GalleryEntry(
      id: 'kw.emiriguard',
      label: 'Emiri Guard',
      spec: KuwaitPlates.emiriGuard,
      theme: KuwaitThemes.emiriGuard,
      note: 'Emiri Guard vehicles: white text on blue field, "الحرس — الأميري" caption.',
      sampleValues: const <String?>['11023'],
    ),
    GalleryEntry(
      id: 'kw.motorcycle',
      label: 'Motorcycle',
      spec: KuwaitPlates.motorcycle,
      theme: KuwaitThemes.civilian,
      note: 'Motorcycles: black text on white field, "دولة الكويت / دراجة" caption. Codes 1-10.',
      sampleValues: const <String?>['5', '1234'],
    ),
  ],
);

/// Tajikistan source — one of the countries under the Iranshahr umbrella.
class TajikistanSource extends GallerySource {
  const TajikistanSource();

  @override
  String get countryName => 'Tajikistan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Nine designs on a European face: the flag over TJ at the hoist end, '
      'Latin letters that are really the shared Cyrillic register wearing Latin '
      'shapes, and the region printed as two digits of the number itself.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    for (final GallerySection section in sections)
      if (section.entries.isNotEmpty) ...[
        section.entries[0],
        if (section.entries.length > 1) section.entries[1],
      ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_tajikistanSection()];
}

/// Kuwait source — one of the countries under the Iranshahr umbrella.
class KuwaitSource extends GallerySource {
  const KuwaitSource();

  @override
  String get countryName => 'Kuwait';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Sixteen designs across the vehicle classes. Private, public transport '
      'and police plates split a class number from the serial with a hyphen; '
      'every other class prints a plain serial.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'kw.diplomatic',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_kuwaitSection()];
}

/// Iraq's section.
///
/// A fresh [GallerySection] each call, for the same reason as the other country
/// sections: [catalogueItems] resolves a [GalleryEntry] back to its
/// [CatalogueItem] by identity, so the umbrella source and [IraqSource] each
/// build their own.
///
/// The entries cover every spec and every theme once, and every band colour at
/// least once. Class is the band, not the field, so the five permanent classes
/// share one spec and differ only in the [PlateCountry] passed with it.
GallerySection _iraqSection() => GallerySection(
  title: 'Iraq',
  note:
      'Black on white in both sizes, with the class carried entirely by the '
      'coloured band down the left: white private, red for hire, blue '
      'government, yellow trade, green agricultural. The format is a '
      'two-digit governorate code, a class letter and a five-digit serial. '
      'Kurdistan Region plates stack KR under IRQ in the band; temporary '
      'plates print the whole thing in red and carry a two-digit expiry year '
      'in place of the letter.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'iq.large.private',
      label: 'Private (520x110)',
      spec: IraqPlates.large,
      theme: IraqThemes.large,
      country: IraqCountry.private,
      note: 'Basra, 14. The band is white, so only the divider separates it.',
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.large.hire',
      label: 'For hire (520x110)',
      spec: IraqPlates.large,
      theme: IraqThemes.large,
      country: IraqCountry.hire,
      note: 'Same spec, red band: taxis and other hire vehicles.',
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.large.government',
      label: 'Government (520x110)',
      spec: IraqPlates.large,
      theme: IraqThemes.large,
      country: IraqCountry.government,
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.large.trade',
      label: 'Trade (520x110)',
      spec: IraqPlates.large,
      theme: IraqThemes.large,
      country: IraqCountry.trade,
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.large.agricultural',
      label: 'Agricultural (520x110)',
      spec: IraqPlates.large,
      theme: IraqThemes.large,
      country: IraqCountry.agricultural,
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.large.kr',
      label: 'Kurdistan Region (520x110)',
      spec: IraqPlates.largeKurdistan,
      theme: IraqThemes.large,
      country: IraqCountry.private,
      note: 'Sulaymaniyah, 21. KR sits under IRQ, so the stack is shorter.',
      sampleValues: const <String?>['21', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.small.private',
      label: 'Private (335x155)',
      spec: IraqPlates.small,
      theme: IraqThemes.small,
      country: IraqCountry.private,
      note: 'The same registration re-laid in two rows for a short bracket.',
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.small.hire',
      label: 'For hire (335x155)',
      spec: IraqPlates.small,
      theme: IraqThemes.small,
      country: IraqCountry.hire,
      sampleValues: const <String?>['14', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.small.kr',
      label: 'Kurdistan Region (335x155)',
      spec: IraqPlates.smallKurdistan,
      theme: IraqThemes.small,
      country: IraqCountry.government,
      sampleValues: const <String?>['21', 'G', '34567'],
    ),
    GalleryEntry(
      id: 'iq.small.temporary',
      label: 'Temporary (335x155)',
      spec: IraqPlates.smallTemporary,
      theme: IraqThemes.temporary,
      country: IraqCountry.temporary,
      note:
          'Red ink on white, rim and divider included, with 22 as the expiry '
          'year where a permanent plate carries its class letter.',
      sampleValues: const <String?>['21', '22', '34567'],
    ),
  ],
);

/// Qatar source — one of the countries under the Iranshahr umbrella.
class QatarSource extends GallerySource {
  const QatarSource();

  @override
  String get countryName => 'Qatar';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Five designs. The country block is the maroon hoist of the flag, cut '
      'by its nine-point serration, with QATAR set one letter per line.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      sections[0].entries.firstWhere(
        (GalleryEntry e) => e.id == 'qa.police',
        orElse: () => sections[0].entries[1],
      ),
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_qatarSection()];
}

/// Iraq's gallery source, showing Iraqi plates as part of the Iranshahr umbrella.
class IraqSource extends GallerySource {
  const IraqSource();

  @override
  String get countryName => 'Iraq';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'The current Iraqi series: black on white in a 520x110 and a 335x155 '
      'size, in a Kurdistan Region variant of each, plus a red temporary '
      'plate. The class is the colour of the band down the left, not the '
      'field, which is white on all of them.';

  /// Built once, and returned by identity: [catalogueItems] resolves a
  /// [GalleryEntry] back to its [CatalogueItem] by identity, so a fresh list
  /// per read would make that lookup never find a match.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.isNotEmpty) ...[
      sections[0].entries[0],
      if (sections[0].entries.length > 1) sections[0].entries[1],
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_iraqSection()];
}

/// The UAE's section: the private plate of each of the seven emirates, long and
/// short. A fresh [GallerySection] each call, for the same reason as the other
/// country sections.
GallerySection _uaeSection() => GallerySection(
  title: 'United Arab Emirates',
  note:
      'Each emirate prints its own black-on-white design in a 520x110 and a '
      '335x155 size: a code (a number in Abu Dhabi and Sharjah, a letter '
      'elsewhere), the emirate named in Arabic and English, and a serial of up '
      'to five digits. Logo and calligraphy variants are not included.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'ae.abudhabi.long',
      label: 'Abu Dhabi (520x110)',
      spec: UaePlates.abuDhabiLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      note: 'White code on the red strip (long) or band (short), painted as background sections.',
      sampleValues: const <String?>['12', '23456'],
    ),
    GalleryEntry(
      id: 'ae.abudhabi.short',
      label: 'Abu Dhabi (335x155)',
      spec: UaePlates.abuDhabiShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['12', '23456'],
    ),
    GalleryEntry(
      id: 'ae.ajman.long',
      label: 'Ajman (520x110)',
      spec: UaePlates.ajmanLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.ajman.short',
      label: 'Ajman (335x155)',
      spec: UaePlates.ajmanShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.dubai.long',
      label: 'Dubai (520x110)',
      spec: UaePlates.dubaiLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      note: '"DUBAI" logotype set as bold text; single code letter only (AA-EE not laid out).',
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.dubai.short',
      label: 'Dubai (335x155)',
      spec: UaePlates.dubaiShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.fujairah.long',
      label: 'Fujairah (520x110)',
      spec: UaePlates.fujairahLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.fujairah.short',
      label: 'Fujairah (335x155)',
      spec: UaePlates.fujairahShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.rasalkhaimah.long',
      label: 'Ras Al Khaimah (520x110)',
      spec: UaePlates.rasAlKhaimahLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.rasalkhaimah.short',
      label: 'Ras Al Khaimah (335x155)',
      spec: UaePlates.rasAlKhaimahShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.sharjah.long',
      label: 'Sharjah (520x110)',
      spec: UaePlates.sharjahLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      note: 'Heavier frame; the one-digit code (1-4) is optional.',
      sampleValues: const <String?>['1', '23456'],
    ),
    GalleryEntry(
      id: 'ae.sharjah.short',
      label: 'Sharjah (335x155)',
      spec: UaePlates.sharjahShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['1', '23456'],
    ),
    GalleryEntry(
      id: 'ae.ummalquwain.long',
      label: 'Umm Al Quwain (520x110)',
      spec: UaePlates.ummAlQuwainLong,
      theme: UaeThemes.long,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
    GalleryEntry(
      id: 'ae.ummalquwain.short',
      label: 'Umm Al Quwain (335x155)',
      spec: UaePlates.ummAlQuwainShort,
      theme: UaeThemes.short,
      country: UaeCountry.uae,
      sampleValues: const <String?>['A', '23456'],
    ),
  ],
);

/// The UAE's gallery source, showing Emirati plates as part of the Iranshahr
/// umbrella.
class UaeSource extends GallerySource {
  const UaeSource();

  @override
  String get countryName => 'United Arab Emirates';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'The private plates of the seven emirates, each in a long and a short '
      'size.';

  /// Built once, and returned by identity, as for the other sources.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.length > 1) ...[
      sections[0].entries[0],
      sections[0].entries[1],
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_uaeSection()];
}

GalleryEntry _tr(
  String id,
  String label,
  PlateSpec spec,
  PlateTheme theme,
  String values, {
  PlateValidator validator = TurkeyPlateValidator.general,
  String? note,
}) => GalleryEntry(
  id: id,
  label: label,
  spec: spec,
  theme: theme,
  country: TurkeyCountry.turkey,
  validator: validator,
  sampleValues: values.split(' '),
  note: note,
);

/// Turkey's section: every spec, every theme, each entry in its own livery.
GallerySection _turkeySection() => GallerySection(
  title: 'Turkey',
  note:
      'A two-digit province code, one to three letters and a serial, on a '
      '520 × 110 plate. Most classes keep the blue TR strip; police, '
      'consulate, official and state plates drop it for a coloured field. '
      'Diplomatic plates have been numbered at random since 2004, so no code '
      'identifies a mission and nothing here is Israel-specific. Ink is ~90% '
      'of the reference height, set in Roboto rather than the plate face.',
  entries: <GalleryEntry>[
    _tr('tr.private', 'Private', TurkeyPlates.private, TurkeyThemes.civilian, '34 AB 1234'),
    _tr(
      'tr.international',
      'International organisation',
      TurkeyPlates.internationalOrganization,
      TurkeyThemes.internationalOrganization,
      '34 B 0426',
    ),
    _tr(
      'tr.diplomatic',
      'Diplomatic (CD)',
      TurkeyPlates.diplomatic,
      TurkeyThemes.diplomatic,
      '34 CD 012',
      validator: TurkeyPlateValidator.diplomatic,
    ),
    _tr(
      'tr.consulate',
      'Consulate (CC)',
      TurkeyPlates.consulate,
      TurkeyThemes.consulate,
      '34 CC 0001',
      validator: TurkeyPlateValidator.consulate,
    ),
    _tr('tr.temporary', 'Temporary', TurkeyPlates.temporary, TurkeyThemes.temporary, '34 G 1234'),
    _tr(
      'tr.temporary.strip',
      'Temporary (with strip)',
      TurkeyPlates.temporaryWithStrip,
      TurkeyThemes.temporary,
      '34 G 1234',
    ),
    _tr(
      'tr.customs',
      'Temporary customs (GMR)',
      TurkeyPlates.temporaryCustoms,
      TurkeyThemes.temporaryCustoms,
      '34 GMR 032',
      validator: TurkeyPlateValidator.temporaryCustoms,
    ),
    _tr(
      'tr.foreign',
      'Foreign resident',
      TurkeyPlates.foreignResident,
      TurkeyThemes.civilian,
      '34 MA 012',
    ),
    _tr(
      'tr.syrian',
      'Syrian resident',
      TurkeyPlates.syrianResident,
      TurkeyThemes.civilian,
      '34 SAB 012',
    ),
    _tr('tr.taxi', 'Taxi', TurkeyPlates.taxi, TurkeyThemes.civilian, '06 T 0123'),
    _tr(
      'tr.taxi.istanbul',
      'Istanbul taxi',
      TurkeyPlates.istanbulTaxi,
      TurkeyThemes.civilian,
      '34 TAB 12',
    ),
    _tr(
      'tr.police',
      'Police',
      TurkeyPlates.police,
      TurkeyThemes.police,
      '16 A 01234',
      validator: TurkeyPlateValidator.police,
    ),
    _tr(
      'tr.gendarmerie',
      'Gendarmerie (J)',
      TurkeyPlates.gendarmerie,
      TurkeyThemes.police,
      '06 JAA 1234',
      validator: TurkeyPlateValidator.gendarmerie,
    ),
    _tr(
      'tr.coastguard',
      'Coast guard (SGH)',
      TurkeyPlates.coastGuard,
      TurkeyThemes.police,
      '34 SGH 1234',
      validator: TurkeyPlateValidator.coastGuard,
    ),
    _tr(
      'tr.provincial',
      'Provincial government',
      TurkeyPlates.provincialGovernment,
      TurkeyThemes.provincialGovernment,
      '06 AA 012',
    ),
    _tr('tr.official', 'Official', TurkeyPlates.official, TurkeyThemes.official, '34 AB 123'),
    _tr('tr.governor', 'Province governor', TurkeyPlates.governor, TurkeyThemes.state, '34 0001'),
    _tr('tr.parliament', 'Parliament', TurkeyPlates.parliament, TurkeyThemes.state, '0019'),
    _tr(
      'tr.parliament.tbmm',
      'Parliament (TBMM)',
      TurkeyPlates.parliamentLabelled,
      TurkeyThemes.state,
      '009',
    ),
    _tr('tr.sample', 'Sample (NUMUNE PLAKA)', TurkeyPlates.sample, TurkeyThemes.civilian, '34 123'),
    _tr(
      'tr.motorcycle',
      'Motorcycle',
      TurkeyPlates.motorcycle,
      TurkeyThemes.civilian,
      '34 UF 2409',
    ),
  ],
);

class TurkeySource extends GallerySource {
  const TurkeySource();

  @override
  String get countryName => 'Turkey';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Province code, letters and serial behind the blue TR strip, in ten '
      'liveries. Diplomatic numbers are random, so there is no '
      'Israel-specific value to refuse.';

  /// Built once, and returned by identity, as for the other sources.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.length > 2) ...[
      sections[0].entries[0],
      sections[0].entries[2],
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_turkeySection()];
}

/// Oman's section: one three-panel design in two liveries.
GallerySection _omanSection() => GallerySection(
  title: 'Oman',
  note:
      'The 2001 series: number, letters and عمان in three panels, in black '
      'on yellow (private) and white on red (taxi). The letters are printed '
      'twice, Latin below and Arabic above in the opposite order. The number is four or '
      'five digits (one variable field) and the letters one or two, each picked; four digits with two letters '
      'and five with one are measured. Only A, B, K and M are sourced as letters.',
  entries: <GalleryEntry>[
    GalleryEntry(
      id: 'om.private',
      label: 'Private · four digits, two letters',
      spec: OmanPlates.twoLetters,
      theme: OmanThemes.private,
      country: OmanCountry.oman,
      validator: const OmanPlateValidator(),
      sampleValues: <String?>['4517', 'B', 'M'],
    ),
    GalleryEntry(
      id: 'om.private.d5',
      label: 'Private · five digits, one letter',
      spec: OmanPlates.oneLetter,
      theme: OmanThemes.private,
      country: OmanCountry.oman,
      validator: const OmanPlateValidator(),
      sampleValues: <String?>['91169', 'B'],
    ),
    GalleryEntry(
      id: 'om.taxi',
      label: 'Taxi · four digits, two letters',
      spec: OmanPlates.twoLetters,
      theme: OmanThemes.taxi,
      country: OmanCountry.oman,
      validator: const OmanPlateValidator(),
      sampleValues: <String?>['4517', 'K', 'K'],
    ),
    GalleryEntry(
      id: 'om.taxi.d5',
      label: 'Taxi · five digits, one letter',
      spec: OmanPlates.oneLetter,
      theme: OmanThemes.taxi,
      country: OmanCountry.oman,
      validator: const OmanPlateValidator(),
      sampleValues: <String?>['91169', 'K'],
    ),
  ],
);

class OmanSource extends GallerySource {
  const OmanSource();

  @override
  String get countryName => 'Oman';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'One three-panel design — number, letters, عمان — in black on yellow '
      '(private) and white on red (taxi), with four or five digits and one '
      'or two letters.';

  /// Built once, and returned by identity, as for the other sources.
  @override
  List<GallerySection> get sections => _sections;

  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    if (sections.isNotEmpty && sections[0].entries.length > 1) ...[
      sections[0].entries[1],
      sections[0].entries[2],
    ],
  ];

  static final List<GallerySection> _sections = <GallerySection>[_omanSection()];
}

/// Kazakhstan's entries, built fresh each call for the same reason as the other
/// country sections.
GalleryEntry _kzEntry(
  String id,
  String label,
  PlateSpec spec,
  PlateTheme theme,
  String values, {
  PlateValidator validator = const KazakhstanValidator(),
}) => GalleryEntry(
  id: 'kz.$id',
  label: label,
  spec: spec,
  theme: theme,
  country: KazakhstanCountry.kazakhstan,
  validator: validator,
  sampleValues: values.split(' '),
);

List<GallerySection> _kzSections() => <GallerySection>[
  GallerySection(
    title: 'Private — 520 × 112',
    note: 'Three digits, three letters, two digits.',
    entries: <GalleryEntry>[
      _kzEntry(
        'private',
        'Private car',
        KazakhstanPlates.private,
        KazakhstanThemes.private,
        '017 ABC 02',
      ),
    ],
  ),
  GallerySection(
    title: 'Non-private and diplomatic',
    note:
        'The non-private plate carries two letters rather than three; the '
        'diplomatic plate leads with the status letter.',
    entries: <GalleryEntry>[
      _kzEntry(
        'non_private',
        'Commercial and state',
        KazakhstanPlates.nonPrivate,
        KazakhstanThemes.nonPrivate,
        '050 AB 02',
        validator: const KazakhstanValidator(letters: 2),
      ),
      _kzEntry(
        'diplomatic',
        'Diplomatic corps',
        KazakhstanPlates.diplomatic,
        KazakhstanThemes.diplomatic,
        'D 001 023',
        validator: const KazakhstanDiplomaticValidator(),
      ),
    ],
  ),
];

const String _kazakhstanNote =
    'A region number, a letter block and a two-digit tail, black on white '
    'with the flag and the KZ code on the right. The non-private plate drops '
    'a letter; the diplomatic plate leads with the status letter. Not drawn: '
    'the Kazakh caption under the flag and the older Soviet-era formats.';

GallerySection _kazakhstanSection() => GallerySection(
  title: 'Kazakhstan',
  note: _kazakhstanNote,
  entries: <GalleryEntry>[for (final GallerySection s in _kzSections()) ...s.entries],
);

class KazakhstanSource extends GallerySource {
  const KazakhstanSource();

  @override
  String get countryName => 'Kazakhstan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note => _kazakhstanNote;

  @override
  List<GallerySection> get sections => _sections;

  static final List<GallerySection> _sections = <GallerySection>[_kazakhstanSection()];
}

/// Uzbekistan's entries, built fresh each call for the same reason as the other
/// country sections.
GalleryEntry _uzEntry(
  String id,
  String label,
  PlateSpec spec,
  PlateTheme theme,
  String values, {
  PlateValidator validator = const UzbekistanValidator(),
}) => GalleryEntry(
  id: 'uz.$id',
  label: label,
  spec: spec,
  theme: theme,
  country: UzbekistanCountry.uzbekistan,
  validator: validator,
  sampleValues: values.split(' '),
);

List<GallerySection> _uzSections() => <GallerySection>[
  GallerySection(
    title: 'Passenger',
    note: 'Region, series letter, serial, then the closing letters.',
    entries: <GalleryEntry>[
      _uzEntry(
        'passenger',
        'Passenger car',
        UzbekistanPlates.passenger,
        UzbekistanThemes.passenger,
        '01 A 123 BC',
      ),
    ],
  ),
  GallerySection(
    title: 'Foreign and temporary',
    note: 'Digits only, on a coloured field.',
    entries: <GalleryEntry>[
      _uzEntry(
        'foreign_citizen',
        'Foreign citizen',
        UzbekistanPlates.foreignCitizen,
        UzbekistanThemes.foreignCitizen,
        '10 123456',
      ),
      _uzEntry(
        'foreign_company',
        'Foreign company',
        UzbekistanPlates.foreignCompany,
        UzbekistanThemes.foreignCompany,
        '20 654321',
      ),
      _uzEntry(
        'temporary',
        'Temporary',
        UzbekistanPlates.temporary,
        UzbekistanThemes.temporary,
        '301122 33',
      ),
    ],
  ),
  GallerySection(
    title: 'Diplomatic',
    note: 'The ambassador, diplomat and United Nations registers.',
    entries: <GalleryEntry>[
      _uzEntry(
        'ambassador',
        'Ambassador',
        UzbekistanPlates.ambassador,
        UzbekistanThemes.diplomatic,
        '001 001',
        validator: const UzbekistanDiplomaticValidator(),
      ),
      _uzEntry(
        'diplomat',
        'Diplomat',
        UzbekistanPlates.diplomat,
        UzbekistanThemes.diplomatic,
        'D 002 015',
        validator: const UzbekistanDiplomaticValidator(),
      ),
      _uzEntry(
        'united_nations',
        'United Nations',
        UzbekistanPlates.unitedNations,
        UzbekistanThemes.unitedNations,
        '1234',
        validator: const UzbekistanUnitedNationsValidator(),
      ),
    ],
  ),
  GallerySection(
    title: 'Trailer and motorcycle',
    note: 'Shorter faces, the number stacked on two rows.',
    entries: <GalleryEntry>[
      _uzEntry(
        'trailer',
        'Trailer',
        UzbekistanPlates.trailer,
        UzbekistanThemes.trailer,
        '0123 AB 45',
      ),
      _uzEntry(
        'motorcycle',
        'Motorcycle',
        UzbekistanPlates.motorcycle,
        UzbekistanThemes.motorcycle,
        '012 CD 34',
      ),
    ],
  ),
];

const String _uzbekistanNote =
    'The region number leads, then the series letter, the serial and the '
    'closing letters. The foreign and temporary plates are digits only, the '
    'diplomatic plate leads with D or T. Not drawn: the UZ oval and the '
    'older Soviet-era formats.';

GallerySection _uzbekistanSection() => GallerySection(
  title: 'Uzbekistan',
  note: _uzbekistanNote,
  entries: <GalleryEntry>[for (final GallerySection s in _uzSections()) ...s.entries],
);

class UzbekistanSource extends GallerySource {
  const UzbekistanSource();

  @override
  String get countryName => 'Uzbekistan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note => _uzbekistanNote;

  @override
  List<GallerySection> get sections => _sections;

  static final List<GallerySection> _sections = <GallerySection>[_uzbekistanSection()];
}

/// Turkmenistan's entries, built fresh each call for the same reason as the other
/// country sections.
GalleryEntry _tmEntry(
  String id,
  String label,
  PlateSpec spec,
  PlateTheme theme,
  String values,
  TurkmenistanValidator validator,
) => GalleryEntry(
  id: 'tm.$id',
  label: label,
  spec: spec,
  theme: theme,
  country: TurkmenistanCountry.turkmenistan,
  validator: validator,
  sampleValues: values.split(' '),
);

List<GallerySection> _tmSections() => <GallerySection>[
  GallerySection(
    title: 'Private',
    note: 'The classic plate carries one region letter, the current two.',
    entries: <GalleryEntry>[
      _tmEntry(
        'classic',
        'Classic',
        TurkmenistanPlates.classic,
        TurkmenistanThemes.classic,
        'A 12 34 AG',
        TurkmenistanValidator.classic,
      ),
      _tmEntry(
        'private',
        'Private car',
        TurkmenistanPlates.private,
        TurkmenistanThemes.private,
        'AT 5678 AG',
        const TurkmenistanValidator(),
      ),
      _tmEntry(
        'trailer',
        'Trailer',
        TurkmenistanPlates.trailer,
        TurkmenistanThemes.private,
        'AT 1122 BN',
        TurkmenistanValidator.trailer,
      ),
    ],
  ),
  GallerySection(
    title: 'Foreign and export',
    note: 'The foreign plate leads with the status digit.',
    entries: <GalleryEntry>[
      _tmEntry(
        'foreign',
        'Foreign resident',
        TurkmenistanPlates.foreign,
        TurkmenistanThemes.foreign,
        '1 H 23456',
        TurkmenistanValidator.foreign,
      ),
      _tmEntry(
        'foreign_trailer',
        'Foreign trailer',
        TurkmenistanPlates.foreignTrailer,
        TurkmenistanThemes.foreign,
        '2 HT 8901',
        TurkmenistanValidator.foreignTrailer,
      ),
      _tmEntry(
        'export',
        'Export',
        TurkmenistanPlates.export,
        TurkmenistanThemes.foreign,
        'ABC 1234',
        TurkmenistanValidator.export,
      ),
    ],
  ),
  GallerySection(
    title: 'State',
    note: 'Diplomatic, government, military and ceremonial registers.',
    entries: <GalleryEntry>[
      _tmEntry(
        'diplomatic',
        'Diplomatic corps',
        TurkmenistanPlates.diplomatic,
        TurkmenistanThemes.diplomatic,
        '12 CD 345',
        TurkmenistanValidator.diplomatic,
      ),
      _tmEntry(
        'government',
        'Government',
        TurkmenistanPlates.government,
        TurkmenistanThemes.government,
        '1234 AGA',
        TurkmenistanValidator.government,
      ),
      _tmEntry(
        'military',
        'Military',
        TurkmenistanPlates.military,
        TurkmenistanThemes.government,
        '5678 AG',
        TurkmenistanValidator.military,
      ),
      _tmEntry(
        'ceremony',
        'Ceremonial',
        TurkmenistanPlates.ceremony,
        TurkmenistanThemes.government,
        'TURKME 1',
        TurkmenistanValidator.ceremony,
      ),
    ],
  ),
];

const String _turkmenistanNote =
    'A region letter, four digits and the two-letter country code. Each '
    'series reorders the register rather than only recolouring it — the '
    'foreign plate leads with a digit, the government plate ends with the '
    'letters. Not drawn: the crescent and stars in full detail and the '
    'transit series.';

GallerySection _turkmenistanSection() => GallerySection(
  title: 'Turkmenistan',
  note: _turkmenistanNote,
  entries: <GalleryEntry>[for (final GallerySection s in _tmSections()) ...s.entries],
);

class TurkmenistanSource extends GallerySource {
  const TurkmenistanSource();

  @override
  String get countryName => 'Turkmenistan';

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note => _turkmenistanNote;

  @override
  List<GallerySection> get sections => _sections;

  static final List<GallerySection> _sections = <GallerySection>[_turkmenistanSection()];
}
