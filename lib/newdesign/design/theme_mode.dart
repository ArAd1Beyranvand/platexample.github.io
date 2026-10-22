import 'package:flutter/material.dart';

import 'theme_store_stub.dart' if (dart.library.js_interop) 'theme_store_web.dart';

/// Starts dark on landscape screens and light on portrait ones until the header toggle overrides it; the
/// override is saved (localStorage on web) and restored at startup.
class PdThemeMode extends ValueNotifier<ThemeMode> {
  PdThemeMode() : super(_restore());

  static const String _key = 'pd.theme';

  static ThemeMode _restore() => switch (readThemeChoice(_key)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => _byOrientation(),
  };

  /// Dark on a landscape screen, light on a portrait one; read once at
  /// startup so resizing later never flips it.
  static ThemeMode _byOrientation() {
    final Size size = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    return size.width > size.height ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle(Brightness current) {
    value = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    writeThemeChoice(_key, value == ThemeMode.light ? 'light' : 'dark');
  }
}
