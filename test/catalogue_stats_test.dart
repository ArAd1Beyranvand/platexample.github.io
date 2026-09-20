import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_stats.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  test('CatalogueStats.of counts the current registry', () {
    final CatalogueStats stats = CatalogueStats.of(gallerySources);

    // One per source: iran_plate, palestine_plate, yemen_plate,
    // lebanon_plate, germany_plate.
    expect(stats.packages, 5);

    // Iran (3: Iran, Bahrain, Azerbaijan) + Palestine + Yemen + Lebanon +
    // Germany. `iran_plate` is the one package that ships more than one
    // country's worth of plates.
    expect(stats.countries, 7);

    // Distinct `entry.spec.id`s across every section of every source.
    expect(stats.specs, 51);

    // Every entry lands in one of two buckets: a car-family plate, or a
    // motorcycle/bicycle one. Both buckets are non-empty in the current
    // registry, so this is 2 rather than 1.
    expect(stats.formFactors, 2);
  });

  test('changing the registry moves the numbers, not a constant', () {
    // A minimal fake source proves the stats are read from the catalogue
    // passed in, not from `gallerySources` by name.
    final CatalogueStats stats = CatalogueStats.of(<GallerySource>[]);

    expect(stats.packages, 0);
    expect(stats.countries, 0);
    expect(stats.specs, 0);
    expect(stats.formFactors, 0);
  });
}
