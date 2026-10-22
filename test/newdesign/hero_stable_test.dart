import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:plate_number_holder/newdesign/app/pd_app.dart';
import 'package:plate_number_holder/newdesign/landing/hero.dart';

void main() {
  for (final Size size in const <Size>[Size(1280, 900), Size(390, 844)]) {
    testWidgets('hero card keeps its size across countries at ${size.width}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const PdApp());
      await tester.pumpAndSettle();
      final Finder chips = find.byType(CountryChip);
      final Finder card = find.ancestor(of: chips.first, matching: find.byType(Container)).last;
      Size? first;
      for (int i = 0; i < heroPlates.length; i++) {
        await tester.ensureVisible(chips.at(i));
        await tester.tap(chips.at(i));
        await tester.pumpAndSettle();
        expect(find.byType(PlateKeypad), findsOneWidget);
        first ??= tester.getSize(card);
        expect(tester.getSize(card), first, reason: heroPlates[i].$1);
      }
    });
  }
}
