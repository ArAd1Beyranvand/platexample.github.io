// D9 vectors: what the Dart packages answer, as JSON under ports/vectors/ for
// the TypeScript, Kotlin and Python ports to replay. The shape is documented in
// ports/vectors/FORMAT.md; spec and alphabet refs are those of ports/data.
//
//   flutter test --no-pub test/port_export_test.dart   # first: ports/data
//   flutter test --no-pub test/port_vectors_test.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show ClipOp, Paragraph;

import 'package:antigua_and_barbuda_plate/antigua_and_barbuda_plate.dart';
import 'package:bhutan_plate/bhutan_plate.dart';
import 'package:caribbean_plate/caribbean_plate.dart';
import 'package:china_plate/china_plate.dart';
import 'package:colombia_plate/colombia_plate.dart';
import 'package:costa_rica_plate/costa_rica_plate.dart';
import 'package:denmark_plate/denmark_plate.dart';
import 'package:egypt_plate/egypt_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:france_plate/france_plate.dart';
import 'package:georgia_country_plate/georgia_country_plate.dart';
import 'package:germany_plate/germany_plate.dart';
import 'package:iranshahr_plate/iranshahr_plate.dart';
import 'package:italy_plate/italy_plate.dart';
import 'package:kyrgyzstan_plate/kyrgyzstan_plate.dart';
import 'package:liechtenstein_plate/liechtenstein_plate.dart';
import 'package:mexico_plate/mexico_plate.dart';
import 'package:morocco_plate/morocco_plate.dart';
import 'package:north_korea_plate/north_korea_plate.dart';
import 'package:papua_new_guinea_plate/papua_new_guinea_plate.dart';
import 'package:philippines_plate/philippines_plate.dart';
import 'package:plate_core/plate_core.dart';
// ignore_for_file: implementation_imports
// The machine and the helpers the barrel hides are part of what the ports port (D8).
import 'package:plate_core/src/input/plate_input_machine.dart';
import 'package:plate_core/src/model/plate_alphabet.dart' show splitRunes;
import 'package:plate_core/src/model/slot_behavior.dart';
import 'package:plate_number_holder/screens/gallery/sources/sources.dart';
import 'package:switzerland_plate/switzerland_plate.dart';
import 'package:tunisia_plate/tunisia_plate.dart';

import 'port_export_names.g.dart';

final Directory root = Directory.current.parent;
final Directory out = Directory('${root.path}/ports/vectors');
const JsonEncoder json = JsonEncoder.withIndent('  ');

Never fail(String what) => throw StateError(what);

void put(String rel, List<Map<String, Object?>> cases) {
  final f = File('${out.path}/$rel')..createSync(recursive: true);
  f.writeAsStringSync('${json.convert({'cases': cases})}\n');
}

Map<String, Object?> vector(String name, Object? input, Object? expect) =>
    {'name': name, 'input': input, 'expect': expect};

/// Every spec the export knows, by package and id.
final Map<String, Map<String, PlateSpec>> specs = () {
  final found = <String, Map<String, PlateSpec>>{};
  for (final MapEntry(key: pkg, value: values) in portExportNames.entries) {
    for (final v in values.values.whereType<PlateSpec>()) {
      found.putIfAbsent(pkg, () => {})[v.id] = v;
    }
  }
  return found;
}();

/// The ports/data package that holds [spec] for a gallery of [source].
String? ownerOf(PlateSpec spec, String source) {
  if (identical(specs[source]?[spec.id], spec)) return source;
  for (final MapEntry(key: pkg, value: s) in specs.entries) {
    if (identical(s[spec.id], spec)) return pkg;
  }
  return portExportNames.containsKey(source) ? source : null;
}

void main() {
  setUpAll(() {
    if (out.existsSync()) {
      for (final f in out.listSync(recursive: true).whereType<File>()) {
        if (f.path.endsWith('.json')) f.deleteSync();
      }
    }
  });

  test('validators', writeValidators, timeout: const Timeout(Duration(minutes: 10)));
  test('resolvers', writeResolvers);
  test('core: alphabet, values, layout, timing', () {
    writeAlphabet();
    writeValues();
    writeLayout();
    writeTiming();
  });
  testWidgets('core: input', writeInput);
  testWidgets('render', writeRender, timeout: const Timeout(Duration(minutes: 20)));
}

// Validators.

/// A validator on a spec: the gallery's pairing, a package's validatorFor,
/// or a hand pairing for a validator nothing in Dart pairs.
typedef Setup = ({String package, PlateSpec spec, PlateValidator validator, List<String?>? sample});

/// The constructor arguments of a validator, read from its public fields.
/// Every class whose constructor takes any must be here.
Map<String, Object?>? args(PlateValidator v) => switch (v) {
  AntiguaAndBarbudaValidator() => {'maxDigits': v.maxDigits},
  BhutanValidator() => {'types': v.types},
  BonaireIslandValidator() => {'island': v.island, 'minDigits': v.minDigits},
  SabaIslandValidator() => {'minDigits': v.minDigits, 'maxDigits': v.maxDigits},
  ChinaNewEnergyValidator() => {'large': v.large},
  TaiwanProtocolValidator() => {'minDigits': v.minDigits, 'maxDigits': v.maxDigits},
  ColombiaValidator() => {'series': v.series.id},
  CostaRicaValidator() => {
    'format': [
      for (final f in v.format.fields)
        {'key': f.key, 'name': f.name, 'letters': f.letters, 'min': f.min, 'max': f.max},
    ],
  },
  DenmarkValidator() => {
    'yearDigits': v.yearDigits,
    'midDigits': v.midDigits,
    'numberDigits': v.numberDigits,
    'allowedLetters': v.allowedLetters?.toList(),
  },
  EgyptValidator() => {'lengths': [for (final e in v.lengths.entries) [e.key, e.value]]},
  FranceValidator() => {'temporary': v.temporary},
  GeorgiaCountryValidator() => {
    'rules': [
      for (final r in v.rules) {'key': r.key, 'kind': r.kind.name, 'min': r.min, 'max': r.max},
    ],
  },
  ArmeniaPlateValidator() => {'issuedYear': v.issuedYear, 'issuedMonth': v.issuedMonth},
  ArmeniaSerialPlateValidator() => {'length': v.length},
  KazakhstanValidator() => {'letters': v.letters},
  TajikistanPlateValidator() => {
    'serialLength': v.serialLength,
    'letterCount': v.letterCount,
    'checkRegion': v.checkRegion,
    'gate': v.gate,
  },
  TurkeyPlateValidator() => {'limitSix': v.limitSix},
  TurkmenistanValidator() => {
    'parts': [
      for (final p in v.parts) {'group': p.group, 'length': p.length, 'digits': p.digits, 'allowed': p.allowed},
    ],
  },
  ItalyDiplomaticValidator() => {'digits': v.digits, 'consular': v.consular},
  KyrgyzstanDiplomaticValidator() => {
    'classes': v.classes,
    'numberLength': v.numberLength,
    'hasMission': v.hasMission,
    'dated': v.dated,
  },
  LiechtensteinValidator() => {
    'ranges': [for (final (a, b) in v.ranges) [a, b]],
    'reason': v.reason,
  },
  MexicoValidator() => {'format': v.format.id},
  MoroccoValidator() => {
    'fields': [for (final f in v.fields) {'group': f.group, 'min': f.min, 'max': f.max}],
    'requiresSeries': v.requiresSeries,
  },
  KPValidator() => {'gateGroup': v.gateGroup},
  PapuaNewGuineaValidator() => {
    'leadMin': v.leadMin,
    'leadMax': v.leadMax,
    'numberMin': v.numberMin,
    'numberMax': v.numberMax,
    'leadStartsWith': v.leadStartsWith,
  },
  PhilippinesValidator() => {'government': v.government},
  SwitzerlandValidator() => {'military': v.military},
  TunisiaDiplomaticValidator() => {'chief': v.chief},
  _ => null,
};

/// `class X extends Y` across the country packages: file and superclass.
final Map<String, ({String file, String parent, String source})> classes = () {
  final found = <String, ({String file, String parent, String source})>{};
  final decl = RegExp(r'^(?:abstract |final |base )*class (\w+)(?:<[^>]*>)? extends (\w+)', multiLine: true);
  for (final dir in root.listSync().whereType<Directory>().where((d) => d.path.endsWith('_plate'))) {
    final lib = Directory('${dir.path}/lib');
    if (!lib.existsSync()) continue;
    for (final f in lib.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      final text = f.readAsStringSync();
      for (final m in decl.allMatches(text)) {
        found[m[1]!] = (file: f.path.substring(root.path.length + 1), parent: m[2]!, source: text);
      }
    }
  }
  return found;
}();

/// The validator classes the oracle wants a file for.
Set<String> get validatorClasses => {
  for (final MapEntry(:key, :value) in classes.entries)
    if (value.parent == 'PlateValidator' || value.parent == 'GatedPlateValidator') key,
};

List<Setup> setups() {
  final found = <Setup>[];
  void add(String pkg, PlateSpec spec, PlateValidator v, [List<String?>? sample]) =>
      found.add((package: pkg, spec: spec, validator: v, sample: sample));

  for (final source in allGallerySources) {
    for (final section in source.sections) {
      for (final e in section.entries) {
        final pkg = ownerOf(e.spec, source.packageName);
        if (e.validator != null && pkg != null) add(pkg, e.spec, e.validator!, e.sampleValues);
      }
    }
  }
  for (final (pkg, prefix, validatorFor) in <(String, String, PlateValidator Function(PlateSpec))>[
    ('iranshahr_plate', 'am.', ArmeniaPlates.validatorFor),
    ('iranshahr_plate', 'tj.', TajikistanPlates.validatorFor),
    ('germany_plate', '', GermanPlates.validatorFor),
  ]) {
    for (final s in specs[pkg]!.values.where((s) => s.id.startsWith(prefix))) {
      add(pkg, s, validatorFor(s));
    }
  }
  add('italy_plate', ItalyPlates.diplomatic, const ItalyDiplomaticValidator());
  add('italy_plate', ItalyPlates.consular, const ItalyDiplomaticValidator(consular: true));
  add('italy_plate', ItalyPlates.unitedNations, const ItalyDiplomaticValidator(digits: 3));
  add('caribbean_plate', TurksAndCaicosIslandsPlates.prefixed, const TurksAndCaicosIslandsPrefixedValidator());
  add('caribbean_plate', TurksAndCaicosIslandsPlates.selfDrive, const TurksAndCaicosIslandsPrefixedValidator());
  return found;
}

void writeValidators() {
  final byClass = <String, List<Map<String, Object?>>>{};
  final seen = <String>{};
  for (final s in setups()) {
    final cls = s.validator.runtimeType.toString();
    final a = args(s.validator);
    final info = classes[cls] ?? fail('$cls: no class declaration found');
    if (a == null && RegExp('\\b$cls(\\.\\w+)?\\([^)\\s]').hasMatch(info.source)) {
      fail('$cls takes constructor arguments; add it to args()');
    }
    final validator = {'class': cls, 'args': ?a};
    if (!seen.add(jsonEncode([s.package, s.spec.id, validator]))) continue;
    final cases = validatorCases(s, info.source);
    final input = {'package': s.package, 'spec': s.spec.id, 'validator': validator};
    final list = [for (final c in cases) vector(c.name, {...input, 'values': c.values}, c.expect)];
    // A subclass's cases are its ancestors' too: an abstract base has no others.
    for (String? k = cls; k != null; k = classes[k]?.parent) {
      if (k == 'PlateValidator' || k == 'GatedPlateValidator') break;
      byClass.putIfAbsent(k, () => []).addAll(list);
    }
  }
  final missing = validatorClasses.where((c) => (byClass[c]?.length ?? 0) < 8).toList()..sort();
  expect(missing, isEmpty, reason: 'validator classes with fewer than 8 cases');
  for (final MapEntry(key: cls, value: cases) in byClass.entries) {
    put('validators/$cls.json', cases);
  }
}

typedef Case = ({String name, List<String?> values, Map<String, Object?> expect});

/// Edge cases first, then random fills that give a verdict not yet seen:
/// at most 6 valid and 3 per reason beyond the edges.
List<Case> validatorCases(Setup s, String source) {
  final spec = s.spec;
  final n = spec.slots.length;
  final random = math.Random(spec.id.hashCode ^ s.validator.runtimeType.toString().hashCode);
  String fill(PlateSlot slot, int count, String Function(int) char) =>
      [for (var k = 0; k < count; k++) char(k)].join();
  String full(PlateSlot slot) {
    final c = slot.alphabet.characters;
    return fill(slot, slotLength(slot), (_) => c[random.nextInt(c.length)]);
  }

  final base = s.sample != null && s.sample!.length == n && s.sample!.any((v) => v != null && v.isNotEmpty)
      ? [...s.sample!]
      : [for (final slot in spec.slots) full(slot)];
  final edges = <(String, List<String?>)>[
    ('sample', base),
    ('empty', List<String?>.filled(n, '')),
    ('unset', List<String?>.filled(n, null)),
  ];
  List<String?> with_(int i, String? v) => [...base]..[i] = v;
  for (final (i, slot) in spec.slots.indexed) {
    final chars = slot.alphabet.characters;
    final len = slotLength(slot);
    final foreign = ['Ж', 'A', '۵', '1'].firstWhere((c) => !chars.contains(c));
    edges.addAll([
      ('slot $i cleared', with_(i, '')),
      ('slot $i first', with_(i, fill(slot, len, (_) => chars.first))),
      ('slot $i last', with_(i, fill(slot, len, (_) => chars.last))),
      if (len > 1) ('slot $i partial', with_(i, fill(slot, len - 1, (_) => chars.first))),
      ('slot $i too long', with_(i, fill(slot, len + 1, (_) => chars.first))),
      ('slot $i wrong script', with_(i, fill(slot, len, (_) => foreign))),
      if (chars.first.toLowerCase() != chars.first)
        ('slot $i lowercase', with_(i, fill(slot, len, (_) => chars.first.toLowerCase()))),
    ]);
  }
  // Literals the validator or a restriction names, poured into each group.
  final literals = {
    for (final m in RegExp(r"'([A-Z0-9]{1,6})'").allMatches(source)) m[1]!,
    for (final r in spec.restrictions) ...r.values,
  }.take(24);
  for (final g in spec.effectiveTextGroups) {
    final at = g.key ?? '${g.indices}';
    List<String?> pour(String text) {
      final runes = text.runes.map(String.fromCharCode).toList();
      final values = [...base];
      for (final i in g.indices) {
        final k = math.min(slotLength(spec.slots[i]), runes.length);
        values[i] = runes.take(k).join();
        runes.removeRange(0, k);
      }
      return values;
    }

    final capacity = g.indices.fold(0, (a, i) => a + slotLength(spec.slots[i]));
    for (final l in literals) {
      if (l.runes.length <= capacity) edges.add(('group $at = $l', pour(l)));
    }
  }

  final picked = <Case>[];
  final keys = <String>{};
  final counts = <String?, int>{};
  bool take(String name, List<String?> values, {required bool edge}) {
    if (!keys.add(jsonEncode(values))) return false;
    final PlateValidation r;
    try {
      r = s.validator.validate(PlateEntry(spec: spec, values: values));
    } on Object {
      return false;
    }
    final seen = counts[r.reason] ?? 0;
    if (!edge && picked.length >= 8 && seen >= (r.isValid ? 6 : 3)) return false;
    counts[r.reason] = seen + 1;
    picked.add((name: name, values: values, expect: {'valid': r.isValid, 'reason': r.reason}));
    return true;
  }

  for (final (name, values) in edges) {
    take(name, values, edge: true);
  }
  for (var k = 0; k < 400; k++) {
    final values = [
      for (final slot in spec.slots)
        random.nextInt(5) == 0 ? fill(slot, random.nextInt(slotLength(slot) + 1), (_) {
          final c = slot.alphabet.characters;
          return c[random.nextInt(c.length)];
        }) : full(slot),
    ];
    take('random $k', values, edge: false);
  }
  return picked;
}

/// Entries a slot holds: a chosen symbol is one, however many characters.
int slotLength(PlateSlot slot) => slot.alphabet.input == AlphabetInput.chosen ? 1 : slot.length;

// Resolvers (D4-code): the functions ports/data only names.

void writeResolvers() {
  final data = Directory('${root.path}/ports/data/countries');
  final byName = <String, List<Map<String, Object?>>>{};
  for (final f in data.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
    final pkg = jsonDecode(f.readAsStringSync()) as Map<String, Object?>;
    final resolvers = pkg['resolvers']! as Map<String, Object?>;
    bool code(Object? name) => name != null && (resolvers[name]! as Map)['kind'] == 'code';
    for (final js in (pkg['specs']! as List).cast<Map<String, Object?>>()) {
      PlateSpec spec() => specs[pkg['package']]?[js['id']] ?? fail('${pkg['package']} ${js['id']}: spec not in names');
      final uses = <(String, Object?, Function? Function())>[
        ('resolveTheme', js['resolveTheme'], () => spec().resolveTheme),
        ('resolveRegion', js['resolveRegion'], () => spec().resolveRegion),
        for (final (i, l) in (js['labels']! as List).cast<Map<String, Object?>>().indexed)
          ('labels/$i', l['resolve'], () => spec().labels[i].resolve),
      ];
      for (final (at, name, fn) in uses) {
        if (!code(name)) continue;
        final where = {'package': pkg['package'], 'spec': js['id'], 'at': at};
        byName.putIfAbsent(name! as String, () => []).addAll(resolverCases(spec(), fn()!, where));
      }
    }
  }
  for (final MapEntry(key: name, value: cases) in byName.entries) {
    put('resolvers/$name.json', cases);
  }
}

/// [f] over every value of the groups it reads when there are at most 4000
/// combinations, else over 600 random fills plus each slot's edges.
List<Map<String, Object?>> resolverCases(PlateSpec spec, Function f, Map<String, Object?> where) {
  final random = math.Random(spec.id.hashCode);
  final theme = f is PlateThemeResolver;
  Object? call(String Function(String) group, PlateTheme base) =>
      theme ? themeJson(f(base, group)) : (f as PlateLabelResolver)(group);

  List<String?> randomFill() => [
    for (final slot in spec.slots)
      [
        for (var k = random.nextInt(4) == 0 ? random.nextInt(slotLength(slot) + 1) : slotLength(slot); k > 0; k--)
          slot.alphabet.characters[random.nextInt(slot.alphabet.characters.length)],
      ].join(),
  ];
  final fills = <List<String?>>[
    List.filled(spec.slots.length, ''),
    for (var k = 0; k < 600; k++) randomFill(),
  ];
  // Exhaustive over each group alone when small, the others random.
  for (final g in spec.effectiveTextGroups.where((g) => g.key != null)) {
    final domain = groupDomain(spec, g.key!);
    for (final v in domain ?? const <String>[]) {
      final values = randomFill();
      final runes = v.runes.map(String.fromCharCode).toList();
      for (final i in g.indices) {
        final k = math.min(slotLength(spec.slots[i]), runes.length);
        values[i] = runes.take(k).join();
        runes.removeRange(0, k);
      }
      fills.add(values);
    }
  }
  final cases = <Map<String, Object?>>[];
  final seen = <String>{};
  for (final values in fills) {
    for (final base in theme ? [baseA, baseB] : [baseA]) {
      final reads = <String, String>{};
      final expect = call((k) => reads[k] = spec.valueOfGroup(k, values), base);
      final input = {...where, 'groups': reads, if (theme) 'base': themeJson(base)};
      if (seen.add(jsonEncode(input))) cases.add(vector('${spec.id} ${jsonEncode(reads)}', input, expect));
    }
  }
  return cases;
}

/// Every whole or partial value of group [key], or null past 4000.
List<String>? groupDomain(PlateSpec spec, String key) {
  var values = <String>{''};
  for (final i in spec.indicesOfGroup(key)) {
    final slot = spec.slots[i];
    final own = <String>{''};
    var layer = <String>[''];
    for (var n = 1; n <= slotLength(slot); n++) {
      layer = [for (final s in layer) for (final c in slot.alphabet.characters) s + c];
      if (layer.length > 4000) return null;
      own.addAll(layer);
    }
    values = {for (final v in values) for (final o in own) v + o};
    if (values.length > 4000) return null;
  }
  return values.toList()..sort();
}

final PlateTheme baseA = PlateTheme.standard();
const PlateTheme baseB = PlateTheme(
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

Map<String, Object?> themeJson(PlateTheme t) => {
  'plateBackground': t.plateBackground.toARGB32(),
  'plateBorder': t.plateBorder.toARGB32(),
  'ink': t.ink.toARGB32(),
  'dividerColor': t.dividerColor.toARGB32(),
  'borderWidthRatio': t.borderWidthRatio,
  'plateRadiusRatio': t.plateRadiusRatio,
  'activeColor': t.activeColor.toARGB32(),
  'inactiveColor': t.inactiveColor.toARGB32(),
  'alertColor': t.alertColor.toARGB32(),
};

// Core (plate_core).

/// The ports/data ref of [a]: `id`, or `id~n` for the nth alphabet claiming it.
String aref(PlateAlphabet a) => alphabetRefs[alphabetKey(
  a.id, a.characters, [for (final e in a.glyphs.entries) [e.key, e.value]], a.input.name, a.direction.name, a.placeholder,
)] ?? fail('alphabet ${a.id} is not in ports/data');

String alphabetKey(Object? id, Object? chars, Object? glyphs, Object? input, Object? dir, Object? placeholder) =>
    jsonEncode([id, chars, glyphs, input, dir, placeholder]);

final Map<String, String> alphabetRefs = {
  for (final MapEntry(:key, :value) in ((jsonDecode(File('${root.path}/ports/data/alphabets.json').readAsStringSync())
          as Map)['alphabets'] as Map).cast<String, Map>().entries)
    alphabetKey(value['id'], value['characters'], value['glyphs'], value['input'], value['direction'], value['placeholder']): key,
};

Iterable<(String, PlateSpec)> get allSpecs sync* {
  for (final pkg in specs.keys.toList()..sort()) {
    for (final s in specs[pkg]!.values) {
      yield (pkg, s);
    }
  }
}

List<double> rect(Rect r) => [r.left, r.top, r.width, r.height];

/// Probes every alphabet answers [PlateAlphabet.accepts], `canonical`,
/// `render`, `renderAll` and `canonicalAll` for: its edges, case folds
/// (H8), each glyph both ways (H21), runs, and foreign script.
void writeAlphabet() {
  final cases = <Map<String, Object?>>[];
  final seen = <String>{};
  for (final (_, spec) in allSpecs) {
    for (final a in {for (final x in spec.slots) x.alphabet, for (final m in spec.mirrors) ?m.alphabet}) {
      final ref = aref(a);
      if (!seen.add(ref)) continue;
      final c = a.characters;
      final probes = <String>{
        '', c.first, c[c.length ~/ 2], c.last, c.first.toLowerCase(), c.last.toLowerCase(),
        c.take(3).join(), [for (final x in c.take(2)) x.toLowerCase()].join(),
        for (final e in a.glyphs.entries.take(8)) ...[e.key, e.value, e.value + e.value],
        'Ж', '۵', 'ß', 'i', 'ı', 'ς', '?', ' ', '-', '😀',
      };
      for (final v in probes) {
        cases.add(vector('$ref ${jsonEncode(v)}', {'alphabet': ref, 'value': v}, {
          'accepts': a.accepts(v),
          'canonical': a.canonical(v),
          'render': a.render(v),
          'renderAll': a.renderAll(v),
          'canonicalAll': a.canonicalAll(v),
        }));
      }
    }
  }
  // H22: `X-Y` tokens expand over code points; anything else is one character.
  for (final (include, exclude) in [
    ('A-Z', ''), ('A-Z', 'I O Q'), ('0-9 A-C', 'B'), ('Α-Ω', ''), ('ا-ي', ''), ('CD CC A-B', ''),
    ('A-', ''), ('-', ''), ('Z-A', ''), ('𝟘-𝟡', ''), ('가-갃', ''), ('a  b', ''), ('A-C', 'A-B'),
  ]) {
    final a = PlateAlphabet.pattern(id: 'p', include: include, exclude: exclude, input: .typed, isNumeric: false);
    cases.add(vector('pattern ${jsonEncode([include, exclude])}', {'include': include, 'exclude': exclude}, {
      'characters': a.characters,
    }));
  }
  put('core/alphabet.json', cases);
}

/// Spec-level value functions: groups, rendering, restrictions, slot verdicts
/// and [PlateController.fromText].
void writeValues() {
  final cases = <Map<String, Object?>>[];
  final random = math.Random(9);
  final slotSeen = <String>{};
  for (final (pkg, spec) in allSpecs) {
    final input = {'package': pkg, 'spec': spec.id};
    final full = [
      for (final x in spec.slots)
        [for (var k = 0; k < slotLength(x); k++) x.alphabet.characters[random.nextInt(x.alphabet.characters.length)]].join(),
    ];
    final partial = [for (final (i, v) in full.indexed) i.isOdd ? null : v];
    cases.add(vector('$pkg ${spec.id} groups', input, {
      'effectiveTextGroups': [for (final g in spec.effectiveTextGroups) {'indices': g.indices, 'prefix': g.prefix, 'key': g.key}],
      'groupAt': [for (var i = -1; i <= spec.slots.length; i++) spec.effectiveTextGroups.indexWhere((g) => identical(g, spec.groupAt(i)))],
      'nextIndex': [for (var i = -1; i <= spec.slots.length; i++) spec.nextIndex(i)],
      'previousIndex': [for (var i = -1; i <= spec.slots.length; i++) spec.previousIndex(i)],
    }));
    final fills = <(String, List<String?>)>[
      ('full', full),
      ('partial', partial),
      ('empty', List.filled(spec.slots.length, null)),
      ('short', full.take(spec.slots.length ~/ 2).toList()),
      for (final r in spec.restrictions)
        for (final v in r.values.take(3)) ('restricted ${r.group}=$v', pour(spec, r.group, v, full)),
    ];
    for (final (name, values) in fills) {
      final broken = spec.restrictionViolatedBy(values);
      cases.add(vector('$pkg ${spec.id} $name', {...input, 'values': values}, {
        'valueOfGroup': {for (final g in spec.effectiveTextGroups) if (g.key != null) g.key: spec.valueOfGroup(g.key!, values), 'nope': spec.valueOfGroup('nope', values)},
        'renderGroup': [for (final g in spec.effectiveTextGroups) spec.renderGroup(g, values)],
        'restrictionViolatedBy': broken?.reason,
        'checkRestrictions': () {
          try {
            spec.checkRestrictions(values);
            return null;
          } on PlateRestrictionException catch (e) {
            return e.toString();
          }
        }(),
      }));
    }
    final text = [for (final g in spec.effectiveTextGroups) spec.renderGroup(g, full)].join(' ');
    for (final t in {text, text.toLowerCase(), full.join(), full.join('-'), '', '${full.join()}XYZ123'}) {
      cases.add(vector('$pkg ${spec.id} fromText ${jsonEncode(t)}', {...input, 'fromText': t}, controllerState(PlateController.fromText(spec, t))));
    }
    for (final x in spec.slots) {
      final ref = aref(x.alphabet);
      if (!slotSeen.add(jsonEncode([ref, x.length, x.minLength]))) continue;
      final c = x.alphabet.characters;
      for (final v in <String?>{null, '', c.first, c.first.toLowerCase(), c.first * x.length, c.last * (x.length + 1),
          [for (var k = 0; k < x.length; k++) c[k % c.length]].join(), if (x.minLength > 0) c.first * x.minLength, 'Ж', '😀'}) {
        final slot = {'alphabet': ref, 'length': x.length, 'minLength': x.minLength};
        cases.add(vector('slot $ref/${x.length}/${x.minLength} ${jsonEncode(v)}', {'slot': slot, 'value': v}, {
          'accepts': v == null ? null : x.accepts(v),
          'canonical': v == null ? null : x.canonical(v),
          'render': v == null ? null : x.render(v),
          'isFull': x.isFull(v),
          'isComplete': x.isComplete(v),
        }));
      }
    }
  }
  put('core/values.json', cases);
}

/// [values] with group [key] holding [text], poured by slot length.
List<String?> pour(PlateSpec spec, String key, String text, List<String?> values) {
  final runes = splitRunes(text);
  final out = [...values];
  for (final i in spec.indicesOfGroup(key)) {
    final k = spec.slots[i].alphabet.input == AlphabetInput.chosen ? runes.length : math.min(spec.slots[i].length, runes.length);
    out[i] = runes.take(k).join();
    runes.removeRange(0, k);
  }
  return out;
}

Map<String, Object?> controllerState(PlateController c) => {
  'values': c.values,
  'isCompleted': c.isCompleted,
  'isEmpty': c.isEmpty,
  'rejection': c.rejection.value?.reason,
  'text': c.text(),
  'textJoined': c.text(sep: ''),
  'regionCaption': c.regionCaption,
};

/// Section layouts (H17) for every spec, at its canvas and at an offset box,
/// and the slot, mirror and rule builders.
void writeLayout() {
  final cases = <Map<String, Object?>>[];
  for (final (pkg, spec) in allSpecs) {
    for (final bounds in [
      Rect.fromLTWH(0, 0, spec.canvasWidth, spec.canvasHeight),
      Rect.zero,
      Rect.fromLTWH(10, 20, spec.canvasWidth / 2, spec.canvasHeight * 2),
    ]) {
      final l = spec.background.layout(bounds);
      cases.add(vector('$pkg ${spec.id} ${rect(bounds)}', {'package': pkg, 'spec': spec.id, 'bounds': rect(bounds)}, {
        'leaves': [for (final (_, r) in l.leaves) rect(r)],
        'dividers': [for (final r in l.dividers) rect(r)],
      }));
    }
  }
  List<double> box(PlateBox b) => [b.left, b.top, b.width, b.height, b.right, b.bottom];
  for (final (count, pitch) in [(0, null), (1, null), (3, null), (4, 61.5), (7, 40.0)]) {
    final args = {'count': count, 'left': 12.5, 'top': 20.0, 'width': 44.0, 'height': 70.0, 'pitch': pitch};
    cases.add(vector('plateRegister $count $pitch', {'builder': 'plateRegister', ...args}, [
      for (final x in plateRegister(alphabet: PlateAlphabet.latinDigits, count: count, left: 12.5, top: 20, width: 44, height: 70, pitch: pitch)) box(x.box),
    ]));
    cases.add(vector('plateEcho $count $pitch', {'builder': 'plateEcho', ...args, 'sources': [for (var i = 0; i < count; i++) i * 2]}, [
      for (final m in plateEcho(sources: [for (var i = 0; i < count; i++) i * 2], left: 12.5, top: 20, width: 44, height: 70, pitch: pitch))
        {'source': m.source, 'box': box(m.box), 'glyphHeight': m.glyphHeight},
    ]));
    cases.add(vector('plateStipple $count', {'builder': 'plateStipple', ...args, 'stepX': 9.0, 'stepY': -1.5}, [
      for (final r in plateStipple(count: count, left: 12.5, top: 20, width: 44, height: 70, stepX: 9, stepY: -1.5)) box(r.box),
    ]));
  }
  for (final count in [0, 1, 3, 7]) {
    cases.add(vector('plateRegisterAcross $count', {'builder': 'plateRegisterAcross', 'count': count, 'left': 30.0, 'right': 490.0, 'top': 18.0, 'height': 74.0}, [
      for (final x in plateRegisterAcross(alphabet: PlateAlphabet.latinDigits, count: count, left: 30, right: 490, top: 18, height: 74)) box(x.box),
    ]));
  }
  cases.add(vector('plateRegister -1', {'builder': 'plateRegister', 'count': -1}, {'throws': 'ArgumentError'}));
  put('core/layout.json', cases);
}

const Map<String, Curve> curves = {
  'ease': Curves.ease,
  'easeInOut': Curves.easeInOut,
  'easeInOutCubic': Curves.easeInOutCubic,
  'easeOut': Curves.easeOut,
  'easeOutBack': Curves.easeOutBack,
  'easeOutCubic': Curves.easeOutCubic,
  'elasticOut': Curves.elasticOut,
  'linear': Curves.linear,
};

String curveName(Curve c) => curves.entries.firstWhere((e) => e.value == c, orElse: () => fail('curve $c')).key;

Map<String, Object?> motionJson(PlateMotion m) => {
  'effect': m.effect.name,
  'durationMs': m.duration.inMilliseconds,
  'curve': curveName(m.curve),
  'delayMs': m.delay.inMilliseconds,
  'origin': [m.origin.x, m.origin.y],
  'startPoint': m.startPoint,
  'clockwise': m.clockwise,
  'softEdge': m.softEdge,
};

/// Curves (H11), motions, part ids, staggers, cue lengths, reveal rects,
/// delayed progress and which parts a spec change keeps.
void writeTiming() {
  final cases = <Map<String, Object?>>[];
  final ts = [for (var i = 0; i <= 20; i++) i / 20, 0.001, 0.999];
  for (final MapEntry(key: name, value: c) in curves.entries) {
    cases.add(vector('curve $name', {'curve': name, 't': ts}, {
      'cubic': c is Cubic ? [c.a, c.b, c.c, c.d] : null,
      'value': [for (final t in ts) c.transform(t)],
    }));
  }
  cases.add(vector('motion default', {'motion': 'default'}, motionJson(const PlateMotion())));
  for (final k in PlatePartKind.values) {
    cases.add(vector('style ${k.name}', {'kind': k.name}, motionJson(const PlateAnimationStyle().motionFor(PlatePartId(k, 3)))));
  }
  // H11: a delay is the head of the curve's interval.
  for (final (kind, cueDelay) in [(PlatePartKind.slot, 0), (PlatePartKind.slot, 300), (PlatePartKind.border, 120), (PlatePartKind.corner, 0)]) {
    final m = const PlateAnimationStyle().motionFor(PlatePartId(kind));
    final wait = m.delay + Duration(milliseconds: cueDelay), total = wait + m.duration;
    final curve = Interval(wait.inMicroseconds / total.inMicroseconds, 1, curve: m.curve);
    final at = [for (var ms = 0; ms <= total.inMilliseconds; ms += 30) ms, total.inMilliseconds];
    cases.add(vector('progress ${kind.name} +$cueDelay', {'kind': kind.name, 'cueDelayMs': cueDelay, 'atMs': at}, {
      'totalMs': total.inMilliseconds,
      'progress': [for (final ms in at) curve.transform(ms / total.inMilliseconds)],
    }));
  }
  for (final (pkg, spec) in allSpecs) {
    final ids = PlatePartId.allOf(spec);
    final forward = PlateStagger.sequence(spec), back = PlateStagger.sequence(spec, step: const Duration(milliseconds: 25), reverse: true);
    cases.add(vector('$pkg ${spec.id} parts', {'package': pkg, 'spec': spec.id}, {
      'allOf': [for (final id in ids) '$id'],
      'regionCount': plateRegionCount(spec.background),
      'dividerCount': plateDividerCount(spec.background),
      'stagger60': [for (final id in ids) forward[id]!.inMilliseconds],
      'stagger25Reverse': [for (final id in ids) back[id]!.inMilliseconds],
      'cueLength': plateCueLength(const PlateAnimationStyle(), ids, const {}).inMilliseconds,
      'cueLength60': plateCueLength(const PlateAnimationStyle(), ids, forward).inMilliseconds,
      'cueLength25Reverse': plateCueLength(const PlateAnimationStyle(), ids, back).inMilliseconds,
    }));
  }
  const bounds = Rect.fromLTWH(10, 20, 200, 80);
  for (final origin in [for (final y in [-1.0, 0.0, 1.0]) for (final x in [-1.0, 0.0, 1.0]) Alignment(x, y), const Alignment(0.5, -0.25)]) {
    for (final phase in PlatePartPhase.values) {
      for (final t in [0.0, 0.25, 0.5, 1.0]) {
        final frame = PlatePartFrame(phase: phase, progress: AlwaysStoppedAnimation(t), motion: const PlateMotion());
        cases.add(vector('reveal ${origin.x},${origin.y} ${phase.name} $t', {
          'bounds': rect(bounds), 'origin': [origin.x, origin.y], 'phase': phase.name, 'progress': t,
        }, {
          'shown': frame.shown,
          'hidden': frame.hidden,
          'span': [frame.span.$1, frame.span.$2],
          'rect': rect(plateRevealRect(bounds, origin, frame)),
        }));
      }
    }
  }
  // Spec changes between neighbours of one package.
  for (final pkg in specs.keys.toList()..sort()) {
    final list = specs[pkg]!.values.toList();
    for (var i = 0; i + 1 < list.length && i < 6; i++) {
      for (final (from, to) in [(list[i], list[i + 1]), (list[i], list[i])]) {
        final ids = {...PlatePartId.allOf(from), ...PlatePartId.allOf(to)};
        final fv = List<String?>.filled(from.slots.length, null), tv = List<String?>.filled(to.slots.length, null);
        const kinds = PlateSpecTransition(keepKinds: {PlatePartKind.panel, PlatePartKind.slot, PlatePartKind.band});
        const identicalOnes = PlateSpecTransition(keepIdentical: true);
        cases.add(vector('$pkg ${from.id} -> ${to.id}', {'package': pkg, 'from': from.id, 'to': to.id, 'values': 'unset'}, {
          'samePart': [for (final id in ids) if (PlateSpecTransition.samePart(id, from, to, fromValues: fv, toValues: tv)) '$id'],
          'keepIdentical': [for (final id in ids) if (identicalOnes.keeps(id, from, to, fromValues: fv, toValues: tv)) '$id'],
          'keepPanelSlotBand': [for (final id in ids) if (kinds.keeps(id, from, to)) '$id'],
        }));
      }
    }
  }
  put('core/timing.json', cases);
}

/// [resolveSlotBehavior] in full, then input sessions (D7, D8): the
/// controller driven through a [PlateInputMachine] wired as [PlateCanvas]
/// wires it, the state and the notifications of each grain after every op.
Future<void> writeInput(WidgetTester tester) async {
  final cases = <Map<String, Object?>>[];
  for (final mode in PlateMode.values) {
    for (final input in AlphabetInput.values) {
      for (final source in PlateInputSource.values) {
        cases.add(vector('behavior ${mode.name} ${input.name} ${source.name}',
            {'mode': mode.name, 'input': input.name, 'source': source.name},
            resolveSlotBehavior(mode: mode, input: input, source: source).name));
      }
    }
  }
  final validators = Map<PlateSpec, PlateValidator>.identity();
  for (final s in setups()) {
    validators.putIfAbsent(s.spec, () => s.validator);
  }
  // One session per kind of spec, and every spec with restrictions.
  final kinds = <String>{};
  for (final (pkg, spec) in allSpecs) {
    if (spec.slots.isEmpty) continue;
    final chosen = spec.slots.any((x) => x.alphabet.input == AlphabetInput.chosen);
    final kind = jsonEncode([
      spec.restrictions.isNotEmpty,
      chosen,
      spec.slots.any((x) => x.length == 1 && x.alphabet.characters.length == 1),
      spec.mirrors.isNotEmpty,
      spec.slots.any((x) => x.minLength < x.length),
      spec.slots.any((x) => x.length > 1),
      spec.textGroups.any((g) => g.key != null),
      spec.slots.any((x) => x.alphabet.glyphs.isNotEmpty),
      spec.textDirection.name,
      validators.containsKey(spec),
    ]);
    if (!kinds.add(kind) && spec.restrictions.isEmpty) continue;
    final others = specs[pkg]!.values.where((s) => s.slots.isNotEmpty && s != spec).toList();
    for (final source in [PlateInputSource.hardwareKeyboard, if (chosen) PlateInputSource.system]) {
      cases.add(await session(tester, pkg, spec, source, others.firstOrNull, validators[spec]));
    }
  }
  put('core/input.json', cases);
}

Future<Map<String, Object?>> session(
  WidgetTester tester,
  String pkg,
  PlateSpec spec,
  PlateInputSource source,
  PlateSpec? other,
  PlateValidator? validator,
) async {
  final random = math.Random(spec.id.hashCode);
  String pick(PlateSlot x) => x.alphabet.characters[random.nextInt(x.alphabet.characters.length)];
  final target = [for (final x in spec.slots) [for (var k = 0; k < slotLength(x); k++) pick(x)].join()];
  final initial = <String?>[
    for (final (i, v) in target.indexed) switch (i % 4) { 0 => v.toLowerCase(), 1 => 'Ж', 2 => null, _ => v },
  ];
  final controller = PlateController(spec: spec, values: initial);
  PlateInputMachine? machine;
  int? sheet;
  Future<void> mount(PlateSpec s) async {
    if (machine != null) controller.detach(machine!);
    final m = machine = PlateInputMachine(
      spec: s,
      readValues: () => controller.values,
      commit: controller.setAt,
      inputSource: source,
      onActiveIndexChanged: (_) => controller.notifyActiveSlotChanged(),
    )..onSheetRequested = (i) => sheet = i;
    controller
      ..attach(m)
      ..installValidation(() {
        final entry = PlateEntry(spec: controller.spec, values: controller.values, activeIndex: m.activeIndex);
        return restrictionVerdict(entry) ?? (identical(controller.spec, spec) ? validator : null)?.validate(entry);
      });
    await tester.pumpWidget(Directionality(
      key: ObjectKey(m),
      textDirection: TextDirection.ltr,
      child: Column(children: [
        for (var i = 0; i < s.slots.length; i++) Focus(focusNode: m.focusNodeAt(i), child: const SizedBox(width: 1, height: 1)),
      ]),
    ));
  }

  Map<String, Object?> state() => {
    ...controllerState(controller),
    'active': controller.activeIndex,
    'systemKeyboard': controller.systemKeyboardActive,
    'validation': switch (controller.validation) {
      null => null,
      final v => {'valid': v.isValid, 'reason': v.reason},
    },
  };

  await mount(spec);
  final steps = <Map<String, Object?>>[];
  Future<void> op(Map<String, Object?> what, Object? Function() run) async {
    final fired = <String, int>{};
    final subs = <(Listenable, VoidCallback)>[];
    void on(Listenable l, String k) {
      void f() => fired.update(k, (n) => n + 1, ifAbsent: () => 1);
      l.addListener(f);
      subs.add((l, f));
    }

    on(controller, 'whole');
    on(controller.completed, 'completed');
    on(controller.rejection, 'rejection');
    for (var i = 0; i < controller.spec.slots.length; i++) {
      on(controller.slot(i), 'slot $i');
    }
    sheet = null;
    Object? result;
    String? threw;
    try {
      result = run();
      if (result is Future) await result;
    } on Error catch (e) {
      threw = e.runtimeType.toString();
    }
    await tester.pump();
    for (final (l, f) in subs) {
      try {
        l.removeListener(f);
      } on Object {
        // A slot notifier adoptSpec disposed.
      }
    }
    steps.add({
      'op': what,
      'result': result is bool ? result : null,
      'throws': threw,
      'sheet': sheet,
      'notified': fired,
      'state': state(),
    });
  }

  final first = state();
  final c0 = spec.slots.first.alphabet.characters.first;
  await op({'op': 'submit', 'char': 'Ж'}, () => controller.submit('Ж'));
  await op({'op': 'submit', 'char': c0.toLowerCase()}, () => controller.submit(c0.toLowerCase()));
  await op({'op': 'clear'}, controller.clear);
  await op({'op': 'focusSlot', 'index': 0}, () => controller.focusSlot(0));
  for (final (i, v) in target.indexed) {
    final x = spec.slots[i];
    for (final ch in x.alphabet.input == AlphabetInput.chosen ? [v] : splitRunes(v)) {
      if (controller.activeIndex != i) await op({'op': 'focusSlot', 'index': i}, () => controller.focusSlot(i));
      await op({'op': 'submit', 'char': ch}, () => controller.submit(ch));
    }
  }
  await op({'op': 'submit', 'char': c0}, () => controller.submit(c0));
  for (var k = 0; k < 4; k++) {
    await op({'op': 'backspace'}, controller.backspace);
  }
  await op({'op': 'focusFirstEmpty'}, controller.focusFirstEmpty);
  final last = spec.slots.length - 1;
  await op({'op': 'focusSlot', 'index': last}, () => controller.focusSlot(last));
  await op({'op': 'backspace'}, controller.backspace);
  await op({'op': 'backspace'}, controller.backspace);
  await op({'op': 'focusSlot', 'index': -1}, () => controller.focusSlot(-1));
  await op({'op': 'setAt', 'index': 0, 'value': 'Ж'}, () => controller.setAt(0, 'Ж'));
  await op({'op': 'setAt', 'index': 0, 'value': ''}, () => controller.setAt(0, ''));
  await op({'op': 'setAt', 'index': spec.slots.length, 'value': c0}, () => controller.setAt(spec.slots.length, c0));
  await op({'op': 'setAt', 'index': 0, 'value': target[0].toLowerCase()}, () => controller.setAt(0, target[0].toLowerCase()));
  for (final g in spec.effectiveTextGroups.where((g) => g.key != null)) {
    final v = [for (final i in g.indices) target[i]].join();
    await op({'op': 'setGroup', 'key': g.key, 'value': v}, () => controller.setGroup(g.key!, v));
  }
  await op({'op': 'setGroup', 'key': 'nope', 'value': 'A'}, () => controller.setGroup('nope', 'A'));
  for (final r in spec.restrictions) {
    for (final v in r.values.take(2)) {
      await op({'op': 'setGroup', 'key': r.group, 'value': v}, () => controller.setGroup(r.group, v));
      await op({'op': 'setValues', 'values': pour(spec, r.group, v, target)}, () => controller.setValues(pour(spec, r.group, v, target)));
    }
  }
  await op({'op': 'setValues', 'values': target}, () => controller.setValues(target));
  if (other != null) {
    for (final (to, preserve) in [
      (other, PlateValuePreservation.byGroupKey),
      (spec, PlateValuePreservation.byIndex),
      (other, PlateValuePreservation.none),
      (spec, PlateValuePreservation.byGroupKey),
    ]) {
      await op({'op': 'adoptSpec', 'spec': to.id, 'preserve': preserve.name}, () async {
        controller.adoptSpec(to, preserve: preserve);
        await mount(to);
        return null;
      });
      if (preserve == PlateValuePreservation.none) {
        await op({'op': 'setValues', 'values': target}, () => controller.setValues(target));
      }
    }
  }
  controller.detach(machine!);
  machine!.dispose();
  controller.dispose();
  await tester.pumpWidget(const SizedBox());
  return vector('$pkg ${spec.id} ${source.name}', {
    'package': pkg,
    'spec': spec.id,
    'source': source.name,
    'values': initial,
    'validator': validator == null ? null : {'class': validator.runtimeType.toString(), 'args': ?args(validator)},
    'other': other?.id,
  }, {'initial': first, 'steps': steps});
}

// Render (D1): what Flutter paints for a plate, as a display list.

/// A [Canvas] that keeps each call with the transform it ran under. Geometry
/// is local to the op; `m` maps it to plate units. `save`/`layer` open the
/// scope a `restore` closes, clips included.
class Recorder implements Canvas {
  final List<Map<String, Object?>> ops = [];
  final List<Matrix4> _stack = [Matrix4.identity()];
  Matrix4 get _m => _stack.last;

  void add(String op, Map<String, Object?> args, [Paint? paint]) {
    final s = _m.storage;
    final m = [s[0], s[1], s[4], s[5], s[12], s[13]];
    ops.add({
      'op': op,
      if (!(m[0] == 1 && m[1] == 0 && m[2] == 0 && m[3] == 1 && m[4] == 0 && m[5] == 0)) 'm': [for (final v in m) num4(v)],
      ...args,
      if (paint != null) 'paint': paintJson(paint),
    });
  }

  @override
  void save() {
    add('save', {});
    _stack.add(_m.clone());
  }

  @override
  void saveLayer(Rect? bounds, Paint paint) {
    add('layer', {'bounds': bounds == null ? null : rect4(bounds)}, paint);
    _stack.add(_m.clone());
  }

  @override
  void restore() {
    _stack.removeLast();
    add('restore', {});
  }

  @override
  int getSaveCount() => _stack.length;
  @override
  void restoreToCount(int count) {
    while (_stack.length > count) {
      restore();
    }
  }

  @override
  void translate(double dx, double dy) => _m.translateByDouble(dx, dy, 0, 1);
  @override
  void scale(double sx, [double? sy]) => _m.scaleByDouble(sx, sy ?? sx, 1, 1);
  @override
  void rotate(double radians) => _m.rotateZ(radians);
  @override
  void transform(Float64List matrix4) => _m.multiply(Matrix4.fromFloat64List(matrix4));
  @override
  Float64List getTransform() => _m.storage;

  @override
  void clipRect(Rect rect, {ClipOp clipOp = ClipOp.intersect, bool doAntiAlias = true}) =>
      add('clipRect', {'rect': rect4(rect), if (clipOp == ClipOp.difference) 'difference': true});
  @override
  void clipRRect(RRect rrect, {bool doAntiAlias = true}) => add('clipRRect', {'rrect': rrect4(rrect)});
  @override
  void clipPath(Path path, {bool doAntiAlias = true}) => add('clipPath', {'path': svgOf(path)});
  @override
  void clipRSuperellipse(RSuperellipse rse, {bool doAntiAlias = true}) =>
      add('clipRSuperellipse', {'rect': rect4(rse.outerRect)});

  @override
  void drawRect(Rect rect, Paint paint) => add('rect', {'rect': rect4(rect)}, paint);
  @override
  void drawRRect(RRect rrect, Paint paint) => add('rrect', {'rrect': rrect4(rrect)}, paint);
  @override
  void drawDRRect(RRect outer, RRect inner, Paint paint) =>
      add('drrect', {'outer': rrect4(outer), 'inner': rrect4(inner)}, paint);
  @override
  void drawPath(Path path, Paint paint) => add('path', {'path': svgOf(path)}, paint);
  @override
  void drawCircle(Offset c, double radius, Paint paint) =>
      add('circle', {'center': [num4(c.dx), num4(c.dy)], 'radius': num4(radius)}, paint);
  @override
  void drawOval(Rect rect, Paint paint) => add('oval', {'rect': rect4(rect)}, paint);
  @override
  void drawLine(Offset a, Offset b, Paint paint) =>
      add('line', {'from': [num4(a.dx), num4(a.dy)], 'to': [num4(b.dx), num4(b.dy)]}, paint);
  @override
  void drawPaint(Paint paint) => add('paint', {}, paint);
  @override
  void drawParagraph(Paragraph paragraph, Offset offset) => fail('a paragraph painted outside a RenderParagraph');

  @override
  dynamic noSuchMethod(Invocation i) => fail('Recorder: unrecorded ${i.memberName}');
}

double num4(double v) => double.parse(v.toStringAsFixed(4));
List<double> rect4(Rect r) => [for (final v in rect(r)) num4(v)];
List<double> rrect4(RRect r) => [
  ...rect4(r.outerRect),
  for (final c in [r.tlRadius, r.trRadius, r.brRadius, r.blRadius]) ...[num4(c.x), num4(c.y)],
];

Map<String, Object?> paintJson(Paint p) => {
  'color': p.color.toARGB32(),
  if (p.style == PaintingStyle.stroke) ...{'stroke': num4(p.strokeWidth), 'cap': p.strokeCap.name, 'join': p.strokeJoin.name},
  if (p.shader != null) 'shader': true,
  if (p.blendMode != BlendMode.srcOver) 'blend': p.blendMode.name,
  if (p.maskFilter != null) 'maskFilter': '${p.maskFilter}',
  if (p.colorFilter != null) 'colorFilter': true,
};

/// [path] as an SVG path in its own units: contours sampled and thinned as
/// ports/data clips are.
String svgOf(Path path) {
  final d = StringBuffer();
  String n(double v) => num4(v).toString();
  for (final m in path.computeMetrics()) {
    final steps = math.max(8, (m.length / 0.25).ceil()).clamp(8, 4000);
    final points = [for (var i = 0; i <= steps; i++) m.getTangentForOffset(m.length * i / steps)!.position];
    final thin = simplify(points, 0.01);
    if (m.isClosed && thin.length > 1 && thin.first == thin.last) thin.removeLast();
    for (final (i, o) in thin.indexed) {
      d.write('${i == 0 ? 'M' : 'L'}${n(o.dx)} ${n(o.dy)} ');
    }
    if (m.isClosed) d.write('Z ');
  }
  return '${path.fillType == PathFillType.evenOdd ? 'evenodd' : 'nonzero'}:${d.toString().trim()}';
}

/// Ramer–Douglas–Peucker, as in port_export_test.dart.
List<Offset> simplify(List<Offset> points, double eps) {
  if (points.length < 3) return [...points];
  final a = points.first, b = points.last;
  var worst = 0.0;
  var at = 0;
  for (var i = 1; i < points.length - 1; i++) {
    final ab = b - a, ap = points[i] - a;
    final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
    final t = len2 == 0 ? 0.0 : ((ap.dx * ab.dx + ap.dy * ab.dy) / len2).clamp(0.0, 1.0);
    final d = (points[i] - (a + ab * t)).distance;
    if (d > worst) {
      worst = d;
      at = i;
    }
  }
  if (worst <= eps) return [a, b];
  return [...simplify(points.sublist(0, at + 1), eps)..removeLast(), ...simplify(points.sublist(at), eps)];
}

/// Paints a render tree into a [Recorder]: a paragraph becomes a `text` op and
/// an asset picture an `asset` op, each over the box it was laid out in.
class Painter extends TestRecordingPaintingContext {
  Painter(Recorder super.canvas, this.assets);

  final Map<RenderObject, Map<String, Object?>> assets;
  Recorder get rec => canvas as Recorder;

  @override
  void paintChild(RenderObject child, Offset offset) {
    final asset = assets[child];
    if (asset != null && child is RenderBox) {
      rec.add('asset', {...asset, 'box': rect4(offset & child.size)});
    } else if (child is RenderParagraph) {
      final style = child.text.style;
      rec.add('text', {
        'text': child.text.toPlainText(),
        'box': rect4(offset & child.size),
        'align': child.textAlign.name,
        'direction': child.textDirection.name,
        'fontSize': style?.fontSize,
        'height': style?.height,
        'color': style?.color?.toARGB32(),
        'fontFamily': style?.fontFamily,
        'fontWeight': style?.fontWeight?.value,
        'letterSpacing': style?.letterSpacing,
      });
    } else {
      child.paint(this, offset);
    }
  }

  @override
  OpacityLayer pushOpacity(Offset offset, int alpha, PaintingContextCallback painter, {OpacityLayer? oldLayer}) {
    canvas.saveLayer(null, Paint()..color = Color.fromARGB(alpha, 0, 0, 0));
    painter(this, offset);
    canvas.restore();
    return OpacityLayer(alpha: alpha);
  }

  @override
  void pushLayer(Layer childLayer, PaintingContextCallback painter, Offset offset, {Rect? childPaintBounds}) {
    switch (childLayer) {
      case ColorFilterLayer(:final colorFilter?):
        rec.add('colorFilter', {'filter': '$colorFilter'});
      case ShaderMaskLayer(:final maskRect?):
        rec.add('shaderMask', {'rect': rect4(maskRect), 'blend': childLayer.blendMode?.name});
      default:
    }
    canvas.save();
    painter(this, offset);
    canvas.restore();
  }
}

/// Every gallery entry with its own sample; the first of each package also
/// empty, half-typed and under a second theme. One file per package.
Future<void> writeRender(WidgetTester tester) async {
  // Raster assets do not decode under the test bundle; their ops keep the box.
  final report = FlutterError.onError;
  FlutterError.onError = (d) => d.library == 'image resource service' ? null : report?.call(d);
  addTearDown(() => FlutterError.onError = report);
  final byPackage = <String, List<Map<String, Object?>>>{};
  final seen = <String>{};
  for (final source in allGallerySources) {
    for (final section in source.sections) {
      for (final e in section.entries) {
        final pkg = ownerOf(e.spec, source.packageName);
        // A spec with specProblems asserts on mount (export's knownProblems).
        if (pkg == null || !seen.add('${e.id}|$pkg') || specProblems(e.spec).isNotEmpty) continue;
        final cases = byPackage.putIfAbsent(pkg, () => []);
        final sample = e.sampleValues ?? List<String?>.filled(e.spec.slots.length, null);
        final theme = e.themeForValues?.call(sample) ?? e.theme;
        final variants = <(String, List<String?>, PlateTheme?)>[
          ('sample', sample, theme),
          if (cases.isEmpty) ...[
            ('empty', List<String?>.filled(e.spec.slots.length, null), theme),
            ('partial', [for (final (i, v) in sample.indexed) i.isEven ? v : null], theme),
            ('theme B', sample, baseB),
          ],
        ];
        for (final (name, values, t) in variants) {
          cases.add(vector('${e.id} $name', {
            'package': pkg,
            'gallery': e.id,
            'spec': e.spec.id,
            'values': values,
            'theme': t == null ? null : themeJson(t),
            'country': e.country?.code,
            'size': [e.spec.canvasWidth, e.spec.canvasHeight],
          }, await displayList(tester, e.spec, values, t, e.country)));
        }
      }
    }
  }
  for (final MapEntry(key: pkg, value: cases) in byPackage.entries) {
    put('render/$pkg.json', cases);
  }
}

Future<List<Map<String, Object?>>> displayList(
  WidgetTester tester,
  PlateSpec spec,
  List<String?> values,
  PlateTheme? theme,
  PlateCountry? country,
) async {
  final controller = PlateController(spec: spec, values: values);
  await tester.pumpWidget(MaterialApp(
    home: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: spec.canvasWidth,
        height: spec.canvasHeight,
        child: PlateThemeScope(
          theme: theme ?? PlateTheme.standard(),
          child: PlateView(controller: controller, theme: theme, country: country),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  final assets = <RenderObject, Map<String, Object?>>{};
  for (final el in find.byWidgetPredicate((w) => w is SvgPicture || w is Image).evaluate()) {
    final w = el.widget;
    final ref = switch (w) {
      SvgPicture(bytesLoader: final SvgAssetLoader l) => {'kind': 'svg', 'package': l.packageName, 'path': l.assetName},
      Image(image: AssetImage(:final assetName, :final package)) => {'kind': 'raster', 'package': package, 'path': assetName},
      Image(image: ExactAssetImage(:final assetName, :final package)) => {'kind': 'raster', 'package': package, 'path': assetName},
      _ => {'kind': w.runtimeType.toString()},
    };
    assets[el.findRenderObject()!] = ref;
  }
  final rec = Recorder();
  final root = tester.renderObject<RenderBox>(find.byType(PlateView));
  Painter(rec, assets).paintChild(root, Offset.zero);
  await tester.pumpWidget(const SizedBox());
  controller.dispose();
  return rec.ops;
}
