import '../catalogue.dart';
import 'algeria.dart';
import 'belarus.dart';
import 'bolivia.dart';
import 'brazil.dart';
import 'burkina_faso.dart';
import 'chile.dart';
import 'colombia.dart';
import 'comoros.dart';
import 'cuba.dart';
import 'djibouti.dart';
import 'eritrea.dart';
import 'germany.dart';
import 'italy.dart';
import 'libya.dart';
import 'mali.dart';
import 'mauritania.dart';
import 'namibia.dart';
import 'nicaragua.dart';
import 'niger.dart';
import 'republic_of_ireland.dart';
import 'slovenia.dart';
import 'somalia.dart';
import 'spain.dart';
import 'sudan.dart';
import 'tunisia.dart';
import 'venezuela.dart';
import 'zimbabwe.dart';

/// A continent's umbrella: one group on Discover, and at `/discover/{region}`
/// an overview with one group per country, each country's page nested under
/// it. Unlike Iranshahr and Yemen it ships no package of its own — its
/// sections are its members' sections, flattened.
class RegionSource extends GallerySource {
  RegionSource(this.countryName, this.members);

  @override
  final String countryName;

  @override
  final List<GallerySource> members;

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
];

final List<GallerySource> africaCountries = <GallerySource>[
  AlgeriaSource(),
  TunisiaSource(),
  LibyaSource(),
  SudanSource(),
  NigerSource(),
  MaliSource(),
  MauritaniaSource(),
  BurkinaFasoSource(),
  NamibiaSource(),
  ZimbabweSource(),
  ComorosSource(),
  SomaliaSource(),
  DjiboutiSource(),
  EritreaSource(),
];

final List<GallerySource> americaCountries = <GallerySource>[
  CubaSource(),
  VenezuelaSource(),
  NicaraguaSource(),
  ColombiaSource(),
  BoliviaSource(),
  BrazilSource(),
  ChileSource(),
];
