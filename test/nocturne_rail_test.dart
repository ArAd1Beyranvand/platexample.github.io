import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app_routes.dart';
import 'package:plate_number_holder/shell/nocturne_rail.dart';
import 'package:plate_number_holder/theme/nocturne.dart';

Color _colorOf(WidgetTester t, String label) =>
    t.widget<Text>(find.text(label)).style!.color!;

void main() {
  testWidgets('rail renders, tick follows tab, hover lightens only that text', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    AppTab tab = AppTab.discover;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => MaterialApp(
          home: Scaffold(
            body: Row(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                NocturneRail(
                  tab: tab,
                  onTabSelected: (AppTab t) => setState(() => tab = t),
                  onToggleView: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('PLATE\nGALLERY'), findsOneWidget);
    expect(find.text('IRAN MADE\nOPEN SOURCE\nMIT'), findsOneWidget);
    expect(find.text('MOBILE VIEW'), findsOneWidget);
    expect(find.byType(Icon), findsNothing, reason: 'the rail has no icons');

    // Rail width and right dock.
    final Rect rail = tester.getRect(find.byType(NocturneRail));
    expect(rail.width, 208);
    expect(rail.right, 1440);
    expect(rail.height, 900);

    // Selected row: text at n100, others at n500.
    expect(_colorOf(tester, 'Discover'), N.n100);
    expect(_colorOf(tester, 'Showcase'), N.n500);

    // The 14x1 accent tick sits on the selected row, at the far right.
    Finder ticks() => find.byWidgetPredicate(
      (Widget w) => w is Container && w.constraints?.maxWidth == 14,
    );
    expect(ticks(), findsOneWidget);
    expect(
      tester.getRect(ticks()).center.dy,
      moreOrLessEquals(tester.getRect(find.text('Discover')).center.dy, epsilon: 2),
    );

    // Tick moves with the selection.
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(_colorOf(tester, 'About'), N.n100);
    expect(_colorOf(tester, 'Discover'), N.n500);
    expect(
      tester.getRect(ticks()).center.dy,
      moreOrLessEquals(tester.getRect(find.text('About')).center.dy, epsilon: 2),
    );

    // Hover a non-selected row: only its own text lightens.
    final TestGesture mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.text('Showcase')));
    await tester.pumpAndSettle();
    expect(_colorOf(tester, 'Showcase'), N.n200);
    expect(_colorOf(tester, 'Discover'), N.n500);
    expect(_colorOf(tester, 'About'), N.n100);
    expect(ticks(), findsOneWidget);
  });

  testWidgets('nav items are focusable and activate on Enter and Space', (
    WidgetTester tester,
  ) async {
    final List<AppTab> taps = <AppTab>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NocturneRail(
            tab: AppTab.showcase,
            onTabSelected: taps.add,
            onToggleView: () => taps.add(AppTab.about),
          ),
        ),
      ),
    );

    // Tab into the rail: first stop is the first nav item.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();

    expect(taps, <AppTab>[AppTab.showcase, AppTab.discover]);
  });
}
