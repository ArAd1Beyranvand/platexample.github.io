import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

void main() {
  testWidgets('every Turkey entry renders, validates, in its own theme', (t) async {
    final source = iranshahirCountries.whereType<TurkeySource>().single;
    final themes = <PlateTheme>{};
    for (final section in source.sections) {
      for (final e in section.entries) {
        themes.add(e.theme!);
        expect(e.sampleValues!.length, e.spec.slots.length, reason: e.id);
        if (e.validator != null) {
          expect(
            e.validator!.validate(PlateEntry(spec: e.spec, values: e.sampleValues!)).isValid,
            isTrue,
            reason: e.id,
          );
        }
        final c = PlateController.fromValues(e.spec, e.sampleValues!);
        await t.pumpWidget(
          MaterialApp(
            home: SizedBox(
              width: 460,
              height: 230,
              child: PlateThemeScope(
                theme: e.theme!,
                child: PlateCanvas(
                  spec: e.spec,
                  country: e.country,
                  controller: c,
                  onChooseCharacter: (_) async => null,
                ),
              ),
            ),
          ),
        );
        expect(t.takeException(), isNull, reason: e.id);
        await t.pumpWidget(const SizedBox.shrink());
        c.dispose();
      }
    }
    expect(themes.length, 10);
  });
}
