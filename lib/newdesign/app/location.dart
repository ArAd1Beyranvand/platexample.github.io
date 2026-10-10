import 'package:flutter/foundation.dart';

import '../data/catalogue.dart';

/// A section of the landing page a URL can point at.
enum LandingAnchor { top, coverage, start, about }

/// One page of the site (REDESIGN §2.2):
///
/// ```
/// /                        Landing
/// /plates                  Landing #coverage
/// /plates/:region          Region (a continent's countries)
/// /plates/:country         Country (its plate types)
/// /plates/:country/:spec   Playground
/// /start, /about           Landing #start / #about
/// ```
///
/// A country and a region share one path shape because the catalogue already
/// distinguishes them by type: `/plates/europe` is a [RegionSource] and
/// `/plates/germany` is not, so the slug alone picks the page and neither
/// needs a `/regions/` prefix nobody would guess.
///
/// Old `/showcase` and `/discover/...` addresses resolve to their new
/// equivalents and [path] reports the new spelling, so the address bar is
/// rewritten (the hash-routed static host has no server-side 301).
@immutable
class PdLocation {
  const PdLocation.landing([this.anchor = LandingAnchor.top])
    : item = null,
      source = null;

  const PdLocation.playground(CatalogueItem this.item)
    : anchor = LandingAnchor.top,
      source = null;

  /// A country's own page: every plate type it ships.
  const PdLocation.country(GallerySource this.source)
    : anchor = LandingAnchor.top,
      item = null;

  /// A region's overview: one card per member country. [source] is a
  /// umbrella (a continent, Iranshahr, Yemen); [PdLocation.of] is what callers normally use.
  const PdLocation.region(GallerySource this.source)
    : anchor = LandingAnchor.top,
      item = null;

  /// The page for [source], whichever of the two it is.
  factory PdLocation.of(GallerySource source) => isUmbrella(source)
      ? PdLocation.region(source)
      : PdLocation.country(source);

  final LandingAnchor anchor;
  final CatalogueItem? item;

  /// The country or region this location is for, on those two pages only.
  final GallerySource? source;

  bool get isPlayground => item != null;
  bool get isRegion => source != null && isUmbrella(source!);
  bool get isCountry => source != null && !isRegion;

  static final PdLocation defaultPlayground = PdLocation.playground(
    playgroundItems.first,
  );

  String get path {
    final CatalogueItem? item = this.item;
    if (item != null) return '/plates/${item.source.slug}/${item.slug}';
    final GallerySource? source = this.source;
    if (source != null) return '/plates/${source.slug}';
    return switch (anchor) {
      LandingAnchor.top => '/',
      LandingAnchor.coverage => '/plates',
      LandingAnchor.start => '/start',
      LandingAnchor.about => '/about',
    };
  }

  static PdLocation fromUri(Uri uri) {
    final List<String> s = <String>[
      for (final String segment in uri.pathSegments)
        if (segment.isNotEmpty) Uri.decodeComponent(segment).toLowerCase(),
    ];
    if (s.isEmpty) return const PdLocation.landing();
    switch (s.first) {
      case 'start':
        return const PdLocation.landing(LandingAnchor.start);
      case 'about':
        return const PdLocation.landing(LandingAnchor.about);
      case 'plates':
        return _plate(s.skip(1).toList());
      case 'discover':
        // Old shape: /discover/{country} or /discover/{umbrella}/{member}/...;
        // the last country-like segment wins.
        return _plate(_dropUmbrella(s.skip(1).toList()));
    }
    return const PdLocation.landing();
  }

  static List<String> _dropUmbrella(List<String> rest) {
    if (rest.length >= 2 && countryBySlug(rest[1]) != null) {
      return rest.sublist(1);
    }
    return rest;
  }

  /// `/plates/...`: nothing is #coverage, one segment is a region or country
  /// page, two is a plate. An unknown or plate-less country falls back to
  /// #coverage rather than showing an empty page.
  static PdLocation _plate(List<String> rest) {
    const PdLocation coverage = PdLocation.landing(LandingAnchor.coverage);
    if (rest.isEmpty) return coverage;
    final GallerySource? region = umbrellaBySlug(rest.first);
    if (region != null && rest.length == 1) return PdLocation.region(region);
    final GallerySource? country = countryBySlug(rest.first);
    if (country == null) return coverage;
    if (rest.length == 1) {
      return firstItemOf(country) == null
          ? coverage
          : PdLocation.country(country);
    }
    final CatalogueItem? item =
        itemBySlug(country, rest[1]) ?? firstItemOf(country);
    return item == null ? coverage : PdLocation.playground(item);
  }

  @override
  bool operator ==(Object other) =>
      other is PdLocation &&
      other.anchor == anchor &&
      identical(other.item, item) &&
      identical(other.source, source);

  @override
  int get hashCode =>
      Object.hash(anchor, identityHashCode(item), identityHashCode(source));
}
