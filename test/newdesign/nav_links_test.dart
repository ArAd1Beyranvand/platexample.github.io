import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/newdesign/app/pd_app.dart';

void main() {
  testWidgets('header links scroll to their sections', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const PdApp());
    await tester.pumpAndSettle();
    for (final (String link, String heading) in const <(String, String)>[
      ('Get started', 'Get started in three steps'),
      ('About', 'About'),
    ]) {
      await tester.tap(find.text(link).first);
      await tester.pumpAndSettle();
      final double y = tester.getTopLeft(find.text(heading).last).dy;
      expect(y, inInclusiveRange(56, 300), reason: link);
    }
  });
}
