/// Extracts metadata from README files for the showcase.
class ReadmeMetadata {
  const ReadmeMetadata({required this.packages, required this.countries});

  /// Number of packages in the plate ecosystem.
  final int packages;

  /// Number of countries supported across all packages.
  final int countries;

  /// Parses metadata from a README file's HTML comment block.
  /// Expected format:
  /// <!-- METADATA: core_plate
  /// packages: 8
  /// countries: 8
  /// -->
  factory ReadmeMetadata.parse(String readmeContent) {
    int? packages;
    int? countries;

    final lines = readmeContent.split('\n');
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.contains('packages:')) {
        packages = _extractNumber(line);
      }
      if (line.contains('countries:')) {
        countries = _extractNumber(line);
      }

      if (packages != null && countries != null) break;
    }

    return ReadmeMetadata(packages: packages ?? 0, countries: countries ?? 0);
  }

  static int? _extractNumber(String line) {
    final regex = RegExp(r':\s*(\d+)');
    final match = regex.firstMatch(line);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }
    return null;
  }
}
