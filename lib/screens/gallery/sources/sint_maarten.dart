import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `sint_maarten_plate`: A one- or two-letter prefix and up to four digits.
class SintMaartenSource extends GallerySource {
  SintMaartenSource();

  @override
  String get countryName => 'Sint Maarten';

  @override
  String get packageName => 'sint_maarten_plate';

  @override
  String get note => 'A one- or two-letter prefix and up to four digits.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'sx.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: SintMaartenCountry.sint_maarten,
        validator: const SintMaartenValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'A one- or two-letter prefix and up to four digits.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private',
          SintMaartenPlates.private,
          SintMaartenThemes.private,
          'P 2404',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
