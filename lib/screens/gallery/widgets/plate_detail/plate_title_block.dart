import 'package:flutter/material.dart';

import '../../../../theme/nocturne.dart';

/// The livery name as the page title, and the `Country · package` subtitle
/// under it — `Car` / `Iran · iran_plate` in the target picture.
class PlateTitleBlock extends StatelessWidget {
  const PlateTitleBlock({
    super.key,
    required this.livery,
    required this.countryName,
    required this.packageName,
    this.liveryFontSize = 52,
  });

  final String livery;
  final String countryName;
  final String packageName;

  /// `52px` on desktop; sk21's mobile panel takes `≈32px`.
  final double liveryFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          livery,
          style: TextStyle(
            fontFamily: NType.archivo,
            fontWeight: FontWeight.w800,
            fontSize: liveryFontSize,
            height: 1.05,
            letterSpacing: -0.02 * liveryFontSize,
            color: N.n100,
          ),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(
            style: const TextStyle(fontFamily: NType.archivo, fontSize: 16, color: N.n400),
            children: <InlineSpan>[
              TextSpan(text: countryName),
              const TextSpan(text: ' · '),
              TextSpan(text: packageName, style: const TextStyle(fontFamily: NType.mono)),
            ],
          ),
        ),
      ],
    );
  }
}
