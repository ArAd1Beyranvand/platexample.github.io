import 'package:angola_plate/angola_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `angola_plate`: the 2015 plate, two letters, four digits and two letters,
/// as the one-line plate and the stacked motorcycle plate.
class AngolaSource extends GallerySource {
  AngolaSource();

  @override
  String get countryName => 'Angola';

  @override
  String get packageName => 'angola_plate';

  @override
  String get note =>
      'Two letters, four digits and two letters, black on white with the '
      'national band. The motorcycle plate stacks the same characters over '
      'two rows. Not drawn: the government, military and diplomatic series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'ao.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: AngolaCountry.angola,
    validator: const AngolaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'The same characters on one row and stacked over two.',
      entries: <GalleryEntry>[
        _e(
          'standard',
          'Private car',
          AngolaPlates.standard,
          AngolaThemes.standard,
          'L D 4 2 8 1 M A',
        ),
        _e(
          'stacked',
          'Motorcycle · stacked',
          AngolaPlates.stacked,
          AngolaThemes.stacked,
          'L D 4 2 8 1 M A',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
