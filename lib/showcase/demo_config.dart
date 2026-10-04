import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:plate_core/plate_core.dart';

import '../device_preview/device_config.dart';
import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/sources/sources.dart';
import 'plate_typist.dart';

/// The complete, per-device recipe the showcase stage plays back: which plate
/// spec to render, the typist script to auto-enter, and the handful of visual
/// switches ([DeviceStage] used to spread across ternaries) that make each
/// device feel like its own demo.
///
/// This used to be a hand-written table pinning Yemen to the laptop, Palestine
/// to the tablet and Iran to the phone, each with its own bespoke script and
/// country-specific second-plate mirror. Now that [scriptFromValues] can type
/// any plate from its sample values, the content is drawn from
/// [gallerySources] instead: [pickDemoConfig] picks a country at random each
/// time a device comes up in the cycle, and everything a device needs — spec,
/// livery, validator, keypad alphabets and the auto-typed script — is read off
/// that country's catalogue entry. The device-shaped fields ([compactKeypad], [showsKeypad],
/// [plateWidthFactor], [inputSource]) are properties of the *device*, not the
/// country, so they stay fixed per [DeviceType].
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
    required this.digitAlphabet,
    required this.letterAlphabet,
    this.theme,
    this.country,
  });

  /// The plate rendered on the glass and fed to its backing controller.
  final PlateSpec spec;

  /// The keystrokes the auto-typist walks for this device, derived from the
  /// chosen entry's sample values via [scriptFromValues].
  final List<TypistStep> script;

  /// The [PlateDisplay.inputSource] for this device. Null would let the plate
  /// fall back to the platform default; every demo here routes input through
  /// the host instead, because the stage types by script and a scripted run
  /// must never raise the visitor's own keyboard.
  final PlateInputSource? inputSource;

  /// Fraction of the glass width the plate occupies.
  final double plateWidthFactor;

  /// Whether the shared [PlateController] drives this device's plate.
  final bool usesController;

  /// Whether typed values are validated — gates the active-slot tracking and,
  /// as `PlateCanvas.autoValidate`, the red invalid-underline colour the plate
  /// paints for itself. On for any device whose chosen country ships a
  /// validator.
  final bool showsValidation;

  /// The rule this device's plate is judged against, when [showsValidation] is
  /// on. Comes from the chosen entry. Never prevents a keystroke.
  final PlateValidator? validator;

  /// Whether the on-screen keypad renders in its compact layout (mobile) rather
  /// than the full pad (tablet). Only meaningful when [showsKeypad] is true.
  final bool compactKeypad;

  /// Whether an on-screen keypad is shown at all (the laptop has none — its deck
  /// carries the keys).
  final bool showsKeypad;

  /// The digit alphabet the on-screen keypad types in. Read off the chosen
  /// spec's first numeric slot rather than hardcoded, so a random country types
  /// in its own numerals (Persian, Latin, …) instead of always Latin.
  final PlateAlphabet digitAlphabet;

  /// The letter alphabet the keypad's letters pad types in, or null when the
  /// spec has no free-choice letter slot. Read off the spec the same way.
  final PlateAlphabet? letterAlphabet;

  /// The plate's own colours, when the entry ships any. Null means the app's
  /// default `PlateTheme.standard()`.
  final PlateTheme? theme;

  /// The panel/country block, when the entry overrides it (Lebanon's usage
  /// blocks, Germany's Bundeswehr flag). Null keeps [PlateSpec.country].
  final PlateCountry? country;
}

/// The device-shaped presentation for each [DeviceType] — everything that is a
/// property of the form factor rather than of the country shown on it.
@immutable
class _DevicePreset {
  const _DevicePreset({
    required this.plateWidthFactor,
    required this.usesController,
    required this.compactKeypad,
    required this.showsKeypad,
  });

  final double plateWidthFactor;
  final bool usesController;
  final bool compactKeypad;
  final bool showsKeypad;
}

const Map<DeviceType, _DevicePreset> _devicePresets =
    <DeviceType, _DevicePreset>{
      // The laptop: no on-screen keypad, its deck carries the keys.
      DeviceType.desktop: _DevicePreset(
        plateWidthFactor: 0.55,
        usesController: true,
        compactKeypad: false,
        showsKeypad: false,
      ),
      // The tablet: the full on-screen pad.
      DeviceType.tablet: _DevicePreset(
        plateWidthFactor: 0.72,
        usesController: true,
        compactKeypad: false,
        showsKeypad: true,
      ),
      // The phone: the compact pad, its slots host-fed so the auto-typist never
      // raises the visitor's own IME.
      DeviceType.mobile: _DevicePreset(
        plateWidthFactor: 0.86,
        usesController: false,
        compactKeypad: true,
        showsKeypad: true,
      ),
    };

/// The spec's own digit alphabet — the first numeric slot's — so the keypad
/// types in the plate's numerals rather than a hardcoded set. Falls back to
/// Latin digits for the (unlikely) spec with no numeric slot at all.
PlateAlphabet _digitAlphabetOf(PlateSpec spec) {
  for (final slot in spec.slots) {
    if (slot.alphabet.isNumeric) return slot.alphabet;
  }
  return PlateAlphabet.latinDigits;
}

/// The spec's free-choice letter alphabet — the first non-numeric slot with
/// more than one character — or null when the plate has none (an all-digit
/// plate, or one whose only letter slot is a printed constant).
PlateAlphabet? _letterAlphabetOf(PlateSpec spec) {
  for (final slot in spec.slots) {
    if (!slot.alphabet.isNumeric && slot.alphabet.characters.length > 1)
      return slot.alphabet;
  }
  return null;
}

/// Builds a [DemoConfig] for [device] from a chosen catalogue [entry].
DemoConfig _configFor(DeviceType device, GalleryEntry entry) {
  final preset = _devicePresets[device]!;
  final values = entry.sampleValues ?? const <String?>[];
  return DemoConfig(
    spec: entry.spec,
    script: scriptFromValues(spec: entry.spec, values: values),
    // Always route through the host: the stage types by script, and a scripted
    // run must never raise the visitor's own keyboard.
    inputSource: PlateInputSource.host,
    plateWidthFactor: preset.plateWidthFactor,
    usesController: preset.usesController,
    showsValidation: entry.validator != null,
    validator: entry.validator,
    compactKeypad: preset.compactKeypad,
    showsKeypad: preset.showsKeypad,
    digitAlphabet: _digitAlphabetOf(entry.spec),
    letterAlphabet: _letterAlphabetOf(entry.spec),
    theme: entry.theme,
    country: entry.country,
  );
}

/// Every catalogue entry that carries enough to auto-type: sample values with
/// at least one real character. Anything blank has no script to walk, so it is
/// never picked for a device.
List<GalleryEntry> _typeableEntries() => <GalleryEntry>[
  for (final GallerySource source in gallerySources)
    for (final GalleryEntry entry in source.entries)
      if (entry.sampleValues != null &&
          entry.sampleValues!.any((v) => v != null && v.isNotEmpty))
        entry,
];

final Random _defaultRng = Random();

/// Picks one country at random from the whole catalogue and builds a
/// [DemoConfig] for [device] from it.
///
/// Called fresh every time a device comes up in the showcase cycle, so a
/// device shows a different plate each turn rather than a fixed one for the
/// whole session — the same country can turn up twice in a row or on two
/// devices at once, which is the point: the stage is demonstrating that the
/// library draws any of them. Pass a seeded [random] to pin the pick (goldens,
/// tests); the default reshuffles on every call.
DemoConfig pickDemoConfig(DeviceType device, {Random? random}) {
  final rng = random ?? _defaultRng;
  final entries = _typeableEntries();
  return _configFor(device, entries[rng.nextInt(entries.length)]);
}

/// Every catalogue *item* whose entry carries enough to draw a sample — the
/// same filter as [_typeableEntries], but paired back up with the section and
/// source each entry came from, which is what opening a plate into its detail
/// page needs.
List<CatalogueItem> _typeableItems() => <CatalogueItem>[
  for (final CatalogueItem item in catalogueItems)
    if (item.entry.sampleValues != null &&
        item.entry.sampleValues!.any((v) => v != null && v.isNotEmpty))
      item,
];

/// Picks one plate at random from the whole catalogue, as a [CatalogueItem] so
/// the showcase card it feeds can open into that plate's detail page.
///
/// Drawn from the same typeable pool as [pickDemoConfig] and re-rolled on every
/// device hop, so the device glass shows a different, openable plate each turn.
/// Pass a seeded [random] to pin the pick.
CatalogueItem pickDemoItem({Random? random}) {
  final rng = random ?? _defaultRng;
  final items = _typeableItems();
  return items[rng.nextInt(items.length)];
}

/// One random [DemoConfig] per [DeviceType], for a caller that wants the whole
/// table at once (a test, or a first paint before the cycle re-rolls). Each
/// device is drawn independently.
Map<DeviceType, DemoConfig> pickDemoConfigs({Random? random}) =>
    <DeviceType, DemoConfig>{
      for (final device in DeviceType.values)
        device: pickDemoConfig(device, random: random),
    };
