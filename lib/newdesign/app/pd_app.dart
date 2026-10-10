import 'package:flutter/material.dart';

import '../design/theme_mode.dart';
import '../design/tokens.dart';
import 'router.dart';

class PdApp extends StatefulWidget {
  const PdApp({super.key, this.initialRoute});

  /// Overrides the platform's start route on platforms with no address bar.
  final String? initialRoute;

  @override
  State<PdApp> createState() => _PdAppState();
}

class _PdAppState extends State<PdApp> {
  final PdRouterDelegate _router = PdRouterDelegate();
  final PdThemeMode _themeMode = PdThemeMode();

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
    _router.dispose();
    _themeMode.dispose();
    _routeProvider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (BuildContext context, ThemeMode mode, _) => PdThemeScope(
        notifier: _themeMode,
        child: MaterialApp.router(
          title: 'platexample — licence-plate input for Flutter',
          debugShowCheckedModeBanner: false,
          theme: pdTheme(Brightness.light),
          darkTheme: pdTheme(Brightness.dark),
          themeMode: mode,
          routerDelegate: _router,
          routeInformationProvider: _routeProvider,
          routeInformationParser: const PdRouteParser(),
        ),
      ),
    );
  }
}

class PdThemeScope extends InheritedNotifier<PdThemeMode> {
  const PdThemeScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static PdThemeMode of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PdThemeScope>()!.notifier!;
}
