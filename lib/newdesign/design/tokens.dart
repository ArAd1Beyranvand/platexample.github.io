import 'package:flutter/material.dart';

/// Plate DS colour tokens (DESIGN_SYSTEM.md §2). Read with `context.tokens`.
@immutable
class PdTokens extends ThemeExtension<PdTokens> {
  const PdTokens({
    required this.bg,
    required this.surface,
    required this.raised,
    required this.text,
    required this.muted,
    required this.subtle,
    required this.divider,
    required this.control,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.hover,
    required this.ok,
    required this.error,
    required this.code,
  });

  static const PdTokens dark = PdTokens(
    bg: Color(0xFF050608),
    surface: Color(0xFF0E1219),
    raised: Color(0xFF141926),
    text: Color(0xFFEAF0FB),
    muted: Color(0xFFA5B4C7),
    subtle: Color(0xFF8592A3),
    divider: Color(0x1AFFFFFF),
    control: Color(0xFF6A7484),
    accent: Color(0xFF2FD4CF),
    onAccent: Color(0xFF050608),
    accentSoft: Color(0xFF0F3F42),
    hover: Color(0xFF0C2A2F),
    ok: Color(0xFF4ADE80),
    error: Color(0xFFF87171),
    code: Color(0xFF0A0D13),
  );

  static const PdTokens light = PdTokens(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF6F7F9),
    raised: Color(0xFFFFFFFF),
    text: Color(0xFF0E1219),
    muted: Color(0xFF4A5565),
    subtle: Color(0xFF5F6B7A),
    divider: Color(0x1A0E1219),
    control: Color(0xFF737D8C),
    accent: Color(0xFF0B7C86),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0xFFBDE6E4),
    hover: Color(0xFFCFEEEC),
    ok: Color(0xFF15803D),
    error: Color(0xFFB91C1C),
    code: Color(0xFFF6F7F9),
  );

  final Color bg;
  final Color surface;
  final Color raised;
  final Color text;
  final Color muted;
  final Color subtle;
  final Color divider;
  final Color control;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;

  /// Turquoise-tinted fill for hovered rows, chips and buttons.
  final Color hover;
  final Color ok;
  final Color error;
  final Color code;

  @override
  PdTokens copyWith() => this;

  @override
  PdTokens lerp(PdTokens? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return PdTokens(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      raised: l(raised, other.raised),
      text: l(text, other.text),
      muted: l(muted, other.muted),
      subtle: l(subtle, other.subtle),
      divider: l(divider, other.divider),
      control: l(control, other.control),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentSoft: l(accentSoft, other.accentSoft),
      hover: l(hover, other.hover),
      ok: l(ok, other.ok),
      error: l(error, other.error),
      code: l(code, other.code),
    );
  }
}

abstract final class PdFonts {
  static const String ui = 'Archivo';
  static const String mono = 'MartianMono';
  static const String persian = 'Vazirmatn';
}

abstract final class PdRadius {
  static const double chip = 6;
  static const double card = 10;
  static const double stage = 16;
}

abstract final class PdMotion {
  static const Duration select = Duration(milliseconds: 150);
  static const Curve selectCurve = Curves.easeOutCubic;
  static const Duration highlight = Duration(milliseconds: 600);

  /// [d], or zero when the platform asks for no animation.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}

/// `clamp(min, vw% of the viewport, max)`, as the mock's CSS writes it.
double pdClamp(BuildContext context, double min, double vw, double max) =>
    (MediaQuery.sizeOf(context).width * vw / 100).clamp(min, max);

extension PdTokensContext on BuildContext {
  PdTokens get tokens => Theme.of(this).extension<PdTokens>()!;
}

ThemeData pdTheme(Brightness brightness) {
  final PdTokens t = brightness == Brightness.dark ? PdTokens.dark : PdTokens.light;
  final ThemeData base = ThemeData(
    brightness: brightness,
    fontFamily: PdFonts.ui,
    fontFamilyFallback: const <String>[PdFonts.persian],
    scaffoldBackgroundColor: t.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: t.accent,
      brightness: brightness,
      primary: t.accent,
      onPrimary: t.onAccent,
      surface: t.bg,
      onSurface: t.text,
      error: t.error,
    ),
    dividerColor: t.divider,
    splashFactory: NoSplash.splashFactory,
    hoverColor: t.hover,
    focusColor: t.accentSoft,
    highlightColor: t.accentSoft,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> s) => s.contains(WidgetState.dragged)
            ? t.accent
            : s.contains(WidgetState.hovered)
            ? t.accent.withValues(alpha: 0.8)
            : t.accent.withValues(alpha: 0.45),
      ),
      trackColor: WidgetStatePropertyAll<Color>(t.accentSoft),
      radius: const Radius.circular(8),
    ),
    extensions: <ThemeExtension<dynamic>>[t],
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: t.text, displayColor: t.text),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: t.accent,
      selectionColor: t.accentSoft,
      selectionHandleColor: t.accent,
    ),
  );
}
