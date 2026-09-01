// Run with: flutter run -t lib/minimal/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        body: BlocProvider(
          create: (_) => PlateCardBloc(IranPlates.car),
          child: Builder(
            builder: (context) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                // inputSource defaults per platform and can be overridden
                child: PlateCanvas(
                  spec: IranPlates.car,
                  // The Iran car plate has a `chosen`-alphabet letter slot;
                  // core no longer ships a picker, so supply one.
                  onChooseCharacter: (alphabet) =>
                      PlateCharacterPicker.show(context, alphabet),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
