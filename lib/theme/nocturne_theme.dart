import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'nocturne.dart';

/// The Material [ThemeData] built from Nocturne's tokens ([N], [NType]).
///
/// This only assembles [ThemeData] — the values themselves live in
/// `nocturne.dart`; see `lib/theme/README.md` for the full token list.
ThemeData nocturneTheme() {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: N.accent,
    brightness: Brightness.dark,
  ).copyWith(
    surface: N.surface,
    onSurface: N.text,
    outline: N.divider,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: N.bg,
    canvasColor: N.bg,
    colorScheme: colorScheme,
    fontFamily: NType.archivo,
    fontFamilyFallback: const [NType.arabic],
    textTheme: TextTheme(
      displayLarge: NType.h1,
      headlineMedium: NType.h2,
      headlineSmall: NType.h3,
      titleLarge: NType.h4,
      titleMedium: NType.h5,
      labelLarge: NType.h6,
      bodyMedium: NType.body,
    ),
    dividerTheme: DividerThemeData(
      color: N.divider,
      thickness: 1,
      space: 0,
    ),
    // The design has no Material ripple anywhere; hover is a colour change
    // and nothing else.
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    visualDensity: VisualDensity.compact,
    // `.pg-scroll` sets `scrollbar-width: none` — no visible scrollbar here.
    scrollbarTheme: const ScrollbarThemeData(
      thumbVisibility: WidgetStatePropertyAll(false),
      thickness: WidgetStatePropertyAll(0),
    ),
  );
}

/// Hides scrollbars everywhere and lets mouse drag scroll like touch,
/// matching the design's `.pg-scroll` treatment on web.
class NocturneScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) => child;
}
