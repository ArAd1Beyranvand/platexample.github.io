import 'package:flutter/material.dart';

import 'mobile_tokens.dart';

/// One thin segment per card, a wider gap between groups.
///
/// Past segments are full accent, the current one is filled to [progress],
/// future ones are dim. Each draws 2 px but hits 24 px.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    super.key,
    required this.groups,
    required this.index,
    required this.progress,
    required this.onSelect,
  });

  /// Segment count of each group, in order.
  final List<int> groups;
  final int index;
  final Animation<double> progress;
  final ValueChanged<int> onSelect;

  static const double _segmentGap = 3;
  static const double _groupGap = 6;
  static const double _hitHeight = 24;

  @override
  Widget build(BuildContext context) {
    int start = 0;
    final List<Widget> children = <Widget>[];
    for (int g = 0; g < groups.length; g++) {
      final int first = start;
      if (g > 0) children.add(const SizedBox(width: _groupGap));
      children.add(
        Expanded(
          flex: groups[g],
          child: Row(
            children: <Widget>[
              for (int s = 0; s < groups[g]; s++) ...<Widget>[
                if (s > 0) const SizedBox(width: _segmentGap),
                Expanded(
                  child: _Segment(
                    position: first + s - index,
                    progress: progress,
                    onTap: () => onSelect(first + s),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
      start += groups[g];
    }
    return SizedBox(height: _hitHeight, child: Row(children: children));
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.position,
    required this.progress,
    required this.onTap,
  });

  /// Negative for past, zero for current, positive for future.
  final int position;
  final Animation<double> progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: SizedBox(
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: position < 0 ? MobileTokens.accent500 : MobileTokens.n800,
              borderRadius: BorderRadius.circular(2),
              boxShadow: position == 0
                  ? <BoxShadow>[
                      BoxShadow(
                        color: MobileTokens.accentAt(0.6),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: AnimatedBuilder(
              animation: progress,
              builder: (BuildContext context, Widget? _) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: position == 0 ? progress.value : 0,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      color: MobileTokens.accent,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
