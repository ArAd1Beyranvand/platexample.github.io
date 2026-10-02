import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/screens/country_detail_screen.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';
import 'package:plate_number_holder/screens/gallery/widgets/plate_tile.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

/// The country grid lays out every plate the source ships at once — Yemen's
/// and Palestine's catalogues are the deepest — so these pump the page at the
/// three widths sk12 pins column counts to and fail on the first overflow.
void main() {
  for (final (String name, Size size) in <(String, Size)>[
    ('1440 — three columns', Size(1440, 900)),
    ('1040 — two columns', Size(1040, 900)),
    ('390 — phone, one column', Size(390, 844)),
  ]) {
    testWidgets('sk12 country grid at $name does not overflow', (WidgetTester tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      for (final GallerySource source in gallerySources) {
        await tester.pumpWidget(
          MaterialApp(
            theme: nocturneTheme(),
            home: CountryDetailScreen(source: source, onOpenPlate: (_, _) {}),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: source.countryName);

        for (int i = 0; i < 6; i++) {
          await tester.drag(find.byType(CountryDetailScreen), const Offset(0, -700));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: source.countryName);
        }
      }
    });
  }

  // currently failing
  testWidgets('sk12 the grid turns over at the pinned breakpoints', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    Future<int> columnCountAt(double width) async {
      tester.view.physicalSize = Size(width, 1200);
      await tester.pumpWidget(
        MaterialApp(
          theme: nocturneTheme(),
          home: CountryDetailScreen(source: gallerySources.first, onOpenPlate: (_, _) {}),
        ),
      );
      await tester.pumpAndSettle();
      final double firstTop = tester.getTopLeft(find.byType(PlateTile).first).dy;
      return find.byType(PlateTile).evaluate().where((element) {
        final RenderBox box = element.renderObject! as RenderBox;
        final Offset top = box.localToGlobal(Offset.zero);
        return (top.dy - firstTop).abs() < 1;
      }).length;
    }

    expect(await columnCountAt(1440), 3);
    expect(await columnCountAt(1040), 2);
    expect(await columnCountAt(650), 1);
  });
}
