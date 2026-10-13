import 'package:egypt_plate/egypt_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `egypt_plate`: the 2008 plate in its usage colours, where the colour is
/// the *country band* and not the theme — digits then Arabic letters, with
/// the Cairo and Giza variants and the motorcycle plate.
class EgyptSource extends GallerySource {
  EgyptSource();

  @override
  String get countryName => 'Egypt';

  @override
  String get packageName => 'egypt_plate';

  @override
  String get note =>
      'Arabic digits then Arabic letters, black on white with a coloured band '
      'naming the usage: blue for private, orange for taxis, red for trucks, '
      'green for diplomatic. Cairo and Giza shift the digit/letter split. Not '
      'drawn: the Latin transliteration row and the older formats.';

  /// The validator is per-geometry (it counts each group's cells), so it
  /// travels with the spec rather than being one constant for the country.
  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateCountry country,
    String values, {
    required EgyptValidator validator,
  }) => GalleryEntry(
    id: 'eg.$id',
    label: label,
    spec: spec,
    theme: EgyptThemes.standard,
    country: country,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and commercial',
      note: 'One geometry; the band colour is the usage.',
      entries: <GalleryEntry>[
        _e('private', 'Private · blue band', EgyptPlates.car,
            EgyptCountry.private, '1234 ABG', validator: EgyptValidator.car),
        _e('taxi', 'Taxi · orange band', EgyptPlates.car,
            EgyptCountry.taxi, '5678 DRS', validator: EgyptValidator.car),
        _e('truck', 'Truck · red band', EgyptPlates.car,
            EgyptCountry.truck, '9012 CTE', validator: EgyptValidator.car),
        _e('bus', 'Bus · grey band', EgyptPlates.car,
            EgyptCountry.bus, '3456 FKL', validator: EgyptValidator.car),
        _e('tourist', 'Tourist · beige band', EgyptPlates.car,
            EgyptCountry.tourist, '7890 LMN', validator: EgyptValidator.car),
        _e('customs', 'Customs · yellow band', EgyptPlates.car,
            EgyptCountry.customs, '1122 HWY', validator: EgyptValidator.car),
      ],
    ),
    GallerySection(
      title: 'Governorate variants',
      note: 'Cairo and Giza carry one fewer digit or letter.',
      entries: <GalleryEntry>[
        _e('cairo', 'Cairo', EgyptPlates.cairo,
            EgyptCountry.private, '123 ABG', validator: EgyptValidator.cairo),
        _e('giza', 'Giza', EgyptPlates.giza,
            EgyptCountry.private, '1234 AB', validator: EgyptValidator.giza),
      ],
    ),
    GallerySection(
      title: 'Official and motorcycle',
      note: 'Diplomatic and police plates, and the two-row motorcycle plate.',
      entries: <GalleryEntry>[
        _e('diplomatic', 'Diplomatic · green band', EgyptPlates.diplomatic,
            EgyptCountry.diplomatic, '123 45', validator: EgyptValidator.diplomatic),
        _e('police', 'Police', EgyptPlates.police,
            EgyptCountry.police, '1234 56 A', validator: EgyptValidator.police),
        _e('motorcycle', 'Motorcycle', EgyptPlates.motorcycle,
            EgyptCountry.motorcycle, 'ABG 1234', validator: EgyptValidator.motorcycle),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
