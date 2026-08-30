import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plate_number/plate_number.dart';

import '../device_preview/content_dissolve.dart';
import '../device_preview/device_config.dart';

/// Paint the tiles in magenta instead of the plate face.
///
/// A live-or-not switch, not a style: flip it, restart (not hot reload — this
/// subsystem adds fields to [DeviceFrame]'s State), and watch the phone→tablet
/// hop. Magenta squares mean the whole chain is wired and only the look needs
/// tuning; nothing means the effect is not running at all.
const bool kDebugTileDissolve = false;

/// Breaks the plate's input boxes into a grid of equal tiles and runs each tile
/// to opacity 0 (leaving) or 1 (arriving) at its own random speed.
///
/// The geometry is read straight off [PlateSpec.slots], which are in the plate's
/// own canvas coordinates; this overlay reproduces [PlateCanvas]'s
/// `FittedBox(fit: contain)` mapping so the tiles land pixel-on-pixel over the
/// real boxes without either side knowing about the other. It must therefore be
/// stacked over the plate at exactly the plate's own bounds — see
/// `PlateDisplay`, which does that with `StackFit.passthrough`.
///
/// The "fade" is painted, not composited: each tile gets [coverColor] — the
/// plate face the boxes sit on — at rising alpha, so a fully covered tile reads
/// as a box that has faded to nothing. That keeps the whole effect to one
/// CustomPaint over a flat background instead of a saveLayer per box, and it is
/// the same trick `PixelDissolve` uses for the laptop deck.
///
/// Painting the face colour alone, though, makes an INVISIBLE effect: the boxes
/// are white on a white plate, so a tile covering one has no edges and all you
/// see is the glyph eroding — under a page that is fading anyway, that reads as
/// an ordinary cross-fade. So a tile is tinted while it is in transit and
/// settles to the pure face colour as it lands: mid-flight tiles are visible
/// squares, finished ones are gone. [tileTint] and [tintPeak] control that.
class SlotTileDissolve extends StatelessWidget {
  const SlotTileDissolve({
    super.key,
    required this.spec,
    required this.dissolve,
    required this.coverColor,
    this.tileTint = const Color(0xFF8F98A6),
    this.tintPeak = 0.85,
  });

  final PlateSpec spec;
  final ValueListenable<ContentDissolve> dissolve;

  /// The colour behind the boxes — the plate face. Where a tile ends up.
  final Color coverColor;

  /// What a tile is tinted toward while it is in transit, so the grid reads as
  /// a grid on a flat white plate. Set equal to [coverColor] for the untinted
  /// (and, on this plate, near-invisible) version.
  final Color tileTint;

  /// How far toward [tileTint] a tile leans at the midpoint of its own transit.
  /// 0 disables the tint entirely.
  final double tintPeak;

  /// Which hops dissolve their outgoing boxes away tile by tile.
  static bool tiledExit(DeviceType from, DeviceType to) =>
      (from == DeviceType.mobile && to == DeviceType.tablet) ||
      (from == DeviceType.tablet && to == DeviceType.desktop);

  /// Which hops bring their incoming boxes in tile by tile.
  static bool tiledEntrance(DeviceType from, DeviceType to) =>
      from == DeviceType.tablet && to == DeviceType.desktop;

  /// The share of the frame's fade-out the tile action occupies — its 't'.
  ///
  /// Not the whole window: the frame's own opacity is falling underneath, and a
  /// tile that only finishes at the very end of it does so against content
  /// already faded to near-black, where nobody can see it. Ending at 0.55 puts
  /// the last tile out while the plate is still about three-quarters present.
  static const double _exitWindow = 0.55;

  /// Same idea for the entrance, mirrored: the boxes have finished arriving a
  /// little before the page itself has finished fading up.
  static const double _entranceWindow = 0.7;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ContentDissolve>(
      valueListenable: dissolve,
      builder: (context, d, _) {
        if (!d.isHop) return const SizedBox.shrink();
        final appearing = d.appearing;
        final enabled = appearing
            ? tiledEntrance(d.from, d.to)
            : tiledExit(d.from, d.to);
        if (!enabled) return const SizedBox.shrink();

        final window = appearing ? _entranceWindow : _exitWindow;
        final p = (d.progress / window).clamp(0.0, 1.0);
        // Nothing to draw at either end: no tile has started leaving yet, or
        // every tile has finished arriving.
        if (!appearing && p <= 0) return const SizedBox.shrink();
        if (appearing && p >= 1) return const SizedBox.shrink();

        return IgnorePointer(
          child: CustomPaint(
            painter: _SlotTilePainter(
              spec: spec,
              progress: p,
              appearing: appearing,
              cover: kDebugTileDissolve ? const Color(0xFFFF00A8) : coverColor,
              tint: kDebugTileDissolve ? const Color(0xFFFF00A8) : tileTint,
              tintPeak: kDebugTileDissolve ? 0.0 : tintPeak,
              seed: d.transitionId,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _SlotTilePainter extends CustomPainter {
  const _SlotTilePainter({
    required this.spec,
    required this.progress,
    required this.appearing,
    required this.cover,
    required this.tint,
    required this.tintPeak,
    required this.seed,
  });

  final PlateSpec spec;

  /// 0 → 1 across the tile action's own window.
  final double progress;
  final bool appearing;
  final Color cover;
  final Color tint;
  final double tintPeak;
  final int seed;

  /// Tile rows per box. Columns are derived from this so tiles come out roughly
  /// square, which is what makes the grid read as a grid.
  static const int _rows = 4;

  /// Earliest point in the window at which a tile may finish. Every tile lands
  /// somewhere in [_earliest, 1] — i.e. between t/2 and t.
  static const double _earliest = 0.5;

  /// How finely a tile's own transit is quantised. Tiles at the same step share
  /// one colour, so they accumulate into a single [Path] and cost one draw —
  /// which also means overlapping their edges to close seams cannot
  /// double-blend.
  static const int _steps = 20;

  /// Grown slightly past the declared slot box so a glyph's overshoot and the
  /// field's underline are inside the tiles, in canvas units.
  static const double _bleed = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final cw = spec.canvasWidth;
    final ch = spec.canvasHeight;
    if (cw <= 0 || ch <= 0) return;

    // Mirror of the plate's own FittedBox(contain) + centre alignment.
    final scale = math.min(size.width / cw, size.height / ch);
    final dx = (size.width - cw * scale) / 2;
    final dy = (size.height - ch * scale) / 2;

    // Indexed by how far through its own transit a tile is, 0.._steps.
    final List<Path?> stepPaths = List<Path?>.filled(_steps + 1, null);

    for (var s = 0; s < spec.slots.length; s++) {
      final slot = spec.slots[s];
      final left = dx + (slot.box.left - _bleed) * scale;
      final top = dy + (slot.box.top - _bleed) * scale;
      final w = (slot.box.width + _bleed * 2) * scale;
      final h = (slot.box.height + _bleed * 2) * scale;
      if (w <= 0 || h <= 0) continue;

      // Square-ish tiles: the row height sets the target, columns follow the
      // box's aspect. Equal tiles within a box, vertical and horizontal edges.
      final cols = math.max(2, math.min(12, (w / (h / _rows)).round()));
      final tw = w / cols;
      final th = h / _rows;

      for (var r = 0; r < _rows; r++) {
        for (var c = 0; c < cols; c++) {
          // The tile's own finish line, uniform in [t/2, t]. Its speed is
          // 1/finish, so this IS the random velocity — a tile that finishes at
          // t/2 travels twice as fast as one that finishes at t.
          final finish = _earliest +
              (1 - _earliest) *
                  _rand(s * 733 + r * 92821 + c * 68917 + seed * 15485863);
          final travelled = (progress / finish).clamp(0.0, 1.0);
          final step = (travelled * _steps).round();
          // +1 closes the seam with the neighbouring tile; safe because tiles
          // at one step are filled as a single path.
          (stepPaths[step] ??= Path()).addRect(
            Rect.fromLTWH(left + c * tw, top + r * th, tw + 1, th + 1),
          );
        }
      }
    }

    final paint = Paint()..isAntiAlias = false;
    for (var i = 0; i <= _steps; i++) {
      final path = stepPaths[i];
      if (path == null) continue;
      final t = i / _steps;
      // Leaving: cover rises 0 → 1. Arriving: it retreats 1 → 0.
      final alpha = appearing ? 1 - t : t;
      if (alpha <= 0.004) continue;
      // Peaks at the midpoint of the transit and is zero at both ends, so a
      // tile that has landed is exactly the face colour and leaves no trace.
      final bump = math.sin(math.pi * t) * tintPeak;
      final color = bump <= 0.001 ? cover : Color.lerp(cover, tint, bump)!;
      paint.color = color.withValues(alpha: alpha);
      canvas.drawPath(path, paint);
    }
  }

  /// Cheap deterministic hash → [0, 1).
  double _rand(int n) {
    var x = n & 0x7fffffff;
    x = (x ^ (x >> 13)) * 1274126177;
    x &= 0x7fffffff;
    return (x % 100000) / 100000.0;
  }

  @override
  bool shouldRepaint(_SlotTilePainter old) =>
      old.progress != progress ||
      old.appearing != appearing ||
      old.seed != seed ||
      old.cover != cover ||
      old.tint != tint ||
      old.tintPeak != tintPeak ||
      !identical(old.spec, spec);
}
