import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../data/catalogue.dart';
import '../plate/live_plate.dart';

/// `/render-check`: every plate of every country (umbrella members included)
/// in one column, mounted one at a time so that any Flutter error raised while
/// a plate is laid out and painted is attributed to that plate. Failures are
/// shown on the row and printed as `RENDERCHECK FAIL ...` lines, so the log
/// alone says which specs to fix.
class RenderCheckPage extends StatefulWidget {
  const RenderCheckPage({super.key});

  @override
  State<RenderCheckPage> createState() => _RenderCheckPageState();
}

class _RenderCheckPageState extends State<RenderCheckPage> {
  final List<CatalogueItem> _items = playgroundItems;
  final Map<int, List<String>> _errors = <int, List<String>>{};
  int _mounted = 0;
  bool _done = false;

  FlutterExceptionHandler? _previous;
  List<String>? _current;

  @override
  void initState() {
    super.initState();
    _previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final List<String>? sink = _current;
      if (sink != null) {
        sink.add(details.exceptionAsString().split('\n').first);
      }
      _previous?.call(details);
    };
    unawaited(_run());
  }

  Future<void> _run() async {
    for (int i = 0; i < _items.length && mounted; i++) {
      final List<String> errors = <String>[];
      _current = errors;
      setState(() => _mounted = i + 1);
      // Build, then layout + paint, then anything scheduled after the first
      // frame.
      await SchedulerBinding.instance.endOfFrame;
      await SchedulerBinding.instance.endOfFrame;
      _current = null;
      if (errors.isNotEmpty && mounted) {
        final CatalogueItem item = _items[i];
        final String name =
            '${item.source.countryName} / ${item.section.title} / '
            '${item.entry.label} [${item.entry.id}]';
        debugPrint('RENDERCHECK FAIL $name: ${errors.first}');
        setState(() => _errors[i] = errors);
      }
    }
    if (!mounted) return;
    setState(() => _done = true);
    debugPrint('RENDERCHECK DONE ${_items.length} plates, ${_errors.length} failed');
  }

  @override
  void dispose() {
    FlutterError.onError = _previous;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _done
              ? 'Render check: ${_errors.length} failed of ${_items.length}'
              : 'Render check: $_mounted / ${_items.length}, '
                    '${_errors.length} failed',
        ),
        backgroundColor: _errors.isEmpty ? Colors.green[100] : Colors.red[100],
      ),
      body: ListView(children: <Widget>[for (int i = 0; i < _mounted; i++) _row(i, _items[i])]),
    );
  }

  Widget _row(int index, CatalogueItem item) {
    final List<String>? errors = _errors[index];
    final bool failed = errors != null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: failed ? Colors.red[50] : null,
        border: const Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 360,
            child: StaticPlate(
              spec: item.entry.spec,
              values: item.entry.sampleValues,
              theme: item.entry.theme,
              country: item.entry.country,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${index + 1}. ${item.source.countryName} · '
                  '${item.section.title} · ${item.entry.label}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'entry ${item.entry.id} · spec ${item.entry.spec.id}',
                  style: const TextStyle(color: Colors.black54),
                ),
                Text(
                  failed ? 'FAIL: ${errors.first}' : 'ok',
                  style: TextStyle(color: failed ? Colors.red : Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
