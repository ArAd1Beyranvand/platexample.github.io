import 'dart:math';

import 'package:haiti_plate/haiti_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `haiti_plate`: four designs, eight plates; the categories of the 2003 and
/// 1998 designs share a spec and differ by caption and letter field.
class HaitiSource extends GallerySource {
  HaitiSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1804);

  @override
  String get countryName => 'Haiti';

  @override
  String get packageName => 'haiti_plate';

  @override
  String get note =>
      'Latin letters and digits. The 2014 passenger-transport plate, the 2006 '
      'regional plate and the 2003 and 1998 series. The coat of arms, the '
      'map of Haiti and the validation stickers are not drawn.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, {String? note}) =>
      GalleryEntry(
        id: 'ht.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: HaitiCountry.haiti,
        validator: const HaitiValidator(),
        sampleValues: HaitiSerialGenerator.generate(spec, random: _rng),
        note: note,
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current series',
      note:
          'Two letters and five digits. The 2014 plate is black on salmon with '
          'HAÏTI stacked at the left; the 2006 plate is dark green on grey '
          'with the department named on a black band.',
      entries: <GalleryEntry>[
        _entry(
          'transport2014',
          'Transport passagers · 2014',
          HaitiPlates.transport2014,
          HaitiThemes.transport2014,
          note: 'The map of Haiti behind the serial is not drawn.',
        ),
        _entry(
          'regional2006',
          'Regional · 2006',
          HaitiPlates.regional2006,
          HaitiThemes.regional2006,
          note: 'The band always reads "Ouest"; it varies by department.',
        ),
      ],
    ),
    GallerySection(
      title: '2003 series',
      note:
          'Navy on white with a black caption band and the flag at the right. '
          'Private has one letter, transport two, location none; four digits.',
      entries: <GalleryEntry>[
        _entry('private2003', 'Private · Privé', HaitiPlates.private2003, HaitiThemes.series2003),
        _entry('location2003', 'Location', HaitiPlates.location2003, HaitiThemes.series2003),
        _entry(
          'transport2003',
          'Transport passagers',
          HaitiPlates.transport2003,
          HaitiThemes.series2003,
        ),
      ],
    ),
    GallerySection(
      title: '1998 series',
      note:
          'Red on white in a red rim, HAÏTI and the caption in blue. Taxi and '
          'transport carry two letters; the international-organisation plate '
          'only digits.',
      entries: <GalleryEntry>[
        _entry('taxi1998', 'Taxi', HaitiPlates.taxi1998, HaitiThemes.series1998),
        _entry('transport1998', 'Transport', HaitiPlates.transport1998, HaitiThemes.series1998),
        _entry(
          'organisation1998',
          'International organisation',
          HaitiPlates.organisation1998,
          HaitiThemes.series1998,
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
