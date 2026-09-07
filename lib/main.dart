// Entry point of the plate showcase.
//
// This app is the *consumer* of the plate packages, kept in its own
// repository on purpose:
//
//   * each package stays small — no poster fonts, no texture PNGs, no
//     device-frame painters, no demo-only dependencies in its pubspec;
//   * everything here goes through their public surfaces
//     (`package:core_plate/core_plate.dart` and the country / keypad
//     barrels), so if the demo compiles, the API is genuinely sufficient
//     to build a real UI with;
//   * the library was split into core_plate + plate_keypad + a country
//     package per country without touching a single file in this project
//     beyond the import lines — which is exactly what P7, P8 and P9 did, and
//     what adding palestine_plate and yemen_plate since has cost.
//
// The libraries are wired as path dependencies in pubspec.yaml — see the
// comment block there for the expected folder layout.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const PlateNumberShowcaseApp());
}
