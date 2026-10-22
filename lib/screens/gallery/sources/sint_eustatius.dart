import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `sint_eustatius_plate`: The Statia plate and the bicentennial one, both prefixed E.
class SintEustatiusSource extends GallerySource {
  SintEustatiusSource();

  @override
  String get countryName => 'Sint Eustatius';

  @override
  String get packageName => 'sint_eustatius_plate';

  @override
  String get note => 'The Statia plate and the bicentennial one, both prefixed E.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'se.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: SintEustatiusCountry.sint_eustatius,
        validator: const SintEustatiusValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'The Statia plate and the bicentennial one, both prefixed E.',
      entries: <GalleryEntry>[
        _entry('statia', 'Statia', SintEustatiusPlates.statia, SintEustatiusThemes.statia, 'E 30'),
        _entry(
          'bicentennial',
          'Bicentennial',
          SintEustatiusPlates.bicentennial,
          SintEustatiusThemes.bicentennial,
          'E 191',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
