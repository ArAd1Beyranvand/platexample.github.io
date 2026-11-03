import 'package:flutter/material.dart';

import '../country/filter_chips.dart';
import '../data/catalogue.dart';
import 'embed_host.dart';
import 'handover.dart';
import 'embed_loader.dart';
import 'protocol.dart';
import 'registry.dart';

/// The country page's language tabs, from the registry. [flutter] is the
/// in-app page, shown unless the registry has a Flutter component; the other
/// tabs show an [EmbedHost]. With no registry it shows [flutter] and nothing else.
class LanguageTabs extends StatelessWidget {
  const LanguageTabs({
    super.key,
    required this.source,
    required this.lang,
    required this.onLang,
    required this.flutter,
    required this.page,
    this.spec,
  });

  final GallerySource source;

  /// Selected language, null for Flutter.
  final String? lang;
  final ValueChanged<String?> onLang;
  final Widget flutter;

  /// Lays out the plate-type list around the language's [detail]; the list
  /// stays put when the language changes and only the detail is handed over.
  final Widget Function(Widget detail) page;

  /// The plate type an embedded component shows.
  final String? spec;

  @override
  Widget build(BuildContext context) {
    final EmbedRegistryLoader loader = EmbedRegistryLoader.instance
      ..ensureLoaded();
    return ValueListenableBuilder<EmbedRegistry>(
      valueListenable: loader.registry,
      builder: (BuildContext context, EmbedRegistry registry, _) {
        final List<String> langs = registry.languagesOf(source.slug);
        // The Flutter tab is an iframe only where a Flutter build exists; otherwise
        // it is the in-app page.
        final String active = lang ?? embedLanguageFlutter;
        final EmbedComponent? component = registry.of(source.slug, active);
        // The registry is loaded lazily: an unbuilt language in the URL stays
        // on the page until it says so, then the route falls back.
        if (lang != null &&
            component == null &&
            !identical(registry, EmbedRegistry.unloaded)) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onLang(null));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (langs.length > 1) ...<Widget>[
              PdFilterRow(
                children: <Widget>[
                  for (final String l in langs)
                    PdFilterChip(
                      label: embedLanguageLabels[l]!,
                      selected: l == active,
                      onTap: () => onLang(l == embedLanguageFlutter ? null : l),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            page(
              EmbedHandover(
                embed: component != null,
                child: component != null
                    ? EmbedHost(
                        key: ValueKey<String>('${source.slug}/$active'),
                        component: component,
                        spec: spec,
                        title:
                            '${source.countryName} plate · ${embedLanguageLabels[active]}',
                      )
                    : KeyedSubtree(
                        key: const ValueKey<String>('flutter'),
                        child: flutter,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
