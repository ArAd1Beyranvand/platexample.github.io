import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app.dart';
import 'package:plate_number_holder/screens/gallery/screens/discover_screen.dart';
import 'package:plate_number_holder/screens/gallery/widgets/plate_tile.dart';

/// A plate opened straight from Showcase synthesizes a country page
/// underneath it in one [GalleryShellState._syncToLocation] call, so
/// unwinding back to the bare Discover index from there has to pop two
/// pages in that same call. The pop loop used to issue only one, because it
/// re-checked the stack mirror synchronously right after each `pop()` even
/// though the mirror only trims once that pop's future resolves on a later
/// microtask — see gallery_shell_screen.dart's `_syncToLocation`.
void main() {
  testWidgets('DISCOVER breadcrumb returns to the index after opening a plate from Showcase', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1920, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PlateNumberShowcaseApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byType(PlateTile).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DiscoverScreen), findsNothing);

    await tester.tap(find.text('DISCOVER'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DiscoverScreen), findsOneWidget);

    // The Showcase device stage's card auto-replays for as long as it's
    // mounted (it's kept alive underneath by the `IndexedStack`): tearing the
    // tree down stops it from looping again, but the 1400ms hold it was
    // already waiting out is a bare `Timer` the tile never cancels, so it has
    // to be pumped past before the framework's end-of-test check for pending
    // timers runs.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1500));
  });
}
