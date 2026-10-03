import 'package:flutter/material.dart';

import '../theme/nocturne.dart';

/// MV2 mobile header: the `PLATE GALLERY` wordmark on the left (with leading
/// accent dash), and the shell's label on the right (`01 / SHOWCASE`).
///
/// Spec: MOBILE_SPEC.md § 1 (header), § 3 (current-file inventory).
class MobileHeader extends StatelessWidget implements PreferredSizeWidget {
  const MobileHeader({super.key, required this.label});

  /// The right-hand text, or nothing where the page names itself.
  final String? label;

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
            if (label != null)
              Text(
                label!,
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
