import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';

import '../../../../theme/nocturne.dart';

/// The two ways [InputModeList] can draw the same three rows: a radio list
/// (the aside, desktop) or a row of cards (sk21's mobile panel). Both bind to
/// the same [PlateInputSource] enum — only the control changes.
enum InputModeListStyle { radio, cards }

/// Which source drives the plate's characters — `System` / `Hardware` /
/// `Keypad` — as a DS radio list. Replaces the old three-button segmented
/// control; same underlying [PlateInputSource], only the control changes.
class InputModeList extends StatelessWidget {
  const InputModeList({
    super.key,
    required this.selected,
    required this.onChanged,
    this.style = InputModeListStyle.radio,
  });

  final PlateInputSource selected;
  final ValueChanged<PlateInputSource> onChanged;
  final InputModeListStyle style;

  static const Map<PlateInputSource, (String, String)> _labels =
      <PlateInputSource, (String, String)>{
        PlateInputSource.system: ('System', 'The platform keyboard.'),
        PlateInputSource.hardwareKeyboard: (
          'Hardware',
          'Physical keys only, no on-screen keyboard.',
        ),
        PlateInputSource.packageKeypad: (
          'Keypad',
          'The on-screen pad from plate_keypad.',
        ),
      };

  @override
  Widget build(BuildContext context) {
    if (style == InputModeListStyle.cards) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final MapEntry<PlateInputSource, (String, String)> e
              in _labels.entries) ...<Widget>[
            _CardRow(
              title: e.value.$1,
              description: e.value.$2,
              selected: e.key == selected,
              onTap: () => onChanged(e.key),
            ),
            if (e.key != _labels.keys.last) const SizedBox(height: 8),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final MapEntry<PlateInputSource, (String, String)> e
            in _labels.entries) ...<Widget>[
          _RadioRow(
            title: e.value.$1,
            description: e.value.$2,
            selected: e.key == selected,
            onTap: () => onChanged(e.key),
          ),
          if (e.key != _labels.keys.last) const SizedBox(height: 20),
        ],
      ],
    );
  }
}

/// sk21's mobile row: a bordered card rather than a dot. The selected card
/// carries a short accent dash at its right edge instead of a radio glyph —
/// the mobile panel has no room for the aside's dot-and-label pairing to read
/// as anything but a checkbox.
class _CardRow extends StatefulWidget {
  const _CardRow({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_CardRow> createState() => _CardRowState();
}

class _CardRowState extends State<_CardRow> {
  bool _hovered = false;

  static const double _dashWidth = 16;
  static const double _dashHeight = 2;

  @override
  Widget build(BuildContext context) {
    final Color border = widget.selected
        ? N.n500
        : _hovered
        ? N.accent700
        : N.n800;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.title,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: border, width: 1),
              borderRadius: BorderRadius.circular(NRadius.md),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontFamily: NType.archivo,
                          fontSize: 15,
                          color: N.n100,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontFamily: NType.archivo,
                          fontSize: 13,
                          color: N.n500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.selected) ...<Widget>[
                  const SizedBox(width: 12),
                  Container(
                    width: _dashWidth,
                    height: _dashHeight,
                    color: N.accent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One row: a 16px dot beside a two-line label. The dot is a plain
/// [BoxDecoration] circle, not `RadioListTile` — that brings its own padding,
/// ripple and colours the design does not use.
class _RadioRow extends StatefulWidget {
  const _RadioRow({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RadioRow> createState() => _RadioRowState();
}

class _RadioRowState extends State<_RadioRow> {
  bool _hovered = false;

  static const double _dotSize = 16;

  @override
  Widget build(BuildContext context) {
    final Color dotBorder = widget.selected
        ? N.accent
        : _hovered
        ? N.accent700
        : N.divider;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.title,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  width: _dotSize,
                  height: _dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: dotBorder, width: 1.5),
                    color: widget.selected ? N.accent : null,
                  ),
                  // The 4px inset ring in `bg` that the selected state carries.
                  child: widget.selected
                      ? Center(
                          child: Container(
                            width: _dotSize - 8,
                            height: _dotSize - 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: N.bg,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: NType.archivo,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: N.n100,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: NType.archivo,
                        fontSize: 13,
                        color: N.n500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
