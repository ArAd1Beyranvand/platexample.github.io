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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';

/// One line per frame that missed a 60Hz budget, split between the UI thread
/// (Dart: build, layout, paint recording) and the raster thread (the GPU
/// actually drawing the picture). Profile mode only — debug timings are not
/// evidence, and release should not pay for the callback.
///
/// Read it as: a high `build` means a subtree is being rebuilt per frame; a
/// high `raster` means the picture itself is expensive to draw.
void _installJankLog() {
  SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
    for (final FrameTiming t in timings) {
      if (t.totalSpan > const Duration(milliseconds: 17)) {
        debugPrint(
          'JANK total=${t.totalSpan.inMilliseconds}ms '
          'build=${t.buildDuration.inMilliseconds}ms '
          'raster=${t.rasterDuration.inMilliseconds}ms',
        );
      }
    }
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kProfileMode) _installJankLog();
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const PlateNumberShowcaseApp());
}
