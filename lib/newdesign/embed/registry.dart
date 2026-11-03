import 'dart:convert';

import 'protocol.dart';

/// One built component: its folder URL and the hash that busts the iframe URL.
class EmbedComponent {
  const EmbedComponent(this.url, this.hash);

  final String url;
  final String hash;

  /// [url] resolved against [base], with `?v=hash`.
  Uri resolve(Uri base) {
    // Named explicitly: dev servers answer a bare folder with the gallery's own index.
    final Uri u = base.removeFragment().resolve(
      url.endsWith('/') ? '${url}index.html' : url,
    );
    return hash.isEmpty
        ? u
        : u.replace(queryParameters: <String, String>{'v': hash});
  }
}

/// `components/index.json` (W3), as the gallery reads it.
class EmbedRegistry {
  const EmbedRegistry(this._components);

  static const EmbedRegistry empty = EmbedRegistry(
    <String, Map<String, EmbedComponent>>{},
  );

  /// Before the fetch finishes; compared by identity.
  static const EmbedRegistry unloaded = EmbedRegistry(
    <String, Map<String, EmbedComponent>>{},
  );

  final Map<String, Map<String, EmbedComponent>> _components;

  /// Null for anything that is not a version 1 registry.
  static EmbedRegistry? parse(String body) {
    try {
      final Object? json = jsonDecode(body);
      if (json is! Map || json['version'] != 1 || json['components'] is! Map)
        return null;
      return EmbedRegistry(<String, Map<String, EmbedComponent>>{
        for (final MapEntry<Object?, Object?> c
            in (json['components'] as Map).entries)
          if (c.key is String && c.value is Map)
            c.key as String: <String, EmbedComponent>{
              for (final MapEntry<Object?, Object?> l
                  in (c.value as Map).entries)
                if (embedLanguages.contains(l.key) &&
                    l.value is Map &&
                    (l.value as Map)['url'] is String)
                  l.key as String: EmbedComponent(
                    (l.value as Map)['url'] as String,
                    ((l.value as Map)['hash'] as String?) ?? '',
                  ),
            },
      });
    } on FormatException {
      return null;
    }
  }

  bool get isEmpty => _components.isEmpty;

  EmbedComponent? of(String country, String lang) =>
      _components[country]?[lang];

  /// Tabs for [country]: Flutter first (always there), then every built language.
  List<String> languagesOf(String country) => <String>[
    for (final String l in embedLanguages)
      if (l == embedLanguageFlutter || of(country, l) != null) l,
  ];
}
