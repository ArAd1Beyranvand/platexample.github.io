import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../device_preview/device_config.dart';
import '../device_preview/device_transition.dart';
import '../mobile/mobile_body.dart';
import '../poster/backdrop/poster_backdrop.dart';
import '../poster/backdrop/sweep_light.dart';
import '../poster/poster_scale.dart';
import '../showcase/device_cycle.dart';
import '../showcase/device_stage.dart';
import '../theme/nocturne.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/catalogue_stats.dart';
import 'gallery/sources/sources.dart';
import 'showcase/hero.dart';
import 'showcase/stat_band.dart';

/// Computed once: [gallerySources] never changes at runtime, and the build
/// method below re-runs on every device hop and phase change.
final CatalogueStats _catalogueStats = CatalogueStats.of(gallerySources);

/// `01 — Showcase`, the page the migration is judged by.
///
/// The design's outer section is `min-height: 100vh` over
/// `grid-template-rows: 1fr auto` (`Plate Gallery.dc.html` line 85): the hero
/// takes whatever height is left and the stat band is pinned under it. This
/// widget is only that composition — backdrop, hero, stat band.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({
    super.key,
    required this.onOpenTab,
    required this.onOpenPlate,
    required this.onOpenCountry,
  });

  /// Asks the router to navigate; the hero's `Browse plates` button is the
  /// only caller. The shell owns the tab, so the screen routes through it
  /// rather than reaching for the Navigator.
  final ValueChanged<AppTab> onOpenTab;

  /// Opens a plate into its detail page. The device stage's card is the only
  /// caller — tapping it routes to the same page a Discover tile opens. The
  /// shell owns the Discover navigator, so the request travels up to it rather
  /// than being pushed from here.
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  /// Opens a country page; the mobile package carousel's cards are the caller.
  final ValueChanged<GallerySource> onOpenCountry;

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
    // Measured here rather than with MediaQuery, for the same reason the hero
    // does: the forced panel narrows constraints, not the window.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          NBreak.isPanel(constraints.biggest) ? _mobile() : _wide(),
    );
  }

  Widget _mobile() {
    return Scaffold(
      backgroundColor: N.bg,
      body: PosterMetricsScope(
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: <Widget>[
            const PosterBackdrop(),
            MobileBody(
              stats: _catalogueStats,
              onOpenArchive: () => widget.onOpenTab(AppTab.discover),
              onOpenPlate: widget.onOpenPlate,
              onOpenCountry: widget.onOpenCountry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _wide() {
    final Widget stage = DeviceStage(
      cycleController: _cycle,
      onFrameDeviceChanged: _onFrameDeviceChanged,
      onPhaseChanged: _onPhaseChanged,
      onOpenPlate: widget.onOpenPlate,
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
            // The design's rotated panel, dash strip, accent bloom and ground
            // fade. It drops the sweep itself in the phone-panel layout, where
            // there is no band for the rake to travel along.
            PosterBackdrop(
              // Fires on the rising edge of frameTransform, which is the exact
              // frame the device's content opacity reaches zero.
              sweep: SweepLight(
                isHopping: _phase == DeviceTransitionPhase.frameTransform,
              ),
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
                StatBand(stats: _catalogueStats),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
