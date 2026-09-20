import 'package:flutter/foundation.dart';

import 'sources/sources.dart';

/// The Showcase stat band's four numbers, computed from the registry so they
/// stay true as packages come and go instead of drifting from a hardcoded
/// `5 / 7 / 51 / 2`.
@immutable
class CatalogueStats {
  const CatalogueStats({
    required this.packages,
    required this.countries,
    required this.specs,
    required this.formFactors,
  });

  /// Walks [catalogue] once, tallying all four counts together.
  factory CatalogueStats.of(List<GallerySource> catalogue) {
    final Set<String> packages = <String>{};
    final Set<String> countries = <String>{};
    final Set<String> specs = <String>{};
    final Set<String> formFactors = <String>{};

    for (final GallerySource source in catalogue) {
      packages.add(source.packageName);
      countries.addAll(source.countryNames);
      for (final GallerySection section in source.sections) {
        for (final GalleryEntry entry in section.entries) {
          specs.add(entry.spec.id);
          formFactors.add(_formFactorOf(entry, section));
        }
      }
    }

    return CatalogueStats(
      packages: packages.length,
      countries: countries.length,
      specs: specs.length,
      formFactors: formFactors.length,
    );
  }

  /// Distinct [GallerySource.packageName]s the catalogue draws from.
  final int packages;

  /// Distinct [GallerySource.countryNames], flattened — not one per source:
  /// `iran_plate` alone ships three.
  final int countries;

  /// Distinct plate spec ids (`entry.spec.id`) across every entry in every
  /// section.
  final int specs;

  /// Distinct form factors across every entry.
  final int formFactors;

  /// No package models a form factor as a field — not on `PlateSpec`, not on
  /// [GalleryEntry] — so this reads the same word a person already reads on
  /// the shelf: "motorcycle", "moto" or "bicycle" somewhere in the entry's id,
  /// its label or its section's title. Everything else is a car-family plate.
  static String _formFactorOf(GalleryEntry entry, GallerySection section) {
    final String haystack = '${entry.id} ${entry.label} ${section.title}'.toLowerCase();
    final bool isTwoWheeler =
        haystack.contains('motorcycle') || haystack.contains('moto') || haystack.contains('bicycle');
    return isTwoWheeler ? 'twoWheeler' : 'car';
  }
}
