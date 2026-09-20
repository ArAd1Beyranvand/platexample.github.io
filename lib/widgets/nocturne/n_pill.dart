import 'package:flutter/widgets.dart';

import '../../theme/nocturne.dart';

/// The design's `pg-stamp`: a small accent dot and a line of uppercase mono
/// inside a fully rounded box with an [N.n800] hairline.
///
/// Transcribed from `design_ref/Plate Gallery.dc.html` line 158 — `radius:999`,
/// `padding: 8px 14px`, a 6px dot, a 10px gap, and a ground of
/// `rgba(18,20,30,.92)` so the stamp stays legible wherever it lands on the
/// backdrop.
class NPill extends StatelessWidget {
  const NPill({super.key, required this.label, this.showDot = true});

  /// Uppercased at paint time, the way `text-transform: uppercase` would.
  final String label;

  /// The leading accent dot. Off for the pills that are pure text.
  final bool showDot;

  /// `rgba(18,20,30,.92)`.
  static const Color _ground = Color(0xEB12141E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _ground,
        border: Border.all(color: N.n800),
        borderRadius: BorderRadius.circular(NRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showDot) ...<Widget>[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: N.accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
          ],
          Text(label.toUpperCase(), style: NType.pill.copyWith(color: N.n300)),
        ],
      ),
    );
  }
}
