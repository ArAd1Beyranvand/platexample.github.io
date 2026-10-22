import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  testWidgets('every Luxembourg entry renders with its own theme', (t) async {
    final source = allGallerySources.whereType<LuxembourgSource>().single;
    for (final section in source.sections) {
      for (final e in section.entries) {
        final c = PlateController.fromValues(e.spec, e.sampleValues!);
        await t.pumpWidget(
          MaterialApp(
            home: SizedBox(
              width: 460,
              height: 130,
              child: PlateView(controller: c, theme: e.theme!, country: e.country),
            ),
          ),
        );
        expect(t.takeException(), isNull, reason: e.id);
        expect(e.sampleValues!.length, e.spec.slots.length, reason: e.id);
        if (e.validator != null) {
          if (e.validator != null) {
            expect(
              e.validator!.validate(PlateEntry(spec: e.spec, values: e.sampleValues!)).isValid,
              isTrue,
              reason: e.id,
            );
          }
        }
        await t.pumpWidget(const SizedBox.shrink());
        c.dispose();
      }
    }
  });
}
