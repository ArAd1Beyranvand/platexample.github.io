import 'package:flutter/material.dart';

import '../design/tokens.dart';

TextStyle eyebrow(PdTokens t) =>
    TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.72, color: t.subtle);

TextStyle h2(BuildContext context) => TextStyle(
  fontSize: pdClamp(context, 22, 2.6, 28),
  height: 1.25,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.015 * pdClamp(context, 22, 2.6, 28),
  color: context.tokens.text,
);

TextStyle h3(PdTokens t) => TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  fontVariations: const <FontVariation>[FontVariation.weight(650)],
  color: t.text,
);

TextStyle body(PdTokens t, {double size = 14}) =>
    TextStyle(fontSize: size, height: 1.55, color: t.muted);

TextStyle monoStyle(PdTokens t, {double size = 13, double? height}) =>
    TextStyle(fontFamily: PdFonts.mono, fontSize: size, height: height, color: t.text);
