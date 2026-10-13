import 'dart:math';

import 'package:colombia_plate/colombia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `colombia_plate`: the 330 × 165 `ABC·123` plate in each series and
/// livery, the National Police plate, and the new diplomatic-corps plate.
class ColombiaSource extends GallerySource {
  ColombiaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1819);

  @override
  String get countryName => 'Colombia';

  @override
  String get packageName => 'colombia_plate';

  @override
  String get note =>
      "Black on yellow for private cars: the serial split by the transport "
      "ministry's roundel, the municipality of issue underneath.";

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    required PlateValidator validator,
    List<String?>? values,
  }) => GalleryEntry(
    id: 'co.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: ColombiaCountry.colombia,
    validator: validator,
    sampleValues:
        values ?? ColombiaSerialGenerator.generate(spec, random: _rng),
  );

  GalleryEntry _series(
    ColombiaSeries s,
    PlateTheme theme,
    String format, {
    String city = 'BOGOTA D.C.',
    String? idSuffix,
    String? labelSuffix,
    List<String?>? values,
  }) => _entry(
    '${s.id}${idSuffix ?? ''}',
    '${s.english}${labelSuffix ?? ''} · $format',
    ColombiaPlates.standard(series: s, city: city),
    theme,
    validator: ColombiaValidator(s),
    values: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Cars — 330 × 165',
      note:
          'Three letters and three digits. The colour gives the service. '
          'The serial reads about 60% of the real height, because the '
          'stamped face is far narrower than the one drawn here.',
      entries: <GalleryEntry>[
        _series(
          ColombiaSeries.private,
          ColombiaThemes.private,
          'ABC·123',
          city: 'ARMENIA',
          values: <String?>['NAZ', '827'],
        ),
        _series(
          ColombiaSeries.commercial,
          ColombiaThemes.commercial,
          'ABC·123',
        ),
        _series(
          ColombiaSeries.official,
          ColombiaThemes.official,
          'OAB·123',
          city: 'PEREIRA',
        ),
        _series(ColombiaSeries.antiqueCar, ColombiaThemes.antique, 'ABC·123'),
      ],
    ),
    GallerySection(
      title: 'Mototaxis, trailers and tank trucks',
      note:
          'The same plate with the serial rearranged. Not photographed in '
          'the article: the layout is the car plate, and the tank-truck red '
          'is a placeholder.',
      entries: <GalleryEntry>[
        _series(
          ColombiaSeries.mototaxi,
          ColombiaThemes.private,
          '123·ABC',
          labelSuffix: ', private',
          city: 'SINCELEJO',
        ),
        _series(
          ColombiaSeries.mototaxi,
          ColombiaThemes.commercial,
          '123·ABC',
          idSuffix: '.commercial',
          labelSuffix: ', commercial',
          city: 'SINCELEJO',
        ),
        _series(
          ColombiaSeries.trailer,
          ColombiaThemes.official,
          'R·12345',
          city: 'CALI',
        ),
        _series(
          ColombiaSeries.tankTruck,
          ColombiaThemes.tank,
          'T·1234',
          city: 'MEDELLIN',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic and police',
      note:
          'Consular, international-organisation and administrative staff '
          'plates are the car plate in three blues. The diplomatic corps has '
          'the newer banded plate; the police their own green on white.',
      entries: <GalleryEntry>[
        _series(ColombiaSeries.consular, ColombiaThemes.consular, 'CC·1234'),
        _series(
          ColombiaSeries.organization,
          ColombiaThemes.organization,
          'OI·1234',
        ),
        _series(ColombiaSeries.staff, ColombiaThemes.staff, 'AT·1234'),
        _entry(
          'cd',
          'Diplomatic corps · A FR 000',
          ColombiaPlates.diplomatic,
          ColombiaThemes.diplomatic,
          validator: const ColombiaDiplomaticValidator(),
          values: <String?>['A', 'FR', '000'],
        ),
        _entry(
          'police',
          'National Police · 12-3456',
          ColombiaPlates.police,
          ColombiaThemes.police,
          validator: const ColombiaPoliceValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
