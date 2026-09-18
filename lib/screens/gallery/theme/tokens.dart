import 'package:flutter/material.dart';

/// The measurements the whole app is laid out on.
///
/// Written down once because the old screens each invented their own: a 14
/// here, a 16 there, a 28 between sections and a 12 between cards, with no
/// rule saying which to reach for. A catalogue that shows other people's
/// design work has to be visually quiet itself, and quiet comes from
/// repetition — four spacings and three radii, used everywhere.
abstract final class Gap {
  /// Between a label and the thing it labels.
  static const double xs = 4;

  /// Inside a control — icon to text.
  static const double sm = 8;

  /// Between siblings in a group.
  static const double md = 16;

  /// Between groups.
  static const double lg = 24;

  /// Between sections of a page.
  static const double xl = 40;
}

abstract final class Radii {
  /// Chips, buttons, small inline surfaces.
  static const Radius sm = Radius.circular(10);

  /// Tiles and cards — the common case.
  static const Radius md = Radius.circular(18);

  /// The plate stage and other full-bleed hero surfaces.
  static const Radius lg = Radius.circular(28);

  static const BorderRadius smAll = BorderRadius.all(sm);
  static const BorderRadius mdAll = BorderRadius.all(md);
  static const BorderRadius lgAll = BorderRadius.all(lg);
}

abstract final class Motion {
  /// A tile reacting to a press.
  static const Duration fast = Duration(milliseconds: 140);

  /// A hero flying between screens, a filter re-laying out a grid.
  static const Duration medium = Duration(milliseconds: 320);

  static const Curve curve = Curves.easeOutCubic;
}

/// The page width past which the layout stops being a phone layout.
///
/// One number, not one per screen: the shell switches from a bottom bar to a
/// side rail at the same width the grids start their third column, so the
/// whole app changes shape once rather than piecewise.
const double kWideBreakpoint = 900;

/// The narrow end of the scale [PlateSizes] interpolates from — a small
/// phone in portrait, below which shrinking further stops helping.
const double kNarrowBreakpoint = 320;

/// The plate stage and grid measurements, scaled to the window.
///
/// 320 logical pixels of plate stage and a 500-wide shelf tile are desktop
/// numbers. Used unchanged on a ~380px phone they were wider and taller than
/// the viewport itself — a shelf card the visitor could barely see past, a
/// single-column grid of near-full-height tiles. These interpolate linearly
/// between [kNarrowBreakpoint] and [kWideBreakpoint] instead, so the
/// catalogue keeps the desktop numbers above the breakpoint and shrinks
/// smoothly below it rather than jumping between two fixed layouts.
class PlateSizes {
  const PlateSizes({
    required this.shelfTileWidth,
    required this.shelfStageHeight,
    required this.gridStageHeight,
    required this.gridMaxCrossAxisExtent,
  });

  factory PlateSizes.of(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= kWideBreakpoint) {
      return const PlateSizes(
        shelfTileWidth: 500,
        shelfStageHeight: 320,
        gridStageHeight: 320,
        gridMaxCrossAxisExtent: 500,
      );
    }
    final double t = ((width - kNarrowBreakpoint) / (kWideBreakpoint - kNarrowBreakpoint)).clamp(0.0, 1.0);
    double lerp(double from, double to) => from + (to - from) * t;
    return PlateSizes(
      // Scaled with everything else rather than pinned to the viewport, so a
      // shelf on a small phone shows most of a second tile alongside the
      // first instead of one plate claiming the whole screen.
      shelfTileWidth: lerp(210, 500),
      shelfStageHeight: lerp(110, 320),
      gridStageHeight: lerp(100, 320),
      gridMaxCrossAxisExtent: lerp(190, 500),
    );
  }

  /// The shelf tile's width — see the class doc for why this isn't 500 on a
  /// phone.
  final double shelfTileWidth;

  /// The plate stage's height on a country shelf.
  final double shelfStageHeight;

  /// The plate stage's height in a country's full grid.
  final double gridStageHeight;

  /// [SliverGridDelegateWithMaxCrossAxisExtent.maxCrossAxisExtent] for that
  /// grid.
  final double gridMaxCrossAxisExtent;
}
