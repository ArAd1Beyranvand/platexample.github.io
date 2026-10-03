import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../theme/nocturne.dart';

/// MV2 mobile header: the `PLATE GALLERY` wordmark on the left (with leading
/// accent dash), and the active tab index / name on the right (`01 / SHOWCASE`).
///
/// Spec: MOBILE_SPEC.md § 1 (header), § 3 (current-file inventory).
class MobileHeader extends StatelessWidget implements PreferredSizeWidget {
  const MobileHeader({super.key, required this.tab});

  /// The tab the URL currently names, used to derive the right-hand label.
  final AppTab tab;

  static const double height = 15 * 2 + 16;

  static const Map<AppTab, String> _labels = <AppTab, String>{
    AppTab.showcase: 'SHOWCASE',
    AppTab.discover: 'DISCOVER',
    AppTab.about: 'ABOUT',
  };

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final int tabIndex = tab.index + 1;
    final String tabLabel = _labels[tab]!;

    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: N.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Left: accent dash + 'PLATE GALLERY'
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 16, height: 1, color: N.accent),
                const SizedBox(width: 10),
                Text(
                  'PLATE GALLERY',
                  style: TextStyle(
                    fontFamily: NType.mono,
                    fontSize: 10,
                    letterSpacing: 0.14 * 10,
                    color: N.n100,
                  ),
                ),
              ],
            ),
            // Right: '01 / SHOWCASE' (tab index / name)
            Text(
              '${tabIndex.toString().padLeft(2, '0')} / $tabLabel',
              style: TextStyle(
                fontFamily: NType.mono,
                fontSize: 9.5,
                letterSpacing: 0.12 * 9.5,
                color: N.n600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
