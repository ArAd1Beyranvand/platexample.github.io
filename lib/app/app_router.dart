import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../screens/gallery_shell_screen.dart';
import 'app_routes.dart';

/// Turns a browser location into an [AppTab] and back again.
///
/// `restoreRouteInformation` is what writes the address bar: returning the
/// tab's canonical path means selecting a tab pushes a real history entry, so
/// browser back/forward walks the tabs.
class AppRouteParser extends RouteInformationParser<AppTab> {
  const AppRouteParser();

  @override
  Future<AppTab> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture<AppTab>(AppTab.fromUri(routeInformation.uri));

  @override
  RouteInformation restoreRouteInformation(AppTab configuration) =>
      RouteInformation(uri: Uri.parse(configuration.path));
}

/// Owns which tab is showing, and hosts the shell.
///
/// The shell still pushes its detail screens imperatively onto this
/// Navigator — a pages list per tab would mean rebuilding the whole stack on
/// every tab change, and the tabs are an [IndexedStack] precisely so they are
/// *not* rebuilt. [popRoute] hands the back gesture to that Navigator first,
/// so back closes an open plate before it leaves the tab.
class AppRouterDelegate extends RouterDelegate<AppTab>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppTab> {
  AppRouterDelegate();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppTab _tab = AppTab.showcase;

  @override
  AppTab get currentConfiguration => _tab;

  /// Called by the nav bar. Notifying makes the Router re-read
  /// [currentConfiguration] and update the address bar.
  void goTo(AppTab tab) {
    if (_tab == tab) return;
    _tab = tab;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppTab configuration) {
    _tab = configuration;
    return SynchronousFuture<void>(null);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: <Page<void>>[
        MaterialPage<void>(
          key: const ValueKey<String>('shell'),
          child: GalleryShellScreen(tab: _tab, onTabSelected: goTo),
        ),
      ],
      onDidRemovePage: (Page<Object?> page) {},
    );
  }
}
