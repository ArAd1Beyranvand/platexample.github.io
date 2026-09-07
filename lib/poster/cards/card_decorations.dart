import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../poster_scale.dart';
import '../poster_tokens.dart';

/// The per-card extras at the end of DESIGN_SPEC.md §4. Each one is a leaf
/// widget sized in DESIGN px through [PosterMetrics]; the cards themselves
/// (P7) position them.

/// Card 01 — vertical IR flag strip, 26px wide, inset `left 22, top 22,
/// bottom 22`, with `inset 0 0 0 2px rgba(0,8,26,.55)` and a
/// `0 0 0 1px rgba(226,238,255,.30)` outline.
class IrFlagStrip extends StatelessWidget {
  const IrFlagStrip({
    super.key,
    this.width = 26,
    this.muted = false,
    this.opacity = 1,
    this.innerRing = true,
  });

  /// Strip width in DESIGN px.
  final double width;

  /// Card 02's faded bands.
  final bool muted;
  final double opacity;

  /// The 2px inner ring + 1px outline of card 01. Card 02's 5px strip has
  /// neither.
  final bool innerRing;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final List<Color> bands = muted
        ? const <Color>[
            PosterColors.flagMutedGreen,
            PosterColors.flagMutedWhite,
            PosterColors.flagMutedRed,
          ]
        : const <Color>[
            PosterColors.flagBrightGreen,
            PosterColors.flagBrightWhite,
            PosterColors.flagBrightRed,
          ];

    final BorderRadius radius = BorderRadius.circular(metrics.px(width * 0.32));

    Widget strip = ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        width: metrics.px(width),
        child: Column(
          children: <Widget>[
            for (final Color band in bands)
              Expanded(child: ColoredBox(color: band)),
          ],
        ),
      ),
    );

    if (innerRing) {
      // A single soft outline instead of the hard inset ring + outline pair —
      // reads as a gently rounded pill rather than a machined edge.
      strip = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: const Color(0x33E2EEFF), // rgba(226,238,255,.20)
            width: metrics.px(1.25),
          ),
        ),
        child: strip,
      );
    }

    if (opacity >= 1) return strip;
    return Opacity(opacity: opacity, child: strip);
  }
}


/// Card 02 — the faded 5px vertical flag strip, `right 20, top 20, bottom 20`,
/// opacity `.8`.
class FadedFlagStrip extends StatelessWidget {
  const FadedFlagStrip({super.key, this.width = 5});

  final double width;

  @override
  Widget build(BuildContext context) {
    return IrFlagStrip(
      width: width,
      muted: true,
      opacity: 0.8,
      innerRing: false,
    );
  }
}

/// Card 05 — the divider between title and body. Softened from a hard
/// two-tone bar into a single rounded rule that fades at both ends, the way
/// a modern UI card separates a header from its content.
class TwoToneDivider extends StatelessWidget {
  const TwoToneDivider({
    super.key,
    this.width,
    this.bandThickness = 3,
    this.dark = const Color(0x9900081A),
    this.light = const Color(0x75E2EEFF),
  });

  /// Length in DESIGN px. Null stretches to the parent.
  final double? width;
  final double bandThickness;

  /// Kept for API compatibility; unused by the softened rule (a single tone
  /// reads calmer than a light/dark split).
  final Color dark;
  final Color light;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final double band = metrics.px(bandThickness * 0.7);
    return SizedBox(
      width: width == null ? double.infinity : metrics.px(width!),
      height: band,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(band / 2),
          gradient: LinearGradient(
            colors: <Color>[
              Colors.transparent,
              light.withValues(alpha: 0.55),
              Colors.transparent,
            ],
            stops: const <double>[0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Card 05 — the footer row: a 44×26 IR flag beside `IR · MOTORBIKE`.
class IrFlagFooter extends StatelessWidget {
  const IrFlagFooter({
    super.key,
    this.label = 'IR · MOTORBIKE',
    this.flagWidth = 44,
    this.flagHeight = 26,
    this.gap = 12,
  });

  final String label;
  final double flagWidth;
  final double flagHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(metrics.px(5)),
          child: SizedBox(
            width: metrics.px(flagWidth),
            height: metrics.px(flagHeight),
            child: Column(
              children: const <Widget>[
                Expanded(child: ColoredBox(color: PosterColors.flagBrightGreen)),
                Expanded(child: ColoredBox(color: PosterColors.flagBrightWhite)),
                Expanded(child: ColoredBox(color: PosterColors.flagBrightRed)),
              ],
            ),
          ),
        ),
        SizedBox(width: metrics.px(gap)),
        Text(label, style: PosterType.metaWeak(metrics.f)),
      ],
    );
  }
}

/// Card 09 — the EU badge column: 34px wide, twelve `#F5D021` stars (r 1.9 on
/// a circle of r 11.5 about the centre of a 34-unit box) over a `D` in
/// Martian Mono `wght 700` 15px.
class EuBadgeColumn extends StatelessWidget {
  const EuBadgeColumn({
    super.key,
    this.width = 34,
    this.letter = 'D',
    this.ground = PosterColors.cardBlueDe,
  });

  final double width;
  final String letter;
  final Color ground;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final double side = metrics.px(width);
    return ClipRRect(
      borderRadius: BorderRadius.circular(metrics.px(10)),
      child: ColoredBox(
      color: ground,
      child: SizedBox(
        width: side,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: side,
              height: side,
              child: CustomPaint(
                painter: _EuStarsPainter(
                  starRadius: side * (1.9 / 34),
                  ringRadius: side * (11.5 / 34),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: metrics.px(6)),
              child: Text(
                letter,
                style: TextStyle(
                  fontFamily: PosterFonts.martianMono,
                  fontWeight: FontWeight.w700,
                  fontSize: 15 * metrics.f,
                  height: 1.0,
                  color: PosterColors.inkDisplay1,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _EuStarsPainter extends CustomPainter {
  const _EuStarsPainter({required this.starRadius, required this.ringRadius});

  final double starRadius;
  final double ringRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = Offset(size.width / 2, size.height / 2);
    final Paint paint = Paint()..color = PosterColors.euStar;
    for (int i = 0; i < 12; i++) {
      final double angle = -math.pi / 2 + i * (math.pi / 6);
      final Offset at = centre +
          Offset(math.cos(angle) * ringRadius, math.sin(angle) * ringRadius);
      canvas.drawPath(_star(at, starRadius), paint);
    }
  }

  /// A five-pointed star, point up.
  Path _star(Offset centre, double radius) {
    final Path path = Path();
    final double inner = radius * 0.382;
    for (int i = 0; i < 10; i++) {
      final double r = i.isEven ? radius : inner;
      final double angle = -math.pi / 2 + i * (math.pi / 5);
      final Offset p = centre + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_EuStarsPainter oldDelegate) {
    return oldDelegate.starRadius != starRadius ||
        oldDelegate.ringRadius != ringRadius;
  }
}

/// Card 09 — the `SERIAL FIELD` flag, softened from a hard-edged banner into
/// a small rounded pill with a gentle shadow, the way a UI would badge a
/// validation state.
class RedTag extends StatelessWidget {
  const RedTag({super.key, this.label = 'SERIAL FIELD'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PosterColors.flareRed,
        borderRadius: BorderRadius.circular(metrics.px(999)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: PosterColors.flareRed.withValues(alpha: 0.45),
            blurRadius: metrics.px(12),
            offset: Offset(0, metrics.px(4)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          metrics.px(16),
          metrics.px(9),
          metrics.px(16),
          metrics.px(9),
        ),
        child: Text(label, style: PosterType.redTag(metrics.f)),
      ),
    );
  }
}

/// Card 10 — the `#003399` accent strip, now a rounded capsule instead of a
/// hard-edged bar.
class DeStrip extends StatelessWidget {
  const DeStrip({super.key, this.width = 8});

  final double width;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(metrics.px(width / 2)),
      child: SizedBox(
        width: metrics.px(width),
        child: const ColoredBox(color: PosterColors.cardBlueDe),
      ),
    );
  }
}
