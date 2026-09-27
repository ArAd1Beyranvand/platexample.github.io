/// Metadata about the plate ecosystem sourced from core_plate/README.md
///
/// This is extracted from the METADATA comment block in core_plate/README.md
/// to keep the showcase stats synchronized with the actual packages available.
///
/// Packages:
/// - Core: core_plate, core_plate_bloc
/// - Countries: iran_plate, germany_plate, palestine_plate, yemen_plate,
///   iranshahr_plate, lebanon_plate
/// - Utilities: plate_keypad
///
/// Countries:
/// - Iran, Germany, Palestine, Yemen, Bahrain, Azerbaijan, Afghanistan,
///   Armenia, Tajikistan, Lebanon
class PlateMetadata {
  /// Total number of packages in the ecosystem (2 core + 6 country + 1 utility).
  static const int packageCount = 9;

  /// Total number of countries supported across all packages.
  static const int countryCount = 10;
}
