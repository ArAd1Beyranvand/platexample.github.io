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
/// The shell pushes its detail screens imperatively onto a Navigator *nested
/// inside* its own page area — a pages list per tab would mean rebuilding the
/// whole stack on every tab change, and the tabs are an [IndexedStack]
/// precisely so they are *not* rebuilt.
///
/// [popRoute] therefore has three things to try, in order: the nested Discover
/// stack, this Navigator (which holds only the shell, but a dialog or a
/// route pushed on the root belongs to it), and finally the tab history the
/// browser keeps. Back on a plate page steps plate → country → Discover index
/// before it leaves Discover at all.
class AppRouterDelegate extends RouterDelegate<AppTab>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppTab> {
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
          child: GalleryShellScreen(key: _shellKey, tab: _tab, onTabSelected: goTo),
        ),
      ],
      onDidRemovePage: (Page<Object?> page) {},
    );
  }
}
