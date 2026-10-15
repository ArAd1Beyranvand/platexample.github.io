import '../catalogue.dart';
import 'iran.dart';
import 'syria.dart';
import 'iranshahr.dart';
import 'korea.dart';
import 'india.dart';
import 'indonesia.dart';
import 'lebanon.dart';
import 'brunei.dart';
import 'laos.dart';
import 'maldives.dart';
import 'malaysia.dart';
import 'philippines.dart';
import 'palestine.dart';
import 'vietnam.dart';
import 'yemen.dart';
import 'regions.dart';
import 'kyrgyzstan.dart';
import 'vanuatu.dart';
import 'cape_verde.dart';
import 'cameroon.dart';
import 'chad.dart';
import 'equatorial_guinea.dart';
import 'gabon.dart';
import 'zambia.dart';
import 'madagascar.dart';
import 'lesotho.dart';
import 'senegal.dart';
import 'mauritius.dart';
import 'seychelles.dart';
import 'andorra.dart';
import 'greece.dart';
import 'finland.dart';
import 'japan.dart';
import 'liechtenstein.dart';
import 'canada.dart';
import 'san_marino.dart';
import 'bahamas.dart';
import 'antigua_and_barbuda.dart';
import 'barbados.dart';
import 'belize.dart';
import 'dominica.dart';
import 'dominican_republic.dart';
import 'sweden.dart';
import 'netherlands.dart';
import 'united_kingdom.dart';
import 'ukraine.dart';
import 'slovakia.dart';
import 'switzerland.dart';

export '../catalogue.dart';
export 'algeria.dart';
export 'bolivia.dart';
export 'brazil.dart';
export 'colombia.dart';
export 'germany.dart';
export 'iran.dart';
export 'syria.dart';
export 'iranshahr.dart';
export 'cuba.dart';
export 'india.dart';
export 'indonesia.dart';
export 'belarus.dart';
export 'namibia.dart';
export 'nicaragua.dart';
export 'tunisia.dart';
export 'venezuela.dart';
export 'lebanon.dart';
export 'brunei.dart';
export 'libya.dart';
export 'laos.dart';
export 'maldives.dart';
export 'malaysia.dart';
export 'philippines.dart';
export 'mali.dart';
export 'mauritania.dart';
export 'niger.dart';
export 'korea.dart';
export 'north_korea.dart';
export 'south_korea.dart';
export 'palestine.dart';
export 'comoros.dart';
export 'somalia.dart';
export 'sudan.dart';
export 'vietnam.dart';
export 'yemen.dart';
export 'zimbabwe.dart';
export 'regions.dart';
export 'republic_of_ireland.dart';
export 'spain.dart';
export 'italy.dart';
export 'slovenia.dart';
export 'chile.dart';
export 'kyrgyzstan.dart';
export 'djibouti.dart';
export 'eritrea.dart';
export 'burkina_faso.dart';
export 'angola.dart';
export 'benin.dart';
export 'bhutan.dart';
export 'bosnia_and_herzegovina.dart';
export 'botswana.dart';
export 'cambodia.dart';
export 'central_african_republic.dart';
export 'egypt.dart';
export 'jordan.dart';
export 'malta.dart';
export 'mongolia.dart';
export 'mozambique.dart';
export 'myanmar.dart';
export 'norway.dart';
export 'republic_of_the_congo.dart';
export 'saint_vincent_and_the_grenadines.dart';
export 'serbia.dart';
export 'sri_lanka.dart';
export 'tanzania.dart';
export 'thailand.dart';
export 'timor_leste.dart';
export 'uruguay.dart';
export 'vanuatu.dart';
export 'vatican_city.dart';
export 'cape_verde.dart';
export 'cameroon.dart';
export 'chad.dart';
export 'equatorial_guinea.dart';
export 'gabon.dart';
export 'zambia.dart';
export 'madagascar.dart';
export 'lesotho.dart';
export 'senegal.dart';
export 'mauritius.dart';
export 'seychelles.dart';
export 'guinea.dart';
export 'gambia.dart';
export 'portugal.dart';
export 'andorra.dart';
export 'greece.dart';
export 'finland.dart';
export 'japan.dart';
export 'liechtenstein.dart';
export 'canada.dart';
export 'san_marino.dart';
export 'bahamas.dart';
export 'antigua_and_barbuda.dart';
export 'barbados.dart';
export 'belize.dart';
export 'dominica.dart';
export 'dominican_republic.dart';
export 'sweden.dart';
export 'netherlands.dart';
export 'united_kingdom.dart';
export 'ukraine.dart';
export 'slovakia.dart';
export 'switzerland.dart';

/// Every country this app can draw, in the order the catalogue lists them.
///
/// Built once. Three of the six adapters deal seeded sample values, so a fresh
/// list per read would reshuffle the catalogue on every frame.
///
/// Iranshahr is shown on Discover as a single group, but clicking "All plates"
/// navigates to `/iranshahr` where it displays like Discover itself, showing
/// each of its nine countries (Bahrain, Azerbaijan, Afghanistan, Armenia,
/// Tajikistan, Kuwait, Qatar, Iraq, UAE) as separate groups. The nine country
/// sources below are used for those detail pages and the `/iranshahr` overview
/// page. Asia, Europe, Africa and America are umbrellas the same way, over
/// the countries in `regions.dart`.
/// The head of the list is fixed — Iran first, then the regions it sits closest
/// to, then the continents. Everything after America is alphabetical.
final List<GallerySource> gallerySources = <GallerySource>[
  const IranSource(),
  const IranshahirSource(),
  YemenSource(),
  PalestineSource(),
  RegionSource(
    'Asia',
    asiaCountries,
    alsoNames: <String>{
      'Iran',
      'Yemen',
      'Palestine',
      'North Korea',
      'South Korea',
      'Japan',
      'Brunei',
      'India',
      'Indonesia',
      'Kyrgyzstan',
      'Laos',
      'Lebanon',
      'Malaysia',
      'Maldives',
      'Philippines',
      'Syria',
      'Vanuatu',
      'Vietnam',
      'Bahrain',
      'Azerbaijan',
      'Afghanistan',
      'Armenia',
      'Tajikistan',
      'Kuwait',
      'Qatar',
      'Iraq',
      'United Arab Emirates',
      'Turkey',
      'Oman',
      'Kazakhstan',
      'Uzbekistan',
      'Turkmenistan',
    },
  ),
  RegionSource(
    'Europe',
    europeCountries,
    alsoNames: <String>{
      'Andorra',
      'Greece',
      'Finland',
      'Liechtenstein',
      'San Marino',
      'Sweden',
      'Netherlands',
      'United Kingdom',
      'Ukraine',
      'Slovakia',
      'Switzerland',
    },
  ),
  RegionSource(
    'America',
    americaCountries,
    alsoNames: <String>{
      'Canada',
      'Bahamas',
      'Antigua and Barbuda',
      'Barbados',
      'Dominica',
      'Dominican Republic',
      'Belize',
    },
  ),
  RegionSource(
    'Africa',
    africaCountries,
    alsoNames: <String>{
      'Cape Verde',
      'Cameroon',
      'Chad',
      'Equatorial Guinea',
      'Gabon',
      'Zambia',
      'Madagascar',
      'Lesotho',
      'Senegal',
      'Mauritius',
      'Seychelles',
    },
  ),
  BruneiSource(),
  IndiaSource(),
  IndonesiaSource(),
  KyrgyzstanSource(),
  LaosSource(),
  LebanonSource(),
  MalaysiaSource(),
  MaldivesSource(),
  KoreaSource(),
  PhilippinesSource(),
  SyriaSource(),
  VanuatuSource(),
  VietnamSource(),
  CapeVerdeSource(),
  CameroonSource(),
  ChadSource(),
  EquatorialGuineaSource(),
  GabonSource(),
  ZambiaSource(),
  MadagascarSource(),
  LesothoSource(),
  SenegalSource(),
  MauritiusSource(),
  SeychellesSource(),
  AndorraSource(),
  GreeceSource(),
  FinlandSource(),
  JapanSource(),
  LiechtensteinSource(),
  CanadaSource(),
  SanMarinoSource(),
  BahamasSource(),
  AntiguaAndBarbudaSource(),
  BarbadosSource(),
  DominicaSource(),
  DominicanRepublicSource(),
  BelizeSource(),
  SwedenSource(),
  NetherlandsSource(),
  UnitedKingdomSource(),
  UkraineSource(),
  SlovakiaSource(),
  SwitzerlandSource(),
];

/// Every source, umbrellas' members included — what a lookup by type wants.
final List<GallerySource> allGallerySources = () {
  final List<GallerySource> all = <GallerySource>[];
  for (final GallerySource top in gallerySources) {
    for (final GallerySource s in <GallerySource>[top, ...top.members]) {
      if (!all.any((GallerySource a) => identical(a, s))) all.add(s);
    }
  }
  return all;
}();

/// The ten countries within Iranshahr for the `/iranshahr/{country}` detail
/// pages and the `/iranshahr` overview page showing them as country groups.
final List<GallerySource> iranshahirCountries = <GallerySource>[
  const BahrainSource(),
  const AzerbaijanSource(),
  const AfghanistanSource(),
  const ArmeniaSource(),
  const TajikistanSource(),
  const KuwaitSource(),
  const QatarSource(),
  const IraqSource(),
  const UaeSource(),
  const TurkeySource(),
  const OmanSource(),
  const KazakhstanSource(),
  const UzbekistanSource(),
  const TurkmenistanSource(),
];

/// The source [source] is a member of, or null for a top-level one.
GallerySource? umbrellaOf(GallerySource source) {
  for (final GallerySource umbrella in gallerySources) {
    if (umbrella.members.any((GallerySource m) => identical(m, source))) {
      return umbrella;
    }
  }
  return null;
}
