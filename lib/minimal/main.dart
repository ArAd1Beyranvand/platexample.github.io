// Run with: flutter run -t lib/minimal/main.dart
import 'package:flutter/material.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:core_plate/core_plate.dart';

void main() {
  runApp(const MinimalApp());
}

class MinimalApp extends StatelessWidget {
  const MinimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              // A spec and the widget: the plate owns its own characters, so
              // there is nothing to provide above it.
              // inputSource defaults per platform and can be overridden
              child: PlateCanvas(
                spec: IranPlates.car,
                // The Iran car plate has a `chosen`-alphabet letter slot;
                // core no longer ships a picker, so supply one.
                onChooseCharacter: (alphabet) => PlateCharacterPicker.show(context, alphabet),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
