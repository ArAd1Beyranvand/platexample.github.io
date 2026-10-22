import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../country/country_page.dart';
import '../country/region_page.dart';
import '../data/catalogue.dart';
import '../debug/render_check_page.dart';
import '../landing/landing_page.dart';
import '../playground/playground_page.dart';
import '../shell/site_shell.dart';
import 'location.dart';

class PdRouteParser extends RouteInformationParser<PdLocation> {
  const PdRouteParser();

  @override
  Future<PdLocation> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture<PdLocation>(PdLocation.fromUri(routeInformation.uri));

  @override
  RouteInformation restoreRouteInformation(PdLocation configuration) =>
      RouteInformation(uri: Uri.parse(configuration.path));
}

class PdRouterDelegate extends RouterDelegate<PdLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PdLocation> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final FocusNode searchFocus = FocusNode(debugLabel: 'coverage search');

  PdLocation _location = const PdLocation.landing();

  /// Bumped on every navigation, so going to the anchor already showing
  /// still scrolls to it.
  int _visit = 0;

  @override
  PdLocation get currentConfiguration => _location;

  /// Whether the landing should focus its search once it has scrolled to
  /// #coverage. Focusing earlier makes the field scroll itself to the bottom
  /// edge, cutting the anchor scroll short.
  bool _focusSearch = false;

  void go(PdLocation location) {
    _location = location;
    _focusSearch = false;
    _visit++;
    notifyListeners();
  }

  void openSearch() {
    go(const PdLocation.landing(LandingAnchor.coverage));
    _focusSearch = true;
  }

  @override
  Future<void> setNewRoutePath(PdLocation configuration) {
    _location = configuration;
    _focusSearch = false;
    _visit++;
    return SynchronousFuture<void>(null);
  }

  @override
  void dispose() {
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdLocation location = _location;
    if (location.isRenderCheck) {
      return Navigator(
        key: navigatorKey,
        pages: const <Page<void>>[
          NoTransitionPage(key: ValueKey<String>('render-check'), child: RenderCheckPage()),
        ],
        onDidRemovePage: (Page<Object?> page) {},
      );
    }
    return Navigator(
      key: navigatorKey,
      pages: <Page<void>>[
        NoTransitionPage(
          // One key per kind of page, so switching kind rebuilds from the
          // top instead of inheriting the last page's scroll offset.
          key: ValueKey<String>(_kindOf(location)),
          child: SiteShell(
            location: location,
            go: go,
            openSearch: openSearch,
            searchFocus: searchFocus,
            child: switch (location) {
              PdLocation(isPlayground: true) => PlaygroundPage(item: location.item!),
              PdLocation(isRegion: true) => RegionPage(region: location.source!),
              PdLocation(isCountry: true) => CountryPage(source: location.source!),
              _ => LandingPage(anchor: location.anchor, visit: _visit, focusSearch: _focusSearch),
            },
          ),
        ),
      ],
      onDidRemovePage: (Page<Object?> page) {},
    );
  }
}

/// Which of the four pages [location] is, as a page key. The country and
/// region keys carry the slug: moving from one country to the next is a new
/// page, not a scroll position to keep.
String _kindOf(PdLocation location) {
  if (location.isPlayground) return 'play';
  final GallerySource? source = location.source;
  if (source != null) return 'source/${source.slug}';
  return 'landing';
}

class NoTransitionPage extends Page<void> {
  const NoTransitionPage({super.key, required this.child});

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) => PageRouteBuilder<void>(
    settings: this,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    // The route outlives this page: a same-key page only replaces the
    // route's settings, so build whichever child the settings hold now.
    pageBuilder: (BuildContext context, _, _) =>
        (ModalRoute.of(context)!.settings as NoTransitionPage).child,
  );
}
