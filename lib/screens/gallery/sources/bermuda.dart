import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bermuda_plate`: black on white, 520 × 110 — five digits, a class prefix
/// and digits, or digits and a cycle suffix.
class BermudaSource extends GallerySource {
  BermudaSource();

  @override
  String get countryName => 'Bermuda';

  @override
  String get packageName => 'bermuda_plate';

  @override
  String get note =>
      'Private plates are five digits; other classes put one to three '
      'letters before three or four digits (CL, L, IN, HA, LP, T, CM, RMC), '
      'and auxiliary cycles put a letter after three. The pre-1975 white-on-'
      'black plates and the personalised 152 × 300 plate are not drawn, and '
      'only the private plate was measured. The article lists nothing '
      'Israel-specific, so nothing is refused.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'bm.$id',
    label: label,
    spec: spec,
    theme: BermudaThemes.plate,
    country: BermudaCountry.bermuda,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Plates',
      note: 'One livery; the field layout changes.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · five digits',
          BermudaPlates.private,
          const BermudaValidator(),
          '05293',
        ),
        _entry(
          'prefixed',
          'Class prefix · CL 123',
          BermudaPlates.prefixed,
          const BermudaPrefixedValidator(),
          'CL 123',
        ),
        _entry(
          'suffixed',
          'Auxiliary cycle · 123 Y',
          BermudaPlates.suffixed,
          const BermudaSuffixedValidator(),
          '123 Y',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
