// STABLE — presentation subsystem. Do not refactor for consistency with other
// layers; change only for rendering bugs.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/nocturne.dart';
import 'device_config.dart';

part 'device_painters.hardware.dart';

/// The chassis ramp, so lid, deck and buttons read as one milled body.
///
/// Nocturne's own `n700`–`n900` steps ([N.n700], [N.n800], [N.n900]) with two
/// mixes between them, rather than the old neutral silver: the design's device
/// is a dark indigo-grey slab, and a lighter, bluer ramp was the loudest thing
/// left on the stage. [glass] is the screen-off fill the design states outright.
class _Metal {
  static const highlight = N.n700; // #39414F
  static const light = Color(0xFF2E3648); // n700 → n800
  static const mid = N.n800; // #232C42
  static const shade = Color(0xFF1A2130); // n800 → n900
  static const deep = N.n900; // #0E1219
  static const edge = Color(0xFF000000);
  static const glass = Color(0xFF0D1017);
}

/// Paints the body: drop shadow, milled aluminium lid, side buttons and the
/// black screen well. Canvas size is the body size — the deck is a widget.
class DeviceBodyPainter extends CustomPainter {
  const DeviceBodyPainter({required this.config, this.ambient = 1});

  final DeviceConfig config;
  final double ambient;

  @override
  void paint(Canvas canvas, Size size) {
    final body = Offset.zero & size;
    final bodyRR = RRect.fromRectAndRadius(body, Radius.circular(config.bodyRadius));
    _paintShadow(canvas, bodyRR);
    _paintSideButtons(canvas, body);
    _paintLid(canvas, bodyRR);
    _paintScreenWell(canvas, body);
  }

  /// The device's drop shadow — [NShadow.lg]'s own values (black at 80%, 26px
  /// down, 60px blur). The elevation ramp is built for boxes, and this is the
  /// one surface on the stage heavy enough to earn its top step; everything
  /// else in Nocturne stops at `md`.
  void _paintShadow(Canvas canvas, RRect bodyRR) {
    canvas.drawRRect(
      bodyRR.shift(const Offset(0, 26)),
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: 0.80 * ambient)
        // CSS blurs a shadow over its full radius; a Gaussian sigma of half
        // that is the usual equivalence, and it keeps the falloff from
        // reaching further than the design's does.
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );
  }

  void _paintLid(Canvas canvas, RRect bodyRR) {
    final rect = bodyRR.outerRect;
    canvas.drawRRect(
      bodyRR,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_Metal.highlight, _Metal.light, _Metal.mid, _Metal.light, _Metal.shade, _Metal.deep],
          stops: [0, .16, .38, .58, .82, 1],
        ).createShader(rect),
    );

    canvas.drawRRect(
      bodyRR.deflate(0.75),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // The rim hairline is `--color-divider` (white at 10%), not the old
          // 42% specular white: on a dark chassis that read as a chrome bead
          // running round the lid and was the brightest edge in the hero.
          colors: [
            N.divider,
            N.divider.withValues(alpha: 0.04),
            _Metal.edge.withValues(alpha: 0.55),
          ],
        ).createShader(rect),
    );

    canvas.save();
    canvas.clipRRect(bodyRR);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height * 0.45)),
    );
    canvas.restore();
  }

  void _paintScreenWell(Canvas canvas, Rect body) {
    final screen = config.bezel.deflateRect(body);
    final rr = RRect.fromRectAndRadius(screen, Radius.circular(config.screenRadius));
    canvas.drawRRect(
      rr.inflate(1.5),
      Paint()
        ..color = const Color(0xFF000000).withValues(alpha: 0.65)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawRRect(rr, Paint()..color = _Metal.glass);
  }

  void _paintSideButtons(Canvas canvas, Rect body) {
    for (final b in config.sideButtons) {
      if (b.opacity <= 0.01 || b.length <= 0.001) continue;
      final top = body.top + body.height * b.start;
      final h = body.height * b.length;
      final rect = b.side < 0
          ? Rect.fromLTWH(body.left - b.thickness + 1, top, b.thickness, h)
          : Rect.fromLTWH(body.right - 1, top, b.thickness, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(b.thickness * 0.6)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _Metal.light.withValues(alpha: b.opacity),
              _Metal.shade.withValues(alpha: b.opacity),
            ],
          ).createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(covariant DeviceBodyPainter old) => old.config != config || old.ambient != ambient;
}
