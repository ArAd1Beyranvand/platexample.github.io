import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_routes.dart';
import '../theme/nocturne.dart';

/// The rail's width, and the horizontal band it claims from the shell.
///
/// Measured from the export rather than guessed: the page wrapper is
/// `grid-template-columns: minmax(0,1fr) 208px` (`Plate Gallery.dc.html`
/// line 76), so the rail column is exactly 208 CSS px. The 1px `border-left`
/// is drawn inside that track, so this is the whole painted width.
const double _kRailWidth = 208;

/// Nocturne's desktop side-nav: the sticky, full-height rail docked to the
/// right of every page above [NBreak.shell].
///
/// Transcribed from the `pg-sidenav` block (`Plate Gallery.dc.html`,
/// lines 626–646). Three sections in a column with a 64px gap — wordmark,
/// nav items, footer — the last pushed down by `margin-top: auto`.
///
/// Deliberately flat: no icons, no ripple, no indicator band. The only
/// selection cue is a 14×1px accent tick at the far right of the active row
/// plus its text lifting from [N.n500] to [N.n100].
class NocturneRail extends StatelessWidget {
  const NocturneRail({
    super.key,
    required this.tab,
    required this.onTabSelected,
    required this.onToggleView,
    this.viewLabel = 'MOBILE VIEW',
  });

  /// The rail's total width, including its left border. The shell reserves
  /// this much space for it.
  static const double width = _kRailWidth;

  /// The tab the URL currently names. The rail renders selection off this and
  /// owns none of it.
  final AppTab tab;

  /// Selecting a row asks the router to navigate; the new tab arrives back
  /// through [tab] on the next build.
  final ValueChanged<AppTab> onTabSelected;

  /// The footer pill. Swaps the app into the design's mobile-panel
  /// presentation.
  final VoidCallback onToggleView;

  /// The pill's label, which flips once the mobile panel exists.
  final String viewLabel;

  /// One label per [AppTab], in enum order. The `01`/`02`/`03` markers are the
  /// enum indexes, so a tab added to [AppTab] needs only a label here.
  static const Map<AppTab, String> _labels = <AppTab, String>{
    AppTab.showcase: 'Showcase',
    AppTab.discover: 'Discover',
    AppTab.about: 'About',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: N.divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _Wordmark(),
              const SizedBox(height: 64),
              for (final AppTab item in AppTab.values) ...<Widget>[
                if (item != AppTab.values.first) const SizedBox(height: 2),
                _RailItem(
                  number: (item.index + 1).toString().padLeft(2, '0'),
                  label: _labels[item]!,
                  isSelected: item == tab,
                  onPressed: () => onTabSelected(item),
                ),
              ],
              const Spacer(),
              const SizedBox(height: 64),
              _Footer(viewLabel: viewLabel, onToggleView: onToggleView),
            ],
          ),
        ),
      ),
    );
  }
}

/// `PLATE` / `GALLERY` on two lines with a 20×1px accent bar under it.
class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('PLATE\nGALLERY', style: NType.kicker.copyWith(color: N.n100)),
          const SizedBox(height: 14),
          Container(width: 20, height: 1, color: N.accent),
        ],
      ),
    );
  }
}

/// One nav row: `01  Showcase`, baseline-aligned, with the selection tick
/// pushed to the far right.
///
/// [FocusableActionDetector] supplies the keyboard half — focus, the
/// `:focus-visible` highlight, and Enter/Space activation. Hover is a plain
/// [MouseRegion] rather than its `onShowHoverHighlight`, which only reports
/// while the focus highlight mode is `traditional` and so silently does
/// nothing on a touch-last input. There is no [InkWell] anywhere: sk3 set
/// [NoSplash.splashFactory], and a ripple would read wrong on a flat rail.
class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.number,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String number;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    // Resting n500, hover n200, selected n100 — selection wins over hover, so
    // hovering the active row changes nothing.
    final Color foreground = widget.isSelected
        ? N.n100
        : _hovered
        ? N.n200
        : N.n500;

    // Two nested rows, not one. The number and the label share a baseline
    // (`align-items: baseline`), but the tick carries `align-self: center` —
    // and a child of a baseline-aligned row cannot opt out. So the text pair
    // is its own baseline row, and the tick centres against the outer one.
    final Widget row = Row(
      children: <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                widget.number,
                style: NType.railNumber.copyWith(color: foreground),
              ),
              const SizedBox(width: 12),
              // Flexible, not bare: the rail is a fixed 208px and a label
              // longer than the three shipped ones would otherwise overflow
              // the row rather than simply truncating.
              Flexible(
                child: Text(
                  widget.label,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: NType.body.copyWith(
                    fontSize: 15,
                    height: 1,
                    color: foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isSelected) Container(width: 14, height: 1, color: N.accent),
      ],
    );

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
              // The DS `:focus-visible` rule: a 2px accent outline at 2px
              // offset. Flutter has no outline-offset, so the ring is a
              // transparent-bordered gap plus the ring itself, drawn in the
              // 24px side padding the design already leaves.
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                border: const Border(
                  left: BorderSide(color: Colors.transparent, width: 2),
                ),
                boxShadow: _focused
                    ? const <BoxShadow>[
                        BoxShadow(color: N.bg, spreadRadius: 2),
                        BoxShadow(color: N.accent, spreadRadius: 4),
                      ]
                    : null,
              ),
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

/// The `MOBILE VIEW` pill and the three mono credit lines.
class _Footer extends StatelessWidget {
  const _Footer({required this.viewLabel, required this.onToggleView});

  final String viewLabel;
  final VoidCallback onToggleView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ViewPill(label: viewLabel, onPressed: onToggleView),
          const SizedBox(height: 18),
          Text(
            'IRAN MADE\nOPEN SOURCE\nMIT',
            style: NType.pill.copyWith(
              fontSize: 10,
              letterSpacing: 0.10 * 10,
              height: 1.8,
              color: N.n600,
            ),
          ),
        ],
      ),
    );
  }
}

/// The pill button: hover lifts its border to [N.accent700] and its text to
/// [N.n100].
class _ViewPill extends StatefulWidget {
  const _ViewPill({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_ViewPill> createState() => _ViewPillState();
}

class _ViewPillState extends State<_ViewPill> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        button: true,
        label: widget.label,
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowFocusHighlight: (bool value) =>
              setState(() => _focused = value),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: _hovered ? N.accent700 : N.n800),
                  borderRadius: BorderRadius.circular(NRadius.pill),
                  boxShadow: _focused
                      ? const <BoxShadow>[
                          BoxShadow(color: N.bg, spreadRadius: 2),
                          BoxShadow(color: N.accent, spreadRadius: 4),
                        ]
                      : null,
                ),
                child: Text(
                  widget.label,
                  style: NType.pill.copyWith(color: _hovered ? N.n100 : N.n300),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
