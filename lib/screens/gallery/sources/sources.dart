import '../catalogue.dart';
import 'iran.dart';
import 'syria.dart';
import 'iranshahr.dart';
import 'india.dart';
import 'indonesia.dart';
import 'lebanon.dart';
import 'brunei.dart';
import 'laos.dart';
import 'maldives.dart';
import 'malaysia.dart';
import 'north_korea.dart';
import 'palestine.dart';
import 'vietnam.dart';
import 'yemen.dart';
import 'regions.dart';
import 'kyrgyzstan.dart';

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
export 'mali.dart';
export 'mauritania.dart';
export 'niger.dart';
export 'north_korea.dart';
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
/// page. Europe, Africa and America are umbrellas the same way, over the
/// countries in `regions.dart`.
final List<GallerySource> gallerySources = <GallerySource>[
  const IranSource(),
  const IranshahirSource(),
  SyriaSource(),
  PalestineSource(),
  YemenSource(),
  LebanonSource(),
  IndiaSource(),
  MalaysiaSource(),
  IndonesiaSource(),
  NorthKoreaSource(),
  BruneiSource(),
  MaldivesSource(),
  LaosSource(),
  VietnamSource(),
  KyrgyzstanSource(),
  RegionSource('Europe', europeCountries),
  RegionSource('Africa', africaCountries),
  RegionSource('America', americaCountries),
];

/// Every source, umbrellas' members included — what a lookup by type wants.
final List<GallerySource> allGallerySources = <GallerySource>[
  for (final GallerySource top in gallerySources) ...<GallerySource>[
    top,
    ...top.members,
  ],
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

/// The source [source] is a member of, or null for a top-level one.
GallerySource? umbrellaOf(GallerySource source) {
  for (final GallerySource umbrella in gallerySources) {
    if (umbrella.members.any((GallerySource m) => identical(m, source))) {
      return umbrella;
    }
  }
  return null;
}
