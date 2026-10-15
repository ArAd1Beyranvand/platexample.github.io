import '../catalogue.dart';
import 'sources.dart';
import 'algeria.dart';
import 'angola.dart';
import 'belarus.dart';
import 'benin.dart';
import 'bhutan.dart';
import 'bolivia.dart';
import 'bosnia_and_herzegovina.dart';
import 'botswana.dart';
import 'brazil.dart';
import 'burkina_faso.dart';
import 'cambodia.dart';
import 'central_african_republic.dart';
import 'chile.dart';
import 'colombia.dart';
import 'comoros.dart';
import 'cuba.dart';
import 'djibouti.dart';
import 'egypt.dart';
import 'eritrea.dart';
import 'gambia.dart';
import 'germany.dart';
import 'guinea.dart';
import 'portugal.dart';
import 'italy.dart';
import 'jordan.dart';
import 'libya.dart';
import 'mali.dart';
import 'malta.dart';
import 'mauritania.dart';
import 'mongolia.dart';
import 'mozambique.dart';
import 'myanmar.dart';
import 'namibia.dart';
import 'nicaragua.dart';
import 'niger.dart';
import 'norway.dart';
import 'republic_of_ireland.dart';
import 'republic_of_the_congo.dart';
import 'saint_vincent_and_the_grenadines.dart';
import 'serbia.dart';
import 'slovenia.dart';
import 'somalia.dart';
import 'spain.dart';
import 'sri_lanka.dart';
import 'sudan.dart';
import 'tanzania.dart';
import 'thailand.dart';
import 'timor_leste.dart';
import 'tunisia.dart';
import 'uruguay.dart';
import 'vatican_city.dart';
import 'venezuela.dart';
import 'zimbabwe.dart';

/// A continent's umbrella: one group on Discover, and at `/discover/{region}`
/// an overview with one group per country, each country's page nested under
/// it. Unlike Iranshahr and Yemen it ships no package of its own — its
/// sections are its members' sections, flattened.
class RegionSource extends GallerySource {
  RegionSource(
    this.countryName,
    this._own, {
    this.alsoNames = const <String>{},
  });

  @override
  final String countryName;

  final List<GallerySource> _own;

  /// Countries that sit at the top level (or under Iranshahr) and also belong
  /// here. They are the same instances as there, so each plate stays one item;
  /// resolved on first read because [gallerySources] is built around this.
  final Set<String> alsoNames;

  @override
  late final List<GallerySource> members = <GallerySource>[
    ..._own,
    for (final GallerySource top in gallerySources)
      if (top is! RegionSource)
        for (final GallerySource s in <GallerySource>[top, ...top.members])
          if (alsoNames.contains(s.countryName) &&
              !_own.any((GallerySource o) => identical(o, s)))
            s,
  ];

  @override
  List<String> get countryNames => <String>[
    for (final GallerySource member in members) ...member.countryNames,
  ];

  @override
  List<String> get packageNames => <String>[
    for (final GallerySource member in members) ...member.packageNames,
  ];

  @override
  String get packageName => '${members.length} packages';

  @override
  String get overviewTitle => '${members.length} countries, one continent';

  @override
  String get note =>
      'Every country in the catalogue from $countryName: '
      '${members.map((GallerySource m) => m.countryName).join(', ')}.';

  /// Built once, and returned by identity, as on every other source.
  @override
  late final List<GallerySection> sections = <GallerySection>[
    for (final GallerySource member in members) ...member.sections,
  ];

  /// One plate per country, not one per section.
  @override
  late final List<GalleryEntry> highlights = <GalleryEntry>[
    for (final GallerySource member in members)
      if (member.highlights.isNotEmpty) member.highlights.first,
  ];
}

final List<GallerySource> europeCountries = <GallerySource>[
  const GermanySource(),
  BelarusSource(),
  RepublicOfIrelandSource(),
  SpainSource(),
  ItalySource(),
  SloveniaSource(),
  BosniaAndHerzegovinaSource(),
  SerbiaSource(),
  MaltaSource(),
  NorwaySource(),
  VaticanCitySource(),
  PortugalSource(),
];

final List<GallerySource> africaCountries = <GallerySource>[
  AlgeriaSource(),
  TunisiaSource(),
  LibyaSource(),
  EgyptSource(),
  SudanSource(),
  NigerSource(),
  MaliSource(),
  MauritaniaSource(),
  BurkinaFasoSource(),
  BeninSource(),
  CentralAfricanRepublicSource(),
  RepublicOfTheCongoSource(),
  AngolaSource(),
  MozambiqueSource(),
  TanzaniaSource(),
  BotswanaSource(),
  NamibiaSource(),
  ZimbabweSource(),
  ComorosSource(),
  SomaliaSource(),
  DjiboutiSource(),
  EritreaSource(),
  GambiaSource(),
  GuineaSource(),
];

final List<GallerySource> americaCountries = <GallerySource>[
  CubaSource(),
  SaintVincentAndTheGrenadinesSource(),
  VenezuelaSource(),
  NicaraguaSource(),
  ColombiaSource(),
  BoliviaSource(),
  BrazilSource(),
  ChileSource(),
  UruguaySource(),
];

/// Asia's own countries. Iran, Iranshahr, Yemen and the other long-standing
/// Asian sources stay at the top level — they are landmarks of the catalogue
/// in their own right, and burying them one level down would make them harder
/// to reach, not easier.
final List<GallerySource> asiaCountries = <GallerySource>[
  JordanSource(),
  MongoliaSource(),
  BhutanSource(),
  SriLankaSource(),
  MyanmarSource(),
  ThailandSource(),
  CambodiaSource(),
  TimorLesteSource(),
];
