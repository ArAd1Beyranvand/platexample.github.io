import 'package:flutter/material.dart';

import '../shell/mobile_panel.dart';
import '../theme/nocturne_theme.dart';
import 'app_router.dart';

class PlateNumberShowcaseApp extends StatefulWidget {
  const PlateNumberShowcaseApp({super.key, this.initialRoute});

  /// Overrides the platform's start route, e.g. `/discover/slovenia`.
  final String? initialRoute;

  @override
  State<PlateNumberShowcaseApp> createState() => _PlateNumberShowcaseAppState();
}

class _PlateNumberShowcaseAppState extends State<PlateNumberShowcaseApp> {
  // Built once and disposed with the app: a delegate rebuilt on every frame
  // would drop the tab it is holding.
  final AppRouterDelegate _routerDelegate = AppRouterDelegate();

  // The `MOBILE VIEW` toggle. Lives above the Router so it survives tab
  // switches and detail pushes untouched.
  final ValueNotifier<bool> _forceMobilePanel = ValueNotifier<bool>(false);

  late final PlatformRouteInformationProvider? _routeProvider =
      widget.initialRoute == null
      ? null
      : PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(widget.initialRoute!),
          ),
        );

  @override
  void dispose() {
    _routerDelegate.dispose();
    _forceMobilePanel.dispose();
    _routeProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plate Gallery',
      debugShowCheckedModeBanner: false,
      theme: nocturneTheme(),
      darkTheme: nocturneTheme(),
      themeMode: ThemeMode.dark,
      scrollBehavior: NocturneScrollBehavior(),
      routerDelegate: _routerDelegate,
      routeInformationProvider: _routeProvider,
      routeInformationParser: const AppRouteParser(),
      builder: (BuildContext context, Widget? child) {
        return MobilePanelScope(
          notifier: _forceMobilePanel,
          child: ValueListenableBuilder<bool>(
            valueListenable: _forceMobilePanel,
            builder: (BuildContext context, bool forced, Widget? routedChild) {
              if (!forced) return routedChild!;
              return MobilePanelChrome(child: routedChild!);
            },
            child: child,
          ),
        );
      },
    );
  }
}
