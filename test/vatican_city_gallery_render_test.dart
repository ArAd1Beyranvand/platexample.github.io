import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

/// Every Vatican City gallery entry drawn the way the catalogue draws it.
///
/// A spec can pass its golden and still assert the moment the app shows it:
/// `debugValidateSpec` only runs on render, and the catalogue supplies the
/// theme and country separately from the spec, so an entry wired to the wrong
/// one of the three fails here and nowhere else.
void main() {
  final List<GalleryEntry> entries = <GalleryEntry>[
    for (final GallerySection section in VaticanCitySource().sections) ...section.entries,
  ];

  test('every Vatican City entry is wired to a theme and a country', () {
    expect(entries, isNotEmpty);
    for (final GalleryEntry entry in entries) {
      expect(entry.theme, isNotNull, reason: '${entry.id} has no theme');
      expect(entry.country, isNotNull, reason: '${entry.id} has no country');
      expect(
        entry.sampleValues,
        hasLength(entry.spec.slotCount),
        reason:
            '${entry.id} samples ${entry.sampleValues?.length} of ${entry.spec.slotCount} slots',
      );
    }
  });

  for (final GalleryEntry entry in entries) {
    testWidgets('${entry.id} renders', (WidgetTester tester) async {
      final PlateController controller = PlateController.fromValues(
        entry.spec,
        entry.sampleValues!,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 520,
                height: 520 * entry.spec.canvasHeight / entry.spec.canvasWidth,
                child: PlateThemeScope(
                  theme: entry.theme!,
                  child: PlateView(
                    controller: controller,
                    theme: entry.theme,
                    country: entry.country,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
