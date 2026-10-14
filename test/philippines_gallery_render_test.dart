import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/screens/gallery/sources/philippines.dart';

void main() {
  for (final entry in PhilippinesSource().sections.expand((s) => s.entries)) {
    testWidgets('${entry.id} renders', (tester) async {
      final c = PlateController.fromValues(entry.spec, entry.sampleValues!);
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: SizedBox(
              width: 520,
              child: AspectRatio(
                aspectRatio: entry.spec.canvasWidth / entry.spec.canvasHeight,
                child: PlateView(
                  controller: c,
                  theme: entry.theme!,
                  country: entry.country,
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        entry.validator!
            .validate(PlateEntry(spec: entry.spec, values: c.values))
            .isValid,
        isTrue,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
    });
  }
}
