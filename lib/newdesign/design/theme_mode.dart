import 'package:flutter/material.dart';

import 'theme_store_stub.dart'
    if (dart.library.js_interop) 'theme_store_web.dart';

/// Follows the platform brightness until the header toggle overrides it; the
/// override is saved (localStorage on web) and restored at startup.
class PdThemeMode extends ValueNotifier<ThemeMode> {
  PdThemeMode() : super(_restore());

  static const String _key = 'pd.theme';

  static ThemeMode _restore() => switch (readThemeChoice(_key)) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  void toggle(Brightness current) {
    value = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    writeThemeChoice(_key, value == ThemeMode.light ? 'light' : 'dark');
  }
}
