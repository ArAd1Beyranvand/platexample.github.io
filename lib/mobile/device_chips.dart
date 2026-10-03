import 'package:flutter/material.dart';

import '../device_preview/device_config.dart';
import '../theme/nocturne.dart';
import 'feature_deck.dart';
import 'mobile_tokens.dart';

/// Mobile / Tablet / Desktop pills under the device frame.
class DeviceChips extends StatelessWidget {
  const DeviceChips({super.key, required this.active, required this.onPick});

  final DeviceType active;
  final ValueChanged<DeviceType> onPick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (final FeatureGroup group in featureGroups) ...<Widget>[
          if (group != featureGroups.first) const SizedBox(width: 6),
          _Chip(
            device: group.device,
            active: group.device == active,
            onTap: () => onPick(group.device),
          ),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.device,
    required this.active,
    required this.onTap,
  });

  final DeviceType device;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active ? MobileTokens.n700 : MobileTokens.n800,
            ),
          ),
          child: Text(
            device.name.toUpperCase(),
            style: TextStyle(
              fontFamily: NType.mono,
              fontSize: 9.5,
              letterSpacing: 0.10 * 9.5,
              color: active ? MobileTokens.n200 : MobileTokens.n500,
            ),
          ),
        ),
      ),
    );
  }
}
