// D3 exporter: every spec, alphabet, country and theme the country packages
// expose, as JSON under ports/data/ for codegen in the TypeScript, Kotlin and
// Python ports. The shape is documented in ports/data/SCHEMA.md.
//
//   python3 ../tools/port_export_names.py   # when packages gain or lose names
//   flutter test --no-pub test/port_export_test.dart
//
// Fails, and writes nothing, on any specProblems not in [knownProblems], any
// value it cannot serialise and any spec id two different specs of one package
// claim.
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';

import 'port_export_names.g.dart';

final Directory root = Directory.current.parent;
final Directory out = Directory('${root.path}/ports/data');

/// Stops a table resolver whose domain is too large to enumerate.
const int maxTableCalls = 3000000;

/// Values one key of a table resolver may take before it is cut to a prefix.
const int maxDomain = 200000;

Never fail(String where, String what) => throw StateError('$where: $what');

/// specProblems the Dart packages have today: slot boxes up to 0.7 units past
/// the canvas edge. Pinned so a new problem fails, and so does a fixed one
/// until it is removed here.
const Set<String> knownProblems = <String>{
  'eswatini_plate sz.front: PlateSlot 0 in spec "sz.front" has a rect outside the canvas (520.0x110.0).',
  'eswatini_plate sz.front: PlateSlot 1 in spec "sz.front" has a rect outside the canvas (520.0x110.0).',
  'eswatini_plate sz.front: PlateSlot 2 in spec "sz.front" has a rect outside the canvas (520.0x110.0).',
  'trinidad_and_tobago_plate tt.private: PlateSlot 0 in spec "tt.private" has a rect outside the canvas (520.0x110.0).',
  'trinidad_and_tobago_plate tt.private: PlateSlot 1 in spec "tt.private" has a rect outside the canvas (520.0x110.0).',
};

void main() {
  test('export ports/data', () {
    final export = Exporter()..collect();
    final problems = export.problems.toSet();
    expect(problems, knownProblems, reason: problems.difference(knownProblems).join('\n'));
    export.write();
  }, timeout: const Timeout(Duration(minutes: 20)));
}

/// One country package's share of the export.
class Package {
  Package(this.name);

  final String name;
  final Map<String, PlateSpec> specs = <String, PlateSpec>{};
  final Map<String, List<String>> specNames = <String, List<String>>{};
  final List<Map<String, Object?>> specJsons = <Map<String, Object?>>[];
  final Set<String> alphabets = <String>{};
  final Map<String, Map<String, Object?>> countries = <String, Map<String, Object?>>{};
  final Map<String, Map<String, Object?>> themes = <String, Map<String, Object?>>{};
  final Map<String, Map<String, Object?>> resolvers = <String, Map<String, Object?>>{};
  final Map<String, Map<String, Object?>> assets = <String, Map<String, Object?>>{};
  final List<Map<String, Object?>> gallery = <Map<String, Object?>>[];
}

class Exporter {
  final Map<String, Package> packages = <String, Package>{};
  final Map<String, Map<String, Object?>> alphabets = <String, Map<String, Object?>>{};
  final Map<String, List<List<String>>> alphabetNames = <String, List<List<String>>>{};
  final Map<PlateSpec, Set<String>> ownersBySpec = Map<PlateSpec, Set<String>>.identity();
  final List<String> problems = <String>[];

  Package package(String name) => packages.putIfAbsent(name, () => Package(name));

  void collect() {
    final names = portExportNames;
    for (final MapEntry(key: pkg, value: values) in names.entries) {
      if (pkg != 'plate_alphabet') package(pkg);
      for (final v in values.values) {
        if (v is PlateSpec) ownersBySpec.putIfAbsent(v, () => {}).add(pkg);
      }
    }
    for (final MapEntry(key: pkg, value: values) in names.entries) {
      for (final MapEntry(key: name, value: v) in values.entries) {
        switch (v) {
          case PlateAlphabet():
            alphabetNames.putIfAbsent(alphabet(v), () => []).add([pkg, name]);
          case PlateSpec():
            addSpec(package(pkg), v, name);
          case PlateCountry():
            countryRef(package(pkg), v, name);
          case PlateTheme():
            themeRef(package(pkg), v, name);
          default:
            fail('$pkg:$name', 'unexpected ${v.runtimeType}');
        }
      }
    }
    collectGallery();
    for (final p in packages.values) {
      for (final spec in p.specs.values) {
        problems.addAll(specProblems(spec).map((problem) => '${p.name} ${spec.id}: $problem'));
        p.specJsons.add(specJson(p, spec));
      }
    }
  }

  // Specs.

  /// Spec ids are unique within a package only: Madeira re-exports Portugal's
  /// `pt.*` specs, and South Ossetia and Somalia both claim `so.standard`.
  void addSpec(Package p, PlateSpec spec, String? name) {
    final known = p.specs[spec.id];
    if (known == null) {
      p.specs[spec.id] = spec;
      p.specNames[spec.id] = <String>[];
    } else if (!identical(known, spec)) {
      final a = jsonEncode(specJson(p, known)), b = jsonEncode(specJson(p, spec));
      if (a != b) {
        problems.add('${p.name}: two different specs share id ${spec.id} '
            '(${p.specNames[spec.id]!.join(', ')} vs ${name ?? 'a gallery entry'})');
      }
    }
    if (name != null) p.specNames[spec.id]!.add(name);
  }

  Map<String, Object?> specJson(Package p, PlateSpec s) {
    final w = s.id;
    final leaves = s.background.layout(Rect.fromLTWH(0, 0, s.canvasWidth, s.canvasHeight)).leaves;
    var leaf = 0;
    Map<String, Object?> section(PlateSection x, String at) {
      if (x.isLeaf) {
        final size = leaves[leaf++].$2.size;
        return {
          'kind': 'fill',
          'fill': fill(x.fill!, '$at/fill'),
          'shape': x.shape == null ? null : clip(x.shape!, size),
        };
      }
      return {
        'kind': x.axis == Axis.horizontal ? 'columns' : 'rows',
        'parts': [
          for (final (i, part) in x.parts.indexed)
            {'section': section(part.section, '$at/parts/$i'), 'end': part.end, 'divider': part.divider},
        ],
      };
    }

    return {
      'id': s.id,
      'names': p.specNames[s.id],
      'country': countryRef(p, s.country, null),
      'canvasWidth': s.canvasWidth,
      'canvasHeight': s.canvasHeight,
      'panel': {
        'box': box(s.panel.box),
        'flagScale': s.panel.flagScale,
        'captionScale': s.panel.captionScale,
        'padding': switch (s.panel.padding) {
          null => null,
          final e => [e.left, e.top, e.right, e.bottom],
        },
        'direction': s.panel.direction.name,
        'shape': s.panel.shape == null ? null : clip(s.panel.shape!, s.panel.box.rect.size),
      },
      'noPanel': s.noPanel,
      'background': section(s.background, '$w/background'),
      'bands': [
        for (final b in s.bands)
          {
            'box': box(b.box),
            'color': argb(b.color),
            'topCornerRadius': b.topCornerRadius,
            'bottomCornerRadius': b.bottomCornerRadius,
          },
      ],
      'slots': [
        for (final x in s.slots)
          {
            'alphabet': alphabet(x.alphabet, p),
            'box': box(x.box),
            'color': argbOrNull(x.color),
            'length': x.length,
            'minLength': x.minLength,
            'spacing': x.spacing,
          },
      ],
      'rules': [
        for (final r in s.rules) {'box': box(r.box)},
      ],
      'labels': [
        for (final (i, l) in s.labels.indexed)
          {
            'text': l.text,
            'box': box(l.box),
            'glyphHeight': l.glyphHeight,
            'color': argbOrNull(l.color),
            'rotated': l.rotated,
            'lineHeight': l.lineHeight,
            'fontFamily': l.fontFamily,
            'fontPackage': l.fontPackage,
            'resolve': l.resolve == null ? null : resolver(p, s, l.resolve!, '$w/labels/$i'),
          },
      ],
      'decals': [
        for (final (i, d) in s.decals.indexed)
          {
            'box': box(d.box),
            'image': d.image == null ? null : image(p, d.image!, '$w/decals/$i'),
            'drawing': d.drawing == null ? null : graphic(p, d.drawing!, '$w/decals/$i'),
          },
      ],
      'mirrors': [
        for (final m in s.mirrors)
          {
            'source': m.source,
            'box': box(m.box),
            'glyphHeight': m.glyphHeight,
            'alphabet': m.alphabet == null ? null : alphabet(m.alphabet!, p),
            'editable': m.editable,
          },
      ],
      'textDirection': s.textDirection.name,
      'borderWidthRatioOverride': s.borderWidthRatioOverride,
      'inkOverride': argbOrNull(s.inkOverride),
      'textGroups': [
        for (final g in s.textGroups) {'indices': g.indices, 'prefix': g.prefix, 'key': g.key},
      ],
      'restrictions': [
        for (final r in s.restrictions) {'group': r.group, 'values': r.values, 'reason': r.reason},
      ],
      'resolveTheme': s.resolveTheme == null ? null : resolver(p, s, s.resolveTheme!, '$w/resolveTheme'),
      'resolveRegion': s.resolveRegion == null ? null : resolver(p, s, s.resolveRegion!, '$w/resolveRegion'),
    };
  }

  Map<String, Object?> fill(PlateFill f, String where) {
    if (f.isStripes) {
      return {
        'kind': 'stripes',
        'stripes': [for (final (i, s) in f.stripes!.indexed) fill(s, '$where/stripes/$i')],
        'stops': f.stops,
        'angle': f.angle,
        'fog': switch (f.fog) {
          null => null,
          final g => {
            'center': [g.center.dx, g.center.dy],
            'radii': [g.radii.width, g.radii.height],
            'opacity': g.opacity,
            'plateau': g.plateau,
          },
        },
      };
    }
    if (f.color != null) return {'kind': 'color', 'color': argb(f.color!)};
    if (f.isField) return {'kind': 'field'};
    if (f.isPanel) return {'kind': 'panel'};
    const divider = Color(0x12345678);
    final c = f.resolve(field: const Color(0xFF000000), panel: const Color(0xFF000001), divider: divider);
    if (c == divider) return {'kind': 'divider'};
    fail(where, 'unknown PlateFill');
  }

  // Alphabets, global by ref: the id, or `id~n` for the nth different alphabet
  // claiming it (Melilla and Montenegro both use `me.letters`).

  String alphabet(PlateAlphabet a, [Package? p]) {
    final json = <String, Object?>{
      'id': a.id,
      'characters': a.characters,
      'characterCodePoints': [for (final c in a.characters) c.runes.toList()],
      'input': a.input.name,
      'isNumeric': a.isNumeric,
      'glyphs': [for (final e in a.glyphs.entries) [e.key, e.value]],
      'glyphCodePoints': [for (final e in a.glyphs.entries) [e.key.runes.toList(), e.value.runes.toList()]],
      'direction': a.direction.name,
      'placeholder': a.placeholder,
    };
    var ref = a.id;
    for (var n = 2; alphabets.containsKey(ref) && jsonEncode(alphabets[ref]) != jsonEncode(json); n++) {
      ref = '${a.id}~$n';
    }
    alphabets[ref] = json;
    p?.alphabets.add(ref);
    return ref;
  }

  // Countries and themes: deduplicated by content, referenced by Dart name.

  String countryRef(Package p, PlateCountry c, String? name) => ref(p.countries, {
    'code': c.code,
    'captionLines': c.captionLines,
    'headingLines': c.headingLines,
    'panelColor': argb(c.panelColor),
    'panelTextColor': argbOrNull(c.panelTextColor),
    'flagAspectRatio': c.flagAspectRatio,
    'flag': c.flag == null ? null : graphic(p, c.flag!, '${p.name}:${name ?? c.code}/flag'),
    'flagBorderColor': argbOrNull(c.flagBorderColor),
  }, name, c.code);

  String themeRef(Package p, PlateTheme t, String? name) => ref(p.themes, themeJson(t), name, 'theme');

  /// The ref of [json] in [refs]: [name] for the first named copy, else
  /// `<stem>~<n>`. A later name for the same content is kept as an alias.
  String ref(Map<String, Map<String, Object?>> refs, Map<String, Object?> json, String? name, String stem) {
    final key = jsonEncode(json);
    for (final MapEntry(key: r, value: v) in refs.entries) {
      if (jsonEncode({...v}..remove('names')) == key) {
        if (name != null && !(v['names']! as List).contains(name)) (v['names']! as List).add(name);
        return r;
      }
    }
    var r = name ?? stem;
    for (var n = 2; refs.containsKey(r); n++) {
      r = '$stem~$n';
    }
    refs[r] = {'names': <String>[?name], ...json};
    return r;
  }

  // Graphics and assets.

  Map<String, Object?> graphic(Package p, PlateGraphic g, String where) => switch (g) {
    PlateDrawing() => {
      'kind': 'drawing',
      'width': g.width,
      'height': g.height,
      'shapes': [for (final s in g.shapes) shape(s)],
    },
    SvgPlateAsset() => asset(p, 'svg', g.package, g.path),
    RasterPlateAsset() => asset(p, 'raster', g.package, g.path),
  };

  Map<String, Object?> image(Package p, ImageProvider i, String where) => switch (i) {
    AssetImage(:final package?) => asset(p, 'raster', package, i.assetName),
    ExactAssetImage(:final package?) => asset(p, 'raster', package, i.assetName),
    _ => fail(where, 'decal image ${i.runtimeType} is not a package asset (H2)'),
  };

  Map<String, Object?> asset(Package p, String kind, String package, String path) {
    final json = {'kind': kind, 'package': package, 'path': path};
    if (!File('${root.path}/$package/$path').existsSync()) {
      problems.add('${p.name}: asset $package/$path does not exist');
    }
    p.assets['$package/$path'] = json;
    return json;
  }

  Map<String, Object?> shape(PlateShape s) => {
    ...switch (s) {
      PlateRectShape() => {'kind': 'rect', 'left': s.left, 'top': s.top, 'width': s.width, 'height': s.height},
      PlatePolygonShape() => {
        'kind': 'polygon',
        'points': [for (final o in s.points) [o.dx, o.dy]],
      },
      PlateCircleShape() => {'kind': 'circle', 'cx': s.cx, 'cy': s.cy, 'radius': s.radius},
      PlateRingShape() => {'kind': 'ring', 'cx': s.cx, 'cy': s.cy, 'radius': s.radius, 'width': s.width},
      PlateCrescentShape() => {
        'kind': 'crescent',
        'cx': s.cx,
        'cy': s.cy,
        'radius': s.radius,
        'biteDx': s.biteDx,
        'biteRadius': s.biteRadius,
      },
      PlateStarShape() => {
        'kind': 'star',
        'cx': s.cx,
        'cy': s.cy,
        'radius': s.radius,
        'points': s.points,
        'innerRatio': s.innerRatio,
        'rotation': s.rotation,
      },
      PlateStarRingShape() => {
        'kind': 'starRing',
        'cx': s.cx,
        'cy': s.cy,
        'ringRadius': s.ringRadius,
        'starRadius': s.starRadius,
        'count': s.count,
        'points': s.points,
        'innerRatio': s.innerRatio,
      },
    },
    'color': argb(s.color),
  };

  /// [c] at [size] as polygons (H1): each contour sampled every 0.05 units and
  /// thinned to within 0.002, so curves are polylines but exact enough at plate
  /// scale. Coordinates are local to the clipped box.
  Map<String, Object?> clip(CustomClipper<Path> c, Size size) {
    final path = c.getClip(size);
    final d = StringBuffer();
    String n(double v) => double.parse(v.toStringAsFixed(4)).toString();
    for (final m in path.computeMetrics()) {
      final steps = math.max(8, (m.length / 0.05).ceil());
      final points = [
        for (var i = 0; i <= steps; i++) m.getTangentForOffset(m.length * i / steps)!.position,
      ];
      final thin = simplify(points, 0.002);
      if (m.isClosed && thin.length > 1 && thin.first == thin.last) thin.removeLast();
      for (final (i, o) in thin.indexed) {
        d.write('${i == 0 ? 'M' : 'L'}${n(o.dx)} ${n(o.dy)} ');
      }
      if (m.isClosed) d.write('Z ');
    }
    return {
      'clipper': c.runtimeType.toString(),
      'size': [size.width, size.height],
      'fillRule': path.fillType == PathFillType.evenOdd ? 'evenodd' : 'nonzero',
      'svg': d.toString().trim(),
    };
  }

  // Resolvers (D4).

  /// The name [f] is exported under: a [D4-code] function is only named, a
  /// [D4-table] or untagged one is tabulated over the keys it reads.
  String resolver(Package p, PlateSpec spec, Function f, String where) {
    final infos = portExportResolvers[p.name]!;
    String? name;
    for (final MapEntry(key: n, value: i) in infos.entries) {
      if (i.fn != null && i.fn == f) name = n;
    }
    if (name == null) {
      final m = RegExp(r"from Function '(\w+)(@\d+)?'").firstMatch(f.toString());
      if (m != null) {
        final hits = infos.keys.where((n) => n == m[1] || n.endsWith('.${m[1]}')).toList();
        if (hits.length != 1) fail(where, 'resolver ${m[1]} matches $hits in ${p.name}');
        name = hits.single;
      } else {
        name = where; // A lambda in the spec: untagged, tabulated under its position.
      }
    }
    final info = infos[name];
    final theme = f is PlateThemeResolver;
    final entry = p.resolvers.putIfAbsent(
      name,
      () => {
        'kind': info?.tag == 'D4-code' ? 'code' : 'table',
        'signature': theme ? 'theme' : 'label',
        'file': info?.file,
        'tag': info?.tag ?? '',
      },
    );
    if (entry['kind'] == 'table') {
      final table = theme ? tabulate(spec, (g) => themePatch(f, g), where)
          : tabulate(spec, (g) => (f as PlateLabelResolver)(g), where);
      merge(entry, table, '${p.name} $name');
    }
    return name;
  }

  /// Every value [f] gives over the group values the spec's slots can form:
  /// the keys it reads are found by running it, each key's domain is every
  /// concatenation of its slots' partial contents. A key with more than
  /// [maxDomain] values is cut to its first n code points, the smallest n for
  /// which 20000 random whole values agree with the cut table.
  Map<String, Object?> tabulate(PlateSpec spec, Object? Function(String Function(String)) f, String where) {
    final reads = <String>[];
    final domains = <String, List<String>>{};
    final cuts = <String, int>{};
    void learn(String key) {
      reads.add(key);
      domains[key] = groupDomain(spec, key, null) ?? groupDomain(spec, key, cuts[key] = 1)!;
    }

    while (true) {
      final rows = <List<String>, Object?>{};
      var fresh = false;
      var calls = 0;
      void visit(int k, List<String> key) {
        if (fresh) return;
        if (k < reads.length) {
          for (final v in domains[reads[k]]!) {
            visit(k + 1, [...key, v]);
          }
          return;
        }
        if (++calls > maxTableCalls) fail(where, 'table over $reads exceeds $maxTableCalls calls');
        final value = f((g) {
          final i = reads.indexOf(g);
          if (i >= 0 && i < key.length) return key[i];
          if (!fresh) {
            fresh = true;
            learn(g);
          }
          return '';
        });
        rows[key] = value;
      }

      visit(0, const []);
      if (fresh) continue;
      if (cuts.isNotEmpty) {
        if (reads.length != 1) fail(where, 'a cut key among several reads $reads');
        final key = reads.single, cut = cuts[key]!;
        final byValue = {for (final e in rows.entries) e.key.single: jsonEncode(e.value)};
        final random = math.Random(cut);
        var agrees = true;
        for (var n = 0; n < 20000 && agrees; n++) {
          final v = randomValue(spec, key, random);
          agrees = jsonEncode(f((g) => g == key ? v : '')) == byValue[take(v, cut)];
        }
        if (!agrees) {
          if (cut == 4) fail(where, 'group $key is too large to tabulate and no prefix decides it');
          domains[key] = groupDomain(spec, key, cuts[key] = cut + 1) ?? fail(where, 'group $key is too large');
          continue;
        }
      }
      final counts = <String, int>{};
      for (final v in rows.values) {
        counts.update(jsonEncode(v), (n) => n + 1, ifAbsent: () => 1);
      }
      final fallback = counts.entries.reduce((a, b) => b.value > a.value ? b : a).key;
      final table = [
        for (final MapEntry(:key, :value) in rows.entries)
          if (jsonEncode(value) != fallback) [key, value],
      ];
      return {'reads': reads, 'cut': cuts, 'default': jsonDecode(fallback), 'table': table};
    }
  }

  /// The values group [key] can hold, cut to their first [cut] code points;
  /// null when there are more than [maxDomain].
  List<String>? groupDomain(PlateSpec spec, String key, int? cut) {
    final most = cut ?? 1 << 30;
    var values = <String>{''};
    for (final i in spec.indicesOfGroup(key)) {
      final slot = spec.slots[i];
      final own = <String>{''};
      var layer = <String>[''];
      for (var n = 1; n <= math.min(slotLength(slot), most); n++) {
        layer = [for (final s in layer) for (final c in slot.alphabet.characters) s + c];
        if (layer.length > maxDomain) return null;
        own.addAll(layer);
      }
      values = {for (final v in values) for (final o in own) take(v + o, most)};
      if (values.length > maxDomain) return null;
    }
    return values.toList()..sort();
  }

  /// A whole value of group [key]: each slot empty, partly or wholly filled.
  String randomValue(PlateSpec spec, String key, math.Random random) {
    final b = StringBuffer();
    for (final i in spec.indicesOfGroup(key)) {
      final slot = spec.slots[i];
      final chars = slot.alphabet.characters;
      final n = random.nextInt(4) == 0 ? random.nextInt(slotLength(slot) + 1) : slotLength(slot);
      for (var k = 0; k < n; k++) {
        b.write(chars[random.nextInt(chars.length)]);
      }
    }
    return b.toString();
  }

  /// Entries a slot holds: a chosen symbol is one, however many characters.
  int slotLength(PlateSlot slot) => slot.alphabet.input == AlphabetInput.chosen ? 1 : slot.length;

  void merge(Map<String, Object?> entry, Map<String, Object?> t, String where) {
    final old = entry['table'] as List?;
    if (old == null) {
      entry.addAll(t);
      return;
    }
    if (<String>['reads', 'cut', 'default'].any((k) => jsonEncode(entry[k]) != jsonEncode(t[k]))) {
      problems.add('$where: tabulates differently for two specs');
      return;
    }
    final rows = {for (final r in old.cast<List>()) jsonEncode(r[0]): r};
    for (final r in (t['table']! as List).cast<List>()) {
      final known = rows[jsonEncode(r[0])];
      if (known == null) {
        old.add(r);
      } else if (jsonEncode(known[1]) != jsonEncode(r[1])) {
        problems.add('$where: ${r[0]} gives ${known[1]} and ${r[1]} on two specs');
      }
    }
  }

  static final PlateTheme baseA = PlateTheme.standard();
  static const PlateTheme baseB = PlateTheme(
    plateBackground: Color(0xFF010203),
    plateBorder: Color(0xFF040506),
    ink: Color(0xFF070809),
    dividerColor: Color(0xFF0A0B0C),
    borderWidthRatio: 0.0123,
    plateRadiusRatio: 0.0456,
    activeColor: Color(0xFF0D0E0F),
    inactiveColor: Color(0xFF101112),
    alertColor: Color(0xFF131415),
  );

  /// What [f] changes about the host's theme, as the fields it sets: a field
  /// the same under two unrelated bases is set, one that follows the base is
  /// kept. Anything else is logic, not a table.
  Map<String, Object?> themePatch(PlateThemeResolver f, String Function(String) group) {
    final a = themeJson(f(baseA, group)), b = themeJson(f(baseB, group));
    final ja = themeJson(baseA), jb = themeJson(baseB);
    return {
      for (final k in a.keys)
        if (a[k] == b[k])
          k: a[k]
        else if (a[k] != ja[k] || b[k] != jb[k])
          k: fail('theme resolver', 'field $k is derived from the base theme'),
    };
  }

  // Gallery: the holder's pairing of spec, theme, country and validator.

  void collectGallery() {
    final seen = <String>{};
    for (final source in allGallerySources) {
      // A region umbrella names no package; its entries come again under its members.
      if (!packages.containsKey(source.packageName)) continue;
      for (final section in source.sections) {
        for (final e in section.entries) {
          if (!seen.add(e.id)) continue;
          final owners = ownersBySpec[e.spec] ?? {source.packageName};
          final p = package(owners.contains(source.packageName) ? source.packageName : owners.first);
          addSpec(p, e.spec, null);
          p.gallery.add({
            'id': e.id,
            'source': source.countryName,
            'section': section.title,
            'label': e.label,
            'note': e.note,
            'spec': e.spec.id,
            'theme': e.theme == null ? null : themeRef(p, e.theme!, null),
            'country': e.country == null ? null : countryRef(p, e.country!, null),
            'validator': e.validator?.runtimeType.toString(),
            'sampleValues': e.sampleValues,
            'themeForValues': e.themeForValues != null,
            'bands': [
              for (final (label, country, theme) in e.bands)
                {
                  'label': label,
                  'country': countryRef(p, country, null),
                  'theme': theme == null ? null : themeRef(p, theme, null),
                },
            ],
          });
        }
      }
    }
  }

  // Output.

  List<Map<String, Object?>> validators(Package p) {
    final found = <Map<String, Object?>>[];
    final dir = Directory('${root.path}/${p.name}/lib');
    final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList()
      ..sort((a, b) => a.path.compareTo(b.path));
    final decl = RegExp(r'^class (\w+) extends (Gated)?PlateValidator\b', multiLine: true);
    for (final f in files) {
      for (final m in decl.allMatches(f.readAsStringSync())) {
        found.add({'name': m[1], 'file': f.path.substring(root.path.length + 1), 'gated': m[2] != null});
      }
    }
    return found;
  }

  Map<String, Object?> pubspec(Package p) {
    final text = File('${root.path}/${p.name}/pubspec.yaml').readAsStringSync();
    String? field(String k) => RegExp('^$k:\\s*(.+)\$', multiLine: true).firstMatch(text)?[1]?.trim();
    return {'version': field('version'), 'description': field('description'), 'homepage': field('homepage')};
  }

  void write() {
    const json = JsonEncoder.withIndent('  ');
    void put(String rel, Object data) {
      final f = File('${out.path}/$rel')..createSync(recursive: true);
      f.writeAsStringSync('${json.convert(data)}\n');
    }

    if (out.existsSync()) {
      for (final f in out.listSync(recursive: true).whereType<File>()) {
        if (f.path.endsWith('.json')) f.deleteSync();
      }
    }
    final index = <String, Object?>{};
    for (final p in (packages.values.toList()..sort((a, b) => a.name.compareTo(b.name)))) {
      put('countries/${p.name}.json', {
        'format': 1,
        'package': p.name,
        'pubspec': pubspec(p),
        'alphabets': p.alphabets.toList()..sort(),
        'countries': p.countries,
        'themes': p.themes,
        'specs': p.specJsons,
        'resolvers': p.resolvers,
        'validators': validators(p),
        'assets': p.assets.values.toList(),
        'gallery': p.gallery,
      });
      index[p.name] = {
        'countries': {for (final c in p.countries.values) c['code']}.toList(),
        'specs': p.specs.keys.toList(),
      };
    }
    put('index.json', {'format': 1, 'packages': index});
    put('alphabets.json', {
      'format': 1,
      'alphabets': {
        for (final ref in alphabets.keys.toList()..sort()) ref: {...alphabets[ref]!, 'names': alphabetNames[ref] ?? []},
      },
    });
  }
}

Map<String, Object?> themeJson(PlateTheme t) => {
  'plateBackground': argb(t.plateBackground),
  'plateBorder': argb(t.plateBorder),
  'ink': argb(t.ink),
  'dividerColor': argb(t.dividerColor),
  'borderWidthRatio': t.borderWidthRatio,
  'plateRadiusRatio': t.plateRadiusRatio,
  'activeColor': argb(t.activeColor),
  'inactiveColor': argb(t.inactiveColor),
  'alertColor': argb(t.alertColor),
};

List<double> box(PlateBox b) => [b.left, b.top, b.width, b.height];

int argb(Color c) => c.toARGB32();

int? argbOrNull(Color? c) => c?.toARGB32();

/// Ramer–Douglas–Peucker: [points] less every point within [eps] of the line
/// through its kept neighbours.
List<Offset> simplify(List<Offset> points, double eps) {
  if (points.length < 3) return [...points];
  final a = points.first, b = points.last;
  var worst = 0.0;
  var at = 0;
  for (var i = 1; i < points.length - 1; i++) {
    final d = distanceToSegment(points[i], a, b);
    if (d > worst) {
      worst = d;
      at = i;
    }
  }
  if (worst <= eps) return [a, b];
  return [...simplify(points.sublist(0, at + 1), eps)..removeLast(), ...simplify(points.sublist(at), eps)];
}

/// The first [n] code points of [s].
String take(String s, int n) => s.runes.length <= n ? s : String.fromCharCodes(s.runes.take(n));

double distanceToSegment(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return (p - a).distance;
  final t = (((p - a).dx * ab.dx + (p - a).dy * ab.dy) / len2).clamp(0.0, 1.0);
  return (p - (a + ab * t)).distance;
}
