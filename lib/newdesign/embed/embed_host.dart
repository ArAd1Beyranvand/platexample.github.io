import 'dart:async';

import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../widgets/controls.dart';
import 'frame.dart';
import 'frame_stub.dart' if (dart.library.js_interop) 'frame_web.dart';
import 'protocol.dart';
import 'registry.dart';

/// One component in an iframe. Created when its tab is selected and replaced
/// (new [key]) on switch. The skeleton shows until `hello`; after that the
/// component's own splash takes over. No `hello` in [helloTimeout], or a fatal
/// `error`, shows the retry state.
class EmbedHost extends StatefulWidget {
  const EmbedHost({
    super.key,
    required this.component,
    required this.title,
    this.spec,
    this.helloTimeout = const Duration(seconds: 15),
  });

  final EmbedComponent component;
  final String title;

  /// The plate type the component opens on; null leaves its default.
  final String? spec;
  final Duration helloTimeout;

  @override
  State<EmbedHost> createState() => _EmbedHostState();
}

/// Told by an ancestor switcher that this subtree is on its way out, so the
/// component can play its outro before the iframe goes.
class EmbedLeaving extends InheritedWidget {
  const EmbedLeaving({super.key, required this.leaving, required super.child});

  final bool leaving;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<EmbedLeaving>()?.leaving ??
      false;

  @override
  bool updateShouldNotify(EmbedLeaving old) => leaving != old.leaving;
}

enum _Phase { loading, booting, failed }

class _EmbedHostState extends State<EmbedHost> {
  static const double _minHeight = 320;

  _Phase _phase = _Phase.loading;
  double _height = _minHeight;
  int _attempt = 0;
  String? _error;
  Timer? _timer;
  EmbedFrameConfig? _config;

  @override
  void initState() {
    super.initState();
    _arm();
  }

  void _arm() => _timer = Timer(
    widget.helloTimeout,
    () => _fail('The component did not respond.'),
  );

  void _fail(String message) {
    _timer?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _Phase.failed;
      _error = message;
    });
  }

  void _retry() => setState(() {
    _phase = _Phase.loading;
    _error = null;
    _attempt++;
    _config = null;
    _arm();
  });

  void _onMessage(Object? data) {
    final EmbedMessage? m = parseHostMessage(data);
    if (m == null || !mounted) return;
    switch (m.type) {
      case 'hello':
        _timer?.cancel();
        _config?.send?.call(
          initMessage(
            dark: Theme.of(context).brightness == Brightness.dark,
            spec: widget.spec,
          ),
        );
        setState(() => _phase = _Phase.booting);
      case 'ready' || 'resize':
        setState(() => _height = m.height < _minHeight ? _minHeight : m.height);
      case 'error' when m.fatal:
        _fail(m.payload['message'] as String);
    }
  }

  bool _left = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_left && EmbedLeaving.of(context)) {
      _left = true;
      _config?.send?.call(<String, Object?>{
        'ns': 'plate-embed',
        'v': 1,
        'type': 'action',
        'payload': <String, Object?>{'name': 'leave', 'args': <String, Object?>{}},
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    if (_phase == _Phase.failed) {
      return _Retry(message: _error ?? '', onRetry: _retry);
    }
    final EmbedFrameConfig config = _config ??= EmbedFrameConfig(
      url: widget.component.resolve(Uri.base),
      title: widget.title,
      onMessage: _onMessage,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(PdRadius.card),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.surface,
          border: Border.all(color: t.divider),
        ),
        child: SizedBox(
          height: _height,
          child: Stack(
            children: <Widget>[
              KeyedSubtree(
                key: ValueKey<int>(_attempt),
                child: buildEmbedFrame(config),
              ),
              if (_phase == _Phase.loading)
                const Positioned.fill(child: _Skeleton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    Widget bar(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: t.raised,
        borderRadius: BorderRadius.circular(PdRadius.chip),
      ),
    );
    return ColoredBox(
      color: t.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            bar(180, 20),
            const SizedBox(height: 16),
            bar(double.infinity, 96),
          ],
        ),
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Container(
      height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(PdRadius.card),
        border: Border.all(color: t.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'This component could not be loaded.',
            style: TextStyle(fontSize: 15, color: t.text),
          ),
          if (message.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(message, style: TextStyle(fontSize: 13, color: t.muted)),
          ],
          const SizedBox(height: 16),
          PdTappable(
            onTap: onRetry,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            border: t.divider,
            hoverColor: t.hover,
            child: Center(
              widthFactor: 1,
              child: Text(
                'Retry',
                style: TextStyle(fontSize: 14, color: t.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
