import 'package:plate_core/plate_core.dart';
import 'package:vanuatu_plate/vanuatu_plate.dart';

import '../catalogue.dart';

/// `vanuatu_plate`: a digit-only register between two palms, the length of the
/// number set by the caller, and the lettered diplomatic plate.
class VanuatuSource extends GallerySource {
  VanuatuSource();

  @override
  String get countryName => 'Vanuatu';

  @override
  String get packageName => 'vanuatu_plate';

  @override
  String get note =>
      'Digits between two palm leaves with the country caption beneath. The '
      'number runs from one digit to five in one field. The diplomatic plate carries four '
      'letters and a digit. Not drawn: the island code and the motorcycle '
      'plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const VanuatuValidator(),
  }) => GalleryEntry(
    id: 'vu.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: VanuatuCountry.vanuatu,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note: 'One to five digits in a single field.',
      entries: <GalleryEntry>[
        _e('standard', 'Standard', VanuatuPlates.standard,
            VanuatuThemes.standard, '7906'),
        _e('standard.short', 'Standard · short number',
            VanuatuPlates.standard, VanuatuThemes.standard, '42'),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Four letters and a digit.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic corps', VanuatuPlates.diplomatic,
            VanuatuThemes.diplomatic, 'CORP 1',
            validator: const VanuatuDiplomaticValidator()),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
