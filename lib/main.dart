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
//   * the library could be split into plate_number + plate_keypad +
//     iran_plate + germany_plate without touching a single file in this
//     project beyond the import lines — which is exactly what P7 and P8 did.
//
// The libraries are wired as path dependencies in pubspec.yaml — see the
// comment block there for the expected folder layout.
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
