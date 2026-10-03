import 'package:flutter/material.dart';

import '../theme/nocturne.dart';

/// Colour tokens from DESIGN_SPEC.md §1.
class PosterColors {
  const PosterColors._();

  // --- Ground / atmosphere --------------------------------------------------
  // sk10's road. Every value here is the Nocturne ramp — `lib/theme/nocturne.dart`
  // — read through the design's own alphas, so nothing in the backdrop carries
  // a colour of its own any more. The old poster's blues went with the layers
  // that used them: the beam wedge, its colour cast, the two light rails, the
  // masks that framed them and the 9px lane stripe are all gone.
  //
  // Where the design's hex has no ramp entry (its panel sits between `n900`
  // and `n800`, its lift between `n900` and the page ground) the token is
  // stated as the blend it is rather than pasted in as a number. That costs
  // const-ness on a handful of statics, which is why they are `final`.

  /// `--color-bg`: the page ground, and the only opaque fill in the backdrop.
  static const Color pageBlack = N.bg;

  /// The ground inside a device screen. The design's is `#05060a`; ours keeps
  /// a hair more lift so the live plate does not float on pure black.
  static const Color stageBlack = Color(0xFF07080B);

  /// `.pg-app.pg-m`, line 47: `radial-gradient(120% 100% at 50% 0%, #0d0f16,
  /// #050608 60%)` — the lift behind the phone panel. Its core is the page
  /// ground most of the way to `n900`.
  static final Color groundLiftCore = Color.lerp(N.bg, N.n900, 0.86)!;
  static const Color groundLiftEdge = N.bg;

  /// The rotated panel, line 87:
  /// `linear-gradient(180deg,#1b1d28,#0d0e15 55%,#0a0b10)`. `n900` lifted
  /// toward `n800` at the head, `n900` itself at the knee, and half-way from
  /// `n900` down to the page ground at the foot.
  static final Color panelHead = Color.lerp(N.n900, N.n800, 0.45)!;
  static const Color panelKnee = N.n900;
  static final Color panelFoot = Color.lerp(N.n900, N.bg, 0.52)!;

  /// The panel's `box-shadow: 0 -1px 0 rgba(233,233,237,.10), 0 1px 0
  /// rgba(233,233,237,.06)` — a hairline of light along its top edge and a
  /// fainter one under its bottom. The design's near-white is `n100`.
  static final Color panelEdgeTop = N.n100.withValues(alpha: 0.10);
  static final Color panelEdgeBottom = N.n100.withValues(alpha: 0.06);

  /// The dash strip, line 88: `rgba(233,233,237,.30)` on an element carrying
  /// `opacity: .55`, which is `n100` at the product of the two. Over the panel
  /// that composites to about `n700`, where the brief puts it.
  static final Color roadStripe = N.n100.withValues(alpha: 0.30 * 0.55);

  /// The accent bloom: `accent 9%` behind the desktop section (line 89) and
  /// `accent 16%` in the phone panel's top-left corner (line 353).
  static final Color accentBloom = N.accentAt(0.09);
  static final Color accentBloomPanel = N.accentAt(0.16);

  /// The rake of a device hop — `sweep_light.dart`. A wash of `n700`/`n600`
  /// with an `n400` leading edge, screen-blended onto the panel: sk10 dropped
  /// the amplitude roughly fourfold from the old near-white streak, which is
  /// the whole difference between a headlight and a sheen.
  static final Color sweepBodyStart = N.n700.withValues(alpha: 0);
  static final Color sweepBodyMid = N.n700.withValues(alpha: 0.20);
  static final Color sweepBodyEnd = N.n600.withValues(alpha: 0.30);

  static final Color sweepEdgeStart = N.n400.withValues(alpha: 0.18);
  static final Color sweepEdgeMid = N.n400.withValues(alpha: 0.34);
  static final Color sweepEdgeEnd = N.n400.withValues(alpha: 0.18);
  static final Color sweepEdgeGlow = N.n500.withValues(alpha: 0.16);

  // --- Text ------------------------------------------------------------------
  static const Color inkDisplay1 = Color(0xFFEAF0FB);
  static const Color inkDisplay2 = Color(0xFFD6E1F1);
  static const Color inkDisplay3 = Color(0xFFC4D0E2);
  static const Color inkDisplay4 = Color(0xFF1A2130);
  static const Color inkDisplayCut = Color(0xFFBCD3F0);
  static const Color inkByline = Color(0xFFDEE7F4);
  static const Color inkMutedItalic = Color(0xFF8E9DB4);
  static const Color inkLink = Color(0xFFA9B3C7);
  static const Color inkMetaStrong = Color(0xFFA5B4C7);
  static const Color inkMetaWeak = Color(0xFF8592A3);
  static const Color inkStamp = Color(0xFFB3BECD);

  // --- Accent / signal --------------------------------------------------------
  static const Color accent = Color(0xFF7C5CFF);

  /// On-screen keypad key highlight — a lighter cast of hero card 01
  /// (`#16479D`), keeping the pad in the project's blue family.
  static const Color keypadHighlight = Color(0xFF3160B0);

  /// The navigation chrome's accent. The poster keeps its violet [accent],
  /// but the nav is app furniture rather than poster art, and violet made it
  /// read as a different product than the rest of the blue-family UI. This is
  /// hero card 01 (`#16479D`) opened up to the luminance the violet had, so
  /// the indicator still lights the near-black rail instead of sinking into it.
  static const Color navAccent = Color(0xFF2E5AB0);

  /// Glow cast behind the selected nav pill — [navAccent] at full strength.
  static const Color navAccentGlow = Color(0xF22E5AB0); // rgba(46,90,176,.95)

  /// The nav bar's own fill. Was a violet-tinted near-black (`#241C42`),
  /// which tinted the whole capsule purple no matter what the pill did.
  static const Color navSurfaceTop = Color(0xFF16213A);
  static const Color navSurfaceBottom = Color(0xFF0D1422);

  static const Color accentRail = Color(0x8C7C5CFF); // rgba(124,92,255,.55)
  static const Color accentRailGlow = Color(0xF27C5CFF); // rgba(124,92,255,.95)
  static const Color accentPipGlow = Color(0xF27C5CFF); // rgba(124,92,255,.95)
  static const Color pipIdle = Color(0x3DC8D4EC); // rgba(200,212,236,.24)
  static const Color flareRed = Color(0xFFF02C1E);
  static const Color flareInk = Color(0xFF1A0603);

  // --- Card decoration ---------------------------------------------------------
  static const Color cardBlueIr = Color(0xFF16479D);
  static const Color cardBlueDe = Color(0xFF003399);
  static const Color euStar = Color(0xFFF5D021);

  static const Color flagBrightGreen = Color(0xFF239F40);
  static const Color flagBrightWhite = Color(0xFFEDEFF3);
  static const Color flagBrightRed = Color(0xFFDA0000);

  static const Color flagMutedGreen = Color(0xFF1D7A36);
  static const Color flagMutedWhite = Color(0xFFB9B4A6);
  static const Color flagMutedRed = Color(0xFF9E1410);

  static const Color chipFace = Color(0xFFEDEFF3);
  static const Color chipInk = Color(0xFF12141B);

  // --- Card grounds ------------------------------------------------------------
  static const Color cardHeroIr = cardBlueIr;
  static const Color cardHeroDe = cardBlueDe;
  static const Color cardChipWhite = chipFace;
  static const Color metaStrip = Color(0xEB090806); // rgba(9,8,6,.92)

  // --- Compatibility names (do not drop) ---------------------------------------
  /// Read by the frozen `virtual_keypad.dart`.
  static const Color accentCompat = accent;

  /// Read by the frozen `virtual_keypad.dart`.
  static const Color hairlineCompat = Color(
    0x1AFFFFFF,
  ); // rgba(255,255,255,.10)

  /// Read by the frozen plate wiring in `showcase_screen.dart`.
  static const Color bgCompat = stageBlack;

  /// Read by the frozen plate wiring in `showcase_screen.dart`.
  static const Color invalidCompat = Color(0xFFF87171);
}

/// Named gradients from DESIGN_SPEC.md §1.
///
/// CSS `linear-gradient(158deg, a, b)` is measured clockwise from "to top"
/// (0deg = pointing up, 90deg = pointing right). 158deg points mostly down
/// and slightly right, so the gradient *starts* up-and-left of that (where
/// the light would come from) and *ends* down-and-right: begin ~= topLeft,
/// end ~= bottomRight, both nudged by the extra 22deg toward the top edge.
class PosterGradients {
  const PosterGradients._();

  /// `linear-gradient(158deg, #232C42, #0E1219)`
  static const LinearGradient cardSteel = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF232C42), Color(0xFF0E1219)],
  );

  /// `linear-gradient(158deg, #141926, #080A10)`
  static const LinearGradient cardDark = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF141926), Color(0xFF080A10)],
  );

  /// `linear-gradient(158deg, #131826, #080A10)` — variant used on card 04/12.
  static const LinearGradient cardDarkVariant = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF131826), Color(0xFF080A10)],
  );

  /// `linear-gradient(158deg, #1C2233, #0D1017)`
  static const LinearGradient cardChipDark = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF1C2233), Color(0xFF0D1017)],
  );

  /// `linear-gradient(158deg, #1B2131, #0C0F16)` — variant.
  static const LinearGradient cardChipDarkVariant = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF1B2131), Color(0xFF0C0F16)],
  );

  /// Per-card ground for the numbered callout cards (steel + dark kinds):
  ///
  ///  * 04 — a lighter blue of hero card 01 (`#16479D`)
  ///  * 12 — a muted denim, lighter than hero card 09 (`#003399`)
  ///  * 07 — cool charcoal, 08 — cool steel blue, 11 — blue slate
  ///  * 02 / 03 — one shared slate tone
  ///
  /// Anything unlisted falls back to [cardSteel].
  static LinearGradient calloutFace(int index) {
    switch (index) {
      case 2:
      case 3:
        return _face(0xFF20293C, 0xFF0C0F17);
      case 4:
        return _face(0xFF3160B0, 0xFF17233F);
      case 7:
        return _face(0xFF26262B, 0xFF0E0E12);
      case 8:
        return _face(0xFF1B2B3C, 0xFF0A131B);
      case 11:
        return _face(0xFF243040, 0xFF0C1019);
      case 12:
        return _face(0xFF3C5C97, 0xFF111A2E);
      default:
        return cardSteel;
    }
  }

  static LinearGradient _face(int top, int bottom) => LinearGradient(
    begin: const Alignment(-0.62, -0.79),
    end: const Alignment(0.62, 0.79),
    colors: <Color>[Color(top), Color(bottom)],
  );

  /// `linear-gradient(158deg, #1A2032, #0C0E16)`; hover ground → `#EDEFF3`.
  static const LinearGradient linkButton = LinearGradient(
    begin: Alignment(-0.62, -0.79),
    end: Alignment(0.62, 0.79),
    colors: [Color(0xFF1A2032), Color(0xFF0C0E16)],
  );

  static const Color linkButtonHover = Color(0xFFEDEFF3);
}

/// Font family names and variable-axis helpers from DESIGN_SPEC.md §2.
class PosterFonts {
  const PosterFonts._();

  static const String archivo = 'Archivo';
  static const String martianMono = 'MartianMono';
  static const String newsreader = 'Newsreader';
  static const String vazirmatn = 'Vazirmatn';

  /// `wdth 79` — the wordmark.
  static const List<FontVariation> wdth79 = [FontVariation('wdth', 79)];

  /// `wdth 84` — hero card titles (EN).
  static const List<FontVariation> wdth84 = [FontVariation('wdth', 84)];

  /// `wdth 86` — small card titles (EN).
  static const List<FontVariation> wdth86 = [FontVariation('wdth', 86)];

  /// `wdth 104` — index chips.
  static const List<FontVariation> wdth104 = [FontVariation('wdth', 104)];
}

/// Every text specimen in DESIGN_SPEC.md §2, expressed as a factory that
/// takes a fluid scale factor (see `PosterMetrics.f`) instead of an absolute
/// size, so no call site hardcodes design px.
class PosterType {
  const PosterType._();

  static TextStyle wordmark(double f) => TextStyle(
    fontFamily: PosterFonts.archivo,
    fontVariations: PosterFonts.wdth79,
    fontWeight: FontWeight.w900,
    fontSize: 176 * f,
    height: 0.86,
    letterSpacing: -0.045 * 176 * f,
  );

  static TextStyle bylineName(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w800,
    fontSize: 17 * f,
    letterSpacing: 0.16 * 17 * f,
    color: PosterColors.inkByline,
  );

  static TextStyle bylineRole(double f) => TextStyle(
    fontFamily: PosterFonts.newsreader,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: 15 * f,
    color: PosterColors.inkMutedItalic,
  );

  static TextStyle cardEyebrowHero(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w700,
    fontSize: 13 * f,
    letterSpacing: 0.30 * 13 * f,
  );

  static TextStyle cardEyebrowSteel(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w700,
    fontSize: 12 * f,
    letterSpacing: 0.28 * 12 * f,
    color: const Color(0xFF9FB6E4),
  );

  static TextStyle cardEyebrowDark(double f, {bool alt = false}) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w600,
    fontSize: 12 * f,
    letterSpacing: 0.24 * 12 * f,
    color: alt ? const Color(0xFF8B97AE) : const Color(0xFF8F9BB2),
  );

  /// Card title EN (hero). [size] must be in the 42–62px design range.
  static TextStyle cardTitleEnHero(double f, double size) => TextStyle(
    fontFamily: PosterFonts.archivo,
    fontVariations: PosterFonts.wdth84,
    fontWeight: FontWeight.w800,
    fontSize: size * f,
    height: size <= 50 ? 0.94 : 0.92,
    letterSpacing: -0.032 * size * f,
  );

  /// Card title EN (small). [size] must be in the 34–36px design range.
  static TextStyle cardTitleEnSmall(double f, double size) => TextStyle(
    fontFamily: PosterFonts.archivo,
    fontVariations: PosterFonts.wdth86,
    fontWeight: FontWeight.w800,
    fontSize: size * f,
    height: 0.96,
    letterSpacing: -0.025 * size * f,
  );

  /// Card title FA. [size] must be in the 34–50px design range.
  static TextStyle cardTitleFa(double f, double size) => TextStyle(
    fontFamily: PosterFonts.vazirmatn,
    fontWeight: FontWeight.w800,
    fontSize: size * f,
    height: size <= 40 ? 1.22 : 1.18,
  );

  /// Card body EN. [size] must be in the 18–24px design range.
  static TextStyle cardBodyEn(double f, double size) => TextStyle(
    fontFamily: PosterFonts.newsreader,
    fontWeight: FontWeight.w400,
    fontSize: size * f,
    height: size <= 20 ? 1.46 : 1.44,
  );

  /// Card body FA. [size] must be in the 19–23px design range.
  static TextStyle cardBodyFa(double f, double size) => TextStyle(
    fontFamily: PosterFonts.vazirmatn,
    fontWeight: FontWeight.w400,
    fontSize: size * f,
    height: size <= 20 ? 1.78 : 1.70,
  );

  /// Index chip. [size] must be in the 44–78px design range.
  static TextStyle indexChip(double f, double size) => TextStyle(
    fontFamily: PosterFonts.archivo,
    fontVariations: PosterFonts.wdth104,
    fontWeight: FontWeight.w800,
    fontSize: size * f,
  );

  static TextStyle linkLabel(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w700,
    fontSize: 14 * f,
    letterSpacing: 0.20 * 14 * f,
  );

  static TextStyle metaStrong(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w600,
    fontSize: 17 * f,
    letterSpacing: 0.14 * 17 * f,
    color: PosterColors.inkMetaStrong,
  );

  static TextStyle metaWeak(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w500,
    fontSize: 15 * f,
    letterSpacing: 0.14 * 15 * f,
    color: PosterColors.inkMetaWeak,
  );

  static TextStyle stamp(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w700,
    fontSize: 12 * f,
    height: 1.55,
    letterSpacing: 0.20 * 12 * f,
    color: PosterColors.inkStamp,
  );

  /// Red tag on card 09.
  static TextStyle redTag(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w700,
    fontSize: 13 * f,
    letterSpacing: 0.20 * 13 * f,
    color: PosterColors.flareInk,
  );

  static TextStyle eyebrow(double f) => TextStyle(
    fontFamily: PosterFonts.martianMono,
    fontWeight: FontWeight.w600,
    fontSize: 12 * f,
    letterSpacing: 0.25 * 12 * f,
    color: PosterColors.inkDisplay3,
  );
}

/// Design tokens shared across the poster widgets, plus the four names the
/// frozen device-side files already read: [accent], [hairline], [bg] and
/// [invalid]. These four must not be renamed or removed — see
/// DESIGN_SPEC.md §1, "Compatibility names".
class PosterTokens {
  const PosterTokens._();

  static const Color accent = PosterColors.accentCompat;
  static const Color keypadHighlight = PosterColors.keypadHighlight;
  static const Color hairline = PosterColors.hairlineCompat;
  static const Color bg = PosterColors.bgCompat;
  static const Color invalid = PosterColors.invalidCompat;
}
