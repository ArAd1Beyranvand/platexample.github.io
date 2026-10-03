import 'package:flutter/material.dart';

import '../screens/gallery/catalogue_index.dart';
import '../showcase/device_stage.dart';
import 'deck_device_sync.dart';
import 'device_chips.dart';
import 'mobile_tokens.dart';

/// The device frame and its chips, driven by [sync] rather than a timer.
class MobileDeviceSection extends StatefulWidget {
  const MobileDeviceSection({
    super.key,
    required this.sync,
    required this.onOpenPlate,
  });

  final DeckDeviceSync sync;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  static const double stageHeight = 380;

  @override
  State<MobileDeviceSection> createState() => _MobileDeviceSectionState();
}

class _MobileDeviceSectionState extends State<MobileDeviceSection> {
  @override
  void initState() {
    super.initState();
    // The cycle only hears pins once [DeviceCycle] has subscribed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.sync.attach();
    });
  }

  @override
  void dispose() {
    widget.sync.detach(release: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: MobileTokens.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 28, 18, 24),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MobileDeviceSection.stageHeight,
              child: DeviceStage(
                cycleController: widget.sync.cycle,
                onFrameDeviceChanged: widget.sync.onFrameDeviceChanged,
                onPhaseChanged: widget.sync.onPhaseChanged,
                onOpenPlate: widget.onOpenPlate,
              ),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: widget.sync,
              builder: (BuildContext context, Widget? _) => DeviceChips(
                active: widget.sync.frame,
                onPick: widget.sync.pick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
