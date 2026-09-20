import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _routerDelegate.dispose();
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
    );
  }
}
