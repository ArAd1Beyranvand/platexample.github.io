import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/device_preview/device_config.dart';
import 'package:plate_number_holder/poster/callout_motion.dart';
import 'package:plate_number_holder/poster/callouts/callout_card.dart';
import 'package:plate_number_holder/poster/callouts/callout_data.dart';
import 'package:plate_number_holder/screens/showcase/hero.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

/// The hero with a stand-in stage, as in `showcase_hero_test.dart` — the real
/// one drags an auto-typist and five plate packages in behind it.
Widget _hero({
  required double width,
  double height = 2400,
  DeviceType device = DeviceType.tablet,
}) {
  return MaterialApp(
    theme: nocturneTheme(),
    home: Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: ShowcaseHero(
          device: device,
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
  find.text('Plate input\nfor Flutter.'),
  find.text('Browse plates'),
  find.text('View on pub.dev'),
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
    // Three sets of three, and the design says three: nothing downstream may
    // grow a set, or leave a device without one, without this failing first.
    expect(calloutSets.keys, unorderedEquals(DeviceType.values));
    for (final DeviceType device in DeviceType.values) {
      expect(calloutSetFor(device), hasLength(3), reason: '$device');
    }
  });

  testWidgets('above the breakpoint the cards float over the stage', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 1232));
    await tester.pumpAndSettle();

    expect(find.byType(CalloutLayer), findsOneWidget);
    expect(find.byType(CalloutList), findsNothing);
    expect(find.byType(CalloutCard), findsNWidgets(3));
    expect(find.text('RULES'), findsOneWidget);
    expect(find.text('CONTROLLER'), findsOneWidget);
    expect(find.text('STATE'), findsOneWidget);

    _expectNoOverlapWithText(tester);
  });

  testWidgets('under the breakpoint the cards stack in a column', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 1100));
    await tester.pumpAndSettle();

    expect(find.byType(CalloutList), findsOneWidget);
    expect(find.byType(CalloutLayer), findsNothing);
    expect(find.byType(CalloutCard), findsNWidgets(3));

    // Stacked column: one above the other.
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

  testWidgets('each device brings its own set, and the swap is by tile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_hero(width: 1232, device: DeviceType.tablet));
    await tester.pumpAndSettle();
    expect(find.text('RULES'), findsOneWidget);
    expect(find.text('COUNTRIES'), findsNothing);

    // sk23.5 step 4.1: the tile transitions stay mounted at rest, one per
    // card. Swapping them out for their children on the settling frame is what
    // used to remount every card and pop it.
    expect(find.byType(TileTransition), findsNWidgets(3));

    await tester.pumpWidget(_hero(width: 1232, device: DeviceType.desktop));
    await tester.pumpAndSettle();
    expect(find.text('COUNTRIES'), findsOneWidget);
    expect(find.text('RULES'), findsNothing);
    expect(find.byType(CalloutCard), findsNWidgets(3));
    expect(find.byType(TileTransition), findsNWidgets(3));

    // The set flips once, at the crossover — not at the start of the hop.
    await tester.pumpWidget(_hero(width: 1232, device: DeviceType.mobile));
    await tester.pump();
    expect(
      find.text('COUNTRIES'),
      findsOneWidget,
      reason: 'outgoing set holds through the exit',
    );
    await tester.pumpAndSettle();
    expect(find.text('KEYPAD'), findsOneWidget);
  });

  testWidgets(
    'the card is a hairline panel with no shadow, and an accent kicker',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: nocturneTheme(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: CalloutCard(
                  spec: calloutSetFor(DeviceType.tablet).first,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final BoxDecoration decoration =
          tester
                  .widget<Container>(
                    find
                        .descendant(
                          of: find.byType(CalloutCard),
                          matching: find.byType(Container),
                        )
                        .first,
                  )
                  .decoration!
              as BoxDecoration;

      expect(decoration.boxShadow, anyOf(isNull, isEmpty));
      expect(decoration.border, Border.all(color: N.n800));
      expect((decoration.borderRadius! as BorderRadius).topLeft.x, NRadius.lg);
      expect(decoration.gradient, isA<LinearGradient>());

      final TextStyle kicker = tester.widget<Text>(find.text('RULES')).style!;
      expect(kicker.fontFamily, NType.mono);
      expect(kicker.color, N.accent300);
    },
  );
}
