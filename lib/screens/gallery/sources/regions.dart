import '../catalogue.dart';
import 'sources.dart';
import 'algeria.dart';
import 'russia.dart';
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
import 'kenya.dart';
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
import 'malawi.dart';
import 'vatican_city.dart';
import 'venezuela.dart';
import 'zimbabwe.dart';

/// Countries by how many systems the catalogue is after, most first; the
/// order members take inside every continent. Asia's head is pinned ahead of
/// it. Names not listed sort last, in the order they were added.
const List<String> _ranking = <String>[
  'Iran',
  'Russia',
  'North Korea',
  'Cuba',
  'Nicaragua',
  'Belarus',
  'Yemen',
  'South Africa',
  'Iraq',
  'China',
  'Algeria',
  'Palestine',
  'Pakistan',
  'Malaysia',
  'Colombia',
  'Namibia',
  'Lebanon',
  'Venezuela',
  'Turkey',
  'Oman',
  'Qatar',
  'Indonesia',
  'Brazil',
  'Tunisia',
  'Libya',
  'Mauritania',
  'Sudan',
  'Somalia',
  'Comoros',
  'Afghanistan',
  'Bangladesh',
  'Brunei',
  'Maldives',
  'Vietnam',
  'Laos',
  'Zimbabwe',
  'Kenya',
  'Saudi Arabia',
  'Kuwait',
  'Republic of Ireland',
  'Spain',
  'Slovenia',
  'Mexico',
  'Chile',
  'Armenia',
  'Kyrgyzstan',
  'Tajikistan',
  'Djibouti',
  'Mali',
  'Burkina Faso',
  'Niger',
  'Eritrea',
  'Myanmar',
  'Cambodia',
  'Sri Lanka',
  'Angola',
  'Botswana',
  'Central African Republic',
  'Republic of the Congo',
  'Mozambique',
  'Tanzania',
  'Syria',
  'Egypt',
  'Jordan',
  'Belgium',
  'Norway',
  'Malta',
  'Serbia',
  'Bosnia and Herzegovina',
  'Vatican City',
  'Bolivia',
  'Haiti',
  'Saint Vincent and the Grenadines',
  'Suriname',
  'Trinidad and Tobago',
  'Uruguay',
  'Vanuatu',
  'Kazakhstan',
  'Uzbekistan',
  'Turkmenistan',
  'Thailand',
  'Timor-Leste',
  'Mongolia',
  'Nepal',
  'Bhutan',
  'Benin',
  'Burundi',
  'Cape Verde',
  'Cameroon',
  'Chad',
  'Equatorial Guinea',
  'Gabon',
  'Gambia',
  'Guinea',
  'Guinea-Bissau',
  'Lesotho',
  'Madagascar',
  'Mauritius',
  'Nigeria',
  'São Tomé and Príncipe',
  'Senegal',
  'Seychelles',
  'Sierra Leone',
  'Zambia',
  'United Arab Emirates',
  'Bahrain',
  'Morocco',
  'India',
  'Japan',
  'South Korea',
  'Philippines',
  'Singapore',
  'Cyprus',
  'Georgia',
  'Albania',
  'Andorra',
  'Denmark',
  'Finland',
  'France',
  'Greece',
  'Iceland',
  'Liechtenstein',
  'Luxembourg',
  'Moldova',
  'Monaco',
  'Montenegro',
  'Netherlands',
  'North Macedonia',
  'Portugal',
  'San Marino',
  'Slovakia',
  'Sweden',
  'Switzerland',
  'Ukraine',
  'Canada',
  'Antigua and Barbuda',
  'Bahamas',
  'Barbados',
  'Belize',
  'Dominica',
  'Dominican Republic',
  'Ecuador',
  'El Salvador',
  'Grenada',
  'Guyana',
  'Jamaica',
  'Panama',
  'Peru',
  'Saint Kitts and Nevis',
  'Saint Lucia',
  'New Zealand',
  'Kiribati',
  'Samoa',
  'Solomon Islands',
  'Tonga',
  'Tuvalu',
  'DR Congo',
  'Eswatini',
  'Ethiopia',
  'Ghana',
  'Ivory Coast',
  'Kenya',
  'Liberia',
  'Rwanda',
  'South Sudan',
  'Togo',
  'Uganda',
  'Azerbaijan',
  'Malawi',
  'Taiwan',
  'Austria',
  'Bulgaria',
  'Croatia',
  'Estonia',
  'Germany',
  'Italy',
  'Latvia',
  'Lithuania',
  'Poland',
  'Romania',
  'United Kingdom',
  'Kosovo',
  'Costa Rica',
  'Honduras',
  'Australia',
  'Fiji',
  'Nauru',
  'Papua New Guinea',
  'Israel',
  'United States',
  'Czechia',
  'Hungary',
  'Argentina',
  'Guatemala',
  'Paraguay',
  'Marshall Islands',
  'Micronesia',
  'Palau',
];

/// Asia's pinned head: Iran, Yemen, then Palestine's two systems.
const List<String> _asiaHead = <String>[
  'Iran',
  'Yemen',
  'Palestine · West Bank',
  'Palestine · Gaza',
];

/// A continent's umbrella: one group on Discover, and at `/discover/{region}`
/// an overview with one group per country, each country's page nested under
/// it. Unlike Iranshahr and Yemen it ships no package of its own — its
/// sections are its members' sections, flattened.
class RegionSource extends GallerySource {
  RegionSource(this.countryName, this._own, {this.alsoNames = const <String>{}});

  @override
  final String countryName;

  final List<GallerySource> _own;

  /// Stable sort by [_asiaHead] (Asia only), then [_ranking].
  List<GallerySource> _ranked(List<GallerySource> all) {
    final List<String> head = countryName == 'Asia' ? _asiaHead : const [];
    int rank(GallerySource s) {
      final int pinned = head.indexOf(s.countryName);
      if (pinned >= 0) return pinned;
      final int ranked = _ranking.indexOf(s.countryName);
      return head.length + (ranked >= 0 ? ranked : _ranking.length);
    }

    final List<(int, int, GallerySource)> keyed = <(int, int, GallerySource)>[
      for (int i = 0; i < all.length; i++) (rank(all[i]), i, all[i]),
    ]..sort((a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));
    return <GallerySource>[for (final (_, _, s) in keyed) s];
  }

  /// Countries that sit at the top level (or under Iranshahr) and also belong
  /// here. They are the same instances as there, so each plate stays one item;
  /// resolved on first read because [gallerySources] is built around this.
  final Set<String> alsoNames;

  @override
  late final List<GallerySource> members = _ranked(<GallerySource>[
    ..._own,
    for (final GallerySource top in gallerySources)
      if (top is! RegionSource)
        for (final GallerySource s in <GallerySource>[top, ...top.members])
          if (alsoNames.contains(s.countryName) && !_own.any((GallerySource o) => identical(o, s)))
            s,
  ]);

  @override
  List<String> get countryNames => <String>[
    for (final GallerySource member in members) ...member.countryNames,
  ];

  @override
  List<String> get packageNames => <String>[
    for (final GallerySource member in members) ...member.packageNames,
  ];

  @override
  String get packageName => '${members.length} countries';

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

/// Shared by the Russia region and the continents it straddles, so each plate
/// stays one catalogue item.
final RussiaSource russiaSource = RussiaSource();
final BelarusSource belarusSource = BelarusSource();
final GibraltarSource gibraltarSource = GibraltarSource();
final CeutaSource ceutaSource = CeutaSource();
final MelillaSource melillaSource = MelillaSource();
final KosovoSource kosovoSource = KosovoSource();
final NorthernCyprusSource northernCyprusSource = NorthernCyprusSource();
final SomalilandSource somalilandSource = SomalilandSource();
final FalklandIslandsSource falklandIslandsSource = FalklandIslandsSource();
final IsleOfManSource isleOfManSource = IsleOfManSource();
final JerseySource jerseySource = JerseySource();
final GuernseySource guernseySource = GuernseySource();
final FrenchGuianaSource frenchGuianaSource = FrenchGuianaSource();
final MayotteSource mayotteSource = MayotteSource();
final EasterIslandSource easterIslandSource = EasterIslandSource();
final AscensionIslandSource ascensionIslandSource = AscensionIslandSource();
final TristanDaCunhaSource tristanDaCunhaSource = TristanDaCunhaSource();
final AnguillaSource anguillaSource = AnguillaSource();
final BermudaSource bermudaSource = BermudaSource();
final BritishVirginIslandsSource britishVirginIslandsSource = BritishVirginIslandsSource();
final CaymanIslandsSource caymanIslandsSource = CaymanIslandsSource();
final MontserratSource montserratSource = MontserratSource();
final TurksAndCaicosIslandsSource turksAndCaicosIslandsSource = TurksAndCaicosIslandsSource();
final SintMaartenSource sintMaartenSource = SintMaartenSource();
final BonaireSource bonaireSource = BonaireSource();
final SabaIslandSource sabaIslandSource = SabaIslandSource();
final SintEustatiusSource sintEustatiusSource = SintEustatiusSource();
final CollectivityOfSaintMartinSource collectivityOfSaintMartinSource =
    CollectivityOfSaintMartinSource();
final FrenchPolynesiaSource frenchPolynesiaSource = FrenchPolynesiaSource();
final WallisAndFutunaSource wallisAndFutunaSource = WallisAndFutunaSource();
final CookIslandsSource cookIslandsSource = CookIslandsSource();
final NiueSource niueSource = NiueSource();
final NorfolkIslandSource norfolkIslandSource = NorfolkIslandSource();
final ChristmasIslandSource christmasIslandSource = ChristmasIslandSource();
final CocosKeelingIslandsSource cocosKeelingIslandsSource = CocosKeelingIslandsSource();
final SpainSource spainSource = SpainSource();
final SerbiaSource serbiaSource = SerbiaSource();
final CyprusSource cyprusSource = CyprusSource();
final SomaliaSource somaliaSource = SomaliaSource();
final ArgentinaSource argentinaSource = ArgentinaSource();
final UnitedKingdomSource unitedKingdomSource = UnitedKingdomSource();
final GuyanaSource guyanaSource = GuyanaSource();
final ComorosSource comorosSource = ComorosSource();
final ChileSource chileSource = ChileSource();
final SaintHelenaSource saintHelenaSource = SaintHelenaSource();
final UkraineSource ukraineSource = UkraineSource();
final AbkhaziaSource abkhaziaSource = AbkhaziaSource();
final SouthOssetiaSource southOssetiaSource = SouthOssetiaSource();
final TransnistriaSource transnistriaSource = TransnistriaSource();
final ChinaSource chinaSource = ChinaSource();
final TaiwanSource taiwanSource = TaiwanSource();
final HongKongSource hongKongSource = HongKongSource();
final MacauSource macauSource = MacauSource();

final List<GallerySource> europeCountries = <GallerySource>[
  belarusSource,
  ukraineSource,
  abkhaziaSource,
  southOssetiaSource,
  transnistriaSource,
  kosovoSource,
  northernCyprusSource,
  gibraltarSource,
  ceutaSource,
  melillaSource,
  isleOfManSource,
  jerseySource,
  guernseySource,
  cyprusSource,
  unitedKingdomSource,
  const GermanySource(),
  russiaSource,
  RepublicOfIrelandSource(),
  spainSource,
  ItalySource(),
  SloveniaSource(),
  BosniaAndHerzegovinaSource(),
  serbiaSource,
  MaltaSource(),
  NorwaySource(),
  VaticanCitySource(),
  PortugalSource(),
  AlbaniaSource(),
  AustriaSource(),
  BulgariaSource(),
  EstoniaSource(),
];

final List<GallerySource> africaCountries = <GallerySource>[
  somalilandSource,
  mayotteSource,
  ascensionIslandSource,
  tristanDaCunhaSource,
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
  MalawiSource(),
  KenyaSource(),
  comorosSource,
  somaliaSource,
  DjiboutiSource(),
  EritreaSource(),
  GambiaSource(),
  GuineaSource(),
  EswatiniSource(),
  saintHelenaSource,
  SouthSudanSource(),
];

final List<GallerySource> americaCountries = <GallerySource>[
  falklandIslandsSource,
  frenchGuianaSource,
  easterIslandSource,
  anguillaSource,
  bermudaSource,
  britishVirginIslandsSource,
  caymanIslandsSource,
  montserratSource,
  turksAndCaicosIslandsSource,
  sintMaartenSource,
  bonaireSource,
  sabaIslandSource,
  sintEustatiusSource,
  collectivityOfSaintMartinSource,
  guyanaSource,
  CubaSource(),
  SaintVincentAndTheGrenadinesSource(),
  VenezuelaSource(),
  NicaraguaSource(),
  ColombiaSource(),
  BoliviaSource(),
  BrazilSource(),
  chileSource,
  UruguaySource(),
  argentinaSource,
  CostaRicaSource(),
  EcuadorSource(),
  ElSalvadorSource(),
  JamaicaSource(),
];

/// Asia's own countries. Iran, Iranshahr, Yemen and the other long-standing
/// Asian sources stay at the top level — they are landmarks of the catalogue
/// in their own right, and burying them one level down would make them harder
/// to reach, not easier.
final List<GallerySource> asiaCountries = <GallerySource>[
  taiwanSource,
  hongKongSource,
  macauSource,
  JordanSource(),
  russiaSource,
  MongoliaSource(),
  BhutanSource(),
  SriLankaSource(),
  MyanmarSource(),
  ThailandSource(),
  CambodiaSource(),
  TimorLesteSource(),
  BangladeshSource(),
  chinaSource,
];

/// Oceania has no sources of its own: every member sits at the top level and
/// joins through `alsoNames`.
final List<GallerySource> oceaniaCountries = <GallerySource>[
  frenchPolynesiaSource,
  wallisAndFutunaSource,
  cookIslandsSource,
  niueSource,
  norfolkIslandSource,
  christmasIslandSource,
  cocosKeelingIslandsSource,
];
