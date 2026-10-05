import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/device_preview/device_config.dart';
import 'package:plate_number_holder/screens/showcase/hero.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

const Key _stageKey = Key('stage');

/// The hero with a stand-in for the device stage, which sk9 owns and which
/// drags an auto-typist and five plate packages in behind it.
///
/// [height] is always generous. `flutter test` renders every string in the
/// test font, whose glyphs are all one em wide — roughly twice Archivo's
/// average — so the paragraph and the headline take far more lines here than
/// they do on screen, and a box sized to a real 900px viewport would overflow
/// for reasons that have nothing to do with the layout. Width is what selects
/// the branch under test, and width is measured honestly.
Widget _hero({
  required double width,
  double height = 2400,
  DeviceType device = DeviceType.desktop,
  ValueChanged<DeviceType>? onPickDevice,
  VoidCallback? onOpenArchive,
}) {
  return MaterialApp(
    theme: nocturneTheme(),
    home: Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: ShowcaseHero(
          device: device,
          onPickDevice: onPickDevice ?? (_) {},
          onOpenArchive: onOpenArchive ?? () {},
          stage: const ColoredBox(key: _stageKey, color: N.surface),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('hero lays out in two columns above the breakpoint', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // 1440 less the rail's 208px — the width the shell actually hands the
    // showcase on a 1440 window.
    await tester.pumpWidget(_hero(width: 1232));

    expect(find.text('Plate input\nfor Flutter.'), findsOneWidget);
    expect(find.text('ARAD BEYRANVAND — SOLE AUTHOR'), findsOneWidget);
    expect(find.text('Browse plates →'), findsOneWidget);
    expect(find.text('View on pub.dev'), findsOneWidget);

    // The serif is used for the paragraph and nowhere else in the hero — the
    // headline stays on Archivo.
    final TextStyle heading = tester
        .widget<Text>(find.text('Plate input\nfor Flutter.'))
        .style!;
    expect(heading.fontFamily, NType.archivo);
    expect(heading.fontWeight, FontWeight.w800);
    expect(heading.fontSize, closeTo(1232 * 0.056, 0.01));

    // Text left, stage right.
    expect(
      tester.getTopLeft(find.text('Plate input\nfor Flutter.')).dx,
      lessThan(tester.getTopLeft(find.byKey(_stageKey)).dx),
    );
  });

  testWidgets(
    'hero stacks under the breakpoint and drops the headline to 56px',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(900, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_hero(width: 900));

      expect(
        tester
            .widget<Text>(find.text('Plate input\nfor Flutter.'))
            .style!
            .fontSize,
        56,
      );
      // Stacked means the stage is below the text, not beside it.
      expect(
        tester.getTopLeft(find.byKey(_stageKey)).dy,
        greaterThan(
          tester.getBottomLeft(find.text('Plate input\nfor Flutter.')).dy,
        ),
      );
    },
  );

  testWidgets('the mobile hero text stacks the buttons full-width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: nocturneTheme(),
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 2400,
            child: MobileHeroText(onOpenArchive: () {}),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester
          .widget<Text>(find.text('Plate input\nfor Flutter.'))
          .style!
          .fontSize,
      40,
    );

    // Full-width and stacked: both buttons span the column inside its 18px
    // gutters, and the secondary sits below the primary rather than beside it.
    final Rect primary = tester.getRect(find.text('Browse plates →'));
    final Rect secondary = tester.getRect(find.text('View on pub.dev'));
    expect(secondary.right, lessThanOrEqualTo(390 - 18));
    expect(primary.width, closeTo(390 - 36 - 2 * 22 - 2, 1));
    expect(secondary.top, greaterThan(primary.bottom));
  });

  testWidgets('the hero never grows past the height it is given', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // The regression this replaced: below the hero breakpoint the section grew
    // to its content's height inside a scroll view, so the stage rendered off
    // the bottom of the window. The stage now takes the space that is left,
    // whatever is left — here, a real 900px-tall viewport.
    await tester.pumpWidget(_hero(width: 1232, height: 900));

    expect(
      tester.getRect(find.byKey(_stageKey)).bottom,
      lessThanOrEqualTo(900),
    );
  });

  testWidgets('picking a segment reports that device', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final List<DeviceType> picked = <DeviceType>[];
    await tester.pumpWidget(_hero(width: 1232, onPickDevice: picked.add));

    // The selected cell is the one the stage is showing.
    expect(tester.widget<Text>(find.text('DESKTOP')).style!.color, N.accent);
    expect(tester.widget<Text>(find.text('MOBILE')).style!.color, N.text);

    await tester.tap(find.text('MOBILE'));
    expect(picked, <DeviceType>[DeviceType.mobile]);
  });

  testWidgets('Browse plates asks to navigate', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    int opened = 0;
    await tester.pumpWidget(_hero(width: 1232, onOpenArchive: () => opened++));

    await tester.tap(find.text('Browse plates →'));
    expect(opened, 1);
  });
}
