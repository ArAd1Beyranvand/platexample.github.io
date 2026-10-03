import 'package:flutter/material.dart';

import '../theme/nocturne.dart';

/// Colour tokens for mobile showcase, extending Nocturne.
abstract final class MobileTokens {
  static const Color bg = N.bg;
  static const Color surface = N.surface;
  static const Color divider = N.divider;

  static const Color n100 = N.n100;
  static const Color n200 = N.n200;
  static const Color n300 = N.n300;
  static const Color n400 = N.n400;
  static const Color n500 = N.n500;
  static const Color n600 = N.n600;
  static const Color n700 = N.n700;
  static const Color n800 = N.n800;
  static const Color n900 = N.n900;

  static const Color accent = N.accent;
  static const Color accent200 = Color(0xFFE7E5FE);
  static const Color accent300 = N.accent300;
  static const Color accent400 = Color(0xFFB5ABFC);
  static const Color accent500 = Color(0xFF968AE0);
  static const Color accent700 = N.accent700;
  static const Color accent800 = N.accent800;
  static const Color accent900 = N.accent900;

  static Color textAt(double opacity) => N.textAt(opacity);
  static Color accentAt(double opacity) => N.accentAt(opacity);
}
