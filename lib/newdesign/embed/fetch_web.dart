import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The body of [url] (relative to the page), or null on any failure.
Future<String?> fetchText(String url) async {
  try {
    final web.Response r = await web.window
        .fetch(url.toJS, web.RequestInit(cache: 'no-cache'))
        .toDart;
    return r.ok ? (await r.text().toDart).toDart : null;
  } catch (_) {
    return null;
  }
}
