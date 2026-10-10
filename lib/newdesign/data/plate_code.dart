import 'package:iran_plate/iran_plate.dart';
import 'package:plate_core/plate_core.dart';

import 'catalogue.dart';
import 'spec_names.g.dart';

const String kCoreRepo = 'https://github.com/ArAd1Beyranvand/plate-core';

/// The Dart a developer would type for [item]'s spec, or null when the
/// package builds it in a way that has no public name.
String? specName(CatalogueItem item) => specNames[item.entry.spec];

String repoOf(String package) =>
    packageRepos[package] ?? 'https://github.com/ArAd1Beyranvand';

/// The package that ships [item]: the source's own, or for an umbrella the
/// first package name (Iranshahr ships every member from one package).
String packageOf(CatalogueItem item) => item.source.packageNames.first;

/// The `import` a package's barrel lives at.
String importOf(String package) => switch (package) {
  'iranshahr_plate' => "import 'package:iranshahr_plate/iranshahr_plate.dart';",
  _ => "import 'package:$package/$package.dart';",
};

/// The colours option the playground offers next to Country and Mono.
class UsageColours {
  const UsageColours(this.theme, this.code);

  final PlateTheme theme;
  final String code;
}

/// The country's taxi theme, if its package has one: Iran's by usage,
/// otherwise the theme of a catalogue entry in the same country labelled as a
/// taxi. Null hides the Taxi option.
UsageColours? taxiColoursFor(CatalogueItem item) {
  if (item.source is IranSource) {
    return UsageColours(
      IranThemes.forUsage(IranUsage.taxi),
      'IranThemes.forUsage(IranUsage.taxi)',
    );
  }
  for (final CatalogueItem other in catalogueItems) {
    if (!identical(other.source, item.source)) continue;
    final GalleryEntry e = other.entry;
    final String tag = '${e.id} ${e.label}'.toLowerCase();
    final PlateTheme? theme = e.theme;
    if (theme == null || !tag.contains('taxi')) continue;
    return UsageColours(theme, themeNames[theme] ?? '/* taxi theme */ null');
  }
  return null;
}

enum ColoursMode { country, mono, taxi }

/// The theme a colours mode paints [item] with, given the plate's values.
PlateTheme? themeFor(
  CatalogueItem item,
  ColoursMode mode,
  List<String?> values,
) => switch (mode) {
  ColoursMode.country => item.entry.themeFor(values),
  ColoursMode.mono => PlateTheme.standard(),
  ColoursMode.taxi => taxiColoursFor(item)?.theme ?? item.entry.theme,
};

/// One line of generated code; [comment] lines are drawn `subtle`.
typedef CodeLine = ({String text, bool comment});

/// The playground's code panel, generated from the spec, input mode and
/// colours on screen.
List<CodeLine> playgroundCode({
  required CatalogueItem item,
  required PlateInputSource source,
  required ColoursMode colours,
  required List<String?> values,
  required bool isValid,
}) {
  final PlateSpec spec = item.entry.spec;
  final String package = packageOf(item);
  final String name = specName(item) ?? "/* '${spec.id}' from $package */ spec";
  final bool keypad = source == PlateInputSource.packageKeypad;

  final String? theme = switch (colours) {
    ColoursMode.country => switch (item.entry.theme) {
      null => null,
      final PlateTheme t => themeNames[t],
    },
    ColoursMode.mono => 'PlateTheme.standard()',
    ColoursMode.taxi => taxiColoursFor(item)?.code,
  };

  CodeLine c(String text) => (text: text, comment: false);
  CodeLine k(String text) => (text: text, comment: true);

  final List<CodeLine> lines = <CodeLine>[
    c("import 'package:plate_core/plate_core.dart';"),
    c(importOf(package)),
    if (keypad) c("import 'package:plate_keypad/plate_keypad.dart';"),
    c(''),
    c('final spec = $name;'),
    c('final controller = PlateController(spec: spec);'),
    c(''),
    c('PlateCanvas('),
    c('  spec: spec,'),
    c('  controller: controller,'),
    c('  inputSource: PlateInputSource.${source.name},'),
    if (theme != null) c('  theme: $theme,'),
    c('  autoValidate: true,'),
    c('  onChooseCharacter: pickLetter,'),
    c(')'),
  ];
  if (keypad) {
    final int digit = spec.slots.indexWhere(
      (PlateSlot s) => s.alphabet.isNumeric,
    );
    final int letter = spec.slots.indexWhere(
      (PlateSlot s) => !s.alphabet.isNumeric,
    );
    lines.addAll(<CodeLine>[
      c(''),
      c('PlateKeypad('),
      c('  highlightedKey: null,'),
      c(
        '  digitAlphabet: ${digit < 0 ? 'PlateAlphabet.latinDigits' : 'spec.slots[$digit].alphabet'},',
      ),
      c(
        '  letterAlphabet: ${letter < 0 ? 'PlateAlphabet.latinUppercase' : 'spec.slots[$letter].alphabet'},',
      ),
      c('  onKey: (key) => key == kPlateBackspaceKey'),
      c('      ? controller.backspace()'),
      c('      : controller.submit(key),'),
      c(')'),
    ]);
  }
  final String value = values.map((String? v) => v ?? '').join();
  lines.addAll(<CodeLine>[
    c(''),
    k('// controller.text(sep: \'\'): "$value"'),
    k('// isValid: $isValid'),
  ]);
  return lines;
}

/// "2 + 1 + 3 + 2 = 8": the spec's text groups, or runs of one alphabet.
String slotPattern(PlateSpec spec) {
  final List<int> sizes = <int>[];
  if (spec.textGroups.isNotEmpty) {
    sizes.addAll(spec.textGroups.map((PlateTextGroup g) => g.indices.length));
  } else {
    PlateAlphabet? last;
    for (final PlateSlot slot in spec.slots) {
      if (identical(slot.alphabet, last)) {
        sizes.last++;
      } else {
        sizes.add(1);
      }
      last = slot.alphabet;
    }
  }
  return '${sizes.join(' + ')} = ${spec.slotCount}';
}

/// The typed characters, in order, that still fit [next]'s slots: each goes
/// into the next slot if that slot's alphabet takes it, and is dropped if not.
List<String?> carryValues(List<String?> values, PlateSpec next) {
  final List<String?> out = List<String?>.filled(next.slotCount, null);
  int i = 0;
  for (final String? v in values) {
    if (v == null || v.isEmpty) continue;
    if (i >= next.slotCount) break;
    final PlateAlphabet a = next.slots[i].alphabet;
    if (a.accepts(v)) out[i++] = a.canonical(v);
  }
  return out;
}
