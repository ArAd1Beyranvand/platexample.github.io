import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:malaysia_plate/malaysia_plate.dart';

import '../catalogue.dart';

/// `malaysia_plate`: four geometries, and the usage classes as themes on them.
///
/// The single-row plate is made to the registration, so its spec is built per
/// format (`prefix`, `digits`, `suffix`) and its canvas width follows the
/// content; the cards below show three widths of the same design.
class MalaysiaSource extends GallerySource {
  MalaysiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1957);

  @override
  String get countryName => 'Malaysia';

  @override
  String get packageName => 'malaysia_plate';

  @override
  String get note =>
      'Frameless white-on-black plates sized to the registration, a '
      'black-on-white taxi livery, red diplomatic plates, and the 2024 '
      'JPJePlate with its green MAL strip.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    String prefix = '',
    String? note,
  }) => GalleryEntry(
    id: 'my.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MalaysiaCountry.malaysia,
    validator: const MalaysiaValidator(),
    sampleValues: MalaysiaSerialGenerator.generate(
      spec,
      random: _rng,
      prefix: prefix,
    ),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Single row',
      note:
          'One design. The prefix is the state (W Kuala Lumpur, P Penang, '
          'S Sabah, Q Sarawak), then a number of up to four digits and an '
          'optional suffix letter. The serial is about two thirds of the '
          'real 70 mm height: a plate 98 mm tall cannot hold the slot the '
          'engine would need.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · white on black',
          MalaysiaPlates.singleRow(),
          MalaysiaThemes.standard,
          prefix: 'P',
        ),
        _entry(
          'suffix',
          'Sabah · suffix letter',
          MalaysiaPlates.singleRow(suffix: true),
          MalaysiaThemes.standard,
          prefix: 'SAA',
        ),
        _entry(
          'short',
          'Kuala Lumpur · one letter',
          MalaysiaPlates.singleRow(),
          MalaysiaThemes.standard,
          prefix: 'W',
        ),
        _entry(
          'taxi',
          'Taxi · black on white · H',
          MalaysiaPlates.singleRow(),
          MalaysiaThemes.taxi,
          prefix: 'H',
          note:
              'The field is sampled from photographs of aluminium plates, '
              'which read grey; the article calls it white.',
        ),
        _entry(
          'military',
          'Military · Z',
          MalaysiaPlates.singleRow(),
          MalaysiaThemes.standard,
          prefix: 'Z',
        ),
      ],
    ),
    GallerySection(
      title: 'Two row and JPJePlate',
      note:
          'The square rear plate stacks the prefix over the number. The '
          'JPJePlate, issued since September 2024, is European-sized and is '
          'the only Malaysian plate with a country strip.',
      entries: <GalleryEntry>[
        _entry(
          'twoRow',
          'Two row',
          MalaysiaPlates.twoRow(),
          MalaysiaThemes.standard,
          prefix: 'Q',
        ),
        _entry(
          'ev',
          'JPJePlate',
          MalaysiaPlates.ev(),
          MalaysiaThemes.ev,
          prefix: 'V',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'Country number, vehicle number, mission code. Red for the '
          'diplomatic corps; consular and international-organisation plates '
          'are the same layout in white on black.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'my.dc',
          label: 'Diplomatic corps · DC',
          spec: MalaysiaPlates.diplomatic,
          theme: MalaysiaThemes.diplomatic,
          country: MalaysiaCountry.malaysia,
          validator: const MalaysiaDiplomaticValidator(),
          sampleValues: const <String?>['99', '64', 'DC'],
        ),
        GalleryEntry(
          id: 'my.cc',
          label: 'Consular corps · CC',
          spec: MalaysiaPlates.diplomatic,
          theme: MalaysiaThemes.consular,
          country: MalaysiaCountry.malaysia,
          validator: const MalaysiaDiplomaticValidator(),
          sampleValues: const <String?>['21', '07', 'CC'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
