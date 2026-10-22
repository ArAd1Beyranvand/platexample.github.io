import 'package:costa_rica_plate/costa_rica_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `costa_rica_plate`: the 2013 series, one design per layout and one theme
/// per livery.
class CostaRicaSource extends GallerySource {
  CostaRicaSource();

  @override
  String get countryName => 'Costa Rica';

  @override
  String get packageName => 'costa_rica_plate';

  @override
  String get note =>
      'Three letters and three digits on blue, with the flag at the right '
      'and a hologram at the left.';

  GalleryEntry _entry(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    CostaRicaFormat format,
    List<String?> values,
  ) => GalleryEntry(
    id: 'cr.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: CostaRicaCountry.costaRica,
    validator: CostaRicaValidator(format),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and electric',
      note:
          'Letters, a dash and digits. Electric plates keep the layout in '
          'teal; their glyphs are about 78% of the reference height.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private · ABC-123',
          CostaRicaPlates.private,
          CostaRicaThemes.blue,
          CostaRicaFormat.private,
          <String?>['DCF', '239'],
        ),
        _entry(
          'electric',
          'Electric · ABC-123',
          CostaRicaPlates.electric,
          CostaRicaThemes.electric,
          CostaRicaFormat.private,
          <String?>['FGM', '226'],
        ),
        _entry(
          'disabled',
          'Disabled driver · D-123',
          CostaRicaPlates.disabled,
          CostaRicaThemes.blue,
          CostaRicaFormat.disabled,
          <String?>['699'],
        ),
        _entry(
          'motorcycle',
          'Motorcycle · M 123456',
          CostaRicaPlates.motorcycle,
          CostaRicaThemes.blue,
          CostaRicaFormat.commercial,
          <String?>['225846'],
        ),
      ],
    ),
    GallerySection(
      title: 'Public transport and goods',
      note:
          'A yellow strip carries the category letters. Four-digit plates '
          'sit in a five-digit box.',
      entries: <GalleryEntry>[
        _entry(
          'interprovincialBus',
          'Interprovincial bus · AB 1234',
          CostaRicaPlates.interprovincialBus,
          CostaRicaThemes.black,
          CostaRicaFormat.bus,
          <String?>['1234'],
        ),
        _entry(
          'cityBus',
          'City bus · SJB 1234',
          CostaRicaPlates.cityBus,
          CostaRicaThemes.black,
          CostaRicaFormat.bus,
          <String?>['1234'],
        ),
        _entry(
          'taxi',
          'Taxi · TA 1234',
          CostaRicaPlates.taxi,
          CostaRicaThemes.taxi,
          CostaRicaFormat.bus,
          <String?>['1234'],
        ),
        _entry(
          'cityTaxi',
          'City taxi · TSJ 1234',
          CostaRicaPlates.cityTaxi,
          CostaRicaThemes.red,
          CostaRicaFormat.bus,
          <String?>['1234'],
        ),
        _entry(
          'commercial',
          'Commercial · C 123456',
          CostaRicaPlates.commercial,
          CostaRicaThemes.red,
          CostaRicaFormat.commercial,
          <String?>['457611'],
        ),
        _entry(
          'lightLoadTruck',
          'Light load truck · CL 123456',
          CostaRicaPlates.lightLoadTruck,
          CostaRicaThemes.red,
          CostaRicaFormat.commercial,
          <String?>['561937'],
        ),
      ],
    ),
    GallerySection(
      title: 'Protocol, consular, official and historical',
      note:
          'Protocol plates stack a two-digit code beside a dot and the '
          'number; each stacked digit is its own field.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic · CD 12 · 123',
          CostaRicaPlates.diplomatic,
          CostaRicaThemes.black,
          CostaRicaFormat.protocol,
          <String?>['3', '2', '427'],
        ),
        _entry(
          'internationalMission',
          'International mission · MI 12 · 123',
          CostaRicaPlates.internationalMission,
          CostaRicaThemes.mission,
          CostaRicaFormat.protocol,
          <String?>['2', '3', '289'],
        ),
        _entry(
          'powerExecutive',
          'Executive power · PE 12 · 1234',
          CostaRicaPlates.powerExecutive,
          CostaRicaThemes.green,
          CostaRicaFormat.powerExecutive,
          <String?>['1', '2', '4122'],
        ),
        _entry(
          'consular',
          'Consular · CC 1 · 12',
          CostaRicaPlates.consular,
          CostaRicaThemes.black,
          CostaRicaFormat.consular,
          <String?>['4', '77'],
        ),
        _entry(
          'official',
          'Official · 12 · 1234',
          CostaRicaPlates.official,
          CostaRicaThemes.red,
          CostaRicaFormat.official,
          <String?>['29', '6944'],
        ),
        _entry(
          'historical',
          'Historical · VH 1234',
          CostaRicaPlates.historical,
          CostaRicaThemes.historic,
          CostaRicaFormat.historical,
          <String?>['30'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
