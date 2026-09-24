import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/gallery_shell_screen.dart';
import 'app_routes.dart';

/// Turns a browser location into an [AppLocation] and back again.
///
/// `restoreRouteInformation` is what writes the address bar: returning the
/// location's canonical path means opening a country or a plate pushes a real
/// history entry, so browser back/forward walks the same steps the in-app back
/// gesture does.
class AppRouteParser extends RouteInformationParser<AppLocation> {
  const AppRouteParser();

  @override
  Future<AppLocation> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture<AppLocation>(AppLocation.fromUri(routeInformation.uri));

  @override
  RouteInformation restoreRouteInformation(AppLocation configuration) =>
      RouteInformation(uri: Uri.parse(configuration.path));
}

/// Owns which page is showing, and hosts the shell.
///
/// The shell keeps its tabs in an [IndexedStack] and pushes country and plate
/// pages onto a Navigator nested *inside* Discover's slot, so a push does not
/// rebuild the other tabs. That nested stack used to be invisible to the
/// router, which is why those pages had no URL. It is now driven the other way
/// round: this delegate holds the location, the shell reconciles its nested
/// stack against it in `didUpdateWidget`, and every user gesture that changes
/// the page — a tile tap, the breadcrumb, a pop — reports back through
/// [goTo] so the address bar follows.
///
/// [popRoute] still offers back to the nested Discover stack first, because
/// that navigator owns the page transition; the pop then reports the shallower
/// location up through [goTo], which is what writes the history entry.
class AppRouterDelegate extends RouterDelegate<AppLocation>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppLocation> {
  AppRouterDelegate();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Reaches the shell's state so [popRoute] can offer back to its nested
  /// navigator. The shell is a single long-lived widget under this delegate,
  /// so a [GlobalKey] costs nothing and saves threading a callback down.
  final GlobalKey<GalleryShellState> _shellKey = GlobalKey<GalleryShellState>();

  @override
  Future<bool> popRoute() async {
    if (await _shellKey.currentState?.maybePopDiscover() ?? false) return true;
    return super.popRoute();
  }

  AppLocation _location = AppLocation.showcase;

  @override
  AppLocation get currentConfiguration => _location;

  /// Called by the nav bar, by the tiles, and by the shell when its nested
  /// stack moves on its own. Notifying makes the Router re-read
  /// [currentConfiguration] and update the address bar.
  void goTo(AppLocation location) {
    if (_location == location) return;
    _location = location;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppLocation configuration) {
    _location = configuration;
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: <Page<void>>[
        MaterialPage<void>(
          key: const ValueKey<String>('shell'),
          child: GalleryShellScreen(key: _shellKey, location: _location, onNavigate: goTo),
        ),
      ],
      onDidRemovePage: (Page<Object?> page) {},
    );
  }
}
