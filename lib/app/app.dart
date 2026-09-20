import 'package:flutter/material.dart';

import '../shell/mobile_panel.dart';
import '../theme/nocturne_theme.dart';
import 'app_router.dart';

class PlateNumberShowcaseApp extends StatefulWidget {
  const PlateNumberShowcaseApp({super.key});

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

  @override
  void dispose() {
    _routerDelegate.dispose();
    _forceMobilePanel.dispose();
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
