import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'poster_tokens.dart';

/// Ambient backdrop painted behind the plate on the device glass: the poster's
/// own ground gradient plus soft orbs tinted with the poster accent
/// ([PosterColors.accent]) and its steel / slate card tones, so the glass reads
/// as part of the same palette as the rest of the layout.
///
/// Every orb is positioned as a fraction of the glass, so a device morph moves
/// and resizes all of them. That relayout is animated on a single timeline:
/// fade out first, travel while invisible, fade back in on arrival — the orbs
/// are never seen sliding across the plate.
///
/// On top of the relayout, every orb also drifts continuously at a very slow
/// velocity in a random direction, gently bouncing inside a small box around its
/// home position. The random headings are rolled per [_OrbLayer] instance, so
/// each device carries its own independent drift.
///
/// Pure decoration — ignores pointer events.
class PlateBackdrop extends StatelessWidget {
  const PlateBackdrop({super.key, this.duration = const Duration(milliseconds: 900)});

  /// Full fade-out / travel / fade-in cycle. Runs whenever the glass resizes.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    // The orbs repaint continuously (the drift ticker never stops), so they get
    // their own retained layer. Without this boundary every drift frame marks
    // the whole glass — plate, keypad, live text fields — dirty and forces the
    // device's entire subtree to re-rasterise at 60/120Hz, for the lifetime of
    // the app.
    return RepaintBoundary(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0B0E), Color(0xFF121620), Color(0xFF050608)],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => _OrbLayer(size: constraints.biggest, duration: duration),
          ),
        ),
      ),
    );
  }
}

/// Owns the relayout timeline. [size] changing is the trigger.
class _OrbLayer extends StatefulWidget {
  const _OrbLayer({required this.size, required this.duration});

  final Size size;
  final Duration duration;

  @override
  State<_OrbLayer> createState() => _OrbLayerState();
}

class _OrbLayerState extends State<_OrbLayer> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);

  /// Free-running clock for the slow continuous drift, independent of the
  /// relayout timeline on [_controller].
  late final Ticker _drifter = createTicker(_onDrift);

  /// Home-relative offset of each orb, in fractions of the glass, integrated
  /// from [_velocity] and bounced inside [_kDriftBox].
  ///
  /// A [ValueNotifier] rather than widget state on purpose: the painter listens
  /// to it directly, so a drift step repaints the orb layer without rebuilding
  /// a single widget. The old `setState` per tick rebuilt this subtree 60 times
  /// a second, forever.
  final ValueNotifier<List<Offset>> _drift = ValueNotifier<List<Offset>>(
    List<Offset>.filled(_OrbPainter._orbs.length, Offset.zero),
  );

  /// Per-orb velocity, fraction of the glass per second. Random heading, very
  /// small magnitude — a full crossing of the drift box takes tens of seconds.
  late final List<Offset> _velocity = _rollVelocities();

  /// Half-extent of the box each orb drifts within, as a fraction of the glass.
  static const double _kDriftBox = 0.06;

  Duration _lastTick = Duration.zero;

  /// Minimum wall time between drift integrations. The orbs move 0.004–0.011 of
  /// the glass per second — a full crossing of the drift box takes tens of
  /// seconds — so stepping them 20 times a second is indistinguishable from
  /// stepping them every frame, and costs a third as many repaints of a layer
  /// full of screen-blended gradients.
  static const Duration _kDriftStep = Duration(milliseconds: 50);

  static List<Offset> _rollVelocities() {
    final rng = math.Random();
    return List<Offset>.generate(_OrbPainter._orbs.length, (_) {
      final angle = rng.nextDouble() * 2 * math.pi;
      // 0.004–0.011 of the glass per second: barely perceptible.
      final speed = 0.004 + rng.nextDouble() * 0.007;
      return Offset(math.cos(angle) * speed, math.sin(angle) * speed);
    });
  }

  void _onDrift(Duration elapsed) {
    // Only integrate on the throttle boundary; every other tick returns before
    // touching the notifier, so no repaint is scheduled at all.
    if (elapsed - _lastTick < _kDriftStep) return;
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (dt <= 0 || dt > 0.5) return; // skip first tick and long stalls
    final current = _drift.value;
    final next = List<Offset>.filled(current.length, Offset.zero);
    for (var i = 0; i < current.length; i++) {
      var p = current[i] + _velocity[i] * dt;
      var vx = _velocity[i].dx;
      var vy = _velocity[i].dy;
      if (p.dx.abs() > _kDriftBox) {
        vx = -vx;
        p = Offset(p.dx.clamp(-_kDriftBox, _kDriftBox), p.dy);
      }
      if (p.dy.abs() > _kDriftBox) {
        vy = -vy;
        p = Offset(p.dx, p.dy.clamp(-_kDriftBox, _kDriftBox));
      }
      _velocity[i] = Offset(vx, vy);
      next[i] = p;
    }
    _drift.value = next;
  }

  /// 0 -> 1 across the middle of the cycle: where the orbs are, between the
  /// layout they left and the layout they are heading for.
  late final Animation<double> _travel = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.12, 0.82, curve: Curves.easeInOutCubic),
  );

  /// Down, held at zero for the whole journey, then back up.
  late final Animation<double> _opacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 26),
    TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 44),
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
  ]).animate(_controller);

  /// The layout the orbs are travelling away from.
  late Size _from = widget.size;

  @override
  void initState() {
    super.initState();
    // First frame is already settled at the target layout, fully visible.
    _controller.value = 1.0;
    _drifter.start();
  }

  @override
  void didUpdateWidget(covariant _OrbLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.size == oldWidget.size) return;
    // Snapshot where the orbs actually are right now, so a resize that lands
    // mid-flight departs from the visible layout rather than snapping back.
    _from = Size.lerp(_from, oldWidget.size, _travel.value) ?? oldWidget.size;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _drifter.dispose();
    _controller.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No AnimatedBuilder: the painter subscribes to the relayout animations and
    // the drift notifier itself via CustomPainter's `repaint`, so an animating
    // frame repaints without rebuilding any widget. build() now runs only when
    // the glass actually resizes.
    return CustomPaint(
      painter: _OrbPainter(from: _from, to: widget.size, travel: _travel, opacity: _opacity, drift: _drift),
      size: Size.infinite,
      child: const SizedBox.expand(),
    );
  }
}

@immutable
class _Orb {
  const _Orb(this.dx, this.dy, this.r, this.color, this.alpha, {this.core = 0.0});

  /// Centre, as a fraction of width / height.
  final double dx;
  final double dy;

  /// Radius, as a fraction of the shortest side.
  final double r;
  final Color color;

  /// Peak alpha at the centre.
  final double alpha;

  /// 0 = pure halo. > 0 = a solid ball of this fraction of [r] inside the halo.
  final double core;

  Offset centreIn(Size size) => Offset(size.width * dx, size.height * dy);
  double radiusIn(Size size) => size.shortestSide * r;
}

class _OrbPainter extends CustomPainter {
  _OrbPainter({required this.from, required this.to, required this.travel, required this.opacity, required this.drift})
    : super(repaint: Listenable.merge(<Listenable>[travel, opacity, drift]));

  /// Layout being left behind and layout being flown to. Plain values: they
  /// change only when the glass resizes, which rebuilds this painter anyway.
  final Size from;
  final Size to;

  /// Progress between [from] and [to], and the group opacity. Read at paint
  /// time rather than captured, so a tick repaints without a rebuild.
  final Animation<double> travel;
  final Animation<double> opacity;

  /// Per-orb home-relative drift, in fractions of the glass. Same length and
  /// order as [_orbs].
  final ValueListenable<List<Offset>> drift;

  // Large haloes first, then the small bright balls on top. Tints pulled from
  // the callout card color scheme to maintain visual consistency.
  static const List<_Orb> _orbs = [
    _Orb(0.14, 0.18, 0.44, Color(0xFF232C42), 0.24),
    _Orb(0.83, 0.12, 0.34, Color(0xFF3160B0), 0.20),
    _Orb(0.68, 0.74, 0.50, Color(0xFF20293C), 0.30),
    _Orb(0.28, 0.88, 0.38, Color(0xFF1B2B3C), 0.34),
    _Orb(0.50, 0.46, 0.62, Color(0xFF243040), 0.20),
    _Orb(0.22, 0.62, 0.075, Color(0xFF3C5C97), 0.50, core: 0.60),
    _Orb(0.88, 0.46, 0.052, Color(0xFF26262B), 0.42, core: 0.58),
    _Orb(0.62, 0.22, 0.036, Color(0xFF3160B0), 0.38, core: 0.55),
    _Orb(0.41, 0.13, 0.024, Color(0xFF232C42), 0.48, core: 0.50),
    _Orb(0.77, 0.91, 0.029, Color(0xFF20293C), 0.34, core: 0.50),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double groupOpacity = opacity.value;
    if (groupOpacity <= 0.004) return;
    final double t = travel.value;
    final List<Offset> drifts = drift.value;

    for (var i = 0; i < _orbs.length; i++) {
      final o = _orbs[i];
      final d = i < drifts.length ? drifts[i] : Offset.zero;
      final base = Offset.lerp(o.centreIn(from), o.centreIn(to), t) ?? o.centreIn(to);
      final centre = base + Offset(d.dx * size.width, d.dy * size.height);
      final radius = lerpDouble(o.radiusIn(from), o.radiusIn(to), t) ?? o.radiusIn(to);
      if (radius <= 0.5) continue;

      final peak = (o.alpha * groupOpacity).clamp(0.0, 1.0);

      // Halo: additive on a dark ground, so it reads as light, not paint.
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = RadialGradient(
            colors: [
              o.color.withValues(alpha: peak),
              o.color.withValues(alpha: peak * 0.42),
              o.color.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.38, 1.0],
          ).createShader(Rect.fromCircle(center: centre, radius: radius)),
      );

      if (o.core <= 0.0) continue;

      // The soft edge these two used to get from MaskFilter.blur is baked into
      // their gradient stops instead. A mask filter is an offscreen blur pass
      // per draw, and there are six of them per frame on a layer that repaints
      // continuously — by far the most expensive thing painted on the glass,
      // for a difference you cannot see behind a plate.
      final coreR = radius * o.core;
      final coreGlowR = coreR * 1.9;
      canvas.drawCircle(
        centre,
        coreGlowR,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = RadialGradient(
            colors: [
              o.color.withValues(alpha: (peak * 1.4).clamp(0.0, 1.0)),
              o.color.withValues(alpha: peak * 0.55),
              o.color.withValues(alpha: peak * 0.22),
              o.color.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.34, 0.60, 1.0],
          ).createShader(Rect.fromCircle(center: centre, radius: coreGlowR)),
      );

      // Specular highlight, up and to the left.
      final specCentre = centre.translate(-coreR * 0.32, -coreR * 0.32);
      final specR = coreR * 0.78;
      canvas.drawCircle(
        specCentre,
        specR,
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.20 * groupOpacity),
              Colors.white.withValues(alpha: 0.06 * groupOpacity),
              Colors.white.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.45, 1.0],
          ).createShader(Rect.fromCircle(center: specCentre, radius: specR)),
      );
    }
  }

  /// Only the geometry lives on the painter now — [travel], [opacity] and
  /// [drift] drive repaints through `super.repaint`, so they are deliberately
  /// not compared here.
  @override
  bool shouldRepaint(covariant _OrbPainter old) =>
      old.from != from ||
      old.to != to ||
      !identical(old.travel, travel) ||
      !identical(old.opacity, opacity) ||
      !identical(old.drift, drift);
}
