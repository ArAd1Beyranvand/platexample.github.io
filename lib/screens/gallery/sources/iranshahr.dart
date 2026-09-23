import 'package:iranshahr_plate/iranshahr.dart';

import '../catalogue.dart';

/// Bahrain's, Azerbaijan's and Afghanistan's plate designs from the
/// `iranshahr_plate` package.
///
/// The sample values are written out rather than generated: the package ships
/// no serial generator, and adding one to it so that a showcase could fill a
/// plate would be the gallery driving library API.
class IranshahirSource extends GallerySource {
  const IranshahirSource();

  @override
  String get countryName => 'Iranshahr';

  @override
  List<String> get countryNames => const <String>['Bahrain', 'Azerbaijan', 'Afghanistan'];

  @override
  String get packageName => 'iranshahr_plate';

  @override
  String get note =>
      'Bahrain\'s five designs, Azerbaijan\'s four specs and Afghanistan\'s '
      'eleven from the iranshahr_plate package. Each country is independent '
      'with distinct design languages. See iranshahr_plate/README.md.';

  /// Built once, and returned by identity: the pickers select a section by
  /// equality, and a fresh list per read would make the selected one never
  /// equal the one in the list.
  @override
  List<GallerySection> get sections => _sections;

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
          sampleValues: const <String?>['1', '2', '3', '4', '5', '6'],
        ),
        GalleryEntry(
          id: 'bh.us',
          label: 'Civilian (US size)',
          spec: BahrainPlates.us,
          theme: BahrainThemes.civilian,
          note: 'Same six digits as the EU size, re-laid in two bands.',
          sampleValues: const <String?>['4', '0', '7', '2', '1', '9'],
        ),
        GalleryEntry(
          id: 'bh.bicycle',
          label: 'Bicycle',
          spec: BahrainPlates.bicycle,
          theme: BahrainThemes.civilian,
          sampleValues: const <String?>['8', '1', '3', '5'],
        ),
        GalleryEntry(
          id: 'bh.diplomatic',
          label: 'Diplomatic corps',
          spec: BahrainPlates.diplomatic,
          theme: BahrainThemes.diplomatic,
          note: 'Green head band, wording reversed out white.',
          sampleValues: const <String?>['0', '4', '2'],
        ),
        GalleryEntry(
          id: 'bh.police',
          label: 'Police',
          spec: BahrainPlates.police,
          theme: BahrainThemes.police,
          sampleValues: const <String?>['2', '6', '0', '9'],
        ),
      ],
    ),
    GallerySection(
      title: 'Azerbaijan',
      note:
          'Five plates over four specs. The class is the colour of the field '
          'and the grouping of the serial, and nothing else: no divider, no '
          'band, no sticker, and the same white flag-over-`AZ` block on every '
          'one. The blue transport plate is the car spec in another theme — '
          'which is why two entries here share `AzerbaijanPlates.car`.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'az.car',
          label: 'Car',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.civilian,
          sampleValues: const <String?>['8', '8', 'B', 'E', '1', '1', '4'],
        ),
        GalleryEntry(
          id: 'az.car.transport',
          label: 'Bus / taxi',
          spec: AzerbaijanPlates.car,
          theme: AzerbaijanThemes.transport,
          note: 'The car spec, printed blue. Privately owned public transport.',
          sampleValues: const <String?>['1', '0', 'T', 'H', '3', '0', '8'],
        ),
        GalleryEntry(
          id: 'az.bicycle',
          label: 'Motorcycle',
          spec: AzerbaijanPlates.bicycle,
          theme: AzerbaijanThemes.civilian,
          note: 'The same groups as the car, in two rows and one letter short.',
          sampleValues: const <String?>['0', '7', 'T', '0', '9', '6'],
        ),
        GalleryEntry(
          id: 'az.diplomatic',
          label: 'Diplomatic corps',
          spec: AzerbaijanPlates.diplomatic,
          theme: AzerbaijanThemes.diplomatic,
          note: 'Mission code, class letter, serial — told apart by gaps, not hyphens.',
          sampleValues: const <String?>['0', '1', '3', 'D', '0', '0', '4'],
        ),
        GalleryEntry(
          id: 'az.foreign',
          label: 'Foreign-owned company',
          spec: AzerbaijanPlates.foreign,
          theme: AzerbaijanThemes.foreign,
          note: 'The one coloured field that keeps the civilian black ink.',
          sampleValues: const <String?>['H', '0', '2', '3', '1', '4', '9'],
        ),
      ],
    ),
    GallerySection(
      title: 'Afghanistan',
      note:
          'Fifteen plates over eleven specs, and the only bilingual design in '
          'this package: the serial is printed twice — eastern Arabic numerals '
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
          spec: AfghanistanPlates.car5,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note: 'The ordinary plate: `ش` over `PRV`, and Herat\'s block.',
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'P'],
        ),
        GalleryEntry(
          id: 'af.car4.private',
          label: 'Private (four figures)',
          spec: AfghanistanPlates.car4,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.zabul.country(),
          note: 'Same design, one figure shorter — the figures spread, they do not grow.',
          sampleValues: const <String?>['1', '2', '3', '4', 'P'],
        ),
        GalleryEntry(
          id: 'af.car3.private',
          label: 'Private (three figures)',
          spec: AfghanistanPlates.car3,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.takhar.country(),
          sampleValues: const <String?>['1', '2', '3', 'P'],
        ),
        GalleryEntry(
          id: 'af.kabul6',
          label: 'Kabul (six figures)',
          spec: AfghanistanPlates.kabul6,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          note: 'Kabul exhausted five figures. The sixth is printed once, in Persian only, between two hyphens.',
          sampleValues: const <String?>['5', '1', '2', '3', '4', '6', 'P'],
        ),
        GalleryEntry(
          id: 'af.car5.taxi',
          label: 'Taxi',
          spec: AfghanistanPlates.car5,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The private geometry, printed yellow, with `ت` over `T`.',
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'T'],
        ),
        GalleryEntry(
          id: 'af.car5.bus',
          label: 'Bus',
          spec: AfghanistanPlates.car5,
          theme: AfghanistanThemes.transport,
          country: AfghanistanProvince.kabul.country(),
          note: 'The same yellow field as the taxi. One character tells them apart: `ب` over `B`.',
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'B'],
        ),
        GalleryEntry(
          id: 'af.car5.lorry',
          label: 'Lorry',
          spec: AfghanistanPlates.car5,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.kabul.country(),
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'L'],
        ),
        GalleryEntry(
          id: 'af.car5.duplicate',
          label: 'Private duplicate',
          spec: AfghanistanPlates.car5,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note: 'The one class the Persian register cannot distinguish: `ش` above on both, `DUPL` below.',
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'D'],
        ),
        GalleryEntry(
          id: 'af.cycle3',
          label: 'Motorcycle',
          spec: AfghanistanPlates.cycle3,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nimruz.country(),
          note: 'The two-wheeler plate: a longer, shallower rectangle, not a shrunk car plate.',
          sampleValues: const <String?>['1', '2', '3', 'M'],
        ),
        GalleryEntry(
          id: 'af.cycle4',
          label: 'Rickshaw',
          spec: AfghanistanPlates.cycle4,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.nangarhar.country(),
          sampleValues: const <String?>['1', '2', '3', '4', 'R'],
        ),
        GalleryEntry(
          id: 'af.diplomatic',
          label: 'Diplomatic corps',
          spec: AfghanistanPlates.diplomatic,
          theme: AfghanistanThemes.diplomatic,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note: 'The only hyphenated Afghan number, and the only `CD` — printed once, with no Persian counterpart.',
          sampleValues: const <String?>['1', '2', '3', '4'],
        ),
        GalleryEntry(
          id: 'af.governmental',
          label: 'Governmental',
          spec: AfghanistanPlates.governmental,
          theme: AfghanistanThemes.governmental,
          country: AfghanistanProvince.kabul.country(ink: AfghanistanPanelInk.light),
          note: 'A government vehicle\'s type is not printed: a dash stands in both registers.',
          sampleValues: const <String?>['1', '2', '3', '4'],
        ),
        GalleryEntry(
          id: 'af.un',
          label: 'United Nations',
          spec: AfghanistanPlates.un,
          theme: AfghanistanThemes.un,
          country: AfghanistanProvince.kabul.country(),
          note: 'The plainest of the eleven: the province block and the number, and nothing at the head.',
          sampleValues: const <String?>['1', '2', '3', '4'],
        ),
        GalleryEntry(
          id: 'af.temporary',
          label: 'Private temporary',
          spec: AfghanistanPlates.temporary,
          theme: AfghanistanThemes.civilian,
          // The bare block: this design prints `موقت` where the province code
          // goes, so the block must not print the code as well.
          country: AfghanistanProvince.herat.country(showCode: false),
          note: 'Issued from 2023, valid three years. The one Afghan plate printed in two inks.',
          sampleValues: const <String?>['1', '2', '3', '4', '6'],
        ),
        GalleryEntry(
          id: 'af.international',
          label: 'Cross-border (Herat, 2026)',
          spec: AfghanistanPlates.international,
          theme: AfghanistanThemes.civilian,
          country: AfghanistanProvince.herat.country(),
          note: 'Latin figures and a spelled-out category, no Persian half. Reconstructed from text — no photograph exists.',
          sampleValues: const <String?>['1', '2', '3', '4', '6', 'B'],
        ),
      ],
    ),
  ];
}
