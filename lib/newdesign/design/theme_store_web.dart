import 'package:web/web.dart' as web;

String? readThemeChoice(String key) => web.window.localStorage.getItem(key);

void writeThemeChoice(String key, String value) =>
    web.window.localStorage.setItem(key, value);
