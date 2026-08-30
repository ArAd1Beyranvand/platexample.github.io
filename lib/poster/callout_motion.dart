import 'dart:math' as math;
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'poster_tokens.dart'; // PosterTokens.accent

/// Which side of the device a callout sits on.
///
/// TODO(P8): annotation_callout.dart, the previous owner of this enum, was
/// removed in the poster demolition; this is a temporary local stand-in
/// until P8 rebuilds the callout content model.
enum CalloutSide { left, right }

/// How a set of callouts leaves and the next set arrives.
enum CalloutMotif {
  /// SWEEP. Exit: slides horizontally off its own side of the screen.
  /// Entry: slides in horizontally from that same side and settles.
  sweep,

  /// TRAPDOOR. Exit: a slot opens beneath the callout and it falls through,
  /// fading. Entry: a slot opens above its resting place and it drops out of it.
  trapdoor,

  /// SIPHON. Exit: the callout collapses along its connector toward the dot,
  /// shrinking to a point on the line. Entry: it is emitted back out of the dot
  /// and expands into place.
  siphon,

  /// TILES. The card is cut into an equal grid — straight vertical and
  /// horizontal edges — and every tile runs its own opacity at its own random
  /// speed. Exit: all tiles start together at 1 and each reaches 0 somewhere
  /// between t/2 and t. Entry: the same in reverse, tiles arriving at 1.
  ///
  /// No movement, no scale, no overshoot: the card does not go anywhere, it
  /// comes apart where it stands.
  tiles,
}

/// SWEEP — Transform.translate on X, plus independent group opacity.
class SweepTransition extends StatelessWidget {
  const SweepTransition({
    super.key,
    required this.animation,
    required this.entering,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final bool entering;
  final CalloutSide side;
  final Widget child;

  /// Distance to travel off the poster rail.
  static const double _distance = 520;
  static const Curve _enterCurve = Cubic(0.215, 0.61, 0.355, 1);
  static const Curve _exitCurve = Cubic(0.55, 0.055, 0.675, 0.19);

  @override
  Widget build(BuildContext context) {
    final double sign = side == CalloutSide.left ? -1 : 1;
    return AnimatedBuilder(
      animation: animation,
      // Retained on purpose: the card underneath is a bevel panel with dashed
      // rules, gradients and shadows, and [Opacity] below re-rasterises its
      // child every frame unless the child owns a layer. With the boundary the
      // fade is a composite-time operation on a cached texture instead.
      child: RepaintBoundary(child: child),
      builder: (context, child) {
        final double t = animation.value;
        final double eased = (entering ? _enterCurve : _exitCurve).transform(t);
        final double dx = entering
            ? sign * _distance * (1 - eased)
            : sign * _distance * eased;
        final double opacity = entering ? t : 1 - t;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}

/// TRAPDOOR — a slot that opens, and the text falling through it.
class TrapdoorTransition extends StatelessWidget {
  const TrapdoorTransition({
    super.key,
    required this.animation,
    required this.entering,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final bool entering;
  final CalloutSide side;
  final Widget child;

  static const Curve _enterCurve = Cubic(0.25, 0.46, 0.45, 0.94);
  static const Curve _exitCurve = Cubic(0.55, 0.085, 0.68, 0.53);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      // See SweepTransition — the boundary keeps the Opacity below a composite
      // rather than a full repaint of the card.
      child: RepaintBoundary(child: child),
      builder: (context, child) {
        final double t = animation.value;
        final double eased = (entering ? _enterCurve : _exitCurve).transform(t);
        final double slotFactor = entering ? t : 1 - t;
        final double dy = entering ? -90 * (1 - eased) : 90 * eased;
        final double opacity = entering ? t : 1 - t;

        // Entry aligns the slot to the TOP; exit to the BOTTOM.
        final Alignment slotAlign = entering
            ? Alignment.topCenter
            : Alignment.bottomCenter;

        return ClipRect(
          child: Stack(
            children: [
              Align(
                alignment: slotAlign,
                child: _TrapdoorSlot(widthFactor: slotFactor),
              ),
              Transform.translate(
                offset: Offset(0, dy),
                child: Opacity(opacity: opacity, child: child),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// The horizontal bar the trapdoor child falls through.
class _TrapdoorSlot extends StatelessWidget {
  const _TrapdoorSlot({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor.clamp(0.0, 1.0),
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: PosterTokens.accent.withValues(alpha: 0.55),
          boxShadow: const [
            BoxShadow(color: PosterTokens.accent, blurRadius: 12),
          ],
        ),
      ),
    );
  }
}

/// SIPHON — Transform composing scale and translate toward the connector dot.
class SiphonTransition extends StatelessWidget {
  const SiphonTransition({
    super.key,
    required this.animation,
    required this.entering,
    required this.side,
    required this.child,
  });

  final Animation<double> animation;
  final bool entering;
  final CalloutSide side;
  final Widget child;

  static const Curve _enterCurve = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve _exitCurve = Cubic(0.36, 0, 0.66, -0.56);

  @override
  Widget build(BuildContext context) {
    // The dot sits on the device-facing edge: RIGHT for left callouts,
    // LEFT for right callouts.
    final Alignment scaleAlign = side == CalloutSide.left
        ? const Alignment(1, 0.12)
        : const Alignment(-1, 0.12);
    // The X nudge aims toward the dot.
    final double sign = side == CalloutSide.left ? 1 : -1;

    return AnimatedBuilder(
      animation: animation,
      // See SweepTransition — the boundary keeps the Opacity below a composite
      // rather than a full repaint of the card.
      child: RepaintBoundary(child: child),
      builder: (context, child) {
        final double t = animation.value;
        final double eased = (entering ? _enterCurve : _exitCurve).transform(t);
        final double scale = entering ? 0.04 + 0.96 * eased : 1 - 0.96 * eased;
        final double opacity = entering ? t : 1 - t;
        final double dx = entering
            ? (-sign * 18) * (1 - eased)
            : (sign * 18) * eased;

        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.scale(
            scale: scale,
            alignment: scaleAlign,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
    );
  }
}

/// TILES — the card cut into an equal grid, each tile fading on its own clock.
///
/// The card cannot simply be painted into a `saveLayer` and masked per tile:
/// [BevelPanel] wraps its body in a `ColorFiltered` and `card_decorations.dart`
/// uses an `Opacity`, both of which force compositing, so painting the child
/// pushes a layer and ends the enclosing picture recording — leaving the
/// saveLayer unbalanced and its canvas dead. (That failure surfaces as
/// "A Dart object attempted to access a native peer, but the native peer has
/// been collected".)
///
/// So the card is rasterised ONCE into a [ui.Image] by [SnapshotWidget], and
/// the tiles are drawn out of that image with a per-tile alpha. No layer
/// juggling, and it is cheaper than the other three motifs rather than dearer:
/// they re-rasterise a bevel panel behind an `Opacity` every frame, this draws
/// N textured rects.
class TileTransition extends StatefulWidget {
  const TileTransition({
    super.key,
    required this.animation,
    required this.entering,
    required this.child,
    this.seed = 0,
  });

  final Animation<double> animation;
  final bool entering;
  final Widget child;

  /// Varies the per-tile speeds between hops so the same card does not come
  /// apart in exactly the same order every lap of the cycle.
  final int seed;

  /// Tile rows. Columns are derived from the card's own aspect so the tiles
  /// come out roughly square rather than as letterbox slabs.
  static const int rows = 5;

  /// The earliest point in the window at which a tile may finish. Every tile
  /// lands somewhere in [earliest, 1] — i.e. between t/2 and t, so the last
  /// tile goes exactly as the window closes.
  static const double earliest = 0.5;

  @override
  State<TileTransition> createState() => _TileTransitionState();
}

class _TileTransitionState extends State<TileTransition> {
  final SnapshotController _snapshot = SnapshotController(
    allowSnapshotting: true,
  );
  late _TilePainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = _buildPainter();
  }

  _TilePainter _buildPainter() => _TilePainter(
    animation: widget.animation,
    entering: widget.entering,
    seed: widget.seed,
  );

  @override
  void didUpdateWidget(covariant TileTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The layer above rebuilds this widget every frame, so only swap the
    // painter when something it actually reads has changed — notably the
    // halfway flip, where both the animation and [entering] change at once.
    if (oldWidget.animation != widget.animation ||
        oldWidget.entering != widget.entering ||
        oldWidget.seed != widget.seed) {
      _painter.dispose();
      _painter = _buildPainter();
      // [SnapshotWidget] rasterises once and then keeps that image for as long
      // as snapshotting stays on — it does NOT re-snapshot just because the
      // child changed. At the halfway flip the child swaps from the outgoing
      // callout set to the incoming one, so without this the entry phase would
      // fade the OUTGOING card back in. Clearing forces a fresh raster of the
      // new child on the next paint.
      _snapshot.clear();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    _snapshot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotWidget(
      controller: _snapshot,
      painter: _painter,
      child: widget.child,
    );
  }
}

class _TilePainter extends SnapshotPainter {
  _TilePainter({
    required this.animation,
    required this.entering,
    required this.seed,
  }) {
    animation.addListener(notifyListeners);
  }

  final Animation<double> animation;
  final bool entering;
  final int seed;

  @override
  void dispose() {
    animation.removeListener(notifyListeners);
    super.dispose();
  }

  /// Alpha of the tile at [row], [col] right now.
  double _alphaAt(int row, int col) {
    // The tile's own finish line, uniform in [t/2, t]. Its speed is 1/finish,
    // so this IS the random velocity: a tile finishing at t/2 travels twice as
    // fast as one finishing at t.
    final double finish = TileTransition.earliest +
        (1 - TileTransition.earliest) *
            _rand(row * 92821 + col * 68917 + seed * 15485863);
    final double travelled = (animation.value / finish).clamp(0.0, 1.0);
    return entering ? travelled : 1 - travelled;
  }

  @override
  void paintSnapshot(
    PaintingContext context,
    Offset offset,
    Size size,
    ui.Image image,
    Size sourceSize,
    double pixelRatio,
  ) {
    if (size.isEmpty || sourceSize.isEmpty) return;

    const int rows = TileTransition.rows;
    final double tileH = size.height / rows;
    final int cols = math.max(2, math.min(14, (size.width / tileH).round()));
    final double tileW = size.width / cols;

    // Image pixels per logical pixel, so each tile takes its own slice of the
    // snapshot rather than the whole card scaled down.
    final double sx = sourceSize.width / size.width;
    final double sy = sourceSize.height / size.height;

    final Paint paint = Paint()
      ..filterQuality = FilterQuality.low
      ..isAntiAlias = false;
    final Canvas canvas = context.canvas;

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final double alpha = _alphaAt(r, c);
        if (alpha <= 0.004) continue;
        final double left = c * tileW;
        final double top = r * tileH;
        final double right = (c + 1) * tileW;
        final double bottom = (r + 1) * tileH;
        // Edges come from the indices, so neighbouring tiles share an exact
        // boundary: no seam to show through, no overlap to double-blend.
        paint.color = Color.fromRGBO(0, 0, 0, alpha.clamp(0.0, 1.0));
        canvas.drawImageRect(
          image,
          Rect.fromLTRB(left * sx, top * sy, right * sx, bottom * sy),
          Rect.fromLTRB(
            offset.dx + left,
            offset.dy + top,
            offset.dx + right,
            offset.dy + bottom,
          ),
          paint,
        );
      }
    }
  }

  /// The fallback path, used when the platform cannot snapshot the child (a
  /// platform view in the subtree, or a renderer without support). Paints the
  /// card plainly rather than not at all.
  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Size size,
    PaintingContextCallback painter,
  ) {
    painter(context, offset);
  }

  @override
  bool shouldRepaint(covariant _TilePainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.entering != entering ||
      oldDelegate.seed != seed;

  /// Cheap deterministic hash → [0, 1).
  double _rand(int n) {
    var x = n & 0x7fffffff;
    x = (x ^ (x >> 13)) * 1274126177;
    x &= 0x7fffffff;
    return (x % 100000) / 100000.0;
  }
}

/// Dispatcher so callers never switch on [CalloutMotif] themselves.
class CalloutTransition extends StatelessWidget {
  const CalloutTransition({
    super.key,
    required this.motif,
    required this.animation,
    required this.entering,
    required this.side,
    required this.child,
    this.seed = 0,
  });

  final CalloutMotif motif;
  final Animation<double> animation;
  final bool entering;
  final CalloutSide side;
  final Widget child;

  /// Forwarded to [CalloutMotif.tiles]; ignored by the other motifs.
  final int seed;

  @override
  Widget build(BuildContext context) {
    return switch (motif) {
      CalloutMotif.tiles => TileTransition(
        animation: animation,
        entering: entering,
        seed: seed,
        child: child,
      ),
      CalloutMotif.sweep => SweepTransition(
        animation: animation,
        entering: entering,
        side: side,
        child: child,
      ),
      CalloutMotif.trapdoor => TrapdoorTransition(
        animation: animation,
        entering: entering,
        side: side,
        child: child,
      ),
      CalloutMotif.siphon => SiphonTransition(
        animation: animation,
        entering: entering,
        side: side,
        child: child,
      ),
    };
  }
}
