import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plate_number/plate_number.dart';

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
    this.bloc,
    this.inputSource,
    required this.onChooseCharacter,
    this.onActiveIndexChanged,
    this.controller,
    this.showBackdrop = false,
    this.plateWidthFactor = 0.62,
  });

  final PlateSpec spec;
  final PlateMode mode;

  /// Lets a host drive character entry from outside the plate (e.g. a custom
  /// on-screen keypad). Forwarded straight to [PlateCanvas].
  final PlateInputController? controller;

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

  /// An externally-owned bloc to drive the plate. When null, this widget
  /// creates and owns its own, keeping today's self-contained behaviour.
  final PlateCardBloc? bloc;

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

  @override
  Widget build(BuildContext context) {
    final child = _PlateDisplayBody(
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
    );
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: child);
    }
    return BlocProvider(
      create: (_) => PlateCardBloc(spec),
      child: child,
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
  final PlateInputController? controller;

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
    );

    // Boundaried against each other: the two change on completely different
    // clocks — a key lights and unlights twice per keystroke, the plate's
    // glyphs change once — and sharing a layer meant each flash re-rasterised
    // the plate, and each typed character re-rasterised all 42 keys.
    final body = keyboard == null
        ? inputSurface
        : Column(
            children: [
              Expanded(child: RepaintBoundary(child: inputSurface)),
              RepaintBoundary(child: keyboard!),
            ],
          );

    if (!showBackdrop) return body;
    return Stack(
      fit: StackFit.expand,
      children: [const Positioned.fill(child: PlateBackdrop()), body],
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
  final PlateInputController? controller;

  @override
  Widget build(BuildContext context) {
    final base = PlateTheme.standard();
    final theme = base.copyWith(
      activeColor: activeColor ?? base.activeColor,
      inactiveColor: inactiveColor ?? base.inactiveColor,
      alertColor: alertColor ?? base.alertColor,
    );

    final plate = PlateCanvas(
      spec: spec,
      validator: validator,
      autoValidate: autoValidate,
      inputSource: inputSource,
      onChooseCharacter: onChooseCharacter,
      onActiveIndexChanged: onActiveIndexChanged,
      controller: controller,
    );

    return Center(
      child: FractionallySizedBox(
        widthFactor: plateWidthFactor,
        child: PlateThemeScope(theme: theme, child: plate),
      ),
    );
  }
}
