/// plate-embed v1 (`ports/web/protocol.md`): parsing of what a component posts
/// to the gallery. Anything off-spec parses to null, never throws.
library;

const String embedLanguageFlutter = 'flutter';

/// Language keys of the registry, in tab order.
const List<String> embedLanguages = <String>[
  'flutter',
  'typescript',
  'kotlin',
  'python',
];

const Map<String, String> embedLanguageLabels = <String, String>{
  'flutter': 'Flutter',
  'typescript': 'TypeScript',
  'kotlin': 'Kotlin',
  'python': 'Python',
};

/// A validated component-to-host message.
class EmbedMessage {
  const EmbedMessage(this.type, this.payload);

  final String type;
  final Map<String, Object?> payload;

  double get height => (payload['height'] as num).toDouble();
  bool get fatal => payload['fatal'] == true;
}

const Set<String> _toHost = <String>{
  'hello',
  'ready',
  'resize',
  'change',
  'progress',
  'error',
};

/// [data] as received from `postMessage` (already Dart-converted).
EmbedMessage? parseHostMessage(Object? data) {
  if (data is! Map || data['ns'] != 'plate-embed' || data['v'] != 1)
    return null;
  final Object? type = data['type'];
  final Object? payload = data['payload'];
  if (type is! String || !_toHost.contains(type) || payload is! Map)
    return null;
  final Map<String, Object?> p = <String, Object?>{
    for (final MapEntry<Object?, Object?> e in payload.entries)
      if (e.key is String) e.key as String: e.value,
  };
  return _valid(type, p) ? EmbedMessage(type, p) : null;
}

bool _height(Object? v) => v is num && v.isFinite && v >= 0;
bool _str(Object? v) => v is String;
bool _values(Object? v) =>
    v is List && v.every((Object? e) => e == null || e is String);

bool _valid(String type, Map<String, Object?> p) => switch (type) {
  'hello' =>
    embedLanguages.contains(p['lang']) &&
        _str(p['country']) &&
        _str(p['version']),
  'ready' =>
    _height(p['height']) &&
        _str(p['spec']) &&
        p['specs'] is List &&
        (p['specs'] as List).every(
          (Object? s) => s is Map && _str(s['id']) && _str(s['label']),
        ),
  'resize' => _height(p['height']),
  'change' =>
    _str(p['spec']) &&
        _values(p['values']) &&
        _str(p['text']) &&
        p['complete'] is bool &&
        (p['valid'] == null || p['valid'] is bool),
  'progress' =>
    _str(p['stage']) &&
        (p['fraction'] == null ||
            (p['fraction'] is num &&
                (p['fraction'] as num) >= 0 &&
                (p['fraction'] as num) <= 1)),
  'error' => _str(p['code']) && _str(p['message']) && p['fatal'] is bool,
  _ => false,
};

/// The `init` reply to `hello`.
Map<String, Object?> initMessage({
  required bool dark,
  String locale = 'en',
  String? spec,
}) => <String, Object?>{
  'ns': 'plate-embed',
  'v': 1,
  'type': 'init',
  'payload': <String, Object?>{
    'spec': ?spec,
    'theme': dark ? 'dark' : 'light',
    'locale': locale,
    'keypad': true,
  },
};
