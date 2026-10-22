import 'package:ecuador_plate/ecuador_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ecuador_plate`: two designs; the category is the band colour, a theme.
class EcuadorSource extends GallerySource {
  EcuadorSource();

  @override
  String get countryName => 'Ecuador';

  @override
  String get packageName => 'ecuador_plate';

  @override
  String get note =>
      'Three letters and three or four digits. The first letter is the '
      'province, the second the type of vehicle; the type shows as the colour '
      'of the band under ECUADOR.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values, {
    String? note,
  }) => GalleryEntry(
    id: 'ec.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: EcuadorCountry.ecuador,
    validator: const EcuadorValidator(),
    sampleValues: values,
    note: note,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard plates',
      note:
          'One design in five liveries, named by the second letter. The '
          'examples are the article\'s. The digits are a little under the '
          'real height: the plate face is condensed, and a fixed cell caps '
          'the engine\'s wider glyph.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · any other second letter',
          EcuadorPlates.standard,
          EcuadorThemes.private,
          <String?>['EBA', '0234'],
        ),
        _entry(
          'commercial',
          'Commercial · A, U, Z · orange',
          EcuadorPlates.standard,
          EcuadorThemes.commercial,
          <String?>['AAB', '0123'],
        ),
        _entry(
          'government',
          'Government · E · gold',
          EcuadorPlates.standard,
          EcuadorThemes.government,
          <String?>['PEB', '0001'],
        ),
        _entry(
          'official',
          'Official use · X · gold',
          EcuadorPlates.standard,
          EcuadorThemes.government,
          <String?>['GXA', '0100'],
        ),
        _entry(
          'municipal',
          'Decentralised governments · M, S · lime',
          EcuadorPlates.standard,
          EcuadorThemes.municipal,
          <String?>['LMA', '0010'],
        ),
      ],
    ),
    GallerySection(
      title: 'Protocol plates',
      note:
          'A two-letter code and the number: CC consular corps, CD diplomatic '
          'corps, OI international organisation, AT administrative and '
          'technical staff on blue; IT on red.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic · blue',
          EcuadorPlates.protocol,
          EcuadorThemes.diplomatic,
          <String?>['CC', '0012'],
        ),
        _entry(
          'international',
          'International organisation · red',
          EcuadorPlates.protocol,
          EcuadorThemes.international,
          <String?>['IT', '0654'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
