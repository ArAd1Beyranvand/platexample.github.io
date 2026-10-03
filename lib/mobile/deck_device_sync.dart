import 'package:flutter/foundation.dart';

import '../device_preview/device_config.dart';
import '../device_preview/device_transition.dart';
import '../showcase/device_cycle.dart';
import 'feature_deck.dart';

/// Keeps the feature deck and the device frame on the same device.
///
/// The deck is the clock: its index picks the device, and the frame is pinned
/// to it, which also silences the stage's own dwell. While a hop runs the deck
/// is held unsettled so its 4 s dwell starts only once the frame is idle.
/// Requests made mid-hop are coalesced: only the latest target is pinned when
/// the current hop lands.
class DeckDeviceSync extends ChangeNotifier {
  DeckDeviceSync() {
    deck.index.addListener(_onIndex);
  }

  final FeatureDeckController deck = FeatureDeckController();
  final DeviceCycleController cycle = DeviceCycleController();

  /// [DeviceCycle]'s default order starts on desktop.
  DeviceType _frame = DeviceType.desktop;
  DeviceType get frame => _frame;

  late DeviceType _want = deviceAt(deck.index.value);
  bool _attached = false;
  bool _hopping = false;

  /// Called by the device section once its stage is mounted; until then there
  /// is no frame to wait for and the deck runs freely.
  void attach() {
    _attached = true;
    _drive();
  }

  void detach() {
    _attached = false;
    _hopping = false;
    deck.settled.value = true;
  }

  /// Chip tap: jump the deck to the start of [device]'s group.
  void pick(DeviceType device) => deck.jumpTo(firstIndexOf(device));

  void onFrameDeviceChanged(DeviceType device) {
    _frame = device;
    notifyListeners();
  }

  void onPhaseChanged(DeviceTransitionPhase phase) {
    if (phase != DeviceTransitionPhase.idle || !_hopping) return;
    _hopping = false;
    _drive();
  }

  void _onIndex() {
    _want = deviceAt(deck.index.value);
    if (!_hopping) _drive();
  }

  void _drive() {
    if (!_attached) return;
    if (_want == _frame) {
      deck.settled.value = true;
      return;
    }
    _hopping = true;
    deck.settled.value = false;
    cycle.pin(_want);
  }

  @override
  void dispose() {
    deck.index.removeListener(_onIndex);
    deck.dispose();
    cycle.dispose();
    super.dispose();
  }
}
