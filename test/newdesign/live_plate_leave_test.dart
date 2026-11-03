import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/newdesign/design/tokens.dart';
import 'package:plate_number_holder/newdesign/plate/live_plate.dart';

void main() {
  testWidgets('an owner-cued stagger out and in is visible partway', (WidgetTester tester) async {
    final PlateController c = PlateController(spec: IranPlates.civil);
    final PlateAnimationController anim = PlateAnimationController();
    await tester.pumpWidget(
      MaterialApp(
        theme: pdTheme(Brightness.dark),
        home: Scaffold(
          body: SizedBox(width: 500, child: LivePlate(controller: c, validName: 'x', animation: anim)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    double faded() => tester.widgetList<Opacity>(find.byType(Opacity)).where((o) => o.opacity < 1).length.toDouble() +
        tester.widgetList<FadeTransition>(find.byType(FadeTransition)).where((o) => o.opacity.value < 1).length;
    expect(faded(), 0);
    anim.goOutAll(delays: PlateStagger.sequence(IranPlates.civil, reverse: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(faded(), greaterThan(0));
    await tester.pumpAndSettle();
    anim.comeInAll(delays: PlateStagger.sequence(IranPlates.civil));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(faded(), greaterThan(0));
  });
}
