import '../../screens/gallery/catalogue_index.dart';
export '../../screens/gallery/catalogue_stats.dart';
import '../../screens/gallery/sources/sources.dart';

export '../../screens/gallery/catalogue_index.dart';
export '../../screens/gallery/sources/sources.dart';

/// A URL-safe name: lowercase ASCII, words joined by single dashes. Non-Latin
/// usage words are romanised first so `خصوصي · 2 + 5` does not become `2-5`.
String slugify(String text) {
  String romanised = text.toLowerCase();
  _romanisations.forEach((String from, String to) {
    romanised = romanised.replaceAll(from, ' $to ');
  });

  final StringBuffer out = StringBuffer();
  bool pendingDash = false;
  for (final int unit in romanised.codeUnits) {
    final bool isDigit = unit >= 0x30 && unit <= 0x39;
    final bool isLetter = unit >= 0x61 && unit <= 0x7a;
    if (isDigit || isLetter) {
      if (pendingDash && out.isNotEmpty) out.write('-');
      pendingDash = false;
      out.writeCharCode(unit);
    } else {
      pendingDash = true;
    }
  }
  return out.toString();
}

const Map<String, String> _romanisations = <String, String>{
  'خصوصي': 'private',
  'أجرة': 'taxi',
  'نقل': 'transport',
  'حكومي': 'government',
  'عسكري': 'military',
};

/// Every country a plate can be opened under: each top-level source and each
/// umbrella member, regions excluded (their sections are their members').
final List<GallerySource> plateCountries = <GallerySource>[
  for (final GallerySource source in allGallerySources)
    if (source is! RegionSource && source.sections.isNotEmpty) source,
];

/// A source that stands for several countries: the continents, and the two
/// top-level groups — Iranshahr and Yemen — that are umbrellas without being
/// [RegionSource]s. Coverage lists these as one row, not as their members.
bool isUmbrella(GallerySource source) =>
    source is RegionSource || source.members.isNotEmpty;

/// Every plate, in catalogue order, as the playground pages through them.
final List<CatalogueItem> playgroundItems = <CatalogueItem>[
  for (final CatalogueItem item in catalogueItems)
    if (item.source is! RegionSource) item,
];

extension GallerySourceSlug on GallerySource {
  String get slug => slugify(countryName);
}

/// A label that romanises to nothing nameable falls back to the entry id.
String _shortName(CatalogueItem item) {
  final String fromLabel = slugify(item.entry.label);
  final bool nameable = fromLabel.codeUnits.any(
    (int unit) => unit >= 0x61 && unit <= 0x7a,
  );
  return nameable ? fromLabel : slugify(item.entry.id);
}

/// Labels repeat within a country (three Iranshahr members have a
/// `Diplomatic corps`); only the collisions get their section as a prefix.
final Map<CatalogueItem, String> _plateSlugs = () {
  final Map<String, List<CatalogueItem>> byShortName =
      <String, List<CatalogueItem>>{};
  for (final CatalogueItem item in catalogueItems) {
    byShortName
        .putIfAbsent('${item.source.slug}/${_shortName(item)}', () => [])
        .add(item);
  }
  final Map<CatalogueItem, String> slugs = <CatalogueItem, String>{};
  for (final List<CatalogueItem> sharing in byShortName.values) {
    for (final CatalogueItem item in sharing) {
      final String short = _shortName(item);
      slugs[item] = sharing.length > 1
          ? '${slugify(item.section.title)}-$short'
          : short;
    }
  }
  return slugs;
}();

extension CatalogueItemSlug on CatalogueItem {
  String get slug => _plateSlugs[this] ?? slugify(entry.label);
}

/// Every region umbrella, in catalogue order.
final List<RegionSource> plateRegions = <RegionSource>[
  for (final GallerySource source in gallerySources)
    if (source is RegionSource) source,
];

/// Europe, which the header links to directly as the region with the most
/// countries behind it.
final RegionSource europeRegion = plateRegions.firstWhere(
  (RegionSource r) => r.countryName == 'Europe',
);

/// An umbrella (continent, Iranshahr or Yemen) by slug.
GallerySource? umbrellaBySlug(String slug) {
  for (final GallerySource source in gallerySources) {
    if (isUmbrella(source) && source.slug == slug) return source;
  }
  return null;
}

RegionSource? regionBySlug(String slug) {
  for (final RegionSource region in plateRegions) {
    if (region.slug == slug) return region;
  }
  return null;
}

/// The region [source] belongs to, or null for a country outside one (Iran,
/// Yemen and the rest of Asia sit at the top level). Used for the country
/// page's breadcrumb, which gains a region crumb only where there is one.
GallerySource? regionOf(GallerySource source) {
  for (final GallerySource region in gallerySources) {
    if (region.members.any((GallerySource m) => identical(m, source))) {
      return region;
    }
  }
  return null;
}

GallerySource? countryBySlug(String slug) {
  for (final GallerySource source in plateCountries) {
    if (source.slug == slug) return source;
  }
  return null;
}

CatalogueItem? itemBySlug(GallerySource source, String slug) {
  for (final CatalogueItem item in catalogueItems) {
    if (identical(item.source, source) && item.slug == slug) return item;
  }
  return null;
}

/// The first plate of [source] (the playground's landing spec for a country).
CatalogueItem? firstItemOf(GallerySource source) {
  for (final CatalogueItem item in catalogueItems) {
    if (identical(item.source, source)) return item;
  }
  return null;
}
