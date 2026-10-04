import 'package:flutter/material.dart';
import 'package:plate_core/core_plate.dart';

import '../poster/plate_backdrop.dart';

class PlateDisplay extends StatelessWidget {
  const PlateDisplay({
    super.key,
    required this.spec,
    required this.mode,
    this.activeColor,
    this.inactiveColor,
    this.alertColor,
    this.validator,
    this.autoValidate = false,
    this.keyboard,
    this.inputSource,
    required this.onChooseCharacter,
    this.onActiveIndexChanged,
    this.controller,
    this.showBackdrop = false,
    this.plateWidthFactor = 0.62,
    this.baseTheme,
    this.country,
    this.secondarySpec,
    this.secondaryTheme,
    this.secondaryController,
  });

  final PlateSpec spec;
  final PlateMode mode;

  /// The panel/country block override for the plate, or null to keep
  /// [PlateSpec.country]. Forwarded straight to [PlateCanvas] — a showcase
  /// device draws its chosen entry's country block (Lebanon's usage colours,
  /// Germany's Bundeswehr flag) through this.
  final PlateCountry? country;

  /// The plate's characters, and the handle a host drives entry through from
  /// outside the plate (e.g. a custom on-screen keypad). Forwarded straight to
  /// [PlateCanvas]. Null lets the canvas own its own, keeping today's
  /// self-contained behaviour for a caller that neither reads nor writes the
  /// value.
  final PlateController? controller;

  /// How characters get into the plate. Null lets the plate resolve the
  /// platform default; pass [PlateInputSource.host] when an app-supplied pad
  /// (e.g. the laptop deck's letter keys or the tablet's `PlateKeypad`) feeds
  /// characters in. Forwarded straight to [PlateCanvas].
  final PlateInputSource? inputSource;

  /// Presents a chooser for a `chosen`-alphabet slot. Required since the keypad
  /// split — core ships no built-in picker. Forwarded straight to [PlateCanvas].
  final Future<String?> Function(PlateAlphabet alphabet) onChooseCharacter;

  /// Fires when the focused plate slot changes, reporting its position in
  /// [spec]'s slots, or null when focus leaves the plate. Resolve it against
  /// [spec] for the slot itself. Forwarded straight to [PlateCanvas].
  final ValueChanged<int?>? onActiveIndexChanged;

  /// Optional fake soft keyboard rendered flush at the bottom of the screen,
  /// below the plate. Null (default) keeps today's behaviour.
  final Widget? keyboard;

  /// Accent for a completed input-field underline. The plate face itself is
  /// always white / black / blue by definition.
  final Color? activeColor;

  /// Accent for an empty/in-progress input-field underline.
  final Color? inactiveColor;

  /// Underline colour the plate paints itself when [autoValidate] is on and
  /// [validator] judges the typed value invalid.
  final Color? alertColor;

  /// The rule the plate is judged against. Never prevents input. Forwarded
  /// straight to [PlateCanvas].
  final PlateValidator? validator;

  /// Whether the plate validates every committed value and paints the alert
  /// itself. Forwarded straight to [PlateCanvas].
  final bool autoValidate;

  /// Paints an ambient [PlateBackdrop] behind the plate content. Off by
  /// default, so existing call sites keep today's plain-glass look.
  final bool showBackdrop;

  /// Fraction of the available width the plate itself occupies. The plate's
  /// own FittedBox would otherwise fill the whole glass.
  final double plateWidthFactor;

  /// The plate's printed colours, before the input-field accents below are
  /// layered on. Null keeps the black-on-white `PlateTheme.standard()`; a
  /// plate that ships its own (the Palestinian green-on-white) passes it here.
  final PlateTheme? baseTheme;

  /// A second plate stacked beneath [spec], rendered read-only from
  /// [secondaryController]. Null (the default) keeps the single-plate layout.
  ///
  /// It is a whole second plate rather than a second value on one, because the
  /// two plates it exists for — Yemen's 2026 unified plate and the 1993
  /// northern one still current across the north — have different slot counts,
  /// different registers and different colours. One `PlateSpec` cannot be both.
  final PlateSpec? secondarySpec;

  /// The printed colours of [secondarySpec].
  final PlateTheme? secondaryTheme;

  /// The controller [secondarySpec] renders from. The host owns it and writes
  /// the mirrored value into it; nothing here types into it.
  final PlateController? secondaryController;

  @override
  Widget build(BuildContext context) {
    return _PlateDisplayBody(
      mode: mode,
      spec: spec,
      keyboard: keyboard,
      showBackdrop: showBackdrop,
      plateWidthFactor: plateWidthFactor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      alertColor: alertColor,
      validator: validator,
      autoValidate: autoValidate,
      inputSource: inputSource,
      onChooseCharacter: onChooseCharacter,
      onActiveIndexChanged: onActiveIndexChanged,
      controller: controller,
      baseTheme: baseTheme,
      country: country,
      secondarySpec: secondarySpec,
      secondaryTheme: secondaryTheme,
      secondaryController: secondaryController,
    );
  }
}

class _PlateDisplayBody extends StatelessWidget {
  const _PlateDisplayBody({
    required this.mode,
    required this.spec,
    required this.keyboard,
    required this.showBackdrop,
    required this.plateWidthFactor,
    required this.activeColor,
    required this.inactiveColor,
    required this.alertColor,
    required this.validator,
    required this.autoValidate,
    required this.inputSource,
    required this.onChooseCharacter,
    required this.onActiveIndexChanged,
    required this.controller,
    required this.baseTheme,
    required this.country,
    required this.secondarySpec,
    required this.secondaryTheme,
    required this.secondaryController,
  });

  final PlateMode mode;
  final PlateSpec spec;
  final Widget? keyboard;
  final bool showBackdrop;
  final double plateWidthFactor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? alertColor;
  final PlateValidator? validator;
  final bool autoValidate;
  final PlateInputSource? inputSource;
  final Future<String?> Function(PlateAlphabet alphabet) onChooseCharacter;
  final ValueChanged<int?>? onActiveIndexChanged;
  final PlateController? controller;
  final PlateTheme? baseTheme;
  final PlateCountry? country;
  final PlateSpec? secondarySpec;
  final PlateTheme? secondaryTheme;
  final PlateController? secondaryController;

  @override
  Widget build(BuildContext context) {
    assert(mode == PlateMode.input);

    final inputSurface = _PlateInputSurface(
      spec: spec,
      plateWidthFactor: plateWidthFactor,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      alertColor: alertColor,
      validator: validator,
      autoValidate: autoValidate,
      inputSource: inputSource,
      onChooseCharacter: onChooseCharacter,
      onActiveIndexChanged: onActiveIndexChanged,
      controller: controller,
      baseTheme: baseTheme,
      country: country,
      secondarySpec: secondarySpec,
      secondaryTheme: secondaryTheme,
      secondaryController: secondaryController,
    );

    // The keypad is boundaried, the plate is NOT, and the asymmetry is the
    // point: the two change on completely different clocks — a key lights and
    // unlights twice per keystroke, the plate's glyphs change once — so
    // isolating the keypad still spares the plate all 42 keys' flashes.
    //
    // A boundary around the plate cost sharpness. This whole page is scaled
    // into the device glass and then carried through the frame's perspective
    // transform; a layer that is repainting (which the plate is, on every
    // keystroke) is rasterised at its own bounds and resampled through that
    // transform, so the plate went soft for exactly as long as typing lasted
    // and snapped sharp when it stopped and the layer went static. Painting
    // the plate into its parent's layer keeps it in the vector pass.
    final body = keyboard == null
        ? inputSurface
        : Column(
            children: [
              Expanded(child: inputSurface),
              RepaintBoundary(child: keyboard!),
            ],
          );

    if (!showBackdrop) return body;
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: PlateBackdrop()),
        body,
      ],
    );
  }
}

/// Wraps the plate in a [PlateThemeScope] that overrides ONLY the input-field
/// underline colours; every other plate token stays standard.
class _PlateInputSurface extends StatelessWidget {
  const _PlateInputSurface({
    required this.spec,
    required this.plateWidthFactor,
    required this.activeColor,
    required this.inactiveColor,
    required this.alertColor,
    required this.validator,
    required this.autoValidate,
    required this.inputSource,
    required this.onChooseCharacter,
    required this.onActiveIndexChanged,
    required this.controller,
    required this.baseTheme,
    required this.country,
    required this.secondarySpec,
    required this.secondaryTheme,
    required this.secondaryController,
  });

  final PlateSpec spec;
  final double plateWidthFactor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? alertColor;
  final PlateValidator? validator;
  final bool autoValidate;
  final PlateInputSource? inputSource;
  final Future<String?> Function(PlateAlphabet alphabet) onChooseCharacter;
  final ValueChanged<int?>? onActiveIndexChanged;
  final PlateController? controller;
  final PlateTheme? baseTheme;
  final PlateCountry? country;
  final PlateSpec? secondarySpec;
  final PlateTheme? secondaryTheme;
  final PlateController? secondaryController;

  @override
  Widget build(BuildContext context) {
    final base = baseTheme ?? PlateTheme.standard();
    final theme = base.copyWith(
      activeColor: activeColor ?? base.activeColor,
      inactiveColor: inactiveColor ?? base.inactiveColor,
      alertColor: alertColor ?? base.alertColor,
    );

    final plate = PlateCanvas(
      spec: spec,
      country: country,
      validator: validator,
      autoValidate: autoValidate,
      inputSource: inputSource,
      onChooseCharacter: onChooseCharacter,
      onActiveIndexChanged: onActiveIndexChanged,
      controller: controller,
    );

    final secondary = secondarySpec;
    final secondaryValue = secondaryController;

    return Center(
      child: FractionallySizedBox(
        widthFactor: plateWidthFactor,
        child: secondary == null || secondaryValue == null
            ? PlateThemeScope(theme: theme, child: plate)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlateThemeScope(theme: theme, child: plate),
                  // Roughly a tenth of a plate's height, so the pair reads as
                  // two plates rather than one tall object.
                  const SizedBox(height: 18),
                  // Read-only, and a [PlateView] rather than a `ShowPlate`
                  // because it takes a [PlateTheme]: for the northern Yemeni
                  // plate the colour is the vehicle class, so the standard
                  // black-on-white would be the wrong plate. It renders blank
                  // until the mirror writes into it, which is what the stacked
                  // pair should look like before the first keystroke.
                  _SecondaryPlate(
                    theme: secondaryTheme ?? PlateTheme.standard(),
                    controller: secondaryValue,
                  ),
                ],
              ),
      ),
    );
  }
}

/// The read-only plate stacked under the one being typed into.
class _SecondaryPlate extends StatelessWidget {
  const _SecondaryPlate({required this.theme, required this.controller});

  final PlateTheme theme;

  /// The host's mirrored value. Nothing here types into it.
  final PlateController controller;

  @override
  Widget build(BuildContext context) => PlateThemeScope(
    theme: theme,
    child: PlateView(controller: controller, theme: theme),
  );
}
