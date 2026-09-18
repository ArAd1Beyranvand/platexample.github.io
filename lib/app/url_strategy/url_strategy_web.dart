import 'package:flutter_web_plugins/url_strategy.dart';

/// Drops the `#` from web URLs, so the tabs are `example.ir/info` rather than
/// `example.ir/#/info`.
///
/// This needs the host to serve `index.html` for every unknown path — a deep
/// link to `/info` is a real request the server sees before Flutter boots.
void configureUrlStrategy() => usePathUrlStrategy();
