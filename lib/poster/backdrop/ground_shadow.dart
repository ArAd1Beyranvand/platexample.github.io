import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../device_preview/device_config.dart'
    show DeviceConfig, DevicePresets, DeviceType;
import '../../device_preview/device_transition.dart';
import '../poster_scale.dart';
import '../poster_tokens.dart';
import 'poster_backdrop.dart';

/// The skewed slab under the device — the "Ground shadow" row of
/// DESIGN_SPEC.md §6 and the `groundShadow*` tokens of §1.
///
/// 104 design px tall, `skewX(-34deg / -30deg / -41deg)` for desktop / mobile
/// / tablet, gradient from §1, blur 2px. Its width and centre are no longer
/// the spec's fixed `900 @ 1030,872`: the slab spans the device currently on
/// the stage, so the phone casts a phone-wide shadow and the laptop a
/// laptop-wide one, instead of every device sitting on the same desktop-sized
/// slab.
///
/// The width that matters is the device's *drawn* footprint, not its layout
/// slot. [DeviceFrame] aspect-fits the shell into the slot, and for the laptop
/// it fits body **plus** the unfolded deck's projected height — so the laptop
/// is letterboxed and its body is markedly narrower than the slot it sits in.
/// [footprintOf] reproduces that fit; spanning the raw slot instead is what
/// made the laptop's slab read far too wide.
///
/// No state machine of its own (§7.2). Both the skew and the slab rect are
/// driven from the *slot* device — the one the screen only swaps in on
/// [DeviceTransitionPhase.frameTransform] — over
/// `DeviceTransitionDurations.frameTransform` (1100ms) with
/// `Curves.easeInOutCubic`, which is exactly the interval the frame morphs on
/// and what the slot's own `AnimatedPositioned` uses. Driving the skew from
/// the incoming device instead would start the slab shearing at the top of the
/// hop, a full 1500ms content fade-out before the shell begins to reshape.
class GroundShadow extends StatelessWidget {
  const GroundShadow({
    super.key,
    required this.device,
    required this.bounds,
    this.duration,
    this.curve = Curves.easeInOutCubic,
  });

  /// The device the *slot* is sized for, i.e. the one that flips when the frame
  /// starts morphing — not the one the hop announced.
  final DeviceType device;

  /// The device slot's box in design coordinates (1920×1080), i.e. the same
  /// space the painter draws in.
  final Rect bounds;

  /// Defaults to the frame's own morph duration.
  final Duration? duration;
  final Curve curve;

  /// CSS `skewX` leans a shape the opposite way to the matrix convention, so
  /// these are negated when they reach `Matrix4.skewX`.
  static double skewDegreesFor(DeviceType device) {
    switch (device) {
      case DeviceType.desktop:
        return -34;
      case DeviceType.mobile:
        return -30;
      case DeviceType.tablet:
        return -41;
    }
  }

  /// The box a [device] actually paints into inside its layout [slot],
  /// reproducing `DeviceFrame`'s own aspect fit: the shell is scaled to
  /// `min(slot.w / total.w, slot.h / fitHeight)` and centred, where the
  /// laptop's `fitHeight` includes its unfolded deck.
  ///
  /// Kept in step with `_DeviceFrameState._buildFrame` by hand; the frame is a
  /// STABLE subsystem, so this reads its presets rather than changing it to
  /// report the fit back out.
  static Rect footprintOf(Rect slot, DeviceType device, {double perspective = 900}) {
    final DeviceConfig config = DevicePresets.of(device);
    final Size total = config.totalSize(perspective);
    final bool hasDeck = config.deck.depth > 0.5;
    final double fitHeight = hasDeck ? total.height : config.bodySize.height;
    if (total.width <= 0 || fitHeight <= 0 || slot.isEmpty) return slot;

    final double fit = math
        .min(slot.width / total.width, slot.height / fitHeight)
        .clamp(0.05, 1.0);
    final double w = total.width * fit;
    final double h = fitHeight * fit;
    // The frame centres itself in the slot (Alignment.center).
    return Rect.fromLTWH(
      slot.left + (slot.width - w) / 2,
      slot.top + (slot.height - h) / 2,
      w,
      h,
    );
  }

  /// The slab for a device slot: as wide as the device's drawn body, a little
  /// proud of it on each side so the blur doesn't stop dead at the edge, and
  /// seated just under its base.
  ///
  /// The overhang and the drop are fractions of the device rather than fixed
  /// design px, so they stay in proportion across the three form factors.
  static Rect slabFor(Rect slot, DeviceType device) {
    final Rect body = footprintOf(slot, device);
    // Scale the slab's thickness with the device too, so the phone doesn't get
    // the same 104px slab the laptop does.
    final double height = _slabHeight * (body.width / _referenceWidth);
    final double overhang = body.width * 0.04;
    return Rect.fromLTWH(
      body.left - overhang,
      body.bottom - height * 0.35,
      body.width + overhang * 2,
      height,
    );
  }

  /// The slab's 104px height is authored against the desktop body, so the other
  /// form factors scale down from it.
  static const double _slabHeight = 104;
  static const double _referenceWidth = 1180;

  @override
  Widget build(BuildContext context) {
    final Duration d =
        duration ?? const DeviceTransitionDurations().frameTransform;
    return TweenAnimationBuilder<double>(
      // No `begin`: the first build lands on the value, every later change
      // eases from wherever the slab currently is.
      tween: Tween<double>(end: skewDegreesFor(device)),
      duration: d,
      curve: curve,
      builder: (BuildContext context, double degrees, Widget? child) {
        return TweenAnimationBuilder<Rect?>(
          // Same duration and curve as the skew and as the slot's own
          // AnimatedPositioned, so the three stay in lockstep through a hop.
          tween: RectTween(end: slabFor(bounds, device)),
          duration: d,
          curve: curve,
          builder: (BuildContext context, Rect? slab, Widget? child) {
            return IgnorePointer(
              child: CustomPaint(
                painter: _GroundShadowPainter(
                  skewDegrees: degrees,
                  slab: slab ?? slabFor(bounds, device),
                ),
                child: const SizedBox.expand(),
              ),
            );
          },
        );
      },
    );
  }
}

class _GroundShadowPainter extends CustomPainter {
  const _GroundShadowPainter({required this.skewDegrees, required this.slab});

  final double skewDegrees;

  /// In design coordinates; see [GroundShadow.slabFor].
  final Rect slab;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || slab.isEmpty) return;

    canvas.save();
    canvas.scale(
      size.width / kBackdropDesignWidth,
      size.height / kBackdropDesignHeight,
    );

    final double w = slab.width;
    final double h = slab.height;

    // Anchor at the slab's own centre so the skew leans it without sliding it
    // out from under the device.
    canvas.translate(slab.center.dx, slab.center.dy);
    // CSS skewX(θ) shears x by +tan(θ)·y; Matrix4.skewX takes the shear factor
    // with the opposite sign convention, hence the negation.
    canvas.transform(
      Matrix4.skewX(-math.tan(skewDegrees * math.pi / 180)).storage,
    );
    canvas.translate(-w / 2, -h / 2);

    final Rect body = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRect(
      body,
      Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2)
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            PosterColors.groundShadowStart,
            PosterColors.groundShadowMid,
            Color(0x00000000),
          ],
          stops: <double>[0.0, 0.6, 1.0],
        ).createShader(body),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GroundShadowPainter oldDelegate) {
    return oldDelegate.skewDegrees != skewDegrees || oldDelegate.slab != slab;
  }
}

/// Sizes [GroundShadow] to the stage, for use as a `Stack` layer under the
/// device.
///
/// [deviceBounds] is the device slot's box in real stage px — the same rect
/// the slot's `AnimatedPositioned` is given — and is converted here into the
/// design coordinates the painter works in. Pass the *slot* device for
/// [device] so the two agree; see [GroundShadow].
class GroundShadowLayer extends StatelessWidget {
  const GroundShadowLayer({
    super.key,
    required this.device,
    required this.deviceBounds,
  });

  final DeviceType device;
  final Rect deviceBounds;

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final Size size = metrics.size;
    // Guard against a zero-width stage on the very first layout pass.
    final double kx = size.width == 0 ? 0 : kBackdropDesignWidth / size.width;
    final double ky = size.height == 0 ? 0 : kBackdropDesignHeight / size.height;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: GroundShadow(
        device: device,
        bounds: Rect.fromLTRB(
          deviceBounds.left * kx,
          deviceBounds.top * ky,
          deviceBounds.right * kx,
          deviceBounds.bottom * ky,
        ),
      ),
    );
  }
}
