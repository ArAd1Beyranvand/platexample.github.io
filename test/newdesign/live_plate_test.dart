import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/newdesign/design/tokens.dart';
import 'package:plate_number_holder/newdesign/plate/live_plate.dart';

void main() {
  testWidgets('live plate alone', (WidgetTester tester) async {
    final PlateController c = PlateController(spec: IranPlates.civil);
    await tester.pumpWidget(
      MaterialApp(
        theme: pdTheme(Brightness.dark),
        home: Scaffold(
          body: SizedBox(
            width: 500,
            child: LivePlate(controller: c, validName: 'x'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
  testWidgets('static plate alone', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: pdTheme(Brightness.dark),
        home: Scaffold(
          body: SizedBox(width: 500, child: StaticPlate(spec: IranPlates.civil)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  });
}
