import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/mobile/mobile_body.dart';
import 'package:plate_number_holder/screens/showcase_screen.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

void main() {
  for (final double width in <double>[360, 390, 430, 559, 560, 1440]) {
    testWidgets('showcase at $width picks the right body', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: nocturneTheme(),
          home: ShowcaseScreen(
            onOpenTab: (_) {},
            onOpenPlate: (_, _) {},
            onOpenCountry: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Portrait counts as a phone too, so 560×900 is a panel as well.
      final bool panel = NBreak.isPanel(Size(width, 900));
      expect(find.byType(MobileBody), panel ? findsOneWidget : findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
