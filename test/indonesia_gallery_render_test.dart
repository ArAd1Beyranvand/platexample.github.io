import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  testWidgets('every Indonesia entry renders with its own theme', (t) async {
    final source = gallerySources.whereType<IndonesiaSource>().single;
    final themes = <PlateTheme>{};
    for (final section in source.sections) {
      for (final e in section.entries) {
        themes.add(e.theme!);
        final c = PlateController.fromValues(e.spec, e.sampleValues!);
        await t.pumpWidget(MaterialApp(
          home: SizedBox(
            width: 460,
            height: 200,
            child: PlateView(controller: c, theme: e.theme!, country: e.country),
          ),
        ));
        expect(t.takeException(), isNull, reason: e.id);
        expect(e.sampleValues!.length, e.spec.slots.length, reason: e.id);
        await t.pumpWidget(const SizedBox.shrink());
        c.dispose();
      }
    }
    // diplomatic equals private by value: black on white, black band.
    expect(themes.length, 9);
  });
}
