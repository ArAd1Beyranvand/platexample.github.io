import 'package:flutter/foundation.dart';

import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/sources/sources.dart';

/// The app's address space.
///
/// Three tabs, and under Discover a country and a plate — so every page the
/// shell can show has a URL, not just the three tabs. `/` is the showcase, so
/// `platexample.ir` and `platexample.ir/showcase` are the same page.
///
/// Paths are declared here and nowhere else: the nav bar, the parser and the
/// delegate all read them off this file, so renaming a URL is a one-line edit.
enum AppTab {
  showcase('/showcase'),
  discover('/discover'),
  about('/about');

  const AppTab(this.path);

  /// The path this tab is addressed by. [AppTab.showcase] additionally answers
  /// to `/` — see [AppLocation.fromUri] — but reports `/showcase` as its
  /// canonical form so the address bar settles on one spelling.
  final String path;

  /// The tab named by the first segment of a location, or null if that segment
  /// names nothing.
  static AppTab? bySegment(String segment) {
    for (final AppTab tab in AppTab.values) {
      if (tab.path == '/$segment') return tab;
    }
    return null;
  }
}

/// A URL-safe name derived from a human one: lowercase ASCII, words joined by
/// single dashes.
///
/// Anything that isn't a letter or a digit becomes a separator, so
/// `Civilian (EU size)` reads `civilian-eu-size` and `Taxi / private hire`
/// reads `taxi-private-hire`.
///
/// Non-Latin words are romanised through [_romanisations] first. Dropping them
/// instead is what made Yemen's `خصوصي · 2 + 5` slugify to a bare `2-5`: the
/// label's only *word* is Arabic, so what survived was punctuation and digits
/// — a URL that names nothing. Anything with no romanisation still falls away,
/// and [_resolvePlateSlugs] catches the result being useless.
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

/// The non-Latin words the catalogue's labels are written in, and the Latin
/// name each is known by in English.
///
/// Whole words rather than per-letter transliteration: there are a handful of
/// them, they are usage classes rather than free text, and a real name beats a
/// mechanical rendering of the consonants. Add to this when a country package
/// starts labelling in its own script; the slug tests will say when it is
/// needed.
const Map<String, String> _romanisations = <String, String>{
  'خصوصي': 'private',
  'أجرة': 'taxi',
  'نقل': 'transport',
  'حكومي': 'government',
  'عسكري': 'military',
};

extension GallerySourceSlug on GallerySource {
  /// This country's URL segment — `iran`, `iranshahr`, `palestine`.
  ///
  /// Off [countryName], not [packageName]: the address bar should read the
  /// country, not the Dart package that happens to ship it.
  String get slug => slugify(countryName);
}

/// Every plate's URL segment, resolved once against the whole catalogue.
///
/// A plate is named by its label — `civilian-eu-size`, not the `bh.eu` that is
/// unique but says nothing. Labels repeat, though: `iranshahr_plate` ships four
/// countries behind one source, and three of them have a `Diplomatic corps`.
/// Where a label is ambiguous within its country the section is prefixed, so
/// those become `bahrain-diplomatic-corps` and `azerbaijan-diplomatic-corps`
/// while every unambiguous plate keeps the short name.
///
/// Prefixing only the collisions rather than everything keeps the common URL
/// short; `test/app_routes_test.dart` asserts the result is still unique, which
/// is where a label collision the section cannot break will surface.
final Map<CatalogueItem, String> _plateSlugs = _resolvePlateSlugs();

/// The short name a plate would like, before collisions are broken.
///
/// A label that romanises to nothing nameable — empty, or nothing but digits
/// and dashes, which is what `· 2 + 5` alone would give — falls back to the
/// entry's id. `ye-northern-car-private-2-5` is not pretty, but it is a name;
/// `2-5` is not. This is a backstop for a label [_romanisations] does not
/// cover, not the normal path.
String _shortName(CatalogueItem item) {
  final String fromLabel = slugify(item.entry.label);
  final bool nameable = fromLabel.codeUnits.any(
    (int unit) => unit >= 0x61 && unit <= 0x7a,
  );
  return nameable ? fromLabel : slugify(item.entry.id);
}

Map<CatalogueItem, String> _resolvePlateSlugs() {
  final Map<String, List<CatalogueItem>> byShortName =
      <String, List<CatalogueItem>>{};
  for (final CatalogueItem item in catalogueItems) {
    final String key =
        '${slugify(item.source.countryName)}/${_shortName(item)}';
    byShortName.putIfAbsent(key, () => <CatalogueItem>[]).add(item);
  }

  final Map<CatalogueItem, String> slugs = <CatalogueItem, String>{};
  for (final List<CatalogueItem> sharing in byShortName.values) {
    final bool ambiguous = sharing.length > 1;
    for (final CatalogueItem item in sharing) {
      final String short = _shortName(item);
      slugs[item] = ambiguous ? '${slugify(item.section.title)}-$short' : short;
    }
  }
  return slugs;
}

extension CatalogueItemSlug on CatalogueItem {
  /// This plate's URL segment within its country — `civilian-eu-size`. See
  /// [_plateSlugs] for how a label shared by two plates is broken.
  String get slug => _plateSlugs[this] ?? slugify(entry.label);

  /// The location this plate's page lives at — nested under its umbrella's
  /// URL when [source] is a member of one (see [GallerySource.members]).
  AppLocation get location => AppLocation.plate(source, this);
}

/// One page of the app, as both a URL and the state the shell renders from.
///
/// This is the router's configuration type. It replaces the bare [AppTab] the
/// delegate used to hold: the country and plate pages were pushed imperatively
/// onto a nested navigator and so had no address at all, which is what made
/// them unlinkable and unreachable by a reload.
///
/// The shapes are a tab on its own, an umbrella's overview (one group per
/// member), a country under Discover, and a plate under a country. [source]
/// and [item] are resolved at parse time, so everything downstream gets the
/// real catalogue objects and never a string it has to look up again.
@immutable
class AppLocation {
  const AppLocation.tab(this.tab) : source = null, item = null;

  const AppLocation._country(this.source) : tab = AppTab.discover, item = null;

  const AppLocation._plate(this.source, this.item) : tab = AppTab.discover;

  /// A country page. Always under Discover — that is the tab whose breadcrumb
  /// and back stack it belongs to. An umbrella's page is its overview.
  factory AppLocation.country(GallerySource source) =>
      AppLocation._country(source);

  /// A plate page, with the country it hangs off so the breadcrumb and the URL
  /// agree even when the plate was opened straight from Showcase.
  factory AppLocation.plate(GallerySource source, CatalogueItem item) =>
      AppLocation._plate(source, item);

  static const AppLocation showcase = AppLocation.tab(AppTab.showcase);
  static const AppLocation discover = AppLocation.tab(AppTab.discover);
  static const AppLocation about = AppLocation.tab(AppTab.about);

  /// The tab this location sits in. Country and plate pages report
  /// [AppTab.discover], so the rail highlights `02 Discover` on them — they are
  /// Discover one and two levels down, not somewhere else.
  final AppTab tab;

  /// The country, on a country or plate page; null on a bare tab.
  final GallerySource? source;

  /// The plate, on a plate page; null otherwise.
  final CatalogueItem? item;

  /// The umbrella [source] is a member of, if any; its URL nests under it.
  GallerySource? get umbrella => source == null ? null : umbrellaOf(source!);

  /// True on an umbrella's own page, which renders as an overview of its
  /// members.
  bool get isOverview => isCountry && source!.members.isNotEmpty;

  bool get isPlate => item != null;
  bool get isCountry => source != null && item == null;

  /// How many pages this location sits above the Discover index — what the
  /// nested navigator's stack depth must be for the shell to be showing it.
  int get discoverDepth => isPlate ? 2 : (isCountry ? 1 : 0);

  /// The canonical URL for this location.
  String get path {
    if (source == null) return tab.path;
    final GallerySource? parent = umbrella;
    final String country = parent == null
        ? '${AppTab.discover.path}/${source!.slug}'
        : '${AppTab.discover.path}/${parent.slug}/${source!.slug}';
    return item == null ? country : '$country/${item!.slug}';
  }

  /// The location a browser address names.
  ///
  /// Unknown paths fall back to the showcase: an app served as static files
  /// has no server-side 404 to defer to, and its front page is the best answer
  /// it has. An unknown *country* likewise falls back to Discover rather than
  /// to a blank country page, and an unknown plate within a known country
  /// falls back to that country.
  ///
  /// Under an umbrella, `/discover/{umbrella}/{x}` is a member when `x` names
  /// one and otherwise a plate the umbrella ships under its own name.
  static AppLocation fromUri(Uri uri) {
    final List<String> segments = <String>[
      for (final String segment in uri.pathSegments)
        if (segment.isNotEmpty) Uri.decodeComponent(segment).toLowerCase(),
    ];
    if (segments.isEmpty) return showcase;

    final AppTab? tab = AppTab.bySegment(segments.first);
    if (tab == null) return showcase;
    if (tab != AppTab.discover || segments.length == 1) {
      return AppLocation.tab(tab);
    }

    final GallerySource? source = _sourceBySlug(gallerySources, segments[1]);
    if (source == null) return discover;
    if (segments.length == 2) return AppLocation.country(source);

    final GallerySource? member = _sourceBySlug(source.members, segments[2]);
    if (member != null) {
      if (segments.length == 3) return AppLocation.country(member);
      final CatalogueItem? item = _itemBySlug(member, segments[3]);
      if (item == null) return AppLocation.country(member);
      return AppLocation.plate(member, item);
    }

    final CatalogueItem? item = _itemBySlug(source, segments[2]);
    if (item == null) return AppLocation.country(source);
    return AppLocation.plate(source, item);
  }

  static GallerySource? _sourceBySlug(
    List<GallerySource> sources,
    String slug,
  ) {
    for (final GallerySource source in sources) {
      if (source.slug == slug) return source;
    }
    return null;
  }

  static CatalogueItem? _itemBySlug(GallerySource source, String slug) {
    for (final CatalogueItem item in catalogueItems) {
      if (identical(item.source, source) && item.slug == slug) return item;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is AppLocation &&
      other.tab == tab &&
      identical(other.source, source) &&
      identical(other.item, item);

  @override
  int get hashCode =>
      Object.hash(tab, identityHashCode(source), identityHashCode(item));

  @override
  String toString() => 'AppLocation($path)';
}
