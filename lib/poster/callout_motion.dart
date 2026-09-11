import 'dart:math' as math;
import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  static const int rows = 7;

  /// The earliest point in the window at which a tile may finish. Every tile
  /// lands somewhere in [earliest, 1] — i.e. between t/2 and t, so the last
  /// tile goes exactly as the window closes.
  static const double earliest = 0.5;

  @override
  State<TileTransition> createState() => _TileTransitionState();
}

class _TileTransitionState extends State<TileTransition> {
  final SnapshotController _snapshot = SnapshotController(allowSnapshotting: true);
  late _TilePainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = _buildPainter();
  }

  _TilePainter _buildPainter() =>
      _TilePainter(animation: widget.animation, entering: widget.entering, seed: widget.seed);

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
    return SnapshotWidget(controller: _snapshot, painter: _painter, child: widget.child);
  }
}

class _TilePainter extends SnapshotPainter {
  _TilePainter({required this.animation, required this.entering, required this.seed}) {
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
    final double finish =
        TileTransition.earliest + (1 - TileTransition.earliest) * _rand(row * 92821 + col * 68917 + seed * 15485863);
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
    final int cols = math.max(2, math.min(20, (size.width / tileH).round()));
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
          Rect.fromLTRB(offset.dx + left, offset.dy + top, offset.dx + right, offset.dy + bottom),
          paint,
        );
      }
    }
  }

  /// The fallback path, used when the platform cannot snapshot the child (a
  /// platform view in the subtree, or a renderer without support). Paints the
  /// card plainly rather than not at all.
  @override
  void paint(PaintingContext context, Offset offset, Size size, PaintingContextCallback painter) {
    painter(context, offset);
  }

  @override
  bool shouldRepaint(covariant _TilePainter oldDelegate) =>
      oldDelegate.animation != animation || oldDelegate.entering != entering || oldDelegate.seed != seed;

  /// Cheap deterministic hash → [0, 1).
  double _rand(int n) {
    var x = n & 0x7fffffff;
    x = (x ^ (x >> 13)) * 1274126177;
    x &= 0x7fffffff;
    return (x % 100000) / 100000.0;
  }
}
