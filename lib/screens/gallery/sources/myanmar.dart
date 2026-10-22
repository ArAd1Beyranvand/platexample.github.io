import 'package:myanmar_plate/myanmar_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `myanmar_plate`: the three-row plate whose last row is the model name
/// spelled out cell by cell, the embossed one-row series, and the Burmese
/// motorcycle and rickshaw plates.
class MyanmarSource extends GallerySource {
  MyanmarSource();

  @override
  String get countryName => 'Myanmar';

  @override
  String get packageName => 'myanmar_plate';

  @override
  String get note =>
      'The three-row plate names the region, the township and the serial, then '
      'spells the model across a long run of cells — so the model is register '
      'data, not a label. The embossed series is one row; the motorcycle and '
      'rickshaw plates are Burmese. Not drawn: the hand-painted older plates '
      'and the Burmese township glyph variants.';

  /// The model field is a run of single-symbol cells, so a sample pads out to
  /// the spec's own length rather than hard-coding how many blanks that is.
  static List<String> _values(List<String> head, String model, PlateSpec spec) {
    final List<String> cells = <String>[...head, ...model.split('')];
    return <String>[
      ...cells.take(spec.slotCount),
      for (int i = cells.length; i < spec.slotCount; i++) ' ',
    ];
  }

  /// Entries the country's shared validator does not cover.
  static const Set<String> _unvalidated = <String>{'mm.religious'};

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String> values,
  ) => GalleryEntry(
    id: 'mm.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: MyanmarCountry.myanmar,
    validator: _unvalidated.contains('mm.$id') ? null : const MyanmarValidator(),
    sampleValues: values,
  );

  static GalleryEntry _threeRow(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String> head,
    String model,
  ) => _e(id, label, spec, theme, _values(head, model, spec));

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Three rows, with the model spelled out',
      note: 'Region, township and serial over the model name.',
      entries: <GalleryEntry>[
        _threeRow('private', 'Private car', MyanmarPlates.private, MyanmarThemes.private, <String>[
          'YGN',
          '36',
          'A',
          'B',
          '3456',
        ], 'TOYOTA'),
        _threeRow('hire', 'Hire car', MyanmarPlates.hire, MyanmarThemes.hire, <String>[
          'MDY',
          '12',
          'C',
          'D',
          '7890',
        ], 'NISSAN'),
        _threeRow('taxi', 'Taxi', MyanmarPlates.taxi, MyanmarThemes.hire, <String>[
          'YGN',
          '36',
          'E',
          'E',
          '5229',
        ], 'TOYOTA PROBOX'),
        _threeRow('hearse', 'Hearse', MyanmarPlates.hearse, MyanmarThemes.hire, <String>[
          'TNI',
          '10',
          'H',
          'S',
          'E',
          '3887',
        ], 'TOYOTA ALPHARD'),
        _threeRow(
          'religious',
          'Religious',
          MyanmarPlates.religious,
          MyanmarThemes.religious,
          <String>['SGG', '09', 'E', 'F', '5123'],
          'HINO',
        ),
      ],
    ),
    GallerySection(
      title: 'Embossed, one row',
      note: 'Region, a two-cell prefix and four digits.',
      entries: <GalleryEntry>[
        _e(
          'embossed_private',
          'Embossed private · black',
          MyanmarPlates.embossedPrivate,
          MyanmarThemes.embossedPrivate,
          <String>['YGN', '1', 'A', '2345'],
        ),
        _e(
          'embossed_commercial',
          'Embossed commercial · red',
          MyanmarPlates.embossedCommercial,
          MyanmarThemes.embossedCommercial,
          <String>['MDY', '2', 'B', '6789'],
        ),
        _e(
          'embossed_touring',
          'Embossed touring · blue',
          MyanmarPlates.embossedTouring,
          MyanmarThemes.embossedTouring,
          <String>['SGG', '3', 'C', '1234'],
        ),
        _e(
          'organisation',
          'Organisation',
          MyanmarPlates.organisation,
          MyanmarThemes.organisation,
          <String>['NPW', '4', 'D', '5678'],
        ),
      ],
    ),
    GallerySection(
      title: 'Burmese script',
      note: 'The motorcycle and rickshaw plates, read in Burmese.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'mm.motorcycle',
          label: 'Motorcycle',
          spec: MyanmarPlates.motorcycle,
          theme: MyanmarThemes.motorcycle,
          country: MyanmarCountry.myanmar,
          validator: const MyanmarBurmeseValidator(),
          sampleValues: <String>['1', '2', '3', '45678'],
        ),
        GalleryEntry(
          id: 'mm.rickshaw',
          label: 'Rickshaw',
          spec: MyanmarPlates.rickshaw,
          theme: MyanmarThemes.rickshaw,
          country: MyanmarCountry.myanmar,
          validator: const MyanmarBurmeseValidator(),
          sampleValues: <String>['8', '7', '6', '54321'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
