import 'package:iran_plate/iran_plate.dart';

import '../catalogue.dart';

/// `iran_plate` exposes no catalogue at all — two bare consts, `IranPlates.car`
/// and `.bicycle`. Naming them here is the adapter; there is nothing to walk.
///
/// The same package also ships Bahrain's five designs and Azerbaijan's four
/// specs, which is why this one source has three country blocks: the sections
/// below follow the package, not the map.
///
/// The sample values are written out rather than generated: the package ships
/// no serial generator, and adding one to it so that a showcase could fill a
/// plate would be the gallery driving library API.
class IranSource extends GallerySource {
  const IranSource();

  @override
  String get countryName => 'Iran';

  @override
  String get packageName => 'iran_plate';

  @override
  String get note =>
      'Two Iranian specs, Persian digits and the chosen-letter slot, plus '
      'Bahrain\'s five designs and Azerbaijan\'s five from the same package. '
      'See iran_plate/README.md.';

  /// Built once, and returned by identity: the pickers select a section by
  /// equality, and a fresh list per read would make the selected one never
  /// equal the one in the list.
  @override
  List<GallerySection> get sections => _sections;

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Iran',
      note:
          'Right-to-left, with the province pair past the divider. The letter '
          'slot is a `chosen` alphabet, so it opens a picker rather than '
          'accepting typing.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'ir.car',
          label: 'Car',
          spec: IranPlates.car,
          sampleValues: const <String?>['1', '2', 'ب', '3', '4', '5', '1', '1'],
        ),
        GalleryEntry(
          id: 'ir.bicycle',
          label: 'Bicycle',
          spec: IranPlates.bicycle,
          sampleValues: const <String?>[
            '1', '2', '3', //
            '4', '5', '6', '7', '8',
          ],
        ),
      ],
    ),
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
  ];
}
