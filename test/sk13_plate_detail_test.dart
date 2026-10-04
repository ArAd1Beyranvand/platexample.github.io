import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_keypad/plate_keypad.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_index.dart';
import 'package:plate_number_holder/screens/gallery/screens/plate_detail_screen.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

/// sk13's gate, as far as a widget test can carry it: the two-column layout
/// holds at every width for the four plates the prompt names, the caption
/// counts live off the controller, the radio list still drives
/// `PlateInputSource`, and the Persian country block resolves to a font that
/// can draw it.
CatalogueItem _item(String entryId) =>
    catalogueItems.firstWhere((CatalogueItem item) => item.entry.id == entryId);

Widget _app(CatalogueItem item) => MaterialApp(
  theme: nocturneTheme(),
  home: PlateDetailScreen(item: item, heroTag: 'test:${item.entry.id}'),
);

void main() {
  // The four sk13 names by hand: Iran (a `chosen` letter slot), Palestine
  // (a value-driven livery), Germany (the one real validator) and Lebanon.
  const List<String> entryIds = <String>[
    'ir.car',
    'ps.gaza.car2012',
    'de.car',
    'lb.oneLine.private',
  ];

  for (final (String name, Size size) in <(String, Size)>[
    ('1440 — two columns', Size(1440, 900)),
    ('1000 — stacked', Size(1000, 900)),
    ('390 — phone panel', Size(390, 844)),
  ]) {
    testWidgets('sk13 plate detail at $name does not overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      for (final String entryId in entryIds) {
        await tester.pumpWidget(_app(_item(entryId)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: entryId);

        // Every mode in turn — the keypad one grows a strip under the page,
        // which is the layout most likely to run out of height.
        for (final String mode in <String>['Hardware', 'Keypad', 'System']) {
          // The aside scrolls under 1040, so a mode can start below the fold.
          await tester.ensureVisible(find.text(mode));
          await tester.pumpAndSettle();
          await tester.tap(find.text(mode));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$entryId / $mode');
        }
      }
    });
  }

  testWidgets('sk13 the slot caption counts off the controller', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Germany's plate is the one with empty sample slots to fill.
    final CatalogueItem item = _item('de.car');
    await tester.pumpWidget(_app(item));
    await tester.pumpAndSettle();

    final Finder caption = find.textContaining('SLOTS FILLED');
    expect(caption, findsOneWidget);

    final PlateController controller = tester
        .widget<PlateCanvas>(find.byType(PlateCanvas))
        .controller!;

    final int before = controller.values
        .where((String? v) => v != null && v.isNotEmpty)
        .length;
    expect(
      tester.widget<Text>(caption).data,
      startsWith('$before SLOTS FILLED'),
    );

    controller.setAt(0, 'B');
    await tester.pumpAndSettle();
    final int after = controller.values
        .where((String? v) => v != null && v.isNotEmpty)
        .length;
    expect(
      tester.widget<Text>(find.textContaining('SLOTS FILLED')).data,
      startsWith('$after SLOTS FILLED'),
    );
  });

  testWidgets('sk13 the radio list still drives PlateInputSource', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(_item('ir.car')));
    await tester.pumpAndSettle();

    PlateInputSource? sourceOf() =>
        tester.widget<PlateCanvas>(find.byType(PlateCanvas)).inputSource;

    expect(sourceOf(), PlateInputSource.system);
    expect(find.byType(PlateKeypad), findsNothing);

    await tester.tap(find.text('Keypad'));
    await tester.pumpAndSettle();
    expect(sourceOf(), PlateInputSource.packageKeypad);
    expect(find.byType(PlateKeypad), findsOneWidget);

    await tester.tap(find.text('Hardware'));
    await tester.pumpAndSettle();
    expect(sourceOf(), PlateInputSource.hardwareKeyboard);
    expect(find.byType(PlateKeypad), findsNothing);
  });

  testWidgets('sk13 an Arabic-script country block gets Vazirmatn', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Lebanon's country block is its spec label, `لبنان`.
    await tester.pumpWidget(_app(_item('lb.oneLine.private')));
    await tester.pumpAndSettle();

    // The plate itself paints the same word, so this asserts over every
    // match rather than the first: one of them is the aside's fact row, and
    // that one has to be in a font that can draw it.
    final Finder block = find.textContaining('لبنان');
    expect(block, findsWidgets);
    expect(
      tester.widgetList<Text>(block).map((Text t) => t.style?.fontFamily),
      contains(NType.arabic),
    );
  });

  testWidgets('sk13 PROPORTIONS and VALIDATOR survive the redesign', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(_item('ir.car')));
    await tester.pumpAndSettle();

    for (final String label in <String>[
      'PROPORTIONS',
      'VALIDATOR',
      'PACKAGE',
      'SPEC',
      'COUNTRY BLOCK',
      'SLOTS',
      'LIVERY',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(find.text('None'), findsOneWidget);
  });
}
