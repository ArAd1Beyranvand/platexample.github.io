// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plate_number_holder/app/app.dart';

void main() {
  testWidgets('Showcase app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PlateNumberShowcaseApp());
    expect(find.byType(PlateNumberShowcaseApp), findsOneWidget);

    // The showcase's auto-typist arms a 600ms delay before its first run, and
    // a `Future.delayed` cannot be cancelled by the dispose that the end of
    // the test triggers — the binding would report it as a leaked timer. Tear
    // the tree down first, then let that delay expire against nothing: the
    // run bails on `mounted` and arms no successor.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 600));
  });
}
