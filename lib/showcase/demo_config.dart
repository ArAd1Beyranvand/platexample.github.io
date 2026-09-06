import 'package:flutter/foundation.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:palestine_plate/palestine_plate.dart';
import 'package:yemen_plate/yemen_plate.dart';
import 'package:core_plate/core_plate.dart';

import '../device_preview/device_config.dart';
import 'plate_mirror.dart';
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
    this.secondarySpec,
    this.secondaryTheme,
    this.mirrorPairs,
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

  /// Whether the shared [PlateController] drives this device's plate.
  final bool usesController;

  /// Whether typed values are validated (the tablet's Palestinian plate and
  /// the laptop's Yemeni one) — gates the active-slot tracking and, as
  /// `PlateCanvas.autoValidate`, the red invalid-underline colour the plate now
  /// paints for itself.
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
  /// `PlateTheme.standard()` the Iranian plate is printed in; the Palestinian
  /// plate is green on white and the Yemeni ones are white or blue, and those
  /// ship their themes with the country.
  final PlateTheme? theme;

  /// A second plate rendered read-only beneath [spec], carrying the same typed
  /// digits rewritten into its own grammar. Null for a device that shows one
  /// plate — which is the phone; the laptop and the tablet both show two.
  ///
  /// This exists because neither country here has a single plate. Yemen has two
  /// systems in force at the same time — the 2026 unified plate the recognised
  /// government issues and the 1993 format still current across the north — and
  /// Palestine has two separate designs, the West Bank's `ف / P` plate and
  /// Gaza's, which went its own way in 2012. Showing one without the other
  /// would present a country's plates as settled when they are not. See
  /// `plate_mirror.dart` for how the value crosses over, and for the caveat
  /// that the crossover is a display device rather than a claim.
  final PlateSpec? secondarySpec;

  /// The printed colours of [secondarySpec]. On the northern Yemeni plate this
  /// is not decoration: the field colour *is* the usage class, so a plate
  /// painted the wrong colour says the vehicle is something else. On the Gaza
  /// plate the field is always white and the *glyphs* carry the class instead.
  final PlateTheme? secondaryTheme;

  /// Which of [spec]'s keyed text groups feed which of [secondarySpec]'s.
  ///
  /// Required whenever [secondarySpec] is set, and null otherwise. It lives
  /// here rather than in the stage for the reason every other field does: the
  /// pairing is a property of the demo, not a `device == laptop` branch. See
  /// `plate_mirror.dart` for why the match is by group key and never by slot
  /// index.
  final MirrorPairs? mirrorPairs;
}

/// The variation-as-data table behind the showcase: one [DemoConfig] per
/// [DeviceType], holding exactly what `device_stage.dart` used to inline.
const Map<DeviceType, DemoConfig> demoConfigs = {
  // Yemen has two systems in force at once: the deck's keys type into the 2026
  // unified plate, and `plate_mirror.dart` writes the same digits onto the 1993
  // northern plate below it, so both fill in together.
  DeviceType.desktop: DemoConfig(
    spec: YemenUnifiedPlates.car5Private,
    theme: YemenThemes.unified,
    secondarySpec: YemenNorthernPlates.carGov2Serial5Private,
    secondaryTheme: YemenThemes.northernPrivate,
    mirrorPairs: yemenUnifiedToNorthern,
    script: yemenUnifiedCarScript,
    inputSource: PlateInputSource.host,
    // Half the glass each, stacked, rather than the single plate's 0.55.
    plateWidthFactor: 0.5,
    usesController: true,
    showsValidation: true,
    validator: YemenUnifiedValidator(),
    compactKeypad: false,
    showsKeypad: false,
  ),
  // Palestine is split the same way, though for a different reason: the West
  // Bank kept the `ف / P` plate and Gaza went its own way in 2012. The legacy
  // West Bank plate is paired with the Gaza one because their grammars line up
  // digit for digit — 1 + 4 + 2 on both — so the keypad fills both plates at
  // once rather than leaving the mirror half-typed.
  //
  // The two plates are painted in different colours from the same digits on
  // purpose: `40` is a private car in the West Bank and a municipality vehicle
  // in Gaza. Same keystrokes, two grammars.
  DeviceType.tablet: DemoConfig(
    spec: PSWestBankPlates.legacyCar,
    theme: PSThemes.greenOnWhite,
    secondarySpec: PSGazaPlates.car2012,
    secondaryTheme: PSThemes.gazaBlue,
    mirrorPairs: palestineWestBankToGaza,
    script: palestineLegacyCarScript,
    inputSource: PlateInputSource.host,
    // Half the glass each, stacked, matching the laptop's pair.
    plateWidthFactor: 0.5,
    usesController: true,
    showsValidation: true,
    validator: PSWestBankLegacyValidator(),
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
