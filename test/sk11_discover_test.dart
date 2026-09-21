import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/screens/discover_screen.dart';
import 'package:plate_number_holder/screens/gallery/widgets/plate_tile.dart';
import 'package:plate_number_holder/theme/nocturne.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

/// The Discover index lays every card out at a height its grid committed to
/// before building it ([PlateTile.heightFor]), so a card whose footer is one
/// line taller than that arithmetic expects overflows — silently in profile,
/// and on every card at once. These pump the page at the three widths the
/// design has rules for and fail on the first overflow.
void main() {
  for (final (String name, Size size) in <(String, Size)>[
    ('1440 — two columns', Size(1440, 900)),
    ('1000 — under NBreak.detail', Size(1000, 900)),
    ('390 — phone', Size(390, 844)),
  ]) {
    testWidgets('sk11 discover at $name does not overflow', (WidgetTester tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: nocturneTheme(),
          home: Scaffold(
            body: DiscoverScreen(onOpenPlate: (_, _) {}, onOpenCountry: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Every country, not just the ones above the fold: the groups are built
      // lazily and a source with long section titles is the one that breaks.
      for (int i = 0; i < 8; i++) {
        await tester.drag(find.byType(DiscoverScreen), const Offset(0, -700));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }

  testWidgets('sk11 the group turns over at NBreak.detail', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Future<Offset> firstCardAt(double width) async {
      tester.view.physicalSize = Size(width, 900);
      await tester.pumpWidget(
        MaterialApp(
          theme: nocturneTheme(),
          home: Scaffold(
            body: DiscoverScreen(onOpenPlate: (_, _) {}, onOpenCountry: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return tester.getTopLeft(find.byType(PlateTile).first);
    }

    // Above the breakpoint the cards sit in the group's right-hand column,
    // clear of the 220px rail; below it they start at the section's own left
    // padding, because the rail has moved above them.
    expect((await firstCardAt(NBreak.detail + 1)).dx, greaterThan(220));
    expect((await firstCardAt(NBreak.detail - 1)).dx, lessThan(220));
  });
}
