import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/newdesign/app/pd_app.dart';

void main() {
  for (final Size size in const <Size>[Size(1280, 900), Size(390, 844)]) {
    testWidgets('landing renders at ${size.width}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const PdApp());
      await tester.pumpAndSettle();
      expect(find.text('Licence-plate input for Flutter.'), findsOneWidget);
      expect(find.text('Why plates are hard'), findsOneWidget);
    });
  }
}
