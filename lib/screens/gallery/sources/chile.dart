import 'package:chile_plate/chile_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `chile_plate`: the 360 × 130 private plate and the orange provisional
/// plate.
class ChileSource extends GallerySource {
  ChileSource();

  @override
  String get countryName => 'Chile';

  @override
  String get packageName => 'chile_plate';

  @override
  String get note =>
      'Four consonants and two digits (`BB·BB·10`) with CHILE below, in '
      'the colour of the vehicle use; colours are sampled from the vector '
      'overview. Not drawn: the arms inside the shield, the motorcycle, '
      'fire brigade and army plates. Diplomatic mission 39 (Israel) is '
      'refused with PlateRestriction.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'cl.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: ChileCountry.chile,
        validator: const ChileValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and commercial — 360 × 130',
      note:
          'Four consonants and two digits; the colour says the use. Ink is '
          'about 74% of the reference height.',
      entries: <GalleryEntry>[
        _entry('private', 'Private', ChilePlates.private, ChileThemes.private, 'BB BB 10'),
        _entry('taxi', 'Basic taxi', ChilePlates.taxi, ChileThemes.taxi, 'BP CW 17'),
        _entry(
          'collective_taxi',
          'Collective taxi',
          ChilePlates.collectiveTaxi,
          ChileThemes.collectiveTaxi,
          'CD JL 70',
        ),
        _entry(
          'radiotaxi',
          'Radio taxi and tourism',
          ChilePlates.radiotaxi,
          ChileThemes.radiotaxi,
          'CT YS 61',
        ),
        _entry('bus', 'Transantiago bus', ChilePlates.bus, ChileThemes.bus, 'DH RJ 52'),
        _entry(
          'free_zone',
          'Free-zone vehicles',
          ChilePlates.freeZone,
          ChileThemes.freeZone,
          'DZ GF 45',
        ),
      ],
    ),
    GallerySection(
      title: 'Trailers',
      note:
          'Over 3,860 kg: two letters and two pairs of digits. Under it: '
          'red on white with the region above.',
      entries: <GalleryEntry>[
        _entry(
          'trailer',
          'Trailer over 3,860 kg',
          ChilePlates.trailer,
          ChileThemes.trailer,
          'JD 20 67',
        ),
        _entry(
          'light_trailer',
          'Trailer under 3,860 kg',
          ChilePlates.lightTrailer,
          ChileThemes.lightTrailer,
          'BKF 125',
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic, police, provisional',
      note: 'The diplomatic mission pair 39 is refused as COUNTRY NOT FOUND.',
      entries: <GalleryEntry>[
        _entry(
          'diplomatic',
          'Diplomatic corps',
          ChilePlates.diplomatic,
          ChileThemes.diplomatic,
          'CD 24 01',
        ),
        _entry('police', 'Carabineros', ChilePlates.police, ChileThemes.police, 'RP 2560'),
        _entry(
          'provisional',
          'Provisional',
          ChilePlates.provisional,
          ChileThemes.provisional,
          'PR 045',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
