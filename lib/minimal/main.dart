// Run with: flutter run -t lib/minimal/main.dart
import 'package:flutter/material.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:plate_core/plate_core.dart';

void main() {
  runApp(const MinimalApp());
}

// TODO(py): [D2] holder = one PySide6 window: plate, keypad, verdict line; see ROADMAP "Holder spec".
// TODO(ts): [D2] holder = Vite + vanilla TS page: plate SVG, DOM inputs, keypad, verdict; ROADMAP "Holder spec".
// TODO(kt): [D2] holder = Compose Desktop window first, Android second; ROADMAP "Holder spec".
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
                spec: IranPlates.civil,
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
