import 'package:flutter/foundation.dart';

import '../../device_preview/device_config.dart';

/// One of the three cards that float over the showcase's device stage.
///
/// The old poster carried nine of these across three per-device sets, each with
/// its own flag strip, EU badge, tag and bevel. sk23.5 brings the three sets
/// back — the stage says something different about each device it hops to — but
/// not the chrome: Nocturne has three cards and one panel, a kicker, a title
/// and an optional body (see [CalloutCard]).
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

  /// Only the first card of a set has one; the design's `sc-if` drops the
  /// paragraph on the other two, which are a third of its width.
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

/// Mobile anchor slots. The phone frame is the narrowest of the three, so it
/// leaves the most clearance either side — these still float over the stage
/// exactly like tablet's and desktop's do whenever the picker has the phone
/// selected inside the wide two-column hero (`floatingCallouts: true` in
/// [_Stage]). Only the phone-panel breakpoint (window itself under ~600px)
/// drops these for the stacked [CalloutList].
const double _mobileSlot1Fx = 0.02;
const double _mobileSlot1Fy = 0.14;
const double _mobileSlot1W = 0.27;
const double _mobileSlot2Fx = 0.74;
const double _mobileSlot2Fy = 0.08;
const double _mobileSlot2W = 0.20;
const double _mobileSlot3Fx = 0.72;
const double _mobileSlot3Fy = 0.78;
const double _mobileSlot3W = 0.20;

/// Tablet anchor slots: one card on left beside field, two stacked on right.
/// Read off the reference render at 1440×900.
const double _tabletSlot1Fx = 0.01;
const double _tabletSlot1Fy = 0.16;
const double _tabletSlot1W = 0.27;
const double _tabletSlot2Fx = 0.74;
const double _tabletSlot2Fy = 0.08;
const double _tabletSlot2W = 0.19;
const double _tabletSlot3Fx = 0.72;
const double _tabletSlot3Fy = 0.80;
const double _tabletSlot3W = 0.19;

/// Desktop anchor slots: scaled for larger catalogue layout with more breathing room.
const double _desktopSlot1Fx = 0.02;
const double _desktopSlot1Fy = 0.12;
const double _desktopSlot1W = 0.28;
const double _desktopSlot2Fx = 0.73;
const double _desktopSlot2Fy = 0.06;
const double _desktopSlot2W = 0.20;
const double _desktopSlot3Fx = 0.71;
const double _desktopSlot3Fy = 0.78;
const double _desktopSlot3W = 0.20;

/// The three cards, in the design's order, one set per device.
///
/// Every set is three cards into the three slots above: a wide one on the left
/// carrying the only paragraph, and two narrow ones down the right. Each set
/// says something specific to what that device is showing, rather than
/// restating "customizable" in three different fonts.
const Map<DeviceType, List<CalloutSpec>> calloutSets =
    <DeviceType, List<CalloutSpec>>{
      // The phone runs the compact on-screen keypad: what typing on it is like.
      DeviceType.mobile: <CalloutSpec>[
        CalloutSpec(
          kicker: 'KEYPAD',
          title: 'An on-screen pad in the plate\'s own script',
          anchorFx: _mobileSlot1Fx,
          anchorFy: _mobileSlot1Fy,
          widthFx: _mobileSlot1W,
        ),
        CalloutSpec(
          kicker: 'FOCUS',
          title: 'Each slot hands off to the next',
          anchorFx: _mobileSlot2Fx,
          anchorFy: _mobileSlot2Fy,
          widthFx: _mobileSlot2W,
        ),
        CalloutSpec(
          kicker: 'IME',
          title: 'No system keyboard pops up',
          anchorFx: _mobileSlot3Fx,
          anchorFy: _mobileSlot3Fy,
          widthFx: _mobileSlot3W,
        ),
      ],
      // The tablet: what the host app gets back — the rules, the value, and no
      // state-management dependency.
      DeviceType.tablet: <CalloutSpec>[
        CalloutSpec(
          kicker: 'RULES',
          title: 'Validation marks a bad plate red and never blocks a key',
          anchorFx: _tabletSlot1Fx,
          anchorFy: _tabletSlot1Fy,
          widthFx: _tabletSlot1W,
        ),
        CalloutSpec(
          kicker: 'CONTROLLER',
          title: 'Read and write the value from code',
          anchorFx: _tabletSlot2Fx,
          anchorFy: _tabletSlot2Fy,
          widthFx: _tabletSlot2W,
        ),
        CalloutSpec(
          kicker: 'STATE',
          title: 'No provider or bloc required',
          anchorFx: _tabletSlot3Fx,
          anchorFy: _tabletSlot3Fy,
          widthFx: _tabletSlot3W,
        ),
      ],
      // The laptop is typed from its deck, and its set is about breadth: how
      // countries and plates are added.
      DeviceType.desktop: <CalloutSpec>[
        CalloutSpec(
          kicker: 'COUNTRIES',
          title: 'One package per country, one widget for all',
          anchorFx: _desktopSlot1Fx,
          anchorFy: _desktopSlot1Fy,
          widthFx: _desktopSlot1W,
        ),
        CalloutSpec(
          kicker: 'KEYBOARD',
          title: 'Physical keys type straight in',
          anchorFx: _desktopSlot2Fx,
          anchorFy: _desktopSlot2Fy,
          widthFx: _desktopSlot2W,
        ),
        CalloutSpec(
          kicker: 'SPECS',
          title: 'A new plate is a const, not a widget',
          anchorFx: _desktopSlot3Fx,
          anchorFy: _desktopSlot3Fy,
          widthFx: _desktopSlot3W,
        ),
      ],
    };

/// The set shown when nothing says otherwise — the one the design's reference
/// render of this screen is drawn at.
List<CalloutSpec> calloutSetFor(DeviceType device) =>
    calloutSets[device] ?? calloutSets[DeviceType.tablet]!;
