import 'package:bulgaria_plate/bulgaria_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `bulgaria_plate`: the registration plate with its electric and repeater
/// variants, the army and civil-protection plates, and the foreigner and
/// diplomatic plates, all 520 × 110.
class BulgariaSource extends GallerySource {
  BulgariaSource();

  @override
  String get countryName => 'Bulgaria';

  @override
  String get packageName => 'bulgaria_plate';

  @override
  String get note =>
      'A province code, four digits and a series, black on white behind the '
      'EU band. Electric plates are green and repeaters red; army and civil '
      'protection plates carry the national flag on the band; foreigners are '
      'white on light blue and diplomats white on red, with the expiry year '
      'small under a dash. Diplomatic mission 22 is refused (COUNTRY NOT '
      'FOUND). Not drawn: temporary plates, pre-1986 plates and the trailer '
      'series.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    PlateValidator validator = const BulgariaValidator(),
  }) => GalleryEntry(
    id: 'bg.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: spec.country,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Province code, four digits, series; the EU band is background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          BulgariaPlates.private,
          BulgariaThemes.private,
          <String?>['C', '5096', 'MK'],
        ),
        _entry(
          'electric',
          'Electric · green',
          BulgariaPlates.electric,
          BulgariaThemes.electric,
          <String?>['EA', '0082', 'AA'],
        ),
        _entry(
          'repeater',
          'Repeater · red',
          BulgariaPlates.repeater,
          BulgariaThemes.repeater,
          <String?>['CB', '2830', 'KP'],
        ),
      ],
    ),
    GallerySection(
      title: 'Official',
      note: 'Army and civil protection under the flag band; the year is a field.',
      entries: <GalleryEntry>[
        _entry('military', 'Army · BA', BulgariaPlates.military, BulgariaThemes.military, <String?>[
          'BA',
          '509',
          '096',
        ], validator: const BulgariaServiceValidator()),
        _entry(
          'civil_protection',
          'Civil protection · CP',
          BulgariaPlates.civilProtection,
          BulgariaThemes.civilProtection,
          <String?>['CP', '59', '096'],
          validator: const BulgariaServiceValidator(),
        ),
        _entry(
          'foreigner',
          'Foreigner · light blue',
          BulgariaPlates.foreigner,
          BulgariaThemes.foreigner,
          <String?>['XX', '9043', '19'],
          validator: const BulgariaStampedValidator(),
        ),
        _entry(
          'diplomatic',
          'Diplomatic · red',
          BulgariaPlates.diplomatic,
          BulgariaThemes.diplomatic,
          <String?>['CC', '77', '11', '20'],
          validator: const BulgariaStampedValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
