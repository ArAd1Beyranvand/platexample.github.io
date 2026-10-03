import 'package:flutter/widgets.dart';

/// Nocturne's colour ramp, transcribed from `design_ref/Plate Gallery.dc.html`
/// (`:root`, lines 18–43). No [ThemeData] lives here — that's sk3 — this is
/// only the values later prompts build one from.
abstract final class N {
  static const Color bg = Color(0xFF050608);
  static const Color surface = Color(0xFF141926);
  static const Color text = Color(0xFFEAF0FB);

  /// White at 10% — `--color-divider`.
  static const Color divider = Color(0x1AFFFFFF);

  static const Color n100 = Color(0xFFEAF0FB);
  static const Color n200 = Color(0xFFD6E1F1);
  static const Color n300 = Color(0xFFC4D0E2);
  static const Color n400 = Color(0xFFA5B4C7);
  static const Color n500 = Color(0xFF8592A3);
  static const Color n600 = Color(0xFF6A7484);
  static const Color n700 = Color(0xFF39414F);
  static const Color n800 = Color(0xFF232C42);
  static const Color n900 = Color(0xFF0E1219);

  static const Color accent = Color(0xFF7C5CFF);
  static const Color accent300 = Color(0xFFB9A7FF);
  static const Color accent700 = Color(0xFF4A3A93);
  static const Color accent800 = Color(0xFF2E2560);
  static const Color accent900 = Color(0xFF1A1540);

  /// [text] at [opacity] — the `color-mix(text N%)` idiom from the CSS.
  static Color textAt(double opacity) => text.withValues(alpha: opacity);

  /// [accent] at [opacity] — hover fills use 12% / 22%.
  static Color accentAt(double opacity) => accent.withValues(alpha: opacity);
}

/// Nocturne's type scale, transcribed from the page `<style>` block and the
/// inline heading/body styles in `design_ref/Plate Gallery.dc.html`.
abstract final class NType {
  static const String archivo = 'Archivo';
  static const String mono = 'MartianMono';
  static const String serif = 'Newsreader';
  static const String arabic = 'Vazirmatn';

  static TextStyle _heading(double fontSize) => TextStyle(
    fontFamily: archivo,
    fontWeight: FontWeight.w800,
    fontSize: fontSize,
    height: 1.12,
    letterSpacing: -0.015 * fontSize,
    color: N.text,
  );

  static TextStyle get h1 => _heading(42);
  static TextStyle get h2 => _heading(32);
  static TextStyle get h3 => _heading(25);
  static TextStyle get h4 => _heading(20);
  static TextStyle get h5 => _heading(16);

  /// The uppercase eyebrow. `text-transform: uppercase` has no Flutter
  /// equivalent — callers must uppercase the string themselves.
  static TextStyle get h6 => TextStyle(
    fontFamily: archivo,
    fontWeight: FontWeight.w800,
    fontSize: 13,
    height: 1.12,
    letterSpacing: 0.08 * 13,
    color: N.text,
  );

  static TextStyle get body => const TextStyle(
    fontFamily: archivo,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.55,
    color: N.text,
  );

  /// `01` / `02` / `03` — the rail numbers on the showcase device stage.
  static TextStyle get railNumber => const TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    letterSpacing: 0.10 * 10,
    color: N.text,
  );

  /// `RULES`, `FEATURE`, `SCALE`, `COUNTRIES`, `INPUT`, `DETAILS`,
  /// `BUILT AGAINST`. Uppercase the string at the call site.
  static TextStyle get kicker => const TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    letterSpacing: 0.12 * 11,
    color: N.text,
  );

  /// `ir.car`, `ps.gaza.car2012` — spec identifiers.
  static TextStyle get specId => const TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    letterSpacing: 0.02 * 11,
    color: N.text,
  );

  /// The MOBILE VIEW button and the MOBILE / TABLET / DESKTOP segmented
  /// control. Uppercase the string at the call site.
  static TextStyle get pill => const TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w400,
    fontSize: 9.5,
    letterSpacing: 0.10 * 9.5,
    color: N.text,
  );

  /// Arabic-script country blocks (`ایران`, `اليمن - خصوصي`) need Vazirmatn;
  /// everything else stays on Archivo.
  static String forScript(String text) {
    final bool isArabicScript = text.runes.any(
      (int codePoint) =>
          (codePoint >= 0x0600 && codePoint <= 0x06FF) ||
          (codePoint >= 0x0750 && codePoint <= 0x077F) ||
          (codePoint >= 0x08A0 && codePoint <= 0x08FF) ||
          (codePoint >= 0xFB50 && codePoint <= 0xFDFF) ||
          (codePoint >= 0xFE70 && codePoint <= 0xFEFF),
    );
    return isArabicScript ? arabic : archivo;
  }
}

/// The spacing scale, in logical pixels.
abstract final class NSpace {
  static const double s1 = 2.8;
  static const double s2 = 5.6;
  static const double s3 = 8.4;
  static const double s4 = 11.2;
  static const double s6 = 16.8;
  static const double s8 = 22.4;
}

/// Corner radii, in logical pixels.
abstract final class NRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 14;
  static const double pill = 999;
}

/// Nocturne's elevation steps.
///
/// CSS composes a 1px "spread" and a blur in one `box-shadow` list; Flutter's
/// [BoxShadow] has no zero-blur spread-as-border idiom that draws crisply at
/// 1px, so the hairline each elevation carries is a real [Border] instead.
/// Callers put [smBorder]/[mdBorder]/[lgBorder] on the [BoxDecoration] and
/// the matching `Shadows` list alongside it.
abstract final class NShadow {
  /// White at [opacity] — the hairline every elevation step carries.
  static Border hairline(double opacity) => Border.all(
    color: const Color(0xFFFFFFFF).withValues(alpha: opacity),
    width: 1,
  );

  static Border get smBorder => hairline(0.08);
  static List<BoxShadow> get smShadows => const [];

  static Border get mdBorder => hairline(0.10);
  static List<BoxShadow> get mdShadows => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.70),
      offset: const Offset(0, 10),
      blurRadius: 26,
    ),
  ];

  static Border get lgBorder => hairline(0.14);
  static List<BoxShadow> get lgShadows => [
    BoxShadow(
      color: const Color(0xFF000000).withValues(alpha: 0.80),
      offset: const Offset(0, 26),
      blurRadius: 60,
    ),
  ];
}

/// The page's own media-query breakpoints, in logical pixels.
///
/// [shell] replaces the old `kWideBreakpoint = 900` from
/// `lib/screens/gallery/theme/tokens.dart` (removed in sk15) and happens to
/// share its value — that's coincidence, not a dependency.
abstract final class NBreak {
  static const double hero = 1180;
  static const double detail = 1040;
  static const double shell = 900;
  static const double stats = 760;

  /// The phone panel. Not a media query — the design's mobile screens are a
  /// 390×812 panel inside a desktop viewport rather than a narrow viewport of
  /// their own, so the CSS has no rule for this width and the reference render
  /// supplies it.
  ///
  /// It lives here because more than one widget has to turn at exactly the
  /// same place: the showcase hero switches to its panel column here, and the
  /// backdrop drops the road for the panel's ground here.
  static const double panel = 560;

  /// Whether a box of [size] gets the phone-panel layout: under [panel], or
  /// any portrait box. A tall desktop window uses the mobile layout rather
  /// than a stacked version of the wide one.
  static bool isPanel(Size size) =>
      size.width < panel || size.height > size.width;
}

/// A horizontal rule that fades to transparent over its first and last 48px
/// instead of ending cleanly — Nocturne's signature divider treatment.
///
/// Every divider in later prompts uses this, except box outlines and
/// in-control separators, which stay solid.
class NRule extends StatelessWidget {
  const NRule({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double fadeStop = (width.isFinite && width > 0)
            ? (48 / width).clamp(0.0, 0.5)
            : 0.5;
        return Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                N.divider.withValues(alpha: 0),
                N.divider,
                N.divider,
                N.divider.withValues(alpha: 0),
              ],
              stops: <double>[0, fadeStop, 1 - fadeStop, 1],
            ),
          ),
        );
      },
    );
  }
}
