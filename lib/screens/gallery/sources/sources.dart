import '../catalogue.dart';
import 'algeria.dart';
import 'germany.dart';
import 'iran.dart';
import 'iranshahr.dart';
import 'cuba.dart';
import 'india.dart';
import 'venezuela.dart';
import 'lebanon.dart';
import 'malaysia.dart';
import 'palestine.dart';
import 'yemen.dart';

export '../catalogue.dart';
export 'algeria.dart';
export 'germany.dart';
export 'iran.dart';
export 'iranshahr.dart';
export 'cuba.dart';
export 'india.dart';
export 'venezuela.dart';
export 'lebanon.dart';
export 'malaysia.dart';
export 'palestine.dart';
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
];

/// The nine countries within Iranshahr for the `/iranshahr/{country}` detail
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
];
