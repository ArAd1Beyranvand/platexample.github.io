import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/newdesign/app/location.dart';
import 'package:plate_number_holder/newdesign/app/pd_app.dart';
import 'package:plate_number_holder/newdesign/data/catalogue.dart';

void main() {
  for (final Size size in const <Size>[Size(1280, 900), Size(390, 844)]) {
    testWidgets('playground pages through every plate at ${size.width}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        PdApp(initialRoute: PdLocation.playground(playgroundItems.first).path),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('of ${playgroundItems.length}'),
        findsOneWidget,
      );
      for (int i = 1; i < playgroundItems.length; i++) {
        await tester.tap(find.bySemanticsLabel('Next plate'));
        await tester.pump();
        await tester.pump();
        expect(
          find.text('${i + 1} of ${playgroundItems.length}'),
          findsOneWidget,
          reason: 'Next did not advance to ${i + 1}',
        );
        expect(
          tester.takeException(),
          isNull,
          reason: playgroundItems[i].entry.id,
        );
      }
      await tester.ensureVisible(find.text('Keypad'));
      await tester.tap(find.text('Keypad'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
