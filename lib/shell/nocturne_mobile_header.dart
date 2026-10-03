import 'package:flutter/material.dart';

import '../theme/nocturne.dart';

/// The mobile top bar: the `Plate Gallery` wordmark on the left, an optional
/// contextual control on the right.
///
/// Transcribed from the mobile `<header>` block (`Plate Gallery.dc.html`,
/// lines 341–346) — `space-between`, `gap: 12px`, `padding: 15px 18px`,
/// `border-bottom: 1px divider`. The design shows a screen label
/// (`{{ screenLabel }}`) on the right for the three top-level screens and a
/// back arrow on detail; [trailing] is deliberately generic so either can be
/// passed without this widget knowing about routes.
class NocturneMobileHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const NocturneMobileHeader({super.key, this.trailing});

  /// The right-hand control — a screen label, a back button, or nothing.
  final Widget? trailing;

  static const double height = 15 * 2 + 16;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: N.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
            ?trailing,
          ],
        ),
      ),
    );
  }
}
