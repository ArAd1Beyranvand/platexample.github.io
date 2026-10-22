/// Selects the web implementation only when compiling for the web.
///
/// `package:flutter_web_plugins` does not exist off the web, so importing it
/// unconditionally would break the Android and Linux builds this app also
/// ships. The stub is a no-op: there is no address bar to configure.
library;

export 'url_strategy_stub.dart' if (dart.library.js_interop) 'url_strategy_web.dart';
