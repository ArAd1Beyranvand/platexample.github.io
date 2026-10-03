import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_index.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

/// `CatalogueSourceLook.highlightItems` pairs each highlight back up with the
/// section it came from using `identical`, so a source that *rebuilds* its
/// entries in `highlights` — rather than picking them out of its cached
/// sections — matches nothing and throws `Bad state: No element` while the home
/// grid is building.
///
/// That is a trap every source has to avoid and nothing else checks, so it is
/// checked here once for all of them rather than in one source's own test.
void main() {
  final List<GallerySource> sources = <GallerySource>[
    ...gallerySources,
    ...iranshahirCountries,
  ];

  test('every highlight is the same object as the section entry it names', () {
    for (final GallerySource source in sources) {
      final List<GalleryEntry> sectioned = <GalleryEntry>[
        for (final GallerySection section in source.sections)
          ...section.entries,
      ];
      for (final GalleryEntry highlight in source.highlights) {
        expect(
          sectioned.any((GalleryEntry entry) => identical(entry, highlight)),
          isTrue,
          reason:
              '${source.countryName}: highlight "${highlight.id}" is not one of '
              'the objects in its own sections. Pick highlights out of the '
              'cached section list instead of building fresh entries.',
        );
      }
    }
  });

  test('highlightItems resolves for every source', () {
    for (final GallerySource source in sources) {
      expect(
        source.highlightItems,
        hasLength(source.highlights.length),
        reason: source.countryName,
      );
    }
  });

  test('sections are returned by identity, not rebuilt per read', () {
    for (final GallerySource source in sources) {
      expect(
        identical(source.sections, source.sections),
        isTrue,
        reason: source.countryName,
      );
    }
  });
}
