import 'package:georgia_country_plate/georgia_country_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `georgia_country_plate`: the 2014 blue-strip series and its variants. The
/// embassy entry's spec and validator refuse mission code 004 with "COUNTRY
/// NOT FOUND".
class GeorgiaCountrySource extends GallerySource {
  GeorgiaCountrySource();

  @override
  String get countryName => 'Georgia';

  @override
  String get packageName => 'georgia_country_plate';

  @override
  String get note =>
      'Latin letters and digits, black on white, a blue strip with the flag '
      'and GE. Embassy mission code 004 is refused in every layer with '
      '"COUNTRY NOT FOUND". The embassy plate is unmeasured (no photo).';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    GeorgiaCountryValidator validator,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: spec.country,
    validator: validator,
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One line — 520 × 110',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'ge.private',
          'Private',
          GeorgiaCountryPlates.private,
          GeorgiaCountryThemes.private,
          GeorgiaCountryValidator.private,
          <String?>['AB', '440', 'BA'],
        ),
        _e(
          'ge.trailer',
          'Trailer',
          GeorgiaCountryPlates.trailer,
          GeorgiaCountryThemes.private,
          GeorgiaCountryValidator.trailer,
          <String?>['GG', '101', 'G'],
        ),
        _e(
          'ge.temporary',
          'Temporary',
          GeorgiaCountryPlates.temporary,
          GeorgiaCountryThemes.temporary,
          GeorgiaCountryValidator.temporary,
          <String?>['GP', '5891'],
        ),
        _e(
          'ge.vanity',
          'Vanity',
          GeorgiaCountryPlates.vanity,
          GeorgiaCountryThemes.private,
          GeorgiaCountryValidator.vanity,
          <String?>['8'],
        ),
        _e(
          'ge.export',
          'Export',
          GeorgiaCountryPlates.export,
          GeorgiaCountryThemes.export,
          GeorgiaCountryValidator.export,
          <String?>['0092', '04', 'AK'],
        ),
        _e(
          'ge.transit',
          'Transit',
          GeorgiaCountryPlates.transit,
          GeorgiaCountryThemes.transit,
          GeorgiaCountryValidator.transit,
          <String?>['5045', 'AT'],
        ),
        _e(
          'ge.mission',
          'EU Monitoring Mission',
          GeorgiaCountryPlates.mission,
          GeorgiaCountryThemes.mission,
          GeorgiaCountryValidator.mission,
          <String?>['EUMM', '085'],
        ),
        _e(
          'ge.military',
          'Military',
          GeorgiaCountryPlates.military,
          GeorgiaCountryThemes.military,
          GeorgiaCountryValidator.military,
          <String?>['AD', '217'],
        ),
        _e(
          'ge.diplomatic',
          'Embassy',
          GeorgiaCountryPlates.diplomatic,
          GeorgiaCountryThemes.diplomatic,
          GeorgiaCountryValidator.diplomatic,
          <String?>['012', 'CMD', '001'],
          note: 'Unmeasured. Mission code 004 is refused.',
        ),
      ],
    ),
    GallerySection(
      title: 'Stacked',
      note: 'Squared 330 × 205 and motorcycle 240 × 135, a blue corner block.',
      entries: <GalleryEntry>[
        _e(
          'ge.squared',
          'Squared',
          GeorgiaCountryPlates.squared,
          GeorgiaCountryThemes.private,
          GeorgiaCountryValidator.private,
          <String?>['TA', '001', 'KI'],
        ),
        _e(
          'ge.motorcycle',
          'Motorcycle',
          GeorgiaCountryPlates.motorcycle,
          GeorgiaCountryThemes.private,
          GeorgiaCountryValidator.motorcycle,
          <String?>['AA', '1234'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
