import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../theme/nocturne.dart';

/// MV2 mobile bottom tab bar: three equal cells with vertical hairline dividers,
/// and an animated accent bar above the active tab label.
///
/// Spec: MOBILE_SPEC.md § 1 (tab bar geometry), § 3 (current-file inventory).
/// Implementation: `AnimatedAlign` or `AnimatedSlide` to keep constant tree shape.
class MobileTabBar extends StatelessWidget {
  const MobileTabBar({
    super.key,
    required this.tab,
    required this.onTabSelected,
  });

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
              child: _TabBarItem(
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

/// One tab cell: animated accent bar above the label, both centred.
/// Spec: `min-height 60`, `border-right` n800 per cell (except last), gap 7 between bar and label.
class _TabBarItem extends StatelessWidget {
  const _TabBarItem({
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
  Widget build(BuildContext context) {
    final Color foreground = isSelected ? N.n100 : N.n500;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            border: isLast ? null : const Border(right: BorderSide(color: N.n800)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Animated accent bar: 16×2, slides in/out with constant tree shape
              AnimatedAlign(
                alignment: isSelected ? Alignment.center : const Alignment(0, -1),
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 16,
                  height: 2,
                  color: isSelected ? N.accent : Colors.transparent,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label.toUpperCase(),
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
    );
  }
}
