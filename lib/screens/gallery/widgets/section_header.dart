import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A small-caps label that says what kind of thing follows.
///
/// Deliberately the loudest small text in the app: it is the only thing
/// giving a long scroll its structure, and it has to be findable by someone
/// skimming past it at speed.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(color: color ?? theme.colorScheme.onSurfaceVariant),
    );
  }
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

  /// An action sitting on the heading's baseline — "More", typically.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? eyebrow = this.eyebrow;
    final String? note = this.note;
    final int? count = this.count;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (eyebrow != null) ...<Widget>[Eyebrow(eyebrow), const SizedBox(height: Gap.xs)],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(child: Text(title, style: theme.textTheme.titleLarge)),
            if (count != null) ...<Widget>[const SizedBox(width: Gap.sm), _Count(count)],
            const Spacer(),
            ?trailing,
          ],
        ),
        if (note != null) ...<Widget>[
          const SizedBox(height: Gap.sm),
          // Capped: these notes are two to four lines of real explanation,
          // and full-window measure at desktop widths is unreadable.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45),
            ),
          ),
        ],
      ],
    );
  }
}

/// A count, as a pill rather than a bare number — at `labelSmall` next to a
/// `titleLarge` a loose digit reads as a typo.
class _Count extends StatelessWidget {
  const _Count(this.value);

  final int value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: 2),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHigh, borderRadius: Radii.smAll),
      child: Text('$value', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }
}

/// A titled card the playground's pickers sit in.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Eyebrow(title),
        const SizedBox(height: Gap.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: Radii.mdAll,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ],
    );
  }
}
