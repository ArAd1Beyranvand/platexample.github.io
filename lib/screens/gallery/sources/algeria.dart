import 'dart:math';

import 'package:algeria_plate/algeria_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `algeria_plate`: four geometries; front and rear are themes on one.
class AlgeriaSource extends GallerySource {
  AlgeriaSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1962);

  @override
  String get countryName => 'Algeria';

  @override
  String get packageName => 'algeria_plate';

  @override
  String get note =>
      'Digits only: a five-digit serial, the vehicle class and year of '
      'manufacture, and the wilaya. White at the front, yellow at the rear.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme, {
    PlateValidator validator = const AlgeriaValidator(),
    int? vehicleClass,
    int? wilaya,
    String? note,
  }) => GalleryEntry(
    id: 'dz.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: AlgeriaCountry.algeria,
    validator: validator,
    sampleValues: AlgeriaSerialGenerator.generate(
      spec,
      random: _rng,
      vehicleClass: vehicleClass,
      wilaya: wilaya,
    ),
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil plates',
      note:
          'One design in two liveries. The middle group is the class '
          '(1 private … 9 motorcycle) then the year of manufacture; the last '
          'is the wilaya. The digits are about three quarters of the real '
          'height: the plate face is condensed, and a fixed cell caps the '
          'engine\'s wider glyph.',
      entries: <GalleryEntry>[
        _entry(
          'front',
          'Front · black on white',
          AlgeriaPlates.singleLine,
          AlgeriaThemes.front,
          vehicleClass: 1,
          wilaya: 16,
        ),
        _entry(
          'rear',
          'Rear · black on yellow',
          AlgeriaPlates.singleLine,
          AlgeriaThemes.rear,
          vehicleClass: 1,
          wilaya: 31,
        ),
        _entry(
          'truck',
          'Truck · class 2',
          AlgeriaPlates.singleLine,
          AlgeriaThemes.rear,
          vehicleClass: 2,
        ),
        _entry(
          'twoLine',
          'Two line · 275 × 200',
          AlgeriaPlates.twoLine,
          AlgeriaThemes.rear,
          note:
              'Built from the regulation\'s dimensions; the article has no '
              'image of this plate.',
        ),
      ],
    ),
    GallerySection(
      title: 'Special plates',
      note:
          'Diplomatic plates are serial, staff status and embassy, black on '
          'teal. Army plates are silver on black with the flag in a roundel.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic',
          AlgeriaPlates.diplomatic,
          AlgeriaThemes.diplomatic,
          validator: const AlgeriaDiplomaticValidator(),
          note:
              'The teal is the article\'s colour swatch; no image of the '
              'plate was available to sample.',
        ),
        _entry('army', 'Army', AlgeriaPlates.army, AlgeriaThemes.army),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
