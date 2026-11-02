import 'package:flutter/material.dart';

/// One clock for every [PdSwap] below it, so a whole page of swaps runs on a
/// single ticker. [run] starts a new wave; [generation] tells the swaps which
/// wave their outgoing child belongs to.
class PdSwapScope extends InheritedNotifier<Animation<double>> {
  const PdSwapScope({
    super.key,
    required Animation<double> clock,
    required this.generation,
    required super.child,
  }) : super(notifier: clock);

  final int generation;

  /// The wave's length for swaps up to [orders] deep.
  static Duration span(int orders) => PdSwap.half * 2 + PdSwap.step * orders;

  static PdSwapScope? _of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PdSwapScope>();

  @override
  bool updateShouldNotify(PdSwapScope oldWidget) =>
      oldWidget.generation != generation || super.updateShouldNotify(oldWidget);
}

/// Swaps [child] in place when [id] changes: the old child fades out where it
/// stands, then the new one fades in there, on the [PdSwapScope]'s clock.
/// [order] delays both halves, so siblings ripple through in sequence.
/// Children that keep their [id] are left alone.
class PdSwap extends StatefulWidget {
  const PdSwap({
    super.key,
    required this.id,
    required this.child,
    this.order = 0,
  });

  final Object? id;

  /// Null leaves nothing behind once out, so a row can fade away.
  final Widget? child;
  final int order;

  static const Duration half = Duration(milliseconds: 200);
  static const Duration step = Duration(milliseconds: 30);
  static const int maxOrder = 16;

  @override
  State<PdSwap> createState() => _PdSwapState();
}

class _PdSwapState extends State<PdSwap> {
  Widget? _outgoing;
  int _generation = -1;

  /// Whether the last build was still showing [_outgoing]. The clock has
  /// already restarted by the time a new wave reaches [didUpdateWidget], so its
  /// value cannot say where the previous wave had got to.
  bool _leaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Mounted partway through a wave (a row the last country lacked): join it,
    // with nothing outgoing, so it fades in with its siblings.
    if (_generation < 0)
      _generation = PdSwapScope._of(context)?.generation ?? -1;
  }

  @override
  void didUpdateWidget(PdSwap old) {
    super.didUpdateWidget(old);
    if (old.id == widget.id) return;
    final PdSwapScope? scope = PdSwapScope._of(context);
    if (scope == null) return;
    // Caught mid-wave and still on its way out: the screen shows the older
    // child, so that is the one to keep fading.
    _outgoing = _leaving ? _outgoing : old.child;
    _generation = scope.generation;
  }

  /// Where this swap is in the scope's wave, 0 → 1.
  double _progress(PdSwapScope scope) {
    final Animation<double> clock = scope.notifier!;
    final int total = PdSwapScope.span(PdSwap.maxOrder).inMicroseconds;
    final int delay =
        (PdSwap.step * widget.order.clamp(0, PdSwap.maxOrder)).inMicroseconds;
    final double t =
        (clock.value * total - delay) / (PdSwap.half * 2).inMicroseconds;
    return t.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final PdSwapScope? scope = PdSwapScope._of(context);
    if (scope == null || _generation != scope.generation) {
      _outgoing = null;
      _leaving = false;
      return widget.child ?? const SizedBox.shrink();
    }
    final double v = _progress(scope);
    if (v >= 1) {
      _leaving = false;
      return widget.child ?? const SizedBox.shrink();
    }
    final bool leaving = v < 0.5;
    _leaving = leaving;
    final Widget? shown = leaving ? _outgoing : widget.child;
    if (shown == null) return const SizedBox.shrink();
    final double opacity = leaving
        ? 1 - Curves.easeInCubic.transform(v * 2)
        : Curves.easeOutCubic.transform((v - 0.5) * 2);
    return Opacity(opacity: opacity, child: shown);
  }
}
