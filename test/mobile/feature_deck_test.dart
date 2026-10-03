import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/device_preview/device_config.dart';
import 'package:plate_number_holder/mobile/feature_deck.dart';
import 'package:plate_number_holder/mobile/segmented_progress.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

Future<FeatureDeckController> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final FeatureDeckController controller = FeatureDeckController();
  addTearDown(controller.dispose);
  // Held unsettled so the 4 s dwell never advances on its own.
  controller.settled.value = false;
  await tester.pumpWidget(
    MaterialApp(
      theme: nocturneTheme(),
      home: Scaffold(
        body: SingleChildScrollView(child: FeatureDeck(controller: controller)),
      ),
    ),
  );
  return controller;
}

void main() {
  testWidgets('right zone advances, left zone goes back, wrap rewinds', (
    WidgetTester tester,
  ) async {
    final FeatureDeckController c = await _pump(tester);
    expect(c.index.value, 0);

    final Rect card = tester.getRect(find.text('01 / 09')).inflate(0);
    final Offset right = Offset(370, card.top - 60);
    final Offset left = Offset(30, card.top - 60);

    await tester.tapAt(right);
    expect(c.index.value, 1);
    await tester.tapAt(left);
    expect(c.index.value, 0);
    await tester.tapAt(left);
    expect(c.index.value, 8, reason: 'back from the first wraps to the last');
    await tester.pump();
    expect(find.text('09 / 09'), findsOneWidget);
    await tester.tapAt(right);
    await tester.pump();
    expect(c.index.value, 0);
    expect(find.text('01 / 09'), findsOneWidget);
  });

  testWidgets('a chip jumps to the first card of its group', (
    WidgetTester tester,
  ) async {
    final FeatureDeckController c = await _pump(tester);
    for (final DeviceType device in DeviceType.values) {
      c.jumpTo(firstIndexOf(device));
      await tester.pump();
      expect(c.index.value, firstIndexOf(device));
    }
  });

  testWidgets('tapping a progress segment jumps to it', (
    WidgetTester tester,
  ) async {
    final FeatureDeckController c = await _pump(tester);
    final Rect bar = tester.getRect(find.byType(SegmentedProgress));
    await tester.tapAt(Offset(bar.right - 4, bar.center.dy));
    expect(c.index.value, 8);
  });

  testWidgets('the dwell advances when settled; long press pauses it', (
    WidgetTester tester,
  ) async {
    final FeatureDeckController c = await _pump(tester);
    c.settled.value = true;
    await tester.pump();
    await tester.pump(const Duration(seconds: 4, milliseconds: 100));
    expect(c.index.value, 1);

    final Rect footer = tester.getRect(find.text('02 / 09'));
    final TestGesture hold = await tester.startGesture(
      Offset(200, footer.top - 60),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 6));
    expect(c.index.value, 1, reason: 'held card must not advance');
    await hold.up();
    await tester.pump();
  });
}
