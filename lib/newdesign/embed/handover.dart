import 'dart:async';

import 'package:flutter/widgets.dart';

import '../design/tokens.dart';
import 'embed_host.dart';

/// Swaps [child] when its key changes. An outgoing [embed] is told to leave
/// and stays until its outro is done; the incoming one is mounted only after.
class EmbedHandover extends StatefulWidget {
  const EmbedHandover({super.key, required this.child, required this.embed});

  final Widget child;

  /// Whether [child] is an iframe component rather than an in-app page.
  final bool embed;

  @override
  State<EmbedHandover> createState() => _EmbedHandoverState();
}

class _EmbedHandoverState extends State<EmbedHandover> {
  static const Duration _outro = Duration(milliseconds: 1700);

  late Widget _current = widget.child;
  Widget? _outgoing;
  Timer? _timer;

  @override
  void didUpdateWidget(EmbedHandover old) {
    super.didUpdateWidget(old);
    if (widget.child.key != _current.key) {
      if (_outgoing == null) {
        _outgoing = _current;
        _timer = Timer(PdMotion.of(context, _outro), () {
          if (mounted) setState(() => _outgoing = null);
        });
      }
    }
    _current = widget.child;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget? out = _outgoing;
    // The incoming component is not mounted until the outro is done: a loading
    // iframe shares the page's main thread and stalls the outgoing one's outro.
    final bool hidden = out != null;
    // Both slots keep one wrapper shape, so the outgoing component is the same
    // element once it starts leaving, not a new iframe.
    Widget slot(Widget child, {required bool held, required bool leaving}) =>
        Align(
          key: child.key,
          alignment: Alignment.topCenter,
          child: EmbedHeld(
            held: held,
            child: EmbedLeaving(leaving: leaving, child: child),
          ),
        );
    return Stack(
      children: <Widget>[
        if (!hidden) slot(_current, held: false, leaving: false),
        if (out != null) slot(out, held: false, leaving: true),
      ],
    );
  }
}
