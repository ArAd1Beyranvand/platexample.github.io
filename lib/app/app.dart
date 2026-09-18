import 'package:flutter/material.dart';

import '../poster/poster_tokens.dart';
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
      theme: ThemeData(
        // Seeded from the nav accent, not the poster's violet: this scheme
        // colours app chrome (ripples, selection, default Material widgets),
        // which should sit in the project's blue family. The poster keeps
        // PosterColors.accent for its own art.
        colorSchemeSeed: PosterColors.navAccent,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: PosterColors.pageBlack,
        canvasColor: PosterColors.pageBlack,
        useMaterial3: true,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: const AppRouteParser(),
    );
  }
}
