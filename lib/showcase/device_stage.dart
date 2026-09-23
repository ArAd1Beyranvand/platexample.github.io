import 'dart:async';

import 'package:flutter/material.dart';

import '../device_preview/device_config.dart';
import '../device_preview/device_frame.dart';
import '../device_preview/device_transition.dart';
import '../poster/plate_backdrop.dart';
import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/widgets/plate_tile.dart';
import '../showcase/demo_config.dart';
import '../showcase/device_cycle.dart';

class DeviceStage extends StatefulWidget {
  const DeviceStage({
    super.key,
    required this.onOpenPlate,
    this.cycleController,
    this.onFrameDeviceChanged,
    this.onPhaseChanged,
  });

  /// The handle the hero's segmented control pins a device with. Supplying one
  /// hands its lifetime to the caller; omitting it leaves the stage cycling on
  /// its own with a controller it creates and disposes itself.
  final DeviceCycleController? cycleController;

  /// Fired the instant a hop starts, with the incoming device — i.e. the same
  /// moment [_DeviceStageState._frameDevice] flips, before the plate content
  /// has caught up. The callout rails switch on this, so they leave while the
  /// device is still morphing.
  final ValueChanged<DeviceType>? onFrameDeviceChanged;

  /// Fired for every phase reported by the frame transition.
  final ValueChanged<DeviceTransitionPhase>? onPhaseChanged;

  /// Opens the plate currently on the glass into its detail page — the card on
  /// the glass is a control now, not a demo, so tapping it routes to the same
  /// page a Discover tile opens.
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  @override
  State<DeviceStage> createState() => _DeviceStageState();
}

class _DeviceStageState extends State<DeviceStage> {
  late final DeviceCycleController _controller = widget.cycleController ?? DeviceCycleController();

  /// The plate the content device currently shows — a random catalogue item,
  /// re-rolled on every content swap so a device shows a different plate each
  /// turn. Held as a [CatalogueItem] rather than a bare spec so the card's tap
  /// can open it into its own detail page.
  CatalogueItem _item = pickDemoItem();

  /// Bumped on every device hop; captured by the pending auto-advance so a
  /// stale timer (from a device we already left) bails out.
  int _generation = 0;

  /// The generation the dwell timer has already been armed for, so a repeated
  /// idle phase for the same device doesn't queue a second advance.
  int _startedGen = -1;

  /// How long a card sits on the glass before the cycle advances to the next
  /// device. The card auto-types on hover, so there is no typing run to wait
  /// on any more — this is a plain dwell.
  static const Duration _dwell = Duration(seconds: 4);

  /// The pending dwell, held as a real [Timer] rather than a [Future.delayed]
  /// so [dispose] can cancel it — a delayed future keeps ticking after the
  /// stage is gone and trips the test binding's "timer still pending" guard.
  Timer? _dwellTimer;

  @override
  void initState() {
    super.initState();
    // The first device never fires a transition phase, so arm the dwell timer
    // directly once the tree is laid out.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeArmDwell());
  }

  @override
  void dispose() {
    _dwellTimer?.cancel();
    // Only the one this stage made: a caller-supplied controller outlives the
    // stage (the hero rebuilds this subtree on every resize) and is disposed
    // by whoever created it.
    if (widget.cycleController == null) _controller.dispose();
    _generation++;
    super.dispose();
  }

  void _onDeviceChanged(DeviceType device) {
    _generation++;
    // The card itself is device-independent — the same plate on every form
    // factor — so nothing about the content changes on a hop; only the shell
    // reshapes. The re-roll happens on the content swap.
    widget.onFrameDeviceChanged?.call(device);
  }

  /// Fired by [DeviceFrame] the moment content opacity hits zero, as the frame
  /// starts morphing — the outgoing card is already invisible, so the plate can
  /// be re-rolled without a visible flash.
  void _onContentSwap() {
    if (!mounted) return;
    setState(() => _item = pickDemoItem());
  }

  void _onPhase(DeviceTransitionPhase phase) {
    widget.onPhaseChanged?.call(phase);
    // At idle the content has fully faded back in, so start the dwell.
    if (phase == DeviceTransitionPhase.idle) _maybeArmDwell();
  }

  void _maybeArmDwell() {
    if (!mounted || _startedGen == _generation) return;
    _startedGen = _generation;
    final int gen = _generation;
    _dwellTimer?.cancel();
    _dwellTimer = Timer(_dwell, () {
      if (!mounted || gen != _generation) return;
      _controller.advance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DeviceCycle(
      controller: _controller,
      onDeviceChanged: _onDeviceChanged,
      // Isolate the device + card in its own layer. It is expensive to raster
      // (perspective transform, nested FittedBoxes, clips), and on Linux an
      // instant window maximise that forces a full re-raster of it can miss the
      // GL embedder's frame deadline and crash the app. A RepaintBoundary lets
      // the resize composite the cached layer instead of re-rendering it.
      builder: (context, device) => RepaintBoundary(child: _buildDevice(device)),
    );
  }

  Widget _buildDevice(DeviceType frameDevice) {
    return DeviceFrame(
      device: frameDevice,
      onPhaseChanged: _onPhase,
      onContentSwap: _onContentSwap,
      builder: (context, _) => _CardGlass(item: _item, onOpenPlate: widget.onOpenPlate),
    );
  }
}

/// The device glass, holding one discovery-style [PlateTile] centred on it,
/// over the same drifting-orb [PlateBackdrop] the detail page paints.
///
/// The same card the Discover archive draws: it auto-types its sample on hover
/// and, tapped, opens the plate into its detail page. Padding and a cap on the
/// card's width keep it reading as a card sitting on the glass rather than one
/// stretched edge to edge.
class _CardGlass extends StatelessWidget {
  const _CardGlass({required this.item, required this.onOpenPlate});

  final CatalogueItem item;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  @override
  Widget build(BuildContext context) {
    // Unique per device so the hero into the detail page never clashes with a
    // Discover tile's tag, and re-keys as the content swaps.
    final String heroTag = 'showcase-stage-${item.entry.id}';
    // The plate band's height on the showcase glass — much taller than the
    // grid's default, so the plate is the subject of the card.
    const double stageHeight = 200;
    // The card is sized to its plate rather than to a fixed cap: a card wider
    // than the plate at this height leaves the plate a small strip floating in
    // it (which is what the fixed 820 cap did to nearly-square plates). Width
    // the card to the plate's own aspect at [stageHeight], plus the card's
    // horizontal padding, so the plate fills the band edge to edge whatever its
    // proportions. Clamped so a very wide plate still fits the glass.
    final double aspect = item.entry.spec.canvasWidth / item.entry.spec.canvasHeight;
    final double cardWidth = (stageHeight * aspect + PlateTile.padding.horizontal).clamp(300.0, 860.0);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // The moving blue orbs, behind the card on the glass — the same ambient
        // the detail page draws, so the showcase device reads like the real
        // screen it opens into.
        const Positioned.fill(child: PlateBackdrop()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: cardWidth,
              child: PlateTile(
                // Fresh state per plate, so a content swap re-seeds the
                // controller and restarts the auto-replay on the new entry.
                key: ValueKey<String>(item.entry.id),
                entry: item.entry,
                heroTag: heroTag,
                onTap: () => onOpenPlate(item, heroTag),
                stageHeight: stageHeight,
                // The showcase card fills itself in on a loop, hover or not.
                autoReplay: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
