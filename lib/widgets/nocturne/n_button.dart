import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/nocturne.dart';

/// The three button treatments Nocturne ships: `.btn-primary`,
/// `.btn-secondary` and `.btn-ghost`.
///
/// All three share the `.btn` ground — transparent fill, a 1px border, radius
/// `md` — and differ only in which colour that border and the label take, and
/// what the hover / active fill is.
enum NButtonVariant {
  /// `.btn-primary`: accent text and an accent border. Hover fills accent at
  /// 12%, pressing at 22%.
  primary,

  /// `.btn-secondary`: [N.text] label over a divider-coloured border. Hover
  /// fills text at 7%, pressing at 14%.
  secondary,

  /// `.btn-ghost`: accent text, no border, tighter side padding. Hover fills
  /// accent at 10%, pressing at 18%.
  ghost,
}

/// Nocturne's `.btn`, transcribed from the design system's `styles.css`
/// (`.btn`, lines 137–159).
///
/// Deliberately not a Material [OutlinedButton] wearing a theme: the design's
/// states are plain fills with no ripple, no elevation and no shape animation,
/// and every Material button brings machinery for all three. Hover and press
/// are tracked here the same way [NocturneRail] tracks them, so the whole
/// design system behaves identically under a mouse.
class NButton extends StatefulWidget {
  const NButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = NButtonVariant.secondary,
    this.fontSize = 14,
    this.padding,
  });

  final String label;
  final VoidCallback onPressed;
  final NButtonVariant variant;

  /// `.btn` is 14px; the showcase hero overrides its pair to 15px.
  final double fontSize;

  /// Defaults to the DS padding for [variant]. The hero overrides it to
  /// `11px 22px`.
  final EdgeInsetsGeometry? padding;

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  /// `padding: var(--space-2) calc(var(--space-3) * 1.2)`, with `.btn-ghost`'s
  /// `padding-inline: var(--space-1)` override.
  EdgeInsetsGeometry get _padding =>
      widget.padding ??
      EdgeInsets.symmetric(
        vertical: NSpace.s2,
        horizontal: widget.variant == NButtonVariant.ghost ? NSpace.s1 : NSpace.s3 * 1.2,
      );

  Color? get _fill {
    if (!_hovered && !_pressed) return null;
    return switch (widget.variant) {
      NButtonVariant.primary => N.accentAt(_pressed ? 0.22 : 0.12),
      NButtonVariant.secondary => N.textAt(_pressed ? 0.14 : 0.07),
      NButtonVariant.ghost => N.accentAt(_pressed ? 0.18 : 0.10),
    };
  }

  Color get _border => switch (widget.variant) {
    NButtonVariant.primary => N.accent,
    NButtonVariant.secondary => N.divider,
    NButtonVariant.ghost => Colors.transparent,
  };

  Color get _foreground => switch (widget.variant) {
    NButtonVariant.primary || NButtonVariant.ghost => N.accent,
    NButtonVariant.secondary => N.text,
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (bool value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: widget.onPressed,
            child: Container(
              padding: _padding,
              decoration: BoxDecoration(
                color: _fill,
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(NRadius.md),
                // The DS `:focus-visible` ring, drawn the same way the rail
                // draws it: a bg-coloured spread to fake `outline-offset`,
                // then the accent ring itself.
                boxShadow: _focused
                    ? const <BoxShadow>[
                        BoxShadow(color: N.bg, spreadRadius: 2),
                        BoxShadow(color: N.accent, spreadRadius: 4),
                      ]
                    : null,
              ),
              child: Text(
                widget.label,
                // Inert at the DS's own width, where the button hugs its
                // label. It matters when a caller stretches one — the hero's
                // phone-panel pair goes full-width — because the Text then
                // fills the row and would otherwise sit against the left edge.
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: NType.archivo,
                  // `--font-heading-weight: 800`.
                  fontWeight: FontWeight.w800,
                  fontSize: widget.fontSize,
                  height: 1.2,
                  color: _foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
