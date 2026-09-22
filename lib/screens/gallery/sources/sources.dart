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
final List<GallerySource> gallerySources = <GallerySource>[
  const IranSource(),
  const IranshahirSource(),
  PalestineSource(),
  YemenSource(),
  LebanonSource(),
  const GermanySource(),
];
