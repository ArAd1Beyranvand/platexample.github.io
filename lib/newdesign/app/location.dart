import 'package:flutter/foundation.dart';

import '../data/catalogue.dart';
import '../embed/protocol.dart';

/// A section of the landing page a URL can point at.
enum LandingAnchor { top, coverage, start, about }

/// One page of the site (REDESIGN §2.2):
///
/// ```
/// /                        Landing
/// /plates                  Landing #coverage
/// /plates/:region          Region (a continent's countries)
/// /plates/:country         Country (its plate types)
/// /plates/:country?language=kotlin   Country, in a built language (typescript, kotlin, python)
/// /plates/:country/:spec[?language=kotlin]   Playground
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
      lang = null,
      source = null,
      isRenderCheck = false;

  /// `/render-check`: a test page listing every plate (see RenderCheckPage).
  const PdLocation.renderCheck()
    : anchor = LandingAnchor.top,
      item = null,
      source = null,
      lang = null,
      isRenderCheck = true;

  /// One plate type. [lang] picks a built language for the stage; null is Flutter.
  const PdLocation.playground(CatalogueItem this.item, [this.lang])
    : anchor = LandingAnchor.top,
      source = null,
      isRenderCheck = false;

  /// A country's own page: every plate type it ships. [lang] picks a
  /// non-Flutter tab (`typescript`, `kotlin`, `python`); null is Flutter.
  const PdLocation.country(GallerySource this.source, [this.lang])
    : anchor = LandingAnchor.top,
      item = null,
      isRenderCheck = false;

  /// A region's overview: one card per member country. [source] is a
  /// umbrella (a continent, Iranshahr, Yemen); [PdLocation.of] is what callers normally use.
  const PdLocation.region(GallerySource this.source)
    : anchor = LandingAnchor.top,
      item = null,
      lang = null,
      isRenderCheck = false;

  /// The page for [source], whichever of the two it is.
  factory PdLocation.of(GallerySource source) =>
      isUmbrella(source) ? PdLocation.region(source) : PdLocation.country(source);

  final LandingAnchor anchor;
  final bool isRenderCheck;
  final CatalogueItem? item;

  /// The country page's language tab; null for the in-app Flutter one.
  final String? lang;

  /// The country or region this location is for, on those two pages only.
  final GallerySource? source;

  bool get isPlayground => item != null;
  bool get isRegion => source != null && isUmbrella(source!);
  bool get isCountry => source != null && !isRegion;

  static final PdLocation defaultPlayground = PdLocation.playground(playgroundItems.first);

  String get path {
    if (isRenderCheck) return '/render-check';
    final String query = lang == null ? '' : '?language=$lang';
    final CatalogueItem? item = this.item;
    if (item != null) return '/plates/${item.source.slug}/${item.slug}$query';
    final GallerySource? source = this.source;
    if (source != null) return '/plates/${source.slug}$query';
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
      case 'render-check':
        return const PdLocation.renderCheck();
      case 'start':
        return const PdLocation.landing(LandingAnchor.start);
      case 'about':
        return const PdLocation.landing(LandingAnchor.about);
      case 'plates':
        return _plate(s.skip(1).toList(), uri.queryParameters['language']?.toLowerCase());
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
  static PdLocation _plate(List<String> rest, [String? language]) {
    const PdLocation coverage = PdLocation.landing(LandingAnchor.coverage);
    if (rest.isEmpty) return coverage;
    final GallerySource? region = umbrellaBySlug(rest.first);
    if (region != null && rest.length == 1) return PdLocation.region(region);
    final GallerySource? country = countryBySlug(rest.first);
    if (country == null) return coverage;
    final String? lang = embedLanguages.contains(language) && language != embedLanguageFlutter
        ? language
        : null;
    if (rest.length == 1) {
      return firstItemOf(country) == null ? coverage : PdLocation.country(country, lang);
    }
    // `flutter` is the country page itself; the registry decides later
    // whether a built language is really there.
    if (rest.length == 2 && embedLanguages.contains(rest[1])) {
      if (firstItemOf(country) == null) return coverage;
      return PdLocation.country(country, rest[1] == embedLanguageFlutter ? null : rest[1]);
    }
    final CatalogueItem? item = itemBySlug(country, rest[1]) ?? firstItemOf(country);
    if (item == null) return coverage;
    final String? pathLang = rest.length == 3 && embedLanguages.contains(rest[2]) ? rest[2] : null;
    return PdLocation.playground(
      item,
      pathLang == null ? lang : (pathLang == embedLanguageFlutter ? null : pathLang),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PdLocation &&
      other.anchor == anchor &&
      other.isRenderCheck == isRenderCheck &&
      other.lang == lang &&
      identical(other.item, item) &&
      identical(other.source, source);

  @override
  int get hashCode =>
      Object.hash(anchor, isRenderCheck, lang, identityHashCode(item), identityHashCode(source));
}
