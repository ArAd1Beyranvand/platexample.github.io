import 'package:flutter/foundation.dart';

import 'fetch_stub.dart' if (dart.library.js_interop) 'fetch_web.dart';
import 'registry.dart';

/// Loads `components/index.json` once, on the first country page. Until it
/// arrives, and when it is missing or malformed, the registry is empty and the
/// gallery shows only its Flutter tab.
class EmbedRegistryLoader {
  EmbedRegistryLoader._();

  static final EmbedRegistryLoader instance = EmbedRegistryLoader._();

  final ValueNotifier<EmbedRegistry> registry = ValueNotifier<EmbedRegistry>(
    EmbedRegistry.unloaded,
  );
  bool _started = false;

  void ensureLoaded() {
    if (_started) return;
    _started = true;
    fetchText('components/index.json').then((String? body) {
      final EmbedRegistry? r = body == null ? null : EmbedRegistry.parse(body);
      registry.value = r ?? EmbedRegistry.empty;
    });
  }
}
