import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/device_preview/device_config.dart';
import 'package:plate_number_holder/poster/callouts/callout_card.dart';
import 'package:plate_number_holder/poster/callouts/callout_data.dart';
import 'package:plate_number_holder/screens/showcase/hero.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

/// The hero with a stand-in stage, as in `showcase_hero_test.dart` — the real
/// one drags an auto-typist and five plate packages in behind it.
Widget _hero({required double width, double height = 2400}) {
  return MaterialApp(
    theme: nocturneTheme(),
    home: Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: ShowcaseHero(
          device: DeviceType.desktop,
          onPickDevice: (_) {},
          onOpenArchive: () {},
          stage: const ColoredBox(color: N.surface),
        ),
      ),
    ),
  );
}

/// The headline and the two buttons — the text column the cards must clear.
final List<Finder> _textColumn = <Finder>[
  find.text('Plate input\nfor the road.'),
  find.text('Open the archive'),
  find.text('Read the docs'),
];

void _expectNoOverlapWithText(WidgetTester tester) {
  final List<Rect> cards = tester
      .widgetList<CalloutCard>(find.byType(CalloutCard))
      .map((CalloutCard card) => tester.getRect(find.byWidget(card)))
      .toList();

  for (final Finder finder in _textColumn) {
    final Rect text = tester.getRect(finder);
    for (final Rect card in cards) {
      expect(
        card.overlaps(text),
        isFalse,
        reason: 'callout at $card lands on the hero text at $text',
      );
    }
  }
}

void main() {
  setUp(() {
    // Three cards, and the design says three: nothing downstream may grow the
    // list without this failing first.
    expect(calloutSpecs, hasLength(3));
  });

  testWidgets('above the breakpoint the cards float over the stage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 1232));
    await tester.pumpAndSettle();

    expect(find.byType(CalloutLayer), findsOneWidget);
    expect(find.byType(CalloutList), findsNothing);
    expect(find.byType(CalloutCard), findsNWidgets(3));
    expect(find.text('RULES'), findsOneWidget);
    expect(find.text('FEATURE'), findsOneWidget);
    expect(find.text('SCALE'), findsOneWidget);

    _expectNoOverlapWithText(tester);
  });

  testWidgets('under the breakpoint the cards stack under the stage', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1100, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 1100));
    await tester.pumpAndSettle();

    expect(find.byType(CalloutList), findsOneWidget);
    expect(find.byType(CalloutLayer), findsNothing);
    expect(find.byType(CalloutCard), findsNWidgets(3));

    // Stacked means stacked: one column, in the design's order, top to bottom.
    final List<Rect> cards = tester
        .widgetList<CalloutCard>(find.byType(CalloutCard))
        .map((CalloutCard card) => tester.getRect(find.byWidget(card)))
        .toList();
    for (int i = 1; i < cards.length; i++) {
      expect(cards[i].top, greaterThanOrEqualTo(cards[i - 1].bottom));
      expect(cards[i].left, cards[i - 1].left);
    }

    _expectNoOverlapWithText(tester);
  });

  testWidgets('the phone panel keeps the stacked list', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 390));
    await tester.pumpAndSettle();

    expect(find.byType(CalloutList), findsOneWidget);
    expect(find.byType(CalloutCard), findsNWidgets(3));
    _expectNoOverlapWithText(tester);
  });

  testWidgets('the card is a hairline panel with no shadow, and an accent kicker', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: nocturneTheme(),
        home: Scaffold(
          body: Center(child: SizedBox(width: 200, child: CalloutCard(spec: calloutSpecs.first))),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final BoxDecoration decoration = tester
        .widget<Container>(
          find.descendant(of: find.byType(CalloutCard), matching: find.byType(Container)).first,
        )
        .decoration! as BoxDecoration;

    expect(decoration.boxShadow, anyOf(isNull, isEmpty));
    expect(decoration.border, Border.all(color: N.n800));
    expect((decoration.borderRadius! as BorderRadius).topLeft.x, NRadius.lg);
    expect(decoration.gradient, isA<LinearGradient>());

    final TextStyle kicker = tester.widget<Text>(find.text('RULES')).style!;
    expect(kicker.fontFamily, NType.mono);
    expect(kicker.color, N.accent300);
  });
}
