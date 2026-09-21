import 'package:flutter/material.dart';

import '../../../theme/nocturne.dart';

/// A small-caps mono label that says what kind of thing follows —
/// `COUNTRIES`, `DETAILS`, `BUILT AGAINST`, `02 — DISCOVER`.
///
/// Nocturne's `kicker`: 11px MartianMono at `+0.12em`, uppercased at the call
/// site because CSS's `text-transform` has no Flutter equivalent. Was
/// Material's `labelSmall` in Archivo, which put the one piece of small text
/// that has to be *found* in the same face and colour as the small print it
/// sits above.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;

  /// Defaults to [N.n500]. The Discover header's `02 — Discover` passes
  /// [N.accent300]; a country detail page passes its country's own colour.
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: NType.kicker.copyWith(color: color ?? N.n500),
  );
}

/// The heading over a run of plates: an optional eyebrow, a title, a count,
/// and the paragraph explaining what the run is.
///
/// The old `SectionHeader` put the title *in* the eyebrow — small, uppercase,
/// letterspaced and coloured — which made "System B — 1993 northern, car"
/// read as a label rather than as a heading and left the section with no
/// visual anchor at all. Title in title type, eyebrow above it for the
/// category, count set quietly to the right.
class SectionIntro extends StatelessWidget {
  const SectionIntro({super.key, required this.title, this.eyebrow, this.note, this.count, this.trailing});

  final String title;
  final String? eyebrow;
  final String? note;
  final int? count;

  /// An action sitting on the heading's baseline — `All plates →`, typically.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final String? eyebrow = this.eyebrow;
    final String? note = this.note;
    final int? count = this.count;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (eyebrow != null) ...<Widget>[Eyebrow(eyebrow), const SizedBox(height: NSpace.s2)],
        Row(
          children: <Widget>[
            Flexible(child: Text(title, style: NType.h4)),
            if (count != null) ...<Widget>[const SizedBox(width: NSpace.s3), _Count(count)],
            const Spacer(),
            ?trailing,
          ],
        ),
        if (note != null) ...<Widget>[
          const SizedBox(height: NSpace.s3),
          // Capped: these notes are two to four lines of real explanation,
          // and full-window measure at desktop widths is unreadable.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              note,
              style: const TextStyle(fontFamily: NType.serif, fontSize: 15, height: 1.5, color: N.n400),
            ),
          ),
        ],
      ],
    );
  }
}

/// A count, as a pill rather than a bare number — at kicker size next to a
/// 20px heading a loose digit reads as a typo.
class _Count extends StatelessWidget {
  const _Count(this.value);

  final int value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: NSpace.s3, vertical: 2),
    decoration: BoxDecoration(
      color: N.n900,
      borderRadius: BorderRadius.circular(NRadius.sm),
      border: Border.all(color: N.n800),
    ),
    child: Text('$value', style: NType.specId.copyWith(color: N.n500)),
  );
}

/// A titled box the playground's pickers sit in.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Eyebrow(title),
      const SizedBox(height: NSpace.s3),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: NSpace.s6, vertical: NSpace.s3),
        decoration: BoxDecoration(
          color: N.n900,
          borderRadius: BorderRadius.circular(NRadius.lg),
          border: Border.all(color: N.n800),
        ),
        child: child,
      ),
    ],
  );
}
