import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../device_preview/device_config.dart';
import '../device_preview/device_transition.dart';
import '../poster/backdrop/poster_backdrop.dart';
import '../poster/backdrop/sweep_light.dart';
import '../poster/poster_scale.dart';
import '../showcase/device_cycle.dart';
import '../showcase/device_stage.dart';
import '../theme/nocturne.dart';
import 'showcase/hero.dart';

/// `01 — Showcase`, the page the migration is judged by.
///
/// The design's outer section is `min-height: 100vh` over
/// `grid-template-rows: 1fr auto` (`Plate Gallery.dc.html` line 85): the hero
/// takes whatever height is left and the stat band is pinned under it. This
/// widget is only that composition — backdrop, hero, stat band, callouts —
/// with the pieces it does not own yet left as empty slots:
///
/// - the **stat band** is sk7, and reads live registry numbers;
/// - the **callouts** are sk8, and float over the device stage;
/// - the **device frames** are sk9 and the **backdrop** sk10, so both are
///   still the old poster's, deliberately.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key, required this.onOpenTab});

  /// Asks the router to navigate; the hero's `Open the archive` button is the
  /// only caller. The shell owns the tab, so the screen routes through it
  /// rather than reaching for the Navigator.
  final ValueChanged<AppTab> onOpenTab;

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  /// The handle the hero's segmented control pins a device with. Owned here
  /// rather than inside [DeviceStage] because the hero, which is a sibling of
  /// the stage, is what drives it.
  final DeviceCycleController _cycle = DeviceCycleController();

  /// The device the stage is showing. Set from the stage's own hop callback,
  /// so a pin and an auto-advance update the segmented control identically.
  /// Starts on the first device of [DeviceCycle]'s default order.
  DeviceType _device = DeviceType.desktop;

  DeviceTransitionPhase _phase = DeviceTransitionPhase.idle;

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  void _onFrameDeviceChanged(DeviceType device) {
    if (!mounted) return;
    setState(() => _device = device);
  }

  void _onPhaseChanged(DeviceTransitionPhase phase) {
    if (!mounted) return;
    setState(() => _phase = phase);
  }

  @override
  Widget build(BuildContext context) {
    // The stage keeps its own RepaintBoundary inside; this Stack is where
    // sk8's callouts land, floating over it the way the design's
    // `position:absolute; left:{{c.x}}%` cards do.
    final Widget stage = Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: <Widget>[
        DeviceStage(
          cycleController: _cycle,
          onFrameDeviceChanged: _onFrameDeviceChanged,
          onPhaseChanged: _onPhaseChanged,
        ),
        // Callouts slot — sk8.
      ],
    );

    final Widget hero = ShowcaseHero(
      device: _device,
      onPickDevice: _cycle.pin,
      onOpenArchive: () => widget.onOpenTab(AppTab.discover),
      stage: stage,
    );

    return Scaffold(
      backgroundColor: N.bg,
      body: PosterMetricsScope(
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: <Widget>[
            // Still the poster's road and sweep — sk10 replaces both with the
            // design's rotated panel, dash strip and accent bloom.
            PosterBackdrop(
              // Fires on the rising edge of frameTransform, which is the exact
              // frame the device's content opacity reaches zero.
              sweep: SweepLight(isHopping: _phase == DeviceTransitionPhase.frameTransform),
            ),
            // `grid-template-rows: 1fr auto`, at every width. The section is
            // exactly one viewport tall and never scrolls: the hero takes the
            // `1fr` row and fits itself to it, and the stat band sits on the
            // bottom edge. An earlier pass scrolled below the hero breakpoint,
            // which is where the long ribbon came from — the stage was pushed
            // off the bottom of a page that had grown to fit its own content
            // instead of the window.
            Column(
              children: <Widget>[
                Expanded(child: hero),
                const _StatBandSlot(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Where sk7's live-registry stat band goes: `grid-template-rows: 1fr auto`'s
/// `auto` row, a divider across the top of it.
class _StatBandSlot extends StatelessWidget {
  const _StatBandSlot();

  @override
  Widget build(BuildContext context) => const SizedBox(width: double.infinity);
}
