import 'package:flutter/material.dart';

import 'sources/sources.dart';

/// One plate, and the two things it hangs off — its country and its system.
///
/// The sources model the catalogue as a tree (source → section → entry),
/// which is right for showing it and useless for searching it. This is the
/// same data flattened once, so a query is a `where` over a list instead of
/// three nested loops re-walked on every keystroke.
@immutable
class CatalogueItem {
  CatalogueItem({required this.source, required this.section, required this.entry})
    : haystack = <String>[
        entry.label,
        entry.note ?? '',
        entry.spec.id,
        section.title,
        source.countryName,
        source.packageName,
      ].join(' ').toLowerCase();

  final GallerySource source;
  final GallerySection section;
  final GalleryEntry entry;

  /// Everything a free-text query is matched against, lowercased once at
  /// build time. Includes the spec id: somebody reading the packages has the
  /// id in hand and no idea which country it belongs to, and that is exactly
  /// the lookup the old catalogue made impossible.
  final String haystack;
}

/// Every plate in the app, country and system attached. Built once.
final List<CatalogueItem> catalogueItems = <CatalogueItem>[
  for (final GallerySource source in gallerySources)
    for (final GallerySection section in source.sections)
      for (final GalleryEntry entry in section.entries) CatalogueItem(source: source, section: section, entry: entry),
];

/// The items matching a free-text [query] and an optional [country].
///
/// Terms are ANDed, so "yemen moto" narrows rather than widens — the
/// behaviour anyone who has used a search box expects, and the reason this
/// isn't a single `contains`.
List<CatalogueItem> searchCatalogue({String query = '', GallerySource? country}) {
  final List<String> terms = query.toLowerCase().split(' ').where((String t) => t.isNotEmpty).toList();
  return <CatalogueItem>[
    for (final CatalogueItem item in catalogueItems)
      if (country == null || identical(item.source, country))
        if (terms.every(item.haystack.contains)) item,
  ];
}

extension CatalogueSourceLook on GallerySource {
  /// [GallerySource.highlights], each paired back up with the section it came
  /// from — what a shelf needs in order to caption a plate with its system
  /// and to open it into a detail page.
  List<CatalogueItem> get highlightItems => <CatalogueItem>[
    for (final GalleryEntry entry in highlights)
      catalogueItems.firstWhere((CatalogueItem item) => identical(item.entry, entry)),
  ];

  /// The colour this country is keyed with in the chrome — its own leading
  /// plate's field colour.
  ///
  /// Derived rather than assigned: picking four brand colours by hand would
  /// be four arbitrary decisions, and the plate already carries the one
  /// colour the country is actually recognised by. Null where the package
  /// ships no theme (Germany, Iran draw on the ambient one), and callers
  /// fall back to the accent.
  Color? get accent {
    for (final GalleryEntry entry in highlights) {
      final Color? background = entry.theme?.plateBackground;
      if (background != null) return background;
    }
    return null;
  }
}
