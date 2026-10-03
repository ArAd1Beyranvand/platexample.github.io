import 'package:flutter/widgets.dart';

import '../device_preview/device_config.dart';

/// Drives a [DeviceCycle], either forward one device at a time or straight to
/// a device the viewer asked for.
///
/// Call [advance] to move the cycle to the next device; each call notifies
/// listeners exactly once. Call [pin] to jump to a device *and* stop the
/// automatic advance — the showcase hero's segmented control does this, and
/// once a viewer has picked a form factor the cycle must not take it away
/// again a few seconds later.
class DeviceCycleController extends ChangeNotifier {
  DeviceType? _pinned;
  DeviceType? _target;

  /// The device the cycle has been pinned to, or null while it is still
  /// cycling on its own.
  DeviceType? get pinned => _pinned;

  /// The device the pending notification asks for, or null when it asks for
  /// "whatever comes next". Read by [DeviceCycle] from inside the listener.
  DeviceType? get target => _target;

  /// Advances the cycle to the next device. A no-op once [pin] has been
  /// called: the pin is the viewer's choice and outlives the demo's own
  /// timing.
  void advance() {
    if (_pinned != null) return;
    _target = null;
    notifyListeners();
  }

  /// Jumps the cycle to [device] and stops it advancing on its own.
  void pin(DeviceType device) {
    _pinned = device;
    _target = device;
    notifyListeners();
  }
}

/// Cycles through a sequence of [DeviceType]s on demand, rebuilding [builder]
/// each time the active device changes.
///
/// Each hop lets [DeviceFrame] morph between form factors. Advancing is driven
/// by [controller]: a device stays put until its plate has been fully typed in
/// and something calls [DeviceCycleController.advance].
class DeviceCycle extends StatefulWidget {
  const DeviceCycle({
    super.key,
    required this.builder,
    required this.controller,
    this.order = const [
      DeviceType.desktop,
      DeviceType.mobile,
      DeviceType.tablet,
    ],
    this.onDeviceChanged,
  });

  /// Builds the content for the currently active [DeviceType].
  final Widget Function(BuildContext context, DeviceType device) builder;

  /// Drives the cycle forward one device per [DeviceCycleController.advance].
  final DeviceCycleController controller;

  /// The sequence of devices to cycle through, wrapping back to the first.
  final List<DeviceType> order;

  /// Called whenever the active device advances to a new form factor.
  final ValueChanged<DeviceType>? onDeviceChanged;

  @override
  State<DeviceCycle> createState() => _DeviceCycleState();
}

class _DeviceCycleState extends State<DeviceCycle> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_advance);
  }

  void _advance() {
    if (!mounted) return;
    final DeviceType? target = widget.controller.target;
    final int next = target == null
        ? (_index + 1) % widget.order.length
        : widget.order.indexOf(target);
    // A pin onto the device already showing, or onto one this cycle does not
    // carry, leaves the cycle where it is. The pin itself has still taken
    // effect — the controller stops advancing — so there is nothing to
    // rebuild and no hop to report.
    if (next < 0 || next == _index) return;
    setState(() => _index = next);
    widget.onDeviceChanged?.call(widget.order[_index]);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_advance);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.order[_index]);
  }
}
