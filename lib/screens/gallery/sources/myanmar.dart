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

  /// The model field is a run of free-text cells, so a sample pads out to the
  /// spec's own length rather than hard-coding how many blanks that is.
  static List<String> _values(List<String> head, String model, PlateSpec spec) {
    final List<String> cells = <String>[...head, ...model.split('')];
    return <String>[
      ...cells.take(spec.slotCount),
      for (int i = cells.length; i < spec.slotCount; i++) ' ',
    ];
  }

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
    validator: const MyanmarValidator(),
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
        _threeRow(
          'private',
          'Private car',
          MyanmarPlates.private,
          MyanmarThemes.private,
          <String>['Y', 'G', 'N', '3', '6', 'A', 'B', '3', '4', '5', '6'],
          'TOYOTA',
        ),
        _threeRow(
          'hire',
          'Hire car',
          MyanmarPlates.hire,
          MyanmarThemes.hire,
          <String>['M', 'D', 'Y', '1', '2', 'C', 'D', '7', '8', '9', '0'],
          'NISSAN',
        ),
        _threeRow(
          'religious',
          'Religious',
          MyanmarPlates.religious,
          MyanmarThemes.religious,
          <String>[
            'S', 'G', 'G', '0', '9', 'E', 'F', '5', '1', '2', '3', '4',
          ],
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
          'Y G N 1 A 2 3 4 5'.split(' '),
        ),
        _e(
          'embossed_commercial',
          'Embossed commercial · red',
          MyanmarPlates.embossedCommercial,
          MyanmarThemes.embossedCommercial,
          'M D Y 2 B 6 7 8 9'.split(' '),
        ),
        _e(
          'embossed_touring',
          'Embossed touring · blue',
          MyanmarPlates.embossedTouring,
          MyanmarThemes.embossedTouring,
          'S G G 3 C 1 2 3 4'.split(' '),
        ),
        _e(
          'organisation',
          'Organisation',
          MyanmarPlates.organisation,
          MyanmarThemes.organisation,
          'N P W 4 D 5 6 7 8'.split(' '),
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
          sampleValues: '1 2 3 4 5 6 7 8'.split(' '),
        ),
        GalleryEntry(
          id: 'mm.rickshaw',
          label: 'Rickshaw',
          spec: MyanmarPlates.rickshaw,
          theme: MyanmarThemes.rickshaw,
          country: MyanmarCountry.myanmar,
          validator: const MyanmarBurmeseValidator(),
          sampleValues: '8 7 6 5 4 3 2 1'.split(' '),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
