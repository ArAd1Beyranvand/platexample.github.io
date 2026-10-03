import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app_routes.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_index.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  group('tabs', () {
    test('root and /showcase are the same page', () {
      expect(AppLocation.fromUri(Uri.parse('/')).tab, AppTab.showcase);
      expect(AppLocation.fromUri(Uri.parse('/showcase')).tab, AppTab.showcase);
      expect(
        AppLocation.fromUri(Uri.parse('https://platexample.ir/')).tab,
        AppTab.showcase,
      );
    });

    test('each tab answers to its own path, trailing slash included', () {
      expect(AppLocation.fromUri(Uri.parse('/discover')), AppLocation.discover);
      expect(
        AppLocation.fromUri(Uri.parse('/discover/')),
        AppLocation.discover,
      );
      expect(AppLocation.fromUri(Uri.parse('/about')), AppLocation.about);
    });

    test('an unknown path falls back to the front page', () {
      expect(AppLocation.fromUri(Uri.parse('/nope')), AppLocation.showcase);
    });

    test('a tab round-trips through its own path', () {
      for (final AppTab tab in AppTab.values) {
        final AppLocation location = AppLocation.tab(tab);
        expect(
          AppLocation.fromUri(Uri.parse(location.path)),
          location,
          reason: location.path,
        );
      }
    });
  });

  group('slugs', () {
    test('slugify makes URL-safe names out of labels', () {
      expect(slugify('Civilian (EU size)'), 'civilian-eu-size');
      expect(slugify('Taxi / private hire'), 'taxi-private-hire');
      expect(slugify('  Trailer  '), 'trailer');
      expect(slugify('Class 3'), 'class-3');
    });

    test('slugify romanises a non-Latin word rather than dropping it', () {
      // Yemen labels its usage classes in Arabic. Dropping the word left the
      // punctuation and digits behind — `خصوصي · 2 + 5` became `2-5`, a URL
      // that named nothing.
      expect(slugify('خصوصي · 2 + 5'), 'private-2-5');
      expect(slugify('خصوصي · 4 digits'), 'private-4-digits');
    });

    test('every plate slug contains a word, not just digits', () {
      for (final CatalogueItem item in catalogueItems) {
        expect(
          RegExp('[a-z]').hasMatch(item.slug),
          isTrue,
          reason:
              '${item.entry.label} (${item.source.countryName}) slugs to "${item.slug}"',
        );
      }
    });

    test('every country has a distinct, non-empty slug', () {
      final Set<String> seen = <String>{};
      for (final GallerySource source in gallerySources) {
        expect(source.slug, isNotEmpty, reason: source.countryName);
        expect(
          seen.add(source.slug),
          isTrue,
          reason: 'duplicate country slug: ${source.slug}',
        );
      }
    });

    test('every plate has a distinct, non-empty slug within its country', () {
      final Map<String, Set<String>> seen = <String, Set<String>>{};
      for (final CatalogueItem item in catalogueItems) {
        expect(item.slug, isNotEmpty, reason: item.entry.label);
        final Set<String> within = seen.putIfAbsent(
          item.source.slug,
          () => <String>{},
        );
        expect(
          within.add(item.slug),
          isTrue,
          reason:
              'duplicate plate slug in ${item.source.countryName}: ${item.slug} (${item.entry.label})',
        );
      }
    });
  });

  group('countries and plates', () {
    // currently failing
    test('a country page has a meaningful path and parses back to itself', () {
      for (final GallerySource source in gallerySources) {
        final AppLocation location = AppLocation.country(source);
        expect(location.path, '/discover/${source.slug}');
        expect(
          AppLocation.fromUri(Uri.parse(location.path)),
          location,
          reason: location.path,
        );
      }
    });

    // currently failing
    test('every plate round-trips through its own URL', () {
      for (final CatalogueItem item in catalogueItems) {
        final AppLocation location = item.location;
        expect(location.path, '/discover/${item.source.slug}/${item.slug}');
        final AppLocation parsed = AppLocation.fromUri(
          Uri.parse(location.path),
        );
        expect(parsed, location, reason: location.path);
        expect(identical(parsed.item, item), isTrue, reason: location.path);
      }
    });

    test('a country or plate page reports the Discover tab', () {
      final CatalogueItem item = catalogueItems.first;
      expect(item.location.tab, AppTab.discover);
      expect(AppLocation.country(item.source).tab, AppTab.discover);
    });

    test('depth is what the nested Discover stack must be', () {
      expect(AppLocation.discover.discoverDepth, 0);
      expect(AppLocation.country(gallerySources.first).discoverDepth, 1);
      expect(catalogueItems.first.location.discoverDepth, 2);
    });

    test('an unknown country falls back to Discover', () {
      expect(
        AppLocation.fromUri(Uri.parse('/discover/atlantis')),
        AppLocation.discover,
      );
    });

    test('an unknown plate falls back to its country', () {
      final GallerySource source = gallerySources.first;
      expect(
        AppLocation.fromUri(
          Uri.parse('/discover/${source.slug}/no-such-plate'),
        ),
        AppLocation.country(source),
      );
    });

    test('a URL is matched case-insensitively and past extra segments', () {
      final CatalogueItem item = catalogueItems.first;
      final String upper =
          '/DISCOVER/${item.source.slug.toUpperCase()}/${item.slug.toUpperCase()}';
      expect(AppLocation.fromUri(Uri.parse(upper)), item.location);
      expect(
        AppLocation.fromUri(Uri.parse('${item.location.path}/extra')),
        item.location,
      );
    });
  });
}
