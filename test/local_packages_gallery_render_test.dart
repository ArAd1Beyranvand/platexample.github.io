import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

/// The countries wired in from the local, not-yet-published packages. One test
/// over all of them rather than one file each: they were written together from
/// the same probe of each package's slot shapes, so they fail together too.
final List<Type> _localSources = <Type>[
  AngolaSource,
  BeninSource,
  BhutanSource,
  BosniaAndHerzegovinaSource,
  BotswanaSource,
  CambodiaSource,
  CentralAfricanRepublicSource,
  EgyptSource,
  JordanSource,
  MalawiSource,
  MaltaSource,
  MongoliaSource,
  MozambiqueSource,
  MyanmarSource,
  NorwaySource,
  RepublicOfTheCongoSource,
  SaintVincentAndTheGrenadinesSource,
  SerbiaSource,
  SriLankaSource,
  TanzaniaSource,
  ThailandSource,
  TimorLesteSource,
  UruguaySource,
  VanuatuSource,
  VaticanCitySource,
];

void main() {
  testWidgets('every local-package entry renders and validates', (WidgetTester t) async {
    for (final Type type in _localSources) {
      final GallerySource source = allGallerySources
          .where((GallerySource s) => s.runtimeType == type)
          .single;
      expect(source.sections, isNotEmpty, reason: '$type');
      for (final GallerySection section in source.sections) {
        for (final GalleryEntry e in section.entries) {
          expect(e.sampleValues!.length, e.spec.slots.length, reason: e.id);
          final PlateController c = PlateController.fromValues(e.spec, e.sampleValues!);
          await t.pumpWidget(
            MaterialApp(
              home: SizedBox(
                width: 460,
                height: 160,
                child: PlateView(controller: c, theme: e.theme!, country: e.country),
              ),
            ),
          );
          expect(t.takeException(), isNull, reason: e.id);
          if (e.validator != null) {
            expect(
              e.validator!.validate(PlateEntry(spec: e.spec, values: e.sampleValues!)).isValid,
              isTrue,
              reason: e.id,
            );
          }
          await t.pumpWidget(const SizedBox.shrink());
          c.dispose();
        }
      }
    }
  });
}
