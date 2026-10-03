import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/mobile/archive_strip.dart';
import 'package:plate_number_holder/screens/gallery/catalogue_stats.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

void main() {
  testWidgets('the four stat cells sit on one baseline, in one short strip', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: nocturneTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: ArchiveStrip(stats: CatalogueStats.of(gallerySources)),
          ),
        ),
      ),
    );

    final List<double> tops = <String>[
      'PKGS',
      'COUNTRIES',
      'SPECS',
      'FORMS',
    ].map((String l) => tester.getTopLeft(find.text(l)).dy).toList();
    expect(
      tops.reduce((double a, double b) => a > b ? a : b) -
          tops.reduce((double a, double b) => a < b ? a : b),
      lessThan(2),
      reason: 'labels share one baseline',
    );
    expect(
      tester.getSize(find.byType(IntrinsicHeight).first).height,
      lessThan(100),
    );
  });
}
