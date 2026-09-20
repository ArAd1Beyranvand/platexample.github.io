import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/nocturne.dart';

/// One cell of an [NSegmented] — the value it selects and the text it shows.
@immutable
class NSegmentedOption<T> {
  const NSegmentedOption({required this.value, required this.label});

  final T value;

  /// Uppercased at paint time, the way `text-transform: uppercase` would.
  final String label;
}

/// Nocturne's `.seg`, transcribed from the design system's `styles.css`
/// (`.seg` / `.seg-opt`, lines 189–200).
///
/// One rounded `md` box with a divider border; the cells inside it are split
/// by a 1px divider rather than spaced apart. The selected cell takes accent
/// text plus an `inset 0 0 0 1px` accent ring — drawn as a
/// [Container.foregroundDecoration] so that the ring, unlike a real [Border],
/// costs the cell no layout width and the selection cannot nudge its
/// neighbours by a pixel.
class NSegmented<T> extends StatelessWidget {
  const NSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<NSegmentedOption<T>> options;

  /// The selected value. Null selects nothing, which is legal: the cells are
  /// radio-like, and the design has no "all off" state but nothing here
  /// forbids one.
  final T? value;

  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: N.divider),
        borderRadius: BorderRadius.circular(NRadius.md),
      ),
      // `overflow: hidden` — the first and last cells' hover fills have to be
      // cut to the box's own corners.
      child: ClipRRect(
        // Inset by the 1px border the DecoratedBox draws, so the clip follows
        // the inside of the stroke rather than sitting on top of it.
        borderRadius: BorderRadius.circular(NRadius.md - 1),
        // The separators run the full height of the tallest cell, which is
        // only knowable once the cells have been laid out — hence the
        // intrinsic pass. Three cells make it cheap.
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < options.length; i++) ...<Widget>[
                // `.seg-opt + .seg-opt { border-left: 1px solid divider }`.
                if (i > 0) const _Separator(),
                _SegmentedCell<T>(
                  label: options[i].label,
                  isSelected: options[i].value == value,
                  onPressed: () => onChanged(options[i].value),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 1, child: ColoredBox(color: N.divider));
  }
}

class _SegmentedCell<T> extends StatefulWidget {
  const _SegmentedCell({required this.label, required this.isSelected, required this.onPressed});

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<_SegmentedCell<T>> createState() => _SegmentedCellState<T>();
}

class _SegmentedCellState<T> extends State<_SegmentedCell<T>> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    // Selection wins over hover: `.seg-opt:not(:has(input:checked)):hover` only
    // fills the cells that are not already chosen.
    final bool fills = _hovered && !widget.isSelected;

    return Semantics(
      button: true,
      selected: widget.isSelected,
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
            onTap: widget.onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              color: fills ? N.textAt(0.07) : null,
              // The checked cell's `inset 0 0 0 1px accent` ring, and the
              // `:focus-visible` outline at `outline-offset: -2px` — both are
              // drawn over the cell, inside its bounds.
              foregroundDecoration: widget.isSelected || _focused
                  ? BoxDecoration(
                      border: Border.all(color: N.accent, width: _focused ? 2 : 1),
                    )
                  : null,
              child: Text(
                widget.label.toUpperCase(),
                style: NType.pill.copyWith(color: widget.isSelected ? N.accent : N.text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
