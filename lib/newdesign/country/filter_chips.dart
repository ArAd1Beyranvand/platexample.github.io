import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../widgets/controls.dart';

/// A pill, optionally with the count of what it selects, drawn accent-soft
/// when it is the live one. Both new pages filter with a row of these.
class PdFilterChip extends StatelessWidget {
  const PdFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      radius: 999,
      height: 36,
      selected: selected,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: selected ? t.accentSoft : null,
      border: selected ? t.accent : t.divider,
      hoverColor: selected ? null : t.surface,
      child: Center(
        widthFactor: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: selected ? t.text : t.muted,
              ),
            ),
            if (count != null) ...<Widget>[
              const SizedBox(width: 6),
              Text('$count', style: TextStyle(fontSize: 12, color: t.subtle)),
            ],
          ],
        ),
      ),
    );
  }
}

/// [PdFilterChip]s that wrap, with the mock's 6px gaps.
class PdFilterRow extends StatelessWidget {
  const PdFilterRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) =>
      Wrap(spacing: 6, runSpacing: 6, children: children);
}
