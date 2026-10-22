import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/newdesign/data/spec_names.g.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

/// Every public spec a country package ships is drawn somewhere in the
/// catalogue. `specNames` is generated from the same packages the app depends
/// on, so a plate added to a package and left out of its source shows up here.
void main() {
  test('every package spec is in the gallery', () {
    final Set<PlateSpec> shown = Set<PlateSpec>.identity();
    for (final GallerySource source in allGallerySources) {
      for (final GallerySection section in source.sections) {
        for (final GalleryEntry entry in section.entries) {
          shown.add(entry.spec);
        }
      }
    }

    final List<String> missing = <String>[
      for (final MapEntry<PlateSpec, String> e in specNames.entries)
        if (!shown.contains(e.key)) e.value,
    ]..sort();

    expect(missing, isEmpty, reason: 'not in any gallery source:\n${missing.join('\n')}');
  });
}
