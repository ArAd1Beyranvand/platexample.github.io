import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:plate_number_holder/newdesign/app/location.dart';
import 'package:plate_number_holder/newdesign/data/catalogue.dart';
import 'package:plate_number_holder/newdesign/embed/protocol.dart';
import 'package:plate_number_holder/newdesign/embed/registry.dart';

void main() {
  final Map<String, Object?> vectors =
      jsonDecode(File('../ports/web/protocol_vectors.json').readAsStringSync())
          as Map<String, Object?>;

  group('protocol_vectors.json', () {
    for (final Object? c in vectors['cases']! as List<Object?>) {
      final Map<String, Object?> v = c! as Map<String, Object?>;
      // The host only receives component-to-host messages.
      if (v['dir'] != 'C2H') continue;
      test(v['name']! as String, () {
        expect(parseHostMessage(v['message']) != null, v['valid']);
      });
    }
  });

  group('registry', () {
    final EmbedRegistry r = EmbedRegistry.parse(
      '{"version":1,"components":{"germany":{"python":{"url":"/components/germany/python/","hash":"d4"},'
      '"rust":{"url":"/x/"}}}}',
    )!;

    test('languages: flutter plus built ones, unknown dropped', () {
      expect(r.languagesOf('germany'), <String>['flutter', 'python']);
      expect(r.languagesOf('india'), <String>['flutter']);
    });

    test('resolve busts with the hash', () {
      final Uri u = r.of('germany', 'python')!.resolve(Uri.parse('https://x.dev/#/plates/germany'));
      expect(u.toString(), 'https://x.dev/components/germany/python/index.html?v=d4');
    });

    test('bad bodies parse to null', () {
      expect(EmbedRegistry.parse('nope'), isNull);
      expect(EmbedRegistry.parse('{"version":2,"components":{}}'), isNull);
    });
  });

  group('routes', () {
    test('language segment', () {
      final String slug = plateCountries.first.slug;
      final PdLocation l = PdLocation.fromUri(Uri.parse('/plates/$slug/python'));
      expect(l.isCountry, isTrue);
      expect(l.lang, 'python');
      expect(l.path, '/plates/$slug/python');
      expect(PdLocation.fromUri(Uri.parse('/plates/$slug/flutter')).lang, isNull);
      expect(PdLocation.fromUri(Uri.parse('/plates/$slug')).path, '/plates/$slug');
    });
  });
}
