import 'package:plate_core/plate_core.dart';
import 'package:slovenia_plate/slovenia_plate.dart';

import '../catalogue.dart';

/// `slovenia_plate`: the EU-band registration plate, the yellow export plate,
/// and the police and diplomatic plates, all 520 × 120.
class SloveniaSource extends GallerySource {
  SloveniaSource();

  @override
  String get countryName => 'Slovenia';

  @override
  String get packageName => 'slovenia_plate';

  @override
  String get note =>
      'A unit code, then three digits and two letters, black on white with '
      'the EU band. Export plates are yellow with the letters first; police '
      'plates are blue and lead with P; diplomatic plates lead with a green '
      'CD. Not drawn: the crest, the export date stickers, and temporary, '
      'military and motorcycle plates.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'si.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SloveniaCountry.slovenia,
    validator: const SloveniaValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note:
          'Unit code, digits and letters; the euroband is painted by the '
          'background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          SloveniaPlates.private,
          SloveniaThemes.private,
          'L J 8 9 8 K P',
        ),
        _entry(
          'export',
          'Export · yellow',
          SloveniaPlates.exportPlate,
          SloveniaThemes.exportPlate,
          'M B L L 2 5 1',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Police lead with P; diplomatic plates with a green CD.',
      entries: <GalleryEntry>[
        _entry(
          'police',
          'Police · blue',
          SloveniaPlates.police,
          SloveniaThemes.police,
          'P 0 6 6 9 7',
        ),
        _entry(
          'diplomatic',
          'Diplomatic · CD',
          SloveniaPlates.diplomatic,
          SloveniaThemes.diplomatic,
          'C D 0 8 0 5',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
