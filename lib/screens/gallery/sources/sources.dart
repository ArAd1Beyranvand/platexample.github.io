import '../catalogue.dart';
import 'algeria.dart';
import 'bolivia.dart';
import 'brazil.dart';
import 'colombia.dart';
import 'germany.dart';
import 'iran.dart';
import 'iranshahr.dart';
import 'cuba.dart';
import 'india.dart';
import 'indonesia.dart';
import 'belarus.dart';
import 'namibia.dart';
import 'nicaragua.dart';
import 'tunisia.dart';
import 'venezuela.dart';
import 'lebanon.dart';
import 'malaysia.dart';
import 'mali.dart';
import 'mauritania.dart';
import 'niger.dart';
import 'north_korea.dart';
import 'palestine.dart';
import 'somalia.dart';
import 'sudan.dart';
import 'yemen.dart';

export '../catalogue.dart';
export 'algeria.dart';
export 'bolivia.dart';
export 'brazil.dart';
export 'colombia.dart';
export 'germany.dart';
export 'iran.dart';
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
export 'malaysia.dart';
export 'mali.dart';
export 'mauritania.dart';
export 'niger.dart';
export 'north_korea.dart';
export 'palestine.dart';
export 'somalia.dart';
export 'sudan.dart';
export 'yemen.dart';

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
/// page.
final List<GallerySource> gallerySources = <GallerySource>[
  const IranSource(),
  const IranshahirSource(),
  PalestineSource(),
  YemenSource(),
  LebanonSource(),
  CubaSource(),
  VenezuelaSource(),
  IndiaSource(),
  const GermanySource(),
  MalaysiaSource(),
  AlgeriaSource(),
  IndonesiaSource(),
  BelarusSource(),
  NicaraguaSource(),
  TunisiaSource(),
  BoliviaSource(),
  ColombiaSource(),
  SudanSource(),
  NigerSource(),
  MaliSource(),
  NorthKoreaSource(),
  NamibiaSource(),
  BrazilSource(),
  MauritaniaSource(),
  SomaliaSource(),
];

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
];
