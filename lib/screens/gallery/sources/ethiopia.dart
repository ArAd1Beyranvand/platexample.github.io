import 'package:ethiopia_plate/ethiopia_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ethiopia_plate`: the regional (2002), private (2026) and diplomatic
/// plates. The diplomatic spec and validator refuse mission code 84 with
/// "COUNTRY NOT FOUND".
class EthiopiaSource extends GallerySource {
  EthiopiaSource();

  @override
  String get countryName => 'Ethiopia';

  @override
  String get packageName => 'ethiopia_plate';

  @override
  String get note =>
      'Blue ink on white with Ge\'ez series letters; the diplomatic plate is '
      'black with two yellow bands. Mission code 84 is refused in every layer '
      'with "COUNTRY NOT FOUND".';

  /// One string per slot; stacked pairs are two slots.
  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    PlateValidator validator = const EthiopiaValidator(),
    String? note,
  }) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: EthiopiaCountry.ethiopia,
    validator: validator,
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Current plates',
      note:
          'Ink is ~55–70% of the reference height; the Ge\'ez glyphs depend '
          'on the host font.',
      entries: <GalleryEntry>[
        _e(
          'et.regional',
          'Regional (2002)',
          EthiopiaPlates.regional,
          EthiopiaThemes.regional,
          <String?>['2', 'አ', 'አ', '012346', 'A', 'A'],
          validator: const EthiopiaRegionalValidator(),
        ),
        _e(
          'et.private',
          'Private (2026)',
          EthiopiaPlates.private,
          EthiopiaThemes.private,
          <String?>['012346'],
        ),
        _e(
          'et.diplomatic',
          'Diplomatic',
          EthiopiaPlates.diplomatic,
          EthiopiaThemes.diplomatic,
          <String?>['04', 'ኩ', 'ዴ', '0123', 'C', 'D'],
          validator: const EthiopiaDiplomaticValidator(),
          note: 'The first two digits are the mission code. Try typing 84.',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
