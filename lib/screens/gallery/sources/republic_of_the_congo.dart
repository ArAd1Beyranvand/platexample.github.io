import 'package:plate_core/plate_core.dart';
import 'package:republic_of_the_congo_plate/republic_of_the_congo_plate.dart';

import '../catalogue.dart';

/// `republic_of_the_congo_plate`: a serial number, two series letters and the
/// area number, with the emblem and the RC code on the right.
class RepublicOfTheCongoSource extends GallerySource {
  RepublicOfTheCongoSource();

  @override
  String get countryName => 'Republic of the Congo';

  @override
  String get packageName => 'republic_of_the_congo_plate';

  @override
  String get note =>
      'Three digits, two series letters and the area number, black on white '
      'with the emblem and the RC code at the right. The area runs to two '
      'digits in the larger departments. Not drawn: the emblem\'s detail and '
      'the diplomatic and government series.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    String values,
  ) => GalleryEntry(
    id: 'cg.$id',
    label: label,
    spec: spec,
    theme: RepublicOfTheCongoThemes.private,
    country: RepublicOfTheCongoCountry.republic_of_the_congo,
    validator: const RepublicOfTheCongoValidator(),
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The area number closes the register, on one digit or two.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car · one-digit area',
          RepublicOfTheCongoPlates.private,
          '123 AB 4',
        ),
        _e(
          'private2',
          'Private car · two-digit area',
          RepublicOfTheCongoPlates.private,
          '567 CD 12',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
