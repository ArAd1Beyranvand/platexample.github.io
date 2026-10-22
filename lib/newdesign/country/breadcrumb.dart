import 'package:flutter/material.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../design/tokens.dart';
import '../widgets/controls.dart';

/// One trail of links ending in the current page's own name, which is text
/// rather than a link. Shared by the country and region pages.
class PdBreadcrumb extends StatelessWidget {
  const PdBreadcrumb({super.key, required this.trail, required this.current});

  /// The ancestors, outermost first, each with the page it opens.
  final List<(String, PdLocation)> trail;

  final String current;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final TextStyle style = TextStyle(fontSize: 14, color: t.muted);
    return SizedBox(
      height: 40,
      child: Row(
        children: <Widget>[
          for (final (String label, PdLocation target) in trail) ...<Widget>[
            PdTappable(
              onTap: () => nav.go(target),
              radius: 4,
              child: Text(label, style: style),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('/', style: TextStyle(color: t.subtle)),
            ),
          ],
          Flexible(
            child: Text(
              current,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: t.text),
            ),
          ),
        ],
      ),
    );
  }
}

/// The `flutter pub add ...` line with its Copy button, as the country page
/// and the playground both head their page with.
class PdInstallBar extends StatelessWidget {
  const PdInstallBar({super.key, required this.command});

  final String command;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Container(
      height: 44,
      padding: const EdgeInsets.only(left: 14, right: 6),
      decoration: BoxDecoration(
        color: t.code,
        borderRadius: BorderRadius.circular(PdRadius.chip),
        border: Border.all(color: t.divider),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              command,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: PdFonts.mono, fontSize: 13, color: t.text),
            ),
          ),
          const SizedBox(width: 8),
          PdCopyButton(text: () => command),
        ],
      ),
    );
  }
}
