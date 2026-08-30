import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../poster_scale.dart';
import '../poster_tokens.dart';

/// The display wordmark from DESIGN_SPEC.md §6 "Chrome" and §2.
///
/// Four uppercase lines — PLATE / INPUT / FOR THE / ROAD — in Archivo
/// `wght 900`, `wdth 79`, 176 design px, line height `.86`, tracking
/// `-.045em`. It is the largest element on the page and fills the lower-left
/// quadrant the device used to occupy (anchor `.036, .172`, width `.396`).
///
/// Two details carry the design:
///
///   * Lines 1 and 2 glow — `0 0 80px rgba(150,180,220,.28–.32)`. Rendered as
///     a `Text.shadows` blur, scaled through [PosterMetrics] so it tracks the
///     type size.
///   * Line 4 ("ROAD") is a `#1A2130` base with a brighter `#BCD3F0` copy laid
///     over it and cut on a hard diagonal. The cut climbs to the right at 40°
///     — the first-quadrant diagonal — and passes through the centre of the
///     "O". A `ShaderMask` draws it: a two-colour gradient along the line's
///     normal with both stops at the same position, so the edge is a crisp
///     cut rather than a fade.
class PosterWordmark extends StatelessWidget {
  const PosterWordmark({super.key});

  /// The `#BCD3F0` glow lines carry a 80 design-px blur at full scale.
  static const double _glowBlurDesignPx = 80;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final double f = metrics.f;

    // Base display style — 176 design px through the fluid factor, so every
    // metric below (line height, tracking) rides on the same size.
    final TextStyle base = PosterType.wordmark(f);

    // The soft blue glow on lines 1–2. `.28–.32` in the source; a single .30
    // reads the same at this blur radius.
    final List<Shadow> lineGlow = <Shadow>[
      Shadow(
        color: const Color(0x4D96B4DC), // rgba(150,180,220,.30)
        blurRadius: metrics.px(_glowBlurDesignPx),
      ),
    ];

    return SizedBox(
      width: metrics.px(760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'PLATE',
            style: base.copyWith(
              color: PosterColors.inkDisplay1,
              shadows: lineGlow,
            ),
          ),
          Text(
            'INPUT',
            style: base.copyWith(
              color: PosterColors.inkDisplay2,
              shadows: lineGlow,
            ),
          ),
          Text(
            'FOR THE',
            style: base.copyWith(color: PosterColors.inkDisplay3),
          ),
          _RoadLine(base: base),
        ],
      ),
    );
  }
}

/// The fourth wordmark line: a dark `#1A2130` base with a brighter
/// `#BCD3F0` copy diagonally cut across it.
class _RoadLine extends StatelessWidget {
  const _RoadLine({required this.base});

  final TextStyle base;

  @override
  Widget build(BuildContext context) {
    final Text dark = Text(
      'ROAD',
      style: base.copyWith(color: PosterColors.inkDisplay1),
    );
    final Text cut = Text(
      'ROAD',
      style: base.copyWith(color: PosterColors.inkDisplayCut),
    );

    return Stack(
      children: <Widget>[
        dark,
        // The bright copy, masked to the diagonal.
        Positioned.fill(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: _cutShader,
            child: cut,
          ),
        ),
      ],
    );
  }
}

/// The cut runs at [_cutAngleDeg] measured the Cartesian way — counter-
/// clockwise from the +x axis, y pointing up — so it climbs to the right.
const double _cutAngleDeg = 40;

/// Where the cut crosses, as a fraction of the "ROAD" box: the centre of the
/// "O". The glyph advances put the O between .235 and .496 of the width, and
/// its ink is centred a little above the box mid-line.
const Offset _cutPivotFraction = Offset(0.365, 0.385);

/// A hard-edged mask for the bright copy: opaque up-left of the cut line,
/// transparent down-right of it.
Shader _cutShader(Rect bounds) {
  // The gradient axis is the *normal* of the cut line, so the hard stop at
  // its midpoint lays the edge down at exactly [_cutAngleDeg]. In screen
  // space (y down) the line direction is (cos θ, −sin θ); its normal, aimed
  // down-right into the transparent side, is (sin θ, cos θ).
  final double rad = _cutAngleDeg * math.pi / 180.0;
  final Offset normal = Offset(math.sin(rad), math.cos(rad));
  final Offset pivot = Offset(
    bounds.width * _cutPivotFraction.dx,
    bounds.height * _cutPivotFraction.dy,
  );
  // Any span that covers the box works; the edge sits at the midpoint.
  final double reach = bounds.longestSide;
  return ui.Gradient.linear(
    pivot - normal * reach,
    pivot + normal * reach,
    const <Color>[
      Color(0xFFFFFFFF), // opaque — the bright copy shows
      Color(0xFFFFFFFF),
      Color(0x00FFFFFF), // transparent — the dark base shows
    ],
    const <double>[0.0, 0.5, 0.5],
  );
}
