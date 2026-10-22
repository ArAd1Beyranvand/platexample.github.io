import 'package:federated_states_of_micronesia_plate/federated_states_of_micronesia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `federated_states_of_micronesia_plate`: the Pohnpei, Yap and Kosrae state plates.
class FederatedStatesOfMicronesiaSource extends GallerySource {
  FederatedStatesOfMicronesiaSource();

  @override
  String get countryName => 'Federated States of Micronesia';

  @override
  String get packageName => 'federated_states_of_micronesia_plate';

  @override
  String get note => 'One plate per state: Pohnpei, Yap and Kosrae.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, [
    PlateValidator validator = const FederatedStatesOfMicronesiaValidator(),
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: FederatedStatesOfMicronesiaCountry.federated_states_of_micronesia,
    validator: validator,
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'States',
      note: '',
      entries: <GalleryEntry>[
        _e(
          'fm.pohnpei',
          'Pohnpei',
          FederatedStatesOfMicronesiaPlates.pohnpei,
          FederatedStatesOfMicronesiaThemes.pohnpei,
          <String?>['1495'],
        ),
        _e(
          'fm.yap',
          'Yap',
          FederatedStatesOfMicronesiaPlates.yap,
          FederatedStatesOfMicronesiaThemes.yap,
          <String?>['2945'],
        ),
        _e(
          'fm.kosrae',
          'Kosrae',
          FederatedStatesOfMicronesiaPlates.kosrae,
          FederatedStatesOfMicronesiaThemes.kosrae,
          <String?>['2187'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
