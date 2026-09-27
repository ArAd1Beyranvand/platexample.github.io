import '../catalogue.dart';
import 'germany.dart';
import 'iran.dart';
import 'iranshahr.dart';
import 'lebanon.dart';
import 'palestine.dart';
import 'yemen.dart';

export '../catalogue.dart';
export 'germany.dart';
export 'iran.dart';
export 'iranshahr.dart';
export 'lebanon.dart';
export 'palestine.dart';
export 'yemen.dart';

/// Every country this app can draw, in the order the catalogue lists them.
///
/// Built once. Three of the six adapters deal seeded sample values, so a fresh
/// list per read would reshuffle the catalogue on every frame.
///
/// Iranshahr is shown on Discover as a single group, but clicking "All plates"
/// navigates to `/iranshahr` where it displays like Discover itself, showing
/// each of its five countries (Bahrain, Azerbaijan, Afghanistan, Armenia,
/// Tajikistan) as separate groups. The five country sources below are used for
/// those detail pages and the `/iranshahr` overview page.
final List<GallerySource> gallerySources = <GallerySource>[
  const IranSource(),
  const IranshahirSource(),
  PalestineSource(),
  YemenSource(),
  LebanonSource(),
  const GermanySource(),
];

/// The five countries within Iranshahr, for the `/iranshahr/{country}` detail
/// pages and the `/iranshahr` overview page which shows them as country groups.
final List<GallerySource> iranshahirCountries = <GallerySource>[
  const BahrainSource(),
  const AzerbaijanSource(),
  const AfghanistanSource(),
  const ArmeniaSource(),
  const TajikistanSource(),
];
