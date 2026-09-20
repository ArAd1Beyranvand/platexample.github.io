import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../theme/nocturne.dart';

/// Nocturne's mobile bottom nav: a three-column grid docked to the bottom of
/// the window below [NBreak.shell].
///
/// Transcribed from the mobile bottom `<nav>` block (`Plate Gallery.dc.html`,
/// lines 601–614) — label only, no `01`/`02`/`03` marker; those belong to
/// [NocturneRail] and the mobile header's trailing text, not this bar. Flat,
/// like the rail: no [Material] nav widget, no ripple, no indicator
/// animation beyond the colour and accent-bar swap.
class NocturneBottomBar extends StatelessWidget {
  const NocturneBottomBar({super.key, required this.tab, required this.onTabSelected});

  /// The tab the URL currently names.
  final AppTab tab;

  /// Selecting a cell asks the router to navigate; the new tab arrives back
  /// through [tab] on the next build.
  final ValueChanged<AppTab> onTabSelected;

  static const Map<AppTab, String> _labels = <AppTab, String>{
    AppTab.showcase: 'Showcase',
    AppTab.discover: 'Discover',
    AppTab.about: 'About',
  };

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: N.n900,
        border: Border(top: BorderSide(color: N.divider)),
      ),
      child: Row(
        children: <Widget>[
          for (final AppTab item in AppTab.values)
            Expanded(
              child: _BottomBarItem(
                label: _labels[item]!,
                isSelected: item == tab,
                isLast: item == AppTab.values.last,
                onPressed: () => onTabSelected(item),
              ),
            ),
        ],
      ),
    );
  }
}

/// One cell: the selection accent bar above the label, both centred in a
/// column — `min-height: 60px` per the design.
class _BottomBarItem extends StatefulWidget {
  const _BottomBarItem({
    required this.label,
    required this.isSelected,
    required this.isLast,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onPressed;

  @override
  State<_BottomBarItem> createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<_BottomBarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color foreground = widget.isSelected
        ? N.n100
        : _hovered
        ? N.n200
        : N.n500;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            decoration: BoxDecoration(
              border: widget.isLast
                  ? null
                  : const Border(right: BorderSide(color: N.n800)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(width: 18, height: 2, color: widget.isSelected ? N.accent : Colors.transparent),
                const SizedBox(height: 7),
                Text(
                  widget.label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: NType.mono,
                    fontSize: 10,
                    letterSpacing: 0.11 * 10,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
