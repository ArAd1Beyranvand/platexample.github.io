import 'package:hungary_plate/hungary_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `hungary_plate`: the 2022 plate (520 × 110, EU band, coat of arms), the
/// diplomatic and staff plates, and the older-style plates with the tricolour.
class HungarySource extends GallerySource {
  HungarySource();

  @override
  String get countryName => 'Hungary';

  @override
  String get packageName => 'hungary_plate';

  @override
  String get note =>
      'Since 1 July 2022 two letters, the coat of arms, two letters, a dash '
      'and three digits, black on white with the EU band; the letters carry '
      'no geography. Diplomatic plates are pale blue on blue, embassy staff '
      'red on cream. Not drawn: the pre-1990 and foreign-resident plates '
      '(no longer issued), the US-size, sporting and moped plates (photos too '
      'blurred to measure) and the trial and export date stickers.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'hu.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: spec.country,
        validator: const HungaryValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'The 2022 plate; the EU band is painted by the background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · 2022',
          HungaryPlates.private,
          HungaryThemes.private,
          'AA BP 022',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Two letters and two pairs of digits.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic · blue',
          HungaryPlates.diplomatic,
          HungaryThemes.diplomatic,
          'DT 04 56',
        ),
        _entry(
          'staff',
          'Embassy staff · red',
          HungaryPlates.staff,
          HungaryThemes.staff,
          'CK 06 29',
        ),
      ],
    ),
    GallerySection(
      title: 'Special',
      note: 'Older style: the tricolour and `H` left of a divider.',
      entries: <GalleryEntry>[
        _entry(
          'agricultural',
          'Agricultural',
          HungaryPlates.agricultural,
          HungaryThemes.oldStyle,
          'M 010311',
        ),
        _entry('export', 'Export', HungaryPlates.export, HungaryThemes.oldStyle, 'Z 07458 17'),
        _entry('trial', 'Trial', HungaryPlates.trial, HungaryThemes.oldStyle, 'P 04017 16'),
        _entry(
          'slow',
          'Slow vehicle · two rows',
          HungaryPlates.slowVehicle,
          HungaryThemes.slowVehicle,
          'YEW 557',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
