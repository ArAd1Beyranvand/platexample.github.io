// STABLE — presentation subsystem. Do not refactor for consistency with other
// layers; change only for rendering bugs.

import 'package:flutter/widgets.dart';

import 'device_config.dart';

/// Built-in presets. Override any of them with [DeviceFrame.configResolver].
///
/// Geometry and stage scale are the design's own numbers, read off the
/// `devicePresets()` array in `design_ref/Plate Gallery.dc.html` — which the
/// designer derived from this file in the first place, so the two line up.
/// Everything the design does not state (hardware placement, side buttons,
/// deck depth) stays ours.
class DevicePresets {
  const DevicePresets._();

  static const mobile = DeviceConfig(
    type: DeviceType.mobile,
    label: 'Mobile',
    bodySize: Size(390, 844),
    bezel: EdgeInsets.all(12),
    bodyRadius: 54,
    screenRadius: 42,
    notchSize: Size(126, 32),
    notchRadius: 16,
    stageScale: 0.88,
    cameraEdge: 0.1463,
    cameraRadius: 5,
    speakerEdge: 0.1175,
    speakerSize: Size(44, 5),
    homeIndicatorWidth: 134,
    sideButtons: [
      SideButton(side: -1, start: 0.18, length: 0.035),
      SideButton(side: -1, start: 0.235, length: 0.065),
      SideButton(side: -1, start: 0.315, length: 0.065),
      SideButton(side: 1, start: 0.26, length: 0.10),
    ],
  );

  /// Landscape tablet — wider than tall.
  static const tablet = DeviceConfig(
    type: DeviceType.tablet,
    label: 'Tablet',
    bodySize: Size(1194, 834),
    bezel: EdgeInsets.all(16),
    bodyRadius: 38,
    screenRadius: 24,
    stageScale: 0.68,
    cameraEdge: 0.875,
    cameraRadius: 4,
    speakerEdge: 0.625,
    speakerSize: Size(64, 3),
    homeIndicatorWidth: 200,
    sideButtons: [
      SideButton(side: -1, start: 0.10, length: 0.05),
      SideButton(side: -1, start: 0.20, length: 0.07),
      SideButton(side: -1, start: 0.30, length: 0.07),
      SideButton(side: 1, start: 0.06, length: 0.06),
    ],
  );

  static const desktop = DeviceConfig(
    type: DeviceType.desktop,
    label: 'Desktop',
    bodySize: Size(1180, 740),
    // The design's single `bezel: 22`, not the old asymmetric chin: the lid is
    // tilted back now, and an extra 12px under the glass read as a gap between
    // screen and hinge rather than as a chin.
    bezel: EdgeInsets.all(22),
    // Same corner rounding as the tablet, so the three form factors read as one
    // family and the morph between them never changes corner size.
    bodyRadius: 38,
    screenRadius: 24,
    notchSize: Size(180, 22),
    notchRadius: 8,
    stageScale: 0.68,
    // The lid stays flat, facing the viewer, rather than leaning back off its
    // bottom edge into the scene: at the design's `rotateX(-7deg)` the screen
    // read as receding into the depth instead of sitting parallel to the
    // stage, most visible where its top edge tucked in behind the hinge.
    lidTiltDeg: 0,
    cameraEdge: 0.125,
    cameraRadius: 3.5,
    // 58° from the screen plane — the design's `baseTransform: rotateX(58deg)`.
    // Depth stays ours: the design fakes its base height with an arithmetic
    // fudge, we project a real plane, and 210 is what keeps the keycap rows
    // legible at 0.34.
    deck: DeviceDeck(depth: 210, angleDeg: 58, hingeHeight: 9, opacity: 1),
  );

  static DeviceConfig of(DeviceType type) => switch (type) {
    DeviceType.mobile => mobile,
    DeviceType.tablet => tablet,
    DeviceType.desktop => desktop,
  };
}
