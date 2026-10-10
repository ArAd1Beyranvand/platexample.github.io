// TEMPORARY DEMO CONTROL — exercises plate_core's part animations.
// Delete this file and its one use in live_plate.dart to remove it.

import 'package:flutter/material.dart';
import 'package:plate_core/plate_core.dart';

/// Buttons that cue a [PlateAnimationController]: every part at once, every
/// part in sequence, or one picked part.
class PlateAnimationDemoBar extends StatefulWidget {
  const PlateAnimationDemoBar({
    super.key,
    required this.controller,
    required this.spec,
  });

  final PlateAnimationController controller;
  final PlateSpec spec;

  @override
  State<PlateAnimationDemoBar> createState() => _PlateAnimationDemoBarState();
}

class _PlateAnimationDemoBarState extends State<PlateAnimationDemoBar> {
  PlatePartId _part = PlatePartId.border;

  @override
  Widget build(BuildContext context) {
    final parts = PlatePartId.allOf(widget.spec);
    final part = parts.contains(_part) ? _part : parts.first;
    final c = widget.controller;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
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
        DropdownButton<PlatePartId>(
          value: part,
          items: <DropdownMenuItem<PlatePartId>>[
            for (final p in parts)
              DropdownMenuItem<PlatePartId>(value: p, child: Text('$p')),
          ],
          onChanged: (p) => setState(() => _part = p ?? _part),
        ),
        OutlinedButton(
          onPressed: () => c.comeIn(part),
          child: const Text('Part in'),
        ),
        OutlinedButton(
          onPressed: () => c.goOut(part),
          child: const Text('Part out'),
        ),
      ],
    );
  }
}
