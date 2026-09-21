import 'package:flutter/material.dart';

/// The measurements the two detail screens are laid out on.
///
/// Nocturne's `NSpace`/`NRadius` replaced these everywhere else, but not on a
/// like-for-like scale: `NSpace` steps in 2.8s and has no value for [Gap.lg]
/// or [Gap.xl], and `NRadius` is 4/8/14 against these 10/18/28. The country
/// and plate detail screens are still laid out on this scale, so sk15 kept it
/// rather than re-spacing two shipping screens inside a deletion pass.
/// Migrating them is its own change, with its own visual review.
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
