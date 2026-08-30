// Entry point of the plate_number showcase.
//
// This app is the *consumer* of the plate_number package, kept in its own
// repository on purpose:
//
//   * the package stays small — no poster fonts, no texture PNGs, no
//     device-frame painters, no demo-only dependencies in its pubspec;
//   * everything here goes through the package's public surface
//     (`package:plate_number/plate_number.dart`), so if the demo compiles,
//     the published API is genuinely sufficient to build a real UI with;
//   * the library can be split into core_plate + iran_plate + germany_plate
//     without touching a single file in this project beyond the import lines.
//
// The dependency is wired as a path dependency in pubspec.yaml — see the
// comment block there for the expected folder layout and for what changes
// once the country packages land.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const PlateNumberShowcaseApp());
}
