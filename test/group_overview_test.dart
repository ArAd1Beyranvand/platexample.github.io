import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/app/app_routes.dart';
import 'package:plate_number_holder/screens/gallery/screens/group_overview_screen.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';
import 'package:plate_number_holder/theme/nocturne_theme.dart';

void main() {
  final GallerySource yemen = gallerySources.whereType<YemenSource>().single;

  test('Yemen is an umbrella over its five systems', () {
    expect(yemen.members.map((GallerySource m) => m.countryName), <String>[
      'Unified (2026)',
      'Northern (1993)',
      'Hadhramaut, Al Mahrah, Shabwah, Marib',
      'Aden and Taiz',
      'Riyadh',
    ]);
    expect(AppLocation.country(yemen).isOverview, isTrue);
    for (final GallerySource member in yemen.members) {
      final AppLocation at = AppLocation.country(member);
      expect(at.path, '/discover/yemen/${member.slug}');
      expect(AppLocation.fromUri(Uri.parse(at.path)), at);
      expect(at.isOverview, isFalse);
    }
  });

  testWidgets('the Yemen overview renders a group per system', (t) async {
    t.view.physicalSize = const Size(1440, 2400);
    t.view.devicePixelRatio = 1.0;
    addTearDown(t.view.reset);
    await t.pumpWidget(
      MaterialApp(
        theme: nocturneTheme(),
        home: Scaffold(
          body: GroupOverviewScreen(
            source: yemen,
            onOpenPlate: (_, _) {},
            onOpenCountry: (_) {},
          ),
        ),
      ),
    );
    await t.pump();
    expect(t.takeException(), isNull);
    expect(find.text('Five systems, one country'), findsOneWidget);
    expect(find.text('Riyadh'), findsWidgets);
  });
}
