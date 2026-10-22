import 'package:flutter/material.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:palestine_plate/palestine_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../data/catalogue.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
import '../shell/site_shell.dart';
import 'hero.dart';
import 'text_styles.dart';

const String kAuthorEmail = 'ArAd1Beyranvand@gmail.com';
const String kAuthorGithub = 'https://github.com/ArAd1Beyranvand';

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.lede});

  final String title;
  final String? lede;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: h2(context)),
        if (lede != null) ...<Widget>[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(lede!, style: body(t, size: 16)),
          ),
        ],
        const SizedBox(height: 28),
      ],
    );
  }
}

class PdCard extends StatelessWidget {
  const PdCard({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? t.surface,
        borderRadius: BorderRadius.circular(PdRadius.card),
        border: Border.all(color: t.divider),
      ),
      child: child,
    );
  }
}

// --- 2. Why plates are hard -------------------------------------------------

class WhySection extends StatelessWidget {
  const WhySection({super.key});

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    CatalogueItem? of(PlateSpec spec) => itemForSpec(spec);
    final CatalogueItem? iran = of(IranPlates.civil);
    final CatalogueItem? westBank = of(PSWestBankPlates.modernCar);
    final CatalogueItem? gaza = of(PSGazaPlates.car2012);
    // Northern specs are built per geometry, so there is no named constant.
    final CatalogueItem? yemenNorth = catalogueItems
        .where((CatalogueItem i) => i.entry.id.startsWith('ye.northern.car.private.blue'))
        .firstOrNull;

    Widget card(CatalogueItem? item, String title, String text, {PlateTheme? theme}) => PdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (item != null)
            StaticPlate(
              spec: item.entry.spec,
              values: item.entry.sampleValues,
              theme: theme ?? item.entry.theme,
              country: item.entry.country,
              autoType: true,
            ),
          const SizedBox(height: 18),
          Text(title, style: h3(t)),
          const SizedBox(height: 6),
          Text(text, style: body(t)),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionHeading(
          'Why plates are hard',
          lede:
              'A plate is not a string. Four things change from one country '
              'to the next.',
        ),
        PdAutoGrid(
          minWidth: 200,
          gap: 16,
          children: <Widget>[
            card(
              yemenNorth,
              'Right-to-left',
              'Two rows, mirroring each other. The plate lays itself out '
                  'right to left.',
            ),
            card(
              gaza,
              'Flags and emblems',
              'Gaza’s 2012 plate carries the flag in a vertical strip. The '
                  'spec draws it; you never place an image yourself.',
            ),
            card(
              westBank,
              'One country, two systems',
              'Palestine issues West Bank and Gaza plates. Each is its own '
                  'spec in the same package; pick the one the car carries.',
            ),
            card(
              iran,
              'Its own alphabet',
              'Iran’s letter slot takes one of a fixed set of Persian '
                  'letters, chosen from a picker. A–Z is wrong here.',
            ),
          ],
        ),
      ],
    );
  }
}

// --- 3. A text field vs. this widget ----------------------------------------

class CompareSection extends StatefulWidget {
  const CompareSection({super.key});

  @override
  State<CompareSection> createState() => _CompareSectionState();
}

class _CompareSectionState extends State<CompareSection> {
  final TextEditingController _text = TextEditingController(text: '12ب3ABcd');
  final PlateController _plate = PlateController(spec: IranPlates.civil);

  final GlobalKey _plateKey = GlobalKey();

  /// Refuses focus while the plate is being filled, so rewriting the field's
  /// text from the plate never pulls focus (and the page) over to it.
  final FocusNode _fieldFocus = FocusNode();

  /// On a phone, brings the plate to the top once the keyboard has settled.
  void _liftPlate() {
    if (MediaQuery.sizeOf(context).width >= 600) return;
    final double header = headerExtent(context);
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      final BuildContext? plate = _plateKey.currentContext;
      if (!mounted || plate == null) return;
      final ScrollPosition position = Scrollable.of(plate).position;
      final double top = (plate.findRenderObject()! as RenderBox).localToGlobal(Offset.zero).dy;
      final double target = position.pixels + top - header - 16;
      position.animateTo(
        target.clamp(position.minScrollExtent, position.maxScrollExtent),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    });
  }

  /// True when the field holds a character the plate refused.
  bool _refused = false;
  bool _syncing = false;

  /// The slot values the field last fed the plate; a plate notification that
  /// still matches them must not strip the field's refused characters.
  String _fed = '';

  @override
  void initState() {
    super.initState();
    _text.addListener(_textToPlate);
    _plate.addListener(_plateToText);
    _textToPlate();
  }

  /// A left-to-right mark after every character, so Persian letters and
  /// Arabic-Indic digits keep typing order instead of forming an RTL run.
  static const String _lrm = '\u200E';

  static String _ltr(String raw) =>
      raw.characters.where((String c) => c != _lrm).map((String c) => '$c$_lrm').join();

  /// The field's text as last written in [_ltr] form.
  String _shown = '';

  /// Rewrites what the user typed into [_ltr] form, keeping the caret after
  /// the same real characters. A backspace that only took a mark takes the
  /// character before it too.
  void _keepLtr() {
    String text = _text.text;
    int caret = _text.selection.baseOffset.clamp(0, text.length);
    if (text.length < _shown.length && _ltr(text) == _shown && caret > 0) {
      final String head = text.substring(0, caret).characters.skipLast(1).string;
      text = head + text.substring(caret);
      caret = head.length;
    }
    final String shown = _ltr(text);
    _shown = shown;
    if (shown == _text.text) return;
    _syncing = true;
    _text.value = TextEditingValue(
      text: shown,
      selection: TextSelection.collapsed(offset: _ltr(text.substring(0, caret)).length),
    );
    _syncing = false;
  }

  /// The field's characters fed slot by slot, as [PlateController.fromText]
  /// reads them; anything left over or refused marks the field.
  void _textToPlate() {
    if (_syncing) return;
    _keepLtr();
    final PlateSpec spec = _plate.spec;
    final List<String?> values = List<String?>.filled(spec.slotCount, null);
    bool refused = false;
    int index = 0;
    for (final String c in _text.text.characters) {
      if (c == _lrm || c.trim().isEmpty) continue;
      // A one-character alphabet is printed on the plate, not typed.
      while (index < spec.slotCount && spec.slots[index].alphabet.characters.length == 1) {
        index++;
      }
      final PlateAlphabet? alphabet = index < spec.slotCount ? spec.slots[index].alphabet : null;
      if (alphabet == null || !alphabet.accepts(c)) {
        refused = true;
        continue;
      }
      final String value = (values[index] ?? '') + alphabet.canonical(c);
      values[index] = value;
      if (value.characters.length >= spec.slots[index].length) index++;
    }
    _syncing = true;
    _plate.setValues(values);
    _fed = values.whereType<String>().join();
    _syncing = false;
    if (refused != _refused) setState(() => _refused = refused);
  }

  /// A slot typed on the plate rewrites the field with the corrected value.
  void _plateToText() {
    if (_syncing) return;
    final PlateSpec spec = _plate.spec;
    final String next = <String?>[
      for (int i = 0; i < spec.slotCount; i++)
        if (spec.slots[i].alphabet.characters.length > 1) _plate.valueAt(i),
    ].whereType<String>().join();
    if (next == _fed) return;
    final String shown = _ltr(next);
    _shown = shown;
    _syncing = true;
    _text.value = TextEditingValue(
      text: shown,
      selection: TextSelection.collapsed(offset: shown.length),
    );
    _syncing = false;
    if (_refused) setState(() => _refused = false);
  }

  @override
  void dispose() {
    _text.removeListener(_textToPlate);
    _plate.removeListener(_plateToText);
    _text.dispose();
    _fieldFocus.dispose();
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final CatalogueItem? iran = itemForSpec(IranPlates.civil);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionHeading(
          'A text field vs. this widget',
          lede: 'Type the same plate into both. See what each one accepts.',
        ),
        PdAutoGrid(
          minWidth: 320,
          gap: 16,
          children: <Widget>[
            PdCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('TEXTFIELD', style: eyebrow(t)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: Listener(
                      onPointerDown: (_) => _fieldFocus.canRequestFocus = true,
                      child: PdTextField(
                        controller: _text,
                        focusNode: _fieldFocus,
                        style: monoStyle(t, size: 16),
                        semanticLabel: 'Type a plate into a text field',
                        error: _refused,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _refused
                        ? 'Holds characters this plate refuses. The plate '
                              'shows only what fits.'
                        : 'Keeps every character. No slots, no alphabet, no '
                              'direction, no colours.',
                    style: body(t).copyWith(color: _refused ? t.error : null),
                  ),
                ],
              ),
            ),
            PdCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('PLATECANVAS · IRANPLATES.CIVIL', style: eyebrow(t)),
                  const SizedBox(height: 16),
                  Listener(
                    onPointerDown: (_) {
                      _fieldFocus.canRequestFocus = false;
                      _liftPlate();
                    },
                    child: KeyedSubtree(
                      key: _plateKey,
                      child: LivePlate(
                        controller: _plate,
                        validName: iran == null ? 'Iran car' : validNameOf(iran),
                        theme: iran?.entry.theme,
                        country: iran?.entry.country,
                        validator: iran?.entry.validator,
                        inputSource: PlateInputSource.system,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap a slot and type with your own keyboard. Each slot '
                    'takes only its alphabet, drawn in the plate’s own layout.',
                    style: body(t),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A 44/48 h outlined field in the DS style.
class PdTextField extends StatelessWidget {
  const PdTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hint,
    this.style,
    this.semanticLabel,
    this.prefix,
    this.error = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hint;
  final TextStyle? style;
  final String? semanticLabel;
  final Widget? prefix;

  /// Paints the border in the error colour.
  final bool error;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(PdRadius.chip),
      borderSide: BorderSide(color: c, width: w),
    );
    return Semantics(
      label: semanticLabel,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: style ?? TextStyle(fontSize: 15, color: t.text),
        expands: true,
        maxLines: null,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: t.subtle),
          prefixIcon: prefix,
          filled: true,
          fillColor: t.bg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          enabledBorder: border(error ? t.error : t.control),
          focusedBorder: border(error ? t.error : t.accent, 2),
        ),
      ),
    );
  }
}

// --- 5. Your first plate in a minute (#start) -------------------------------

class StartSection extends StatelessWidget {
  const StartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<(String, String, String)> steps = <(String, String, String)>[
      (
        '01',
        'Install',
        'dependencies:\n'
            '  plate_core:\n'
            '    git: ${repoOf('plate_core')}\n'
            '  iran_plate:\n'
            '    git: ${repoOf('iran_plate')}',
      ),
      (
        '02',
        'Render a plate',
        'final controller = PlateController(spec: IranPlates.civil);\n'
            '\n'
            'PlateCanvas(\n'
            '  spec: IranPlates.civil,\n'
            '  controller: controller,\n'
            '  onChooseCharacter: pickLetter,\n'
            ')',
      ),
      (
        '03',
        'Read the value',
        'controller.values        // one entry per slot\n'
            "controller.text(sep: ' ') // the plate as a string\n"
            'controller.isCompleted   // every slot filled',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionHeading('Your first plate in a minute'),
        for (final (String n, String title, String code) in steps) ...<Widget>[
          _Step(n: n, title: title, code: code),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.title, required this.code});

  final String n;
  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(n, style: monoStyle(t, size: 12).copyWith(color: t.accent)),
            const SizedBox(width: 10),
            Text(title, style: h3(t)),
          ],
        ),
        const SizedBox(height: 10),
        CodeBlock(code: code),
      ],
    );
  }
}

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Container(
      decoration: BoxDecoration(
        color: t.code,
        borderRadius: BorderRadius.circular(PdRadius.card),
        border: Border.all(color: t.divider),
      ),
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(18, 16, 80, 16),
            child: PdCodeText(code, style: monoStyle(t, height: 22 / 13)),
          ),
          Positioned(top: 6, right: 6, child: PdCopyButton(text: () => code)),
        ],
      ),
    );
  }
}

// --- 6. About (#about) ------------------------------------------------------

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdAutoGrid(
      minWidth: 360,
      gap: pdClamp(context, 32, 5, 64),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('BUILT BY', style: eyebrow(t)),
            const SizedBox(height: 10),
            Text(
              'Arad Beyranvand',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: t.text),
            ),
            const SizedBox(height: 6),
            Text('Flutter developer, Iran. Sole author.', style: body(t)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: <Widget>[
                PdLink('GitHub ↗', onTap: () => openExternal(kAuthorGithub)),
                PdLink(kAuthorEmail, onTap: () => openExternal('mailto:$kAuthorEmail')),
                PdLink('MIT licence ↗', onTap: () => openExternal('$kCoreRepo/blob/main/LICENSE')),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '«هدف اینه که در هر کدبیس و دیزاین سیستمی بشه به راحتی پلاک را '
              'در شکل اصلی خودش وارد کرد یا نمایش داد.»',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: PdFonts.persian,
                fontSize: 19,
                height: 1.8,
                color: t.text,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The goal: in any codebase and any design system, enter or '
              'display a plate in its real form.',
              style: body(t),
            ),
          ],
        ),
      ],
    );
  }
}
