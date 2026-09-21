import 'package:flutter/material.dart';

import '../poster_scale.dart';
import '../poster_tokens.dart';
import 'poster_backdrop.dart';

/// The rake that travels down the road once per device hop — the one piece of
/// the backdrop the design has no equivalent for, kept because the hop needs
/// something to happen behind it.
///
/// A soft band plus a brighter leading edge, both living inside
/// [showcasePanelRect] and travelling along it over 1.5s
/// `cubic-bezier(.42,.02,.6,1)`, screen-blended, with opacity ramping in and
/// out over `.34s` linear.
///
/// sk10 dropped its amplitude. The old rake was a near-white streak across a
/// lit road; the design's road is a near-black panel with an `n800`/`n700`
/// wash over it, so the band is now that wash in motion — see the `sweep*`
/// tokens. It is also clipped to the panel: off the band the ground is flat
/// near-black, and a headlight crossing it is exactly the poster look this
/// migration is removing.
///
/// It owns no state machine. Derive [isHopping] from
/// `DeviceFrame.onPhaseChanged`: pass `phase == frameTransform`, so the rake
/// starts on the exact frame the device's content opacity reaches zero rather
/// than back when it only began fading. The sweep fires once on the false→true
/// edge and runs its full 1.5s on its own controller, so it outlives the
/// shorter phase window that triggered it.
class SweepLight extends StatefulWidget {
  const SweepLight({super.key, required this.isHopping});

  /// True for any `DeviceTransitionPhase` other than `idle`.
  final bool isHopping;

  @override
  State<SweepLight> createState() => _SweepLightState();
}

class _SweepLightState extends State<SweepLight> with SingleTickerProviderStateMixin {
  static const Duration _travel = Duration(milliseconds: 1500);

  /// `cubic-bezier(.42,.02,.6,1)`.
  static const Curve _travelCurve = Cubic(0.42, 0.02, 0.60, 1.0);

  /// `.34s` of the 1.5s travel, at each end.
  static const double _fade = 340 / 1500;

  late final AnimationController _controller = AnimationController(vsync: this, duration: _travel);

  @override
  void initState() {
    super.initState();
    if (widget.isHopping) _fire();
  }

  @override
  void didUpdateWidget(SweepLight oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only the rising edge fires. While isHopping stays true the sweep runs
    // its 1.5s once and then sits at rest.
    if (widget.isHopping && !oldWidget.isHopping) _fire();
  }

  void _fire() => _controller.forward(from: 0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    return IgnorePointer(
      child: SizedBox(
        width: metrics.size.width,
        height: metrics.size.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double t = _controller.value;
            if (t == 0 || t == 1) return const SizedBox.expand();
            return CustomPaint(
              painter: _SweepPainter(travel: _travelCurve.transform(t), opacity: _opacityAt(t)),
            );
          },
        ),
      ),
    );
  }

  /// Opacity is its own `.34s linear` ramp, independent of the travel curve.
  double _opacityAt(double t) {
    if (t < _fade) return t / _fade;
    if (t > 1 - _fade) return (1 - t) / _fade;
    return 1;
  }
}

class _SweepPainter extends CustomPainter {
  const _SweepPainter({required this.travel, required this.opacity});

  /// Eased 0→1 along the panel, from fully off its left end to fully off its
  /// right one.
  final double travel;
  final double opacity;

  /// The band's width, as a fraction of the panel's. The old rake was 400
  /// design px on a 1920 canvas, which is this much of the panel the design
  /// draws in its place.
  static const double _bandWidth = 0.16;

  /// The bright leading edge, in logical px — a line, so it does not scale.
  static const double _edgeWidth = 5;

  /// Half-width of the band that replaces the edge glow's `MaskFilter.blur`,
  /// as a fraction of the band: 3.3σ of the original 18px blur, past which the
  /// profile below is under 1/500 and invisible.
  static const double _glowHalfWidth = 0.15;

  /// The original glow was a 17px-wide rect under `MaskFilter.blur(normal, 18)`
  /// — a gaussian blur re-run on every one of the rake's ~90 frames, inside a
  /// full-band `saveLayer` that was itself allocated per frame. Both are gone:
  /// the blur of a box is an analytic profile,
  ///
  ///     a(x) = ½·(erf((x−390)/σ√2) − erf((x−407)/σ√2)),   σ = 18
  ///
  /// sampled here at 13 even stops across [_glowHalfWidth] either side of the
  /// edge's centre and handed to a `LinearGradient` instead. Same picture, no
  /// offscreen and no per-frame blur. It is a shape rather than a size, so it
  /// survived the move off the 1920×1080 canvas unchanged.
  ///
  /// The `saveLayer` went with it because `screen` is associative: screening
  /// the three draws onto the road one at a time gives the same result as
  /// screening their composite, so the layer was only ever paying for a uniform
  /// opacity that each draw can apply to its own colours.
  static const List<double> _glowStops = <double>[
    0.0000, 0.0833, 0.1667, 0.2500, 0.3333, 0.4167, 0.5000,
    0.5833, 0.6667, 0.7500, 0.8333, 0.9167, 1.0000, //
  ];

  static const List<double> _glowProfile = <double>[
    0.0020, 0.0100, 0.0365, 0.0999, 0.2048, 0.3148, 0.3632,
    0.3148, 0.2048, 0.0999, 0.0365, 0.0100, 0.0020, //
  ];

  static Color _scaled(Color c, double o) => c.withValues(alpha: c.a * o);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || opacity <= 0) return;

    final Rect panel = showcasePanelRect(size);
    if (panel.isEmpty) return;

    canvas.save();
    // The panel's own rotated frame, the same one PosterBackdrop draws the
    // road in, so the rake travels along the band rather than across it — and
    // so the band is axis-aligned here, which makes the clip below a rect
    // rather than a path.
    roadFrame(canvas, size);
    canvas.clipRect(panel);

    final double bandWidth = panel.width * _bandWidth;
    final double from = panel.left - bandWidth;
    final double x = from + (panel.right - from) * travel;
    final Rect band = Rect.fromLTWH(x, panel.top, bandWidth, panel.height);

    // Every draw carries the rake's own opacity and screen-blends straight onto
    // the road — see [_glowStops] for why there is no enclosing saveLayer.
    final double o = opacity.clamp(0.0, 1.0);

    // The body: a soft gradient across the band's width, brightest at the
    // leading edge.
    canvas.drawRect(
      band,
      Paint()
        ..blendMode = BlendMode.screen
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            _scaled(PosterColors.sweepBodyStart, o),
            _scaled(PosterColors.sweepBodyMid, o),
            _scaled(PosterColors.sweepBodyEnd, o),
          ],
          stops: const <double>[0.0, 0.62, 1.0],
        ).createShader(band),
    );

    // Its glow first, then the hard edge over it.
    final double glowHalf = bandWidth * _glowHalfWidth;
    final Rect glow = Rect.fromLTRB(band.right - glowHalf, band.top, band.right + glowHalf, band.bottom);
    final double glowAlpha = PosterColors.sweepEdgeGlow.a * o;
    canvas.drawRect(
      glow,
      Paint()
        ..blendMode = BlendMode.screen
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            for (final double p in _glowProfile) PosterColors.sweepEdgeGlow.withValues(alpha: glowAlpha * p),
          ],
          stops: _glowStops,
        ).createShader(glow),
    );

    // The bright edge on the band's leading side, brightest at its middle.
    final Rect edge = Rect.fromLTWH(band.right - _edgeWidth, band.top, _edgeWidth, band.height);
    canvas.drawRect(
      edge,
      Paint()
        ..blendMode = BlendMode.screen
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            _scaled(PosterColors.sweepEdgeStart, o),
            _scaled(PosterColors.sweepEdgeMid, o),
            _scaled(PosterColors.sweepEdgeEnd, o),
          ],
          stops: const <double>[0.0, 0.5, 1.0],
        ).createShader(edge),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SweepPainter oldDelegate) {
    return oldDelegate.travel != travel || oldDelegate.opacity != opacity;
  }
}
