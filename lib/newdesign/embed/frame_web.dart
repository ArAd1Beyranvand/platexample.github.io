import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import 'frame.dart';

int _views = 0;

Widget buildEmbedFrame(EmbedFrameConfig config) => _EmbedFrame(config: config);

class _EmbedFrame extends StatefulWidget {
  const _EmbedFrame({required this.config});

  final EmbedFrameConfig config;

  @override
  State<_EmbedFrame> createState() => _EmbedFrameState();
}

class _EmbedFrameState extends State<_EmbedFrame> {
  late final String _viewType = 'plate-embed-${_views++}';
  late final web.HTMLIFrameElement _frame;
  StreamSubscription<web.MessageEvent>? _sub;

  @override
  void initState() {
    super.initState();
    final EmbedFrameConfig c = widget.config;
    final String origin = c.url.origin;
    _frame = web.HTMLIFrameElement()
      ..src = c.url.toString()
      ..title = c.title
      ..allow = 'clipboard-write'
      ..loading = 'lazy'
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..setAttribute('sandbox', 'allow-scripts allow-same-origin allow-forms');
    c.send = (Object message) =>
        _frame.contentWindow?.postMessage(message.jsify(), origin.toJS);
    c.hideChooser = () {
      final web.Document? doc = _frame.contentDocument;
      if (doc == null) return;
      doc.head?.appendChild(
        doc.createElement('style')
          ..textContent = 'select{display:none!important}',
      );
    };
    _sub = web.window.onMessage.listen((web.MessageEvent e) {
      if (e.origin != origin || e.source != _frame.contentWindow) return;
      c.onMessage(e.data.dartify());
    });
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _frame,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    widget.config.send = null;
    _frame.src = 'about:blank';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewType);
}
