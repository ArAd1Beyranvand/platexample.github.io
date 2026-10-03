import 'package:flutter/material.dart';

import '../theme/nocturne.dart';
import 'mobile_tokens.dart';

/// Uppercase mono label for mobile showcase sections.
///
/// Examples: `PLATE GALLERY`, `SWIPE →`, `TAP TO ADVANCE`.
class MonoLabel extends StatelessWidget {
  const MonoLabel(
    this.text, {
    super.key,
    this.color = MobileTokens.n100,
    this.tone = 400,
  });

  final String text;
  final Color color;
  final double tone;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: NType.mono,
        fontWeight: FontWeight.w400,
        fontSize: tone == 400 ? 10 : 9.5,
        letterSpacing: (tone == 400 ? 0.14 : 0.10) * (tone == 400 ? 10 : 9.5),
        color: color,
      ),
    );
  }
}
