import 'package:flutter/material.dart';

import '../../theme/nocturne.dart';

/// The country grid's plate measurements, scaled to the window.
///
/// Extracted from the old `screens/gallery/theme/tokens.dart` in sk15, where
/// it shared a file with the blue design's `Gap`/`Radii`/`Motion` tokens. It
/// outlived them because it is a layout helper, not a palette: the country
/// grid still has to shrink its cards on a phone.
///
/// The numbers are Nocturne's, not the old design's. The desktop card is
/// [PlateTile.defaultStageHeight] tall in a 420-wide column — where the blue
/// design used a 320-tall stage in a 500-wide one — so a grid that kept the
/// old constants would draw cards half again too large for the new tile.
/// Below [NBreak.shell] these interpolate linearly down to [_narrow], so the
/// catalogue holds the desktop numbers above the breakpoint and shrinks
/// smoothly below it rather than jumping between two fixed layouts.
class PlateSizes {
  const PlateSizes({
    required this.gridStageHeight,
    required this.gridMaxCrossAxisExtent,
  });

  factory PlateSizes.of(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= NBreak.shell) {
      return const PlateSizes(
        gridStageHeight: _stageHeight,
        gridMaxCrossAxisExtent: _maxCrossAxisExtent,
      );
    }
    final double t =
        ((width - _narrow) / (NBreak.shell - _narrow)).clamp(0.0, 1.0);
    double lerp(double from, double to) => from + (to - from) * t;
    return PlateSizes(
      gridStageHeight: lerp(72, _stageHeight),
      gridMaxCrossAxisExtent: lerp(190, _maxCrossAxisExtent),
    );
  }

  /// The narrow end of the scale — a small phone in portrait, below which
  /// shrinking further stops helping.
  static const double _narrow = 320;

  /// Matches `PlateTile.defaultStageHeight`; named here rather than imported
  /// so this file stays a leaf of the widget layer.
  static const double _stageHeight = 96;

  /// Matches `PlateSliverGrid`'s default tile extent.
  static const double _maxCrossAxisExtent = 420;

  /// The plate stage's height in a country's full grid.
  final double gridStageHeight;

  /// [SliverGridDelegateWithMaxCrossAxisExtent.maxCrossAxisExtent] for that
  /// grid.
  final double gridMaxCrossAxisExtent;
}
