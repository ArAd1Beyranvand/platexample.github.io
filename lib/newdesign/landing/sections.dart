import 'package:flutter/material.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:palestine_plate/palestine_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../data/catalogue.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
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
    final CatalogueItem? iran = of(IranPlates.car);
    final CatalogueItem? westBank = of(PSWestBankPlates.modernCar);
    final CatalogueItem? gaza = of(PSGazaPlates.car2012);
    // Northern specs are built per geometry, so there is no named constant.
    final CatalogueItem? yemenNorth = catalogueItems
        .where(
          (CatalogueItem i) =>
              i.entry.id.startsWith('ye.northern.car.private.blue'),
        )
        .firstOrNull;

    Widget card(
      CatalogueItem? item,
      String title,
      String text, {
      PlateTheme? theme,
    }) => PdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (item != null)
            StaticPlate(
              spec: item.entry.spec,
              values: item.entry.sampleValues,
              theme: theme ?? item.entry.theme,
              country: item.entry.country,
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
              iran,
              'Its own alphabet',
              'Iran’s letter slot takes one of a fixed set of Persian '
                  'letters, chosen from a picker. A–Z is wrong here.',
            ),
            card(
              westBank,
              'One country, two systems',
              'Palestine issues West Bank and Gaza plates. Each is its own '
                  'spec in the same package; pick the one the car carries.',
            ),
            card(
              gaza,
              'Flags and emblems',
              'Gaza’s 2012 plate carries the flag in a vertical strip. The '
                  'spec draws it; you never place an image yourself.',
            ),
            card(
              yemenNorth,
              'Right-to-left',
              'Arabic script and Arabic-Indic digits. The plate draws its own '
                  'direction; the page never overrides it.',
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
  final TextEditingController _text = TextEditingController(text: '12ب345AB67');
  final PlateController _plate = PlateController(spec: IranPlates.car);

  @override
  void dispose() {
    _text.dispose();
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final CatalogueItem? iran = itemForSpec(IranPlates.car);

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
                    child: PdTextField(
                      controller: _text,
                      style: monoStyle(t, size: 16),
                      semanticLabel: 'Type a plate into a text field',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keeps every character. No slots, no alphabet, no '
                    'direction, no colours.',
                    style: body(t),
                  ),
                ],
              ),
            ),
            PdCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('PLATECANVAS · IRANPLATES.CAR', style: eyebrow(t)),
                  const SizedBox(height: 16),
                  LivePlate(
                    controller: _plate,
                    validName: iran == null ? 'Iran car' : validNameOf(iran),
                    theme: iran?.entry.theme,
                    country: iran?.entry.country,
                    validator: iran?.entry.validator,
                    inputSource: PlateInputSource.system,
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
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hint;
  final TextStyle? style;
  final String? semanticLabel;
  final Widget? prefix;

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
          enabledBorder: border(t.control),
          focusedBorder: border(t.accent, 2),
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
        'final controller = PlateController(spec: IranPlates.car);\n'
            '\n'
            'PlateCanvas(\n'
            '  spec: IranPlates.car,\n'
            '  controller: controller,\n'
            '  onChooseCharacter: pickLetter,\n'
            ')',
      ),
      (
        '03',
        'Read the value',
        'controller.values        // one entry per slot\n'
            "controller.text(sep: '') // the plate as a string\n"
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
            child: SelectableText(code, style: monoStyle(t, height: 22 / 13)),
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: t.text,
              ),
            ),
            const SizedBox(height: 6),
            Text('Flutter developer, Iran. Sole author.', style: body(t)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 18,
              runSpacing: 8,
              children: <Widget>[
                PdLink('GitHub ↗', onTap: () => openExternal(kAuthorGithub)),
                PdLink(
                  kAuthorEmail,
                  onTap: () => openExternal('mailto:$kAuthorEmail'),
                ),
                PdLink(
                  'MIT licence ↗',
                  onTap: () => openExternal('$kCoreRepo/blob/main/LICENSE'),
                ),
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
