import 'package:democratic_republic_of_the_congo_plate/democratic_republic_of_the_congo_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `democratic_republic_of_the_congo_plate`: the private plate with the flag
/// and CGO, and the dotted one-line and UN plates of the special series.
class DemocraticRepublicOfTheCongoSource extends GallerySource {
  DemocraticRepublicOfTheCongoSource();

  @override
  String get countryName => 'Democratic Republic of the Congo';

  @override
  String get packageName => 'democratic_republic_of_the_congo_plate';

  @override
  String get note =>
      'Four digits, two letters and the province code (01–26), black on '
      'white with the flag and CGO at the left. Special series are dotted: '
      'international organisations, FARDC, police and the diplomatic corps; '
      'the UN plate is two lines. Only the private plate was measured; the '
      'others are read off photographs. Not drawn: older series, EUSEC/EUPOL, '
      'the governmental plates and the FARDC badge.';

  /// Entries the country's shared validator does not cover.
  static const Set<String> _unvalidated = <String>{'cd.police'};

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'cd.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: DemocraticRepublicOfTheCongoCountry.democratic_republic_of_the_congo,
    validator: _unvalidated.contains('cd.$id')
        ? null
        : const DemocraticRepublicOfTheCongoValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private',
      note: 'The last two digits name the province: 10 is Kongo Central.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car',
          DemocraticRepublicOfTheCongoPlates.private,
          DemocraticRepublicOfTheCongoThemes.private,
          <String?>['1234', 'AB', '10'],
        ),
      ],
    ),
    GallerySection(
      title: 'Special series',
      note: 'Dotted one-line plates and the two-line UN plate.',
      entries: <GalleryEntry>[
        _e(
          'organisation',
          'International organisation',
          DemocraticRepublicOfTheCongoPlates.organisation,
          DemocraticRepublicOfTheCongoThemes.organisation,
          <String?>['045', '015'],
        ),
        _e(
          'fardc',
          'FARDC',
          DemocraticRepublicOfTheCongoPlates.fardc,
          DemocraticRepublicOfTheCongoThemes.fardc,
          <String?>['767', '05', '18'],
        ),
        _e(
          'police',
          'National Police',
          DemocraticRepublicOfTheCongoPlates.police,
          DemocraticRepublicOfTheCongoThemes.police,
          <String?>['01', '0049'],
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          DemocraticRepublicOfTheCongoPlates.diplomatic,
          DemocraticRepublicOfTheCongoThemes.diplomatic,
          <String?>['013', 'CD', '213'],
        ),
        _e(
          'united_nations',
          'United Nations',
          DemocraticRepublicOfTheCongoPlates.unitedNations,
          DemocraticRepublicOfTheCongoThemes.unitedNations,
          <String?>['UN', '24334'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
