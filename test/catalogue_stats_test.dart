import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_stats.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  // Expectations are derived from the registry rather than pinned, so adding a
  // country does not break this test; what it guards is how each count is
  // taken.
  test('CatalogueStats.of counts the current registry', () {
    final CatalogueStats stats = CatalogueStats.of(gallerySources);

    expect(
      stats.packages,
      gallerySources.expand((GallerySource s) => s.packageNames).toSet().length,
    );

    // Flattened, not one per source: `iranshahr_plate` ships several.
    expect(
      stats.countries,
      gallerySources.expand((GallerySource s) => s.countryNames).toSet().length,
    );
    expect(stats.countries, greaterThan(gallerySources.length - 1));

    expect(
      stats.specs,
      <String>{
        for (final GallerySource source in gallerySources)
          for (final GallerySection section in source.sections)
            for (final GalleryEntry entry in section.entries) entry.spec.id,
      }.length,
    );

    // A car-family plate and a motorcycle/bicycle one are both on the shelf.
    expect(stats.formFactors, 2);
  });

  test('changing the registry moves the numbers, not a constant', () {
    final CatalogueStats stats = CatalogueStats.of(<GallerySource>[]);

    expect(stats.packages, 0);
    expect(stats.countries, 0);
    expect(stats.specs, 0);
    expect(stats.formFactors, 0);
  });
}
