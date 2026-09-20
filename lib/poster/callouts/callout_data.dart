import 'package:flutter/foundation.dart';

/// One of the three cards that float over the showcase's device stage.
///
/// The old poster carried nine of these across three per-device sets, each
/// with its own flag strip, EU badge, tag and bevel. Nocturne has three cards
/// and one panel: a kicker, a title, an optional body (see [CalloutCard]).
@immutable
class CalloutSpec {
  const CalloutSpec({
    required this.kicker,
    required this.title,
    this.body,
    required this.anchorFx,
    required this.anchorFy,
    required this.widthFx,
  });

  /// The MartianMono line above the title. Uppercased at paint time, the way
  /// `text-transform: uppercase` would.
  final String kicker;

  final String title;

  /// Only the first card has one; the design's `sc-if` drops the paragraph on
  /// the other two.
  final String? body;

  /// The card's left edge and top edge as fractions of the device stage, and
  /// its width as a fraction of the stage's — the design's
  /// `position:absolute; left:{{c.x}}%; top:{{c.y}}%; width:{{c.w}}%`
  /// (`Plate Gallery.dc.html` line 140).
  ///
  /// Fractions rather than pixels so the cards keep their place against the
  /// device as the stage grows with the window, and so the stacked layouts can
  /// ignore them entirely.
  final double anchorFx;
  final double anchorFy;
  final double widthFx;
}

/// The three cards, in the design's order.
///
/// The percentages are read off the reference render of the showcase at
/// 1440×900 (`newdesign_migration/pictures/target/desktop`), measured against
/// the `.pg-stage` box: the first card sits on the stage's left edge level
/// with the laptop's screen, and the other two stack down its right edge,
/// clearing the device between them.
const List<CalloutSpec> calloutSpecs = <CalloutSpec>[
  CalloutSpec(
    kicker: 'RULES',
    title: 'Live validation',
    body: 'Forbidden district and serial combinations flare red as you type: '
        'before submit, not after.',
    anchorFx: 0.01,
    anchorFy: 0.16,
    widthFx: 0.27,
  ),
  CalloutSpec(
    kicker: 'FEATURE',
    title: 'Both plate input and its display',
    anchorFx: 0.74,
    anchorFy: 0.08,
    widthFx: 0.19,
  ),
  CalloutSpec(
    kicker: 'SCALE',
    title: 'Everything is customizable',
    anchorFx: 0.72,
    anchorFy: 0.80,
    widthFx: 0.19,
  ),
];
