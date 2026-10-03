import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'mobile_tokens.dart';

/// Outlined odometer counter: the last column charges with [dwell], columns
/// roll when their digit changes, and a wrap to 1 rewinds downward.
///
/// Repaint-only: per-frame motion runs through the painter, never `build`.
class RollingNumeral extends StatefulWidget {
  const RollingNumeral({
    super.key,
    required this.value,
    required this.count,
    required this.dwell,
    required this.style,
    this.paused = false,
  });

  /// 1-based position shown.
  final int value;
  final int count;
  final ValueListenable<double> dwell;
  final TextStyle style;
  final bool paused;

  static const Duration roll = Duration(milliseconds: 520);
  static const Duration rewind = Duration(milliseconds: 760);
  static const Duration fade = Duration(milliseconds: 150);
  static const Duration breathe = Duration(milliseconds: 800);

  @override
  State<RollingNumeral> createState() => _RollingNumeralState();
}

class _RollingNumeralState extends State<RollingNumeral>
    with TickerProviderStateMixin {
  late final AnimationController _roll = AnimationController(vsync: this)
    ..value = 1;
  AnimationController? _breathe;

  late _Columns _columns = _Columns.at(widget.value, _width);
  _Glyphs? _glyphs;
  bool _reduced = false;

  int get _width => math.max(2, '${widget.count}'.length);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.disableAnimationsOf(context);
    _relayout();
    _syncBreathe();
  }

  @override
  void didUpdateWidget(RollingNumeral old) {
    super.didUpdateWidget(old);
    if (old.style != widget.style) _relayout();
    if (old.count != widget.count) {
      _columns = _Columns.at(widget.value, _width);
      _roll.value = 1;
    } else if (old.value != widget.value) {
      _start(old.value, widget.value);
    }
    if (old.paused != widget.paused) _syncBreathe();
  }

  void _relayout() {
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    _glyphs?.dispose();
    _glyphs = _Glyphs(widget.style, scaler);
  }

  void _start(int from, int to) {
    final bool wrap = from == widget.count && to == 1 && widget.count > 1;
    final bool back = to < from && !wrap;
    _columns = _columns.toward(
      _Columns.digits(to, _width),
      _roll.value,
      down: back || wrap,
    );
    _roll.duration = _reduced
        ? RollingNumeral.fade
        : wrap
        ? RollingNumeral.rewind
        : RollingNumeral.roll;
    _columns.curve = wrap ? Curves.easeInOutCubic : Curves.easeOutBack;
    _roll.forward(from: 0);
  }

  void _syncBreathe() {
    final bool want = widget.paused && !_reduced;
    if (want && _breathe == null) {
      _breathe = AnimationController(
        vsync: this,
        duration: RollingNumeral.breathe,
      )..repeat(reverse: true);
    } else if (!want && _breathe != null) {
      _breathe!.dispose();
      _breathe = null;
    }
  }

  @override
  void dispose() {
    _roll.dispose();
    _breathe?.dispose();
    _glyphs?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _Glyphs glyphs = _glyphs!;
    return RepaintBoundary(
      child: IgnorePointer(
        child: CustomPaint(
          size: Size(glyphs.advance * _width, glyphs.height),
          painter: _NumeralPainter(
            glyphs: glyphs,
            columns: _columns,
            roll: _roll,
            dwell: widget.dwell,
            breathe: _breathe,
            reduced: _reduced,
          ),
        ),
      ),
    );
  }
}

/// Per-column roll endpoints; the painter interpolates them by roll value.
class _Columns {
  _Columns(this.from, this.to);

  _Columns.at(int value, int width)
    : from = digits(value, width).map((int d) => d.toDouble()).toList(),
      to = digits(value, width).map((int d) => d.toDouble()).toList();

  final List<double> from;
  final List<double> to;
  Curve curve = Curves.easeOutBack;

  static List<int> digits(int value, int width) =>
      '$value'.padLeft(width, '0').split('').map(int.parse).toList();

  double at(int column, double t) {
    final double a = from[column];
    final double b = to[column];
    return a == b ? b : a + (b - a) * curve.transform(t);
  }

  /// Starts from wherever each column is at roll value [t]. Only columns
  /// whose digit changes move; forward rolls go up, [down] rolls go down.
  _Columns toward(List<int> target, double t, {required bool down}) {
    final List<double> start = <double>[];
    final List<double> end = <double>[];
    for (int i = 0; i < target.length; i++) {
      final double now = at(i, t) % 10;
      final double settled = to[i] % 10;
      double a = now;
      double b = target[i].toDouble();
      if (b != settled) {
        if (down && b > a) a += 10;
        if (!down && b < a) b += 10;
      } else {
        b = settled;
      }
      start.add(a);
      end.add(b);
    }
    return _Columns(start, end);
  }
}

/// 20 laid-out painters (digits 0–9 × stroke / fill), built once per style.
class _Glyphs {
  _Glyphs(TextStyle style, TextScaler scaler) {
    final TextStyle base = style.copyWith(
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
    TextPainter make(int d, Paint paint) => TextPainter(
      text: TextSpan(
        text: '$d',
        style: base.copyWith(foreground: paint),
      ),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
    )..layout();
    for (int d = 0; d < 10; d++) {
      stroke.add(make(d, _white));
      fill.add(make(d, _fill));
    }
    advance = stroke.map((TextPainter p) => p.width).reduce(math.max);
    height = stroke.first.height;
    baseline = stroke.first.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    capHeight = scaler.scale(style.fontSize ?? 14) * 0.72;
  }

  static const double strokeWidth = 1.4;

  // Strokes are laid out white and tinted per layer with srcIn.
  static final Paint _white = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth
    ..color = const Color(0xFFFFFFFF);
  static final Paint _fill = Paint()..color = MobileTokens.accentAt(0.14);

  final List<TextPainter> stroke = <TextPainter>[];
  final List<TextPainter> fill = <TextPainter>[];
  late final double advance;
  late final double height;
  late final double baseline;
  late final double capHeight;

  void dispose() {
    for (final TextPainter p in <TextPainter>[...stroke, ...fill]) {
      p.dispose();
    }
  }
}

class _NumeralPainter extends CustomPainter {
  _NumeralPainter({
    required this.glyphs,
    required this.columns,
    required this.roll,
    required this.dwell,
    required this.breathe,
    required this.reduced,
  }) : super(repaint: Listenable.merge(<Listenable?>[roll, dwell, breathe]));

  final _Glyphs glyphs;
  final _Columns columns;
  final Animation<double> roll;
  final ValueListenable<double> dwell;
  final Animation<double>? breathe;
  final bool reduced;

  static final Color _base = MobileTokens.accentAt(0.35);
  static const Color _glint = MobileTokens.accent200;

  /// Distance, in row heights, a digit travels on exit / entry.
  static const double _travel = 0.62;

  /// Slope of the slashed zero, and of the sweep band.
  static const double _slashDeg = 62;

  @override
  void paint(Canvas canvas, Size size) {
    final double t = roll.value;
    final bool rolling = roll.isAnimating;
    final int n = columns.to.length;

    _strokeLayer(canvas, size, () {
      for (int c = 0; c < n; c++) {
        _column(canvas, c, columns.at(c, t));
      }
    }, sweep: rolling && !reduced ? t : null);

    if (rolling || reduced) return;
    final double p = dwell.value.clamp(0.0, 1.0);
    final double level = glyphs.baseline - glyphs.capHeight * p;
    final double x = glyphs.advance * (n - 1);
    final int digit = columns.to[n - 1].round() % 10;
    final Rect cell = Rect.fromLTWH(x, 0, glyphs.advance, size.height);

    canvas.save();
    canvas.clipRect(Rect.fromLTRB(cell.left, level, cell.right, cell.bottom));
    glyphs.fill[digit].paint(canvas, Offset(x, 0));
    canvas.restore();

    final double glow = breathe == null ? 1 : 0.5 + 0.5 * breathe!.value;
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(cell.left, level - 0.75, cell.right, level + 0.75),
    );
    _strokeLayer(
      canvas,
      size,
      () => _digit(canvas, digit, Offset(x, 0)),
      tint: MobileTokens.accent.withValues(alpha: glow),
    );
    canvas.restore();
  }

  /// Draws white strokes from [draw] into a layer, then tints them: flat
  /// [tint], or the base colour with a diagonal glint at [sweep] progress.
  void _strokeLayer(
    Canvas canvas,
    Size size,
    VoidCallback draw, {
    Color? tint,
    double? sweep,
  }) {
    final Rect bounds = Offset.zero & size;
    canvas.saveLayer(bounds, Paint());
    draw();
    final Paint paint = Paint()..blendMode = BlendMode.srcIn;
    if (sweep != null) {
      final double o = -0.15 + sweep * 1.3;
      final double a = (_slashDeg - 90) * math.pi / 180;
      final Offset dir = Offset(math.cos(a), math.sin(a)) * size.width / 2;
      paint.shader = ui.Gradient.linear(
        bounds.center - dir,
        bounds.center + dir,
        <Color>[_base, _base, _glint, _base, _base],
        <double>[
          0,
          (o - 0.12).clamp(0.0, 1.0),
          o.clamp(0.0, 1.0),
          (o + 0.12).clamp(0.0, 1.0),
          1,
        ],
      );
    } else {
      paint.color = tint ?? _base;
    }
    canvas.drawRect(bounds, paint);
    canvas.restore();
  }

  void _column(Canvas canvas, int c, double position) {
    final double x = glyphs.advance * c;
    final double h = glyphs.height;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(x, 0, glyphs.advance, h));
    final int lo = position.floor();
    for (final int d in <int>{lo, lo + 1}) {
      final double off = d - position;
      final double opacity = (1 - off.abs()).clamp(0.0, 1.0);
      if (opacity == 0) continue;
      final double dy = reduced ? 0 : off * _travel * h;
      if (opacity == 1) {
        _digit(canvas, d % 10, Offset(x, dy));
      } else {
        canvas.saveLayer(
          null,
          Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
        );
        _digit(canvas, d % 10, Offset(x, dy));
        canvas.restore();
      }
    }
    canvas.restore();
  }

  void _digit(Canvas canvas, int d, Offset at) {
    glyphs.stroke[d].paint(canvas, at);
    if (d == 0) _slash(canvas, at);
  }

  /// Archivo has no `zero` feature, so the slash is drawn here.
  void _slash(Canvas canvas, Offset at) {
    final double cap = glyphs.capHeight;
    final double cx = at.dx + glyphs.advance / 2;
    final double cy = at.dy + glyphs.baseline - cap / 2;
    final double half = cap * 0.34;
    final double dx = half / math.tan(_slashDeg * math.pi / 180);
    canvas.drawLine(
      Offset(cx - dx, cy + half),
      Offset(cx + dx, cy - half),
      _Glyphs._white,
    );
  }

  @override
  bool shouldRepaint(_NumeralPainter old) =>
      old.glyphs != glyphs ||
      old.columns != columns ||
      old.breathe != breathe ||
      old.reduced != reduced ||
      old.dwell != dwell;
}
