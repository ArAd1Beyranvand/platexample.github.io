import 'package:cape_verde_plate/cape_verde_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `cape_verde_plate`: the regular, free-font, military and diplomatic plates.
class CapeVerdeSource extends GallerySource {
  CapeVerdeSource();

  @override
  String get countryName => 'Cape Verde';

  @override
  String get packageName => 'cape_verde_plate';

  @override
  String get note =>
      'One row split by square dots: an island code, two digits and two '
      'letters, white on black. Not drawn: the president\'s PR CV plate and '
      'the pre-independence CVS/CVB series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'cv.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: CapeVerdeCountry.cape_verde,
    validator: const CapeVerdeValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note:
          'The first pair is the island: BR, BV, FG, MA, SA, SL, SN, ST or SV. '
          'The free-font plate is a four-register variant in a thinner face.',
      entries: <GalleryEntry>[
        _e(
          'regular',
          'Regular · white on black',
          CapeVerdePlates.regular,
          CapeVerdeThemes.regular,
          'ST 65 BC',
        ),
        _e(
          'freeFont',
          'Free font · dark on ochre',
          CapeVerdePlates.freeFont,
          CapeVerdeThemes.freeFont,
          'ST 16 KD G',
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note:
          'Military plates carry the flag block and a fixed FA; diplomatic '
          'plates a fixed CD, the represented country, then a serial.',
      entries: <GalleryEntry>[
        _e(
          'military',
          'Military · FA',
          CapeVerdePlates.military,
          CapeVerdeThemes.regular,
          '06 86',
        ),
        _e(
          'diplomatic',
          'Diplomatic · CD',
          CapeVerdePlates.diplomatic,
          CapeVerdeThemes.diplomatic,
          '00 337',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
