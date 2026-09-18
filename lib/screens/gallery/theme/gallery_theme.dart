import 'package:flutter/material.dart';

/// The app's palette and type, built once for each brightness.
///
/// The old app was `colorSchemeSeed: Color(0xFF0F7A3D)` and nothing else,
/// which made every surface a tinted green — fine for a form, wrong for a
/// catalogue. The plates are the colour here: Yemeni green government plates,
/// yellow for-hire plates, an inverted white-on-green Palestinian bus plate.
/// Chrome that also wants to be green competes with them.
///
/// So: near-neutral surfaces with only a trace of blue in them, one accent
/// used sparingly for interactive affordances, and the saturation budget
/// spent entirely on the artefacts. A gallery paints its walls grey.
abstract final class GalleryTheme {
  /// The one saturated colour the chrome is allowed. Kept green in spirit
  /// with the old seed so the app still reads as the same product, but
  /// brightened and cooled to sit next to plate liveries without clashing.
  static const Color _accent = Color(0xFF2EC27E);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    // fromSeed for the twenty-odd roles that only need to be harmonious and
    // legible; the handful below that carry the look are then pinned, because
    // a seeded neutral is never quite neutral enough.
    final ColorScheme base = ColorScheme.fromSeed(seedColor: _accent, brightness: brightness);
    final ColorScheme colors = isDark
        ? base.copyWith(
            surface: const Color(0xFF0E1013),
            surfaceContainerLowest: const Color(0xFF0A0C0E),
            surfaceContainerLow: const Color(0xFF14171B),
            surfaceContainer: const Color(0xFF191D22),
            surfaceContainerHigh: const Color(0xFF1F242A),
            surfaceContainerHighest: const Color(0xFF262C33),
            onSurface: const Color(0xFFE7EAEE),
            onSurfaceVariant: const Color(0xFF9BA4AF),
            outlineVariant: const Color(0xFF2A3037),
            primary: _accent,
            onPrimary: const Color(0xFF06231A),
          )
        : base.copyWith(
            surface: const Color(0xFFFBFBFC),
            surfaceContainerLowest: Colors.white,
            surfaceContainerLow: const Color(0xFFF4F5F7),
            surfaceContainer: const Color(0xFFEEF0F3),
            surfaceContainerHigh: const Color(0xFFE7EAEE),
            surfaceContainerHighest: const Color(0xFFDFE3E8),
            onSurface: const Color(0xFF12161A),
            onSurfaceVariant: const Color(0xFF5C6673),
            outlineVariant: const Color(0xFFD9DEE4),
            primary: const Color(0xFF12805A),
            onPrimary: Colors.white,
          );

    final Typography typography = Typography.material2021(colorScheme: colors);
    final TextTheme text = isDark ? typography.white : typography.black;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      // Display and headline tightened: at large sizes the default tracking
      // reads loose and webby, and the headings here are short labels
      // ("Yemen", "Plate archive") rather than running prose.
      textTheme: text.copyWith(
        displaySmall: text.displaySmall?.copyWith(letterSpacing: -1, fontWeight: FontWeight.w600),
        headlineMedium: text.headlineMedium?.copyWith(letterSpacing: -0.6, fontWeight: FontWeight.w600),
        headlineSmall: text.headlineSmall?.copyWith(letterSpacing: -0.4, fontWeight: FontWeight.w600),
        titleLarge: text.titleLarge?.copyWith(letterSpacing: -0.2, fontWeight: FontWeight.w600),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        // The one deliberately loud style: the small-caps eyebrow over a
        // section, which has to read as structure rather than as content.
        labelSmall: text.labelSmall?.copyWith(letterSpacing: 1.4, fontWeight: FontWeight.w700),
      ),
    );
  }
}
