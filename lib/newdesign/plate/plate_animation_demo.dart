// TEMPORARY DEMO CONTROL — exercises plate_core's part animations.
// Delete this file and its one use in live_plate.dart to remove it.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plate_core/plate_core.dart';

/// Buttons that cue a [PlateAnimationController]: every part at once, every
/// part in sequence, and which kinds stay put across a plate switch.
class PlateAnimationDemoBar extends StatefulWidget {
  const PlateAnimationDemoBar({
    super.key,
    required this.controller,
    required this.spec,
    required this.keep,
    required this.onKeepChanged,
  });

  final PlateAnimationController controller;
  final PlateSpec spec;

  /// Part kinds that stay put when the plate switches spec.
  final Set<PlatePartKind> keep;
  final ValueChanged<Set<PlatePartKind>> onKeepChanged;

  @override
  State<PlateAnimationDemoBar> createState() => _PlateAnimationDemoBarState();
}

class _PlateAnimationDemoBarState extends State<PlateAnimationDemoBar> {
  /// Kinds worth keeping in place across a plate switch.
  static const _keepable = <PlatePartKind>[
    PlatePartKind.background,
    PlatePartKind.border,
    PlatePartKind.region,
    PlatePartKind.divider,
    PlatePartKind.panel,
    PlatePartKind.flag,
  ];

  /// Loop: 1 s in, 3 s held, 1 s out, repeat.
  Timer? _loop;
  PlateAnimationStyle? _savedStyle;

  static const _inOut = Duration(seconds: 1);
  static const _hold = Duration(seconds: 3);

  void _toggleLoop() {
    final c = widget.controller;
    if (_loop != null) {
      _loop!.cancel();
      _loop = null;
      c.style = _savedStyle ?? const PlateAnimationStyle();
      c.settleAll();
    } else {
      _savedStyle = c.style;
      c.style = PlateAnimationStyle(
        byKind: {
          for (final e in PlateAnimationStyle.defaults.entries)
            e.key: e.value.copyWith(duration: _inOut),
        },
      );
      _cycle();
      _loop = Timer.periodic(_inOut + _hold + _inOut, (_) => _cycle());
    }
    setState(() {});
  }

  void _cycle() {
    final c = widget.controller;
    c.comeInAll();
    Timer(_inOut + _hold, () {
      if (_loop != null && mounted) c.goOutAll();
    });
  }

  @override
  void dispose() {
    _loop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        FilledButton(
          onPressed: _toggleLoop,
          child: Text(_loop == null ? 'Loop 1s/3s/1s' : 'Stop loop'),
        ),
        OutlinedButton(
          onPressed: c.comeInAll,
          child: const Text('Come in all'),
        ),
        OutlinedButton(onPressed: c.goOutAll, child: const Text('Go out all')),
        OutlinedButton(
          onPressed: () =>
              c.comeInAll(delays: PlateStagger.sequence(widget.spec)),
          child: const Text('Stagger in'),
        ),
        OutlinedButton(
          onPressed: () => c.goOutAll(
            delays: PlateStagger.sequence(widget.spec, reverse: true),
          ),
          child: const Text('Stagger out'),
        ),
        for (final kind in _keepable)
          FilterChip(
            label: Text('keep ${kind.name}'),
            selected: widget.keep.contains(kind),
            onSelected: (on) => widget.onKeepChanged(
              on ? {...widget.keep, kind} : ({...widget.keep}..remove(kind)),
            ),
          ),
      ],
    );
  }
}
