import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design/tokens.dart';

/// A tappable box with the DS hover fill, press scale and focus ring
/// (2px `bg` gap + 2px `accent`). Everything clickable on the site is one.
class PdTappable extends StatefulWidget {
  const PdTappable({
    super.key,
    required this.onTap,
    required this.child,
    this.radius = PdRadius.chip,
    this.color,
    this.hoverColor,
    this.border,
    this.pressScale = 1,
    this.brighten = false,
    this.semanticLabel,
    this.selected,
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double radius;
  final Color? color;
  final Color? hoverColor;
  final Color? border;
  final double pressScale;

  /// Hover as `brightness(1.08)` instead of a fill swap (accent buttons).
  final bool brighten;
  final String? semanticLabel;
  final bool? selected;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? width;

  @override
  State<PdTappable> createState() => _PdTappableState();
}

class _PdTappableState extends State<PdTappable> {
  bool _hover = false;
  bool _focus = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final bool enabled = widget.onTap != null;
    final Duration d = PdMotion.of(context, PdMotion.select);
    Color? fill = widget.color;
    if (_hover && enabled) {
      fill = widget.brighten && fill != null
          ? Color.lerp(fill, Colors.white, 0.08)
          : (widget.hoverColor ?? fill);
    }
    final BorderRadius r = BorderRadius.circular(widget.radius);

    Widget box = AnimatedContainer(
      duration: d,
      curve: PdMotion.selectCurve,
      height: widget.height,
      width: widget.width,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: fill ?? Colors.transparent,
        borderRadius: r,
        border: widget.border == null
            ? null
            : Border.all(color: widget.border!),
      ),
      child: widget.child,
    );
    box = AnimatedScale(
      duration: d,
      scale: _down && enabled ? widget.pressScale : 1,
      child: box,
    );
    box = Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        box,
        if (_focus)
          Positioned(
            left: -4,
            top: -4,
            right: -4,
            bottom: -4,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius + 4),
                  border: Border.all(color: t.accent, width: 2),
                ),
              ),
            ),
          ),
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      selected: widget.selected,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onShowHoverHighlight: (bool v) => setState(() => _hover = v),
        onShowFocusHighlight: (bool v) => setState(() => _focus = v),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => widget.onTap?.call(),
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _down = true),
          onTapCancel: () => setState(() => _down = false),
          onTapUp: (_) => setState(() => _down = false),
          onTap: widget.onTap,
          child: box,
        ),
      ),
    );
  }
}

enum PdButtonKind { primary, outline }

class PdButton extends StatelessWidget {
  const PdButton({
    super.key,
    required this.label,
    required this.onTap,
    this.kind = PdButtonKind.primary,
  });

  final String label;
  final VoidCallback onTap;
  final PdButtonKind kind;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final bool primary = kind == PdButtonKind.primary;
    return PdTappable(
      onTap: onTap,
      radius: PdRadius.card,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: primary ? t.accent : null,
      brighten: primary,
      hoverColor: primary ? null : t.surface,
      border: primary ? null : t.control,
      pressScale: 0.98,
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: primary ? t.onAccent : t.text,
          ),
        ),
      ),
    );
  }
}

/// A "Copy" button that reads "Copied" for 1.5 s after a tap.
class PdCopyButton extends StatefulWidget {
  const PdCopyButton({super.key, required this.text});

  final String Function() text;

  @override
  State<PdCopyButton> createState() => _PdCopyButtonState();
}

class _PdCopyButtonState extends State<PdCopyButton> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.text()));
    _timer?.cancel();
    setState(() {
      _timer = Timer(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() => _timer = null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final bool copied = _timer != null;
    return PdTappable(
      onTap: _copy,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      hoverColor: t.surface,
      border: t.divider,
      child: Center(
        widthFactor: 1,
        child: Text(
          copied ? 'Copied' : 'Copy',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: copied ? t.ok : t.muted,
          ),
        ),
      ),
    );
  }
}

/// Inline accent text link.
class PdLink extends StatelessWidget {
  const PdLink(this.label, {super.key, required this.onTap, this.style});

  final String label;
  final VoidCallback onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => PdTappable(
    onTap: onTap,
    radius: 4,
    child: Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: context.tokens.accent,
      ).merge(style),
    ),
  );
}

Future<void> openExternal(String url) =>
    launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');

/// The DS section container: max 1200, centred, padding x clamp(16,3vw,32).
class PdContainer extends StatelessWidget {
  const PdContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: pdClamp(context, 16, 3, 32)),
        child: child,
      ),
    ),
  );
}

/// The CSS `grid auto-fit minmax(min(100%, min), 1fr)` the mock uses
/// everywhere: as many equal columns of at least [minWidth] as fit.
class PdAutoGrid extends StatelessWidget {
  const PdAutoGrid({
    super.key,
    required this.minWidth,
    required this.gap,
    required this.children,
    this.rowGap,
  });

  final double minWidth;
  final double gap;
  final double? rowGap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints c) {
      final int cols = ((c.maxWidth + gap) / (minWidth + gap)).floor().clamp(
        1,
        children.length,
      );
      final double w = (c.maxWidth - gap * (cols - 1)) / cols;
      final List<Widget> rows = <Widget>[];
      for (int i = 0; i < children.length; i += cols) {
        final List<Widget> cells = children.sublist(
          i,
          (i + cols).clamp(0, children.length),
        );
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int j = 0; j < cols; j++) ...<Widget>[
                if (j > 0) SizedBox(width: gap),
                SizedBox(width: w, child: j < cells.length ? cells[j] : null),
              ],
            ],
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            if (i > 0) SizedBox(height: rowGap ?? gap),
            rows[i],
          ],
        ],
      );
    },
  );
}
