import 'package:plate_core/plate_core.dart';
import 'package:spain_plate/spain_plate.dart';

import '../catalogue.dart';

/// `spain_plate`: the current `1234 BCD` registration plate with the EU band,
/// the single-colour taxi, trailer and provisional plates, and the diplomatic
/// family, all 500 × 110.
class SpainSource extends GallerySource {
  SpainSource();

  @override
  String get countryName => 'Spain';

  @override
  String get packageName => 'spain_plate';

  @override
  String get note =>
      'Four digits and three consonants, black on white with the EU band. '
      'Taxi, trailer and provisional plates are one colour with no band; '
      'diplomatic plates carry CD, CC or OI, an embassy code and a car number. '
      'Embassy code 83 is the one the article lists for Israel, so it is '
      'refused with "COUNTRY NOT FOUND". Not drawn: historic, police, moped, '
      'dealer and temporary plates.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'es.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: SpainCountry.spain,
    validator: const SpainValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note:
          'One design with the EU band; the euroband is painted by the '
          'background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · black on white',
          SpainPlates.private,
          SpainThemes.private,
          '2008 ZGZ',
        ),
      ],
    ),
    GallerySection(
      title: 'Single colour',
      note:
          'Four digits and three letters on a plain field; the trailer and '
          'provisional plates lead with a fixed R or P.',
      entries: <GalleryEntry>[
        _entry(
          'taxi',
          'Taxi · light on blue',
          SpainPlates.taxi,
          SpainThemes.taxi,
          '6334 HRD',
        ),
        _entry(
          'trailer',
          'Trailer · R',
          SpainPlates.trailer,
          SpainThemes.trailer,
          '7286 BBW',
        ),
        _entry(
          'provisional',
          'Provisional · P',
          SpainPlates.provisional,
          SpainThemes.provisional,
          '1588 BBS',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note:
          'Prefix, embassy code of one to three digits, car number. Code 83 '
          'is refused.',
      entries: <GalleryEntry>[
        _entry(
          'cd',
          'Diplomatic · CD',
          SpainPlates.diplomatic,
          SpainThemes.diplomatic,
          'CD 1 001',
        ),
        _entry(
          'cc',
          'Consular · CC',
          SpainPlates.diplomatic,
          SpainThemes.consular,
          'CC 10 014',
        ),
        _entry(
          'oi',
          'International organisation · OI',
          SpainPlates.diplomatic,
          SpainThemes.organisation,
          'OI 303 073',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
