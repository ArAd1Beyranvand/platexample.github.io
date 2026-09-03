import 'package:flutter/foundation.dart';
import 'package:germany_plate/germany_plate.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:palestine_plate/palestine_plate.dart';
import 'package:core_plate/core_plate.dart';

import '../device_preview/device_config.dart';
import 'plate_typist.dart';

/// The complete, per-device recipe the showcase stage plays back: which plate
/// spec to render, the typist script to auto-enter, and the handful of visual
/// switches ([DeviceStage] used to spread across ternaries) that make each
/// device feel like its own demo.
///
/// Every field encodes exactly one former `switch (device)` / `device == ...`
/// branch in `device_stage.dart`, so swapping the switches for a
/// `demoConfigs[device]!` lookup is behaviour-preserving.
@immutable
class DemoConfig {
  const DemoConfig({
    required this.spec,
    required this.script,
    required this.inputSource,
    required this.plateWidthFactor,
    required this.usesController,
    required this.showsValidation,
    this.validator,
    required this.compactKeypad,
    required this.showsKeypad,
    this.theme,
  });

  /// The plate rendered on the glass and fed to its backing bloc.
  final PlateSpec spec;

  /// The keystrokes the auto-typist walks for this device.
  final List<TypistStep> script;

  /// The [PlateDisplay.inputSource] for this device. Null lets the plate fall
  /// back to the platform default (as the mobile demo does); the laptop and
  /// tablet route input through the host instead.
  final PlateInputSource? inputSource;

  /// Fraction of the glass width the plate occupies.
  final double plateWidthFactor;

  /// Whether the shared [PlateInputController] drives this device's plate.
  final bool usesController;

  /// Whether typed values are validated (the tablet's German plate) — gates the
  /// active-slot tracking and, as `PlateCanvas.autoValidate`, the red
  /// invalid-underline colour the plate now paints for itself.
  final bool showsValidation;

  /// The rule this device's plate is judged against, when [showsValidation] is
  /// on. Variation as data: a country validator is a value in this table, not
  /// a `device == tablet` branch in the stage. Never prevents a keystroke.
  final PlateValidator? validator;

  /// Whether the on-screen keypad renders in its compact layout (mobile) rather
  /// than the full pad (tablet). Only meaningful when [showsKeypad] is true.
  final bool compactKeypad;

  /// Whether an on-screen keypad is shown at all (the laptop has none — its deck
  /// carries the keys).
  final bool showsKeypad;

  /// The plate's own colours, when it has any. Null means the black-on-white
  /// `PlateTheme.standard()` the Iranian and German plates are printed in; the
  /// Palestinian plate is green on white and ships its theme with the country.
  final PlateTheme? theme;
}

/// The variation-as-data table behind the showcase: one [DemoConfig] per
/// [DeviceType], holding exactly what `device_stage.dart` used to inline.
const Map<DeviceType, DemoConfig> demoConfigs = {
  DeviceType.desktop: DemoConfig(
    spec: PalestinePlate.car,
    theme: PalestineTheme.green,
    script: palestineCarScript,
    inputSource: PlateInputSource.host,
    plateWidthFactor: 0.55,
    usesController: true,
    showsValidation: false,
    compactKeypad: false,
    showsKeypad: false,
  ),
  DeviceType.tablet: DemoConfig(
    spec: GermanPlates.car,
    script: germanCarScript,
    inputSource: PlateInputSource.host,
    plateWidthFactor: 0.62,
    usesController: true,
    showsValidation: true,
    validator: GermanPlateValidator(),
    compactKeypad: false,
    showsKeypad: true,
  ),
  DeviceType.mobile: DemoConfig(
    spec: IranPlates.bicycle,
    script: bicycleScript,
    inputSource: null,
    plateWidthFactor: 0.86,
    usesController: false,
    showsValidation: false,
    compactKeypad: true,
    showsKeypad: true,
  ),
};
