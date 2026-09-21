import 'package:flutter/widgets.dart';

import '../../theme/nocturne.dart';
import '../gallery/catalogue_stats.dart';

/// The Showcase section's bottom row: `PACKAGES · COUNTRIES · SPECS ·
/// FORM FACTORS`, in equal columns behind solid [N.divider] verticals.
///
/// Transcribed from `.pg-statband` in `design_ref/Plate Gallery.dc.html`
/// (lines 164–171): a `border-top` across the whole band, then four cells at
/// `margin-left: 72px; border-left: 1px; padding: 26px 32px 30px 24px` each —
/// a 34px w800 number over an 11px MartianMono uppercase label at `+0.11em`,
/// `n500`. Two columns under [NBreak.stats].
///
/// The design's own 2-column media query stops at 760px, well inside tablet
/// territory — it never anticipated the 72px inset landing on a ~195px phone
/// half-column, where it eats the cell down to nothing and wraps `PACKAGES`
/// mid-word. [_StatMetrics] adds a third, narrower tier below 480px that
/// shrinks the inset and the number instead, the same escape hatch the hero
/// already uses for its own phone panel.
///
/// The dividers between cells are solid box borders here, not [NRule]:
/// Nocturne's fade-at-the-ends treatment is for freestanding rules, and these
/// are separators inside a bordered grid.
class StatBand extends StatelessWidget {
  const StatBand({super.key, required this.stats});

  final CatalogueStats stats;

  static const double _compactBreak = 480;

  List<_Stat> get _cells => <_Stat>[
    for (final ({int value, String label}) tile in stats.tiles) _Stat(tile.value, tile.label),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: N.divider))),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
          final int columns = width >= NBreak.stats ? 4 : 2;
          final _StatMetrics metrics = switch (width) {
            >= NBreak.stats => _StatMetrics.wide(),
            >= _compactBreak => _StatMetrics.cozy(),
            _ => _StatMetrics.compact(),
          };
          final double columnWidth = width / columns;
          return Wrap(
            children: <Widget>[
              for (final _Stat stat in _cells)
                SizedBox(width: columnWidth, child: _StatCell(stat: stat, metrics: metrics)),
            ],
          );
        },
      ),
    );
  }
}

@immutable
class _Stat {
  const _Stat(this.value, this.label);

  final int value;
  final String label;
}

/// The inset and type sizes of one cell, at one width tier. Three sets rather
/// than an interpolated scale, same reasoning as `_HeroMetrics`: the design
/// gives exact values for the widest tier and nothing below it, so the
/// narrower tiers are judgement calls, not a curve fitted through a number
/// the source never gave.
@immutable
class _StatMetrics {
  const _StatMetrics({
    required this.margin,
    required this.padding,
    required this.numberSize,
    required this.labelSize,
    required this.gap,
  });

  /// The design's own values, verbatim.
  factory _StatMetrics.wide() => const _StatMetrics(
    margin: 72,
    padding: EdgeInsets.fromLTRB(24, 26, 32, 30),
    numberSize: 34,
    labelSize: 11,
    gap: 8,
  );

  /// Tablet-width two-column: the inset shrinks with the column instead of
  /// eating a bigger share of it.
  factory _StatMetrics.cozy() => const _StatMetrics(
    margin: 32,
    padding: EdgeInsets.fromLTRB(NSpace.s6, 22, NSpace.s6, 26),
    numberSize: 30,
    labelSize: 11,
    gap: 8,
  );

  /// Phone width: no left margin at all, and a smaller number — the two
  /// column halves are ~150–195px wide here, and every pixel of inset is a
  /// pixel the longest label, `FORM FACTORS`, doesn't have.
  factory _StatMetrics.compact() => const _StatMetrics(
    margin: 0,
    padding: EdgeInsets.fromLTRB(NSpace.s4, NSpace.s6, NSpace.s4, NSpace.s6),
    numberSize: 26,
    labelSize: 10,
    gap: 6,
  );

  final double margin;
  final EdgeInsets padding;
  final double numberSize;
  final double labelSize;
  final double gap;
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.stat, required this.metrics});

  final _Stat stat;
  final _StatMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: metrics.margin),
      padding: metrics.padding,
      decoration: const BoxDecoration(border: Border(left: BorderSide(color: N.divider))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${stat.value}',
            style: TextStyle(
              fontFamily: NType.archivo,
              fontWeight: FontWeight.w800,
              fontSize: metrics.numberSize,
              height: 1,
              letterSpacing: -0.025 * metrics.numberSize,
              color: N.n100,
            ),
          ),
          SizedBox(height: metrics.gap),
          Text(
            stat.label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: NType.kicker.copyWith(
              fontSize: metrics.labelSize,
              letterSpacing: 0.11 * metrics.labelSize,
              color: N.n500,
            ),
          ),
        ],
      ),
    );
  }
}
