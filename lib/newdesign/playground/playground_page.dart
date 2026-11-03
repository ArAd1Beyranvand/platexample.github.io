import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plate_core/plate_core.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../embed/embed_host.dart';
import '../embed/handover.dart';
import '../embed/embed_loader.dart';
import '../embed/protocol.dart';
import '../embed/registry.dart';
import '../landing/hero.dart' show validNameOf;
import '../landing/text_styles.dart';
import '../plate/live_plate.dart';
import '../shell/site_shell.dart';
import '../widgets/controls.dart';

/// One plate at a time: the live plate and its controls beside the code that
/// reproduces it.
class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key, required this.item, this.lang});

  final CatalogueItem item;

  /// Built language shown on the stage; null is Flutter.
  final String? lang;

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  late final PlateController _plate =
      PlateController(spec: widget.item.entry.spec)
        ..hints.value = widget.item.entry.sampleValues
        ..addListener(_changed);
  bool _codeOpen = true;
  List<String?>? _embedValues;
  bool _embedValid = false;

  CatalogueItem get _item => widget.item;
  int get _index => playgroundItems.indexOf(_item);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void didUpdateWidget(PlaygroundPage old) {
    super.didUpdateWidget(old);
    if (identical(old.item, _item)) return;
    final PlateSpec next = _item.entry.spec;
    _plate.adoptSpec(next, preserve: PlateValuePreservation.none);
    _plate.hints.value = _item.entry.sampleValues;
    _embedValues = null;
  }

  void _embedChanged(List<String?> values, bool? valid) => setState(() {
    _embedValues = values;
    _embedValid = valid ?? false;
  });

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _plate.removeListener(_changed);
    super.dispose();
  }

  void _changed() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    }
  }

  /// ←/→ page through plates unless the plate or a text field has focus.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final BuildContext? focused = FocusManager.instance.primaryFocus?.context;
    if (focused != null &&
        (focused.widget is EditableText ||
            focused.findAncestorWidgetOfExactType<PlateCanvas>() != null ||
            focused.findAncestorWidgetOfExactType<EditableText>() != null)) {
      return false;
    }
    if (_plate.activeIndex != null) return false;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) return _step(-1);
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) return _step(1);
    return false;
  }

  bool _step(int by) {
    final int i = _index + by;
    if (i < 0 || i >= playgroundItems.length) return false;
    PdNav.of(
      context,
    ).go(PdLocation.playground(playgroundItems[i], widget.lang));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<String?> values = _plate.values;
    final bool complete = firstEmpty(_item.entry.spec, values) == null;
    final bool valid =
        complete &&
        verdictOf(_item.entry.spec, values, _item.entry.validator).isValid;
    final List<CodeLine> code = playgroundCode(
      item: _item,
      source: PlateInputSource.keypadFirst,
      values: values,
      isValid: valid,
    );
    final String? lang = widget.lang;
    final List<CodeLine> shown = lang == null
        ? code
        : embedCode(
            lang: lang,
            item: _item,
            values:
                _embedValues ??
                List<String?>.filled(_item.entry.spec.slotCount, null),
            isValid: _embedValid,
          );
    final bool narrow = MediaQuery.sizeOf(context).width < 600;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: headerExtent(context) + pdClamp(context, 20, 3, 40),
        bottom: pdClamp(context, 48, 7, 96),
      ),
      // Its own layer, so a scroll frame doesn't re-record the page.
      child: RepaintBoundary(
        child: PdContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _TopRow(item: _item, index: _index, onStep: _step),
              const SizedBox(height: 24),
              PdAutoGrid(
                minWidth: 460,
                gap: 24,
                children: <Widget>[
                  _StageCard(
                    item: _item,
                    plate: _plate,
                    lang: widget.lang,
                    onEmbedChange: _embedChanged,
                  ),
                  if (narrow && !_codeOpen)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PdLink(
                        '▸ Show code',
                        onTap: () => setState(() => _codeOpen = true),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _CodePanel(lines: shown),
                        if (lang == null) ...<Widget>[
                          const SizedBox(height: 16),
                          _SlotsView(spec: _item.entry.spec, values: values),
                        ],
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 32),
              _Facts(item: _item),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopRow extends StatelessWidget {
  const _TopRow({
    required this.item,
    required this.index,
    required this.onStep,
  });

  final CatalogueItem item;
  final int index;
  final bool Function(int) onStep;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final TextStyle crumb = TextStyle(fontSize: 14, color: t.muted);
    Widget arrow(IconData icon, String label, int by) {
      final int to = index + by;
      final bool enabled = to >= 0 && to < playgroundItems.length;
      return Opacity(
        opacity: enabled ? 1 : 0.4,
        child: PdTappable(
          onTap: enabled ? () => onStep(by) : null,
          semanticLabel: label,
          width: 44,
          height: 44,
          border: t.divider,
          hoverColor: t.hover,
          child: Icon(icon, size: 18, color: t.text),
        ),
      );
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              PdLink(
                'Countries',
                onTap: () =>
                    nav.go(const PdLocation.landing(LandingAnchor.coverage)),
                style: crumb,
              ),
              Text('  /  ', style: crumb),
              PdLink(
                item.source.countryName,
                onTap: () => nav.go(PdLocation.country(item.source)),
                style: crumb,
              ),
              Text('  /  ', style: crumb),
              Text(
                item.entry.label,
                style: crumb.copyWith(
                  color: t.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${index + 1} of ${playgroundItems.length}',
          style: monoStyle(t, size: 12).copyWith(color: t.subtle),
        ),
        const SizedBox(width: 12),
        arrow(Icons.arrow_back, 'Previous plate', -1),
        const SizedBox(width: 8),
        arrow(Icons.arrow_forward, 'Next plate', 1),
      ],
    );
  }
}

class _StageCard extends StatefulWidget {
  const _StageCard({
    required this.item,
    required this.plate,
    required this.lang,
    required this.onEmbedChange,
  });

  final CatalogueItem item;
  final PlateController plate;
  final String? lang;
  final void Function(List<String?> values, bool? valid) onEmbedChange;

  @override
  State<_StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<_StageCard> {
  int _band = 0;

  @override
  void didUpdateWidget(_StageCard old) {
    super.didUpdateWidget(old);
    if (old.item != widget.item) _band = 0;
  }

  @override
  Widget build(BuildContext context) {
    final CatalogueItem item = widget.item;
    final PlateController plate = widget.plate;
    final bands = item.entry.bands;
    final band = bands.isEmpty ? null : bands[_band];
    final PlateCountry? country = band?.$2 ?? item.entry.country;
    final PdTokens t = context.tokens;
    final double h1 = pdClamp(context, 24, 3, 36);

    return Container(
      padding: EdgeInsets.all(pdClamp(context, 20, 3, 32)),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(PdRadius.stage),
        border: Border.all(color: t.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '${item.source.countryName} · ${item.entry.label}',
            style: TextStyle(
              fontSize: h1,
              height: 1.15,
              fontWeight: FontWeight.w700,
              fontVariations: const <FontVariation>[FontVariation.weight(750)],
              letterSpacing: -0.02 * h1,
              color: t.text,
            ),
          ),
          if (item.entry.bands.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final (int i, GalleryBand b) in bands.indexed)
                  ChoiceChip(
                    label: Text(b.$1),
                    selected: i == _band,
                    onSelected: (_) => setState(() => _band = i),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          _LanguageRow(item: item, lang: widget.lang),
          const SizedBox(height: 24),
          EmbedHandover(
            embed: widget.lang != null,
            child: widget.lang == null
                ? LivePlate(
                    key: const ValueKey<String>('flutter'),
                    controller: plate,
                    validName: validNameOf(item),
                    theme: band?.$3 ?? item.entry.themeFor(plate.values),
                    country: country,
                    validator: item.entry.validator,
                    inputSource: PlateInputSource.keypadFirst,
                    showInvalidNote: true,
                    keypadBelow: SlotKeypad(controller: plate),
                  )
                : _Embed(
                    key: ValueKey<String>('${item.source.slug}/${widget.lang}'),
                    item: item,
                    lang: widget.lang!,
                    onChange: widget.onEmbedChange,
                  ),
          ),
        ],
      ),
    );
  }
}

/// The stage's language switcher: a segmented control with every language, so
/// the choice is always visible. Languages not built for this country are dimmed
/// and explain themselves. Only the route parameter changes, so the page stays put.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.item, required this.lang});

  final CatalogueItem item;
  final String? lang;

  static const Map<String, String> _hints = <String, String>{
    'flutter': 'Dart package, rendered by Flutter',
    'typescript': 'TypeScript port, rendered in the DOM',
    'kotlin': 'Kotlin port: Wasm where supported, JS otherwise',
    'python': 'Python port, running in the browser',
  };

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final EmbedRegistryLoader loader = EmbedRegistryLoader.instance
      ..ensureLoaded();
    return ValueListenableBuilder<EmbedRegistry>(
      valueListenable: loader.registry,
      builder: (BuildContext context, EmbedRegistry registry, _) {
        final List<String> built = registry.languagesOf(item.source.slug);
        final String active = lang ?? embedLanguageFlutter;
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: <Widget>[
            Text('Language', style: eyebrow(t)),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: t.raised,
                borderRadius: BorderRadius.circular(PdRadius.card),
                border: Border.all(color: t.divider),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final String l in embedLanguages)
                    _LangButton(
                      label: embedLanguageLabels[l]!,
                      selected: l == active,
                      enabled: built.contains(l),
                      hint: built.contains(l)
                          ? _hints[l]!
                          : '${embedLanguageLabels[l]} build not available for ${item.source.countryName} yet',
                      onTap: () => PdNav.of(context).go(
                        PdLocation.playground(
                          item,
                          l == embedLanguageFlutter ? null : l,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.hint,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Tooltip(
      message: hint,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: MouseRegion(
          cursor: enabled && !selected
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: enabled && !selected ? onTap : null,
            child: AnimatedContainer(
              duration: PdMotion.of(context, const Duration(milliseconds: 160)),
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? t.accentSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(PdRadius.chip),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? t.accent : t.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The plate and keypad of a built language, in an iframe opened on [item]'s
/// spec. A language the registry lacks falls back to Flutter.
class _Embed extends StatelessWidget {
  const _Embed({
    super.key,
    required this.item,
    required this.lang,
    required this.onChange,
  });

  final CatalogueItem item;
  final String lang;
  final void Function(List<String?> values, bool? valid) onChange;

  @override
  Widget build(BuildContext context) {
    final EmbedRegistryLoader loader = EmbedRegistryLoader.instance
      ..ensureLoaded();
    return ValueListenableBuilder<EmbedRegistry>(
      valueListenable: loader.registry,
      builder: (BuildContext context, EmbedRegistry registry, _) {
        final EmbedComponent? component = registry.of(item.source.slug, lang);
        if (component == null) {
          if (!identical(registry, EmbedRegistry.unloaded)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted)
                PdNav.of(context).go(PdLocation.playground(item));
            });
          }
          return const SizedBox(height: 320);
        }
        return EmbedHost(
          key: ValueKey<String>('${item.source.slug}/${item.slug}/$lang'),
          component: component,
          spec: item.entry.id,
          onChange: onChange,
          title:
              '${item.source.countryName} ${item.entry.label} · ${embedLanguageLabels[lang]}',
        );
      },
    );
  }
}

/// The generated code; lines that differ from the previous build flash.
class _CodePanel extends StatefulWidget {
  const _CodePanel({required this.lines});

  final List<CodeLine> lines;

  @override
  State<_CodePanel> createState() => _CodePanelState();
}

class _CodePanelState extends State<_CodePanel> {
  static const int _codeLines = 24;
  Set<int> _changed = <int>{};
  int _generation = 0;

  @override
  void didUpdateWidget(_CodePanel old) {
    super.didUpdateWidget(old);
    final Set<int> changed = <int>{
      for (int i = 0; i < widget.lines.length; i++)
        if (i >= old.lines.length || old.lines[i] != widget.lines[i]) i,
    };
    if (changed.isNotEmpty) {
      _changed = changed;
      _generation++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final Duration flash = PdMotion.of(
      context,
      const Duration(milliseconds: 600),
    );
    return Container(
      decoration: BoxDecoration(
        color: t.code,
        borderRadius: BorderRadius.circular(PdRadius.card),
        border: Border.all(color: t.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: t.divider)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Code · updates as you change the plate',
                    style: TextStyle(fontSize: 13, color: t.muted),
                  ),
                ),
                PdCopyButton(
                  text: () =>
                      widget.lines.map((CodeLine l) => l.text).join('\n'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _codeLines * 22 + 24,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (int i = 0; i < widget.lines.length; i++)
                    TweenAnimationBuilder<double>(
                      key: ValueKey<String>(
                        _changed.contains(i) ? 'f$_generation-$i' : 's$i',
                      ),
                      tween: Tween<double>(
                        begin: _changed.contains(i) && flash > Duration.zero
                            ? 1
                            : 0,
                        end: 0,
                      ),
                      duration: flash,
                      builder:
                          (BuildContext context, double v, Widget? child) =>
                              ColoredBox(
                                color: t.accentSoft.withValues(
                                  alpha: t.accentSoft.a * v,
                                ),
                                child: child,
                              ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          widget.lines[i].text,
                          style: monoStyle(t, size: 13, height: 22 / 13)
                              .copyWith(
                                color: widget.lines[i].comment
                                    ? t.subtle
                                    : t.text,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Slots, in order": each slot's index, alphabet and current value.
class _SlotsView extends StatelessWidget {
  const _SlotsView({required this.spec, required this.values});

  final PlateSpec spec;
  final List<String?> values;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Slots, in order', style: eyebrow(t)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: <Widget>[
            for (int i = 0; i < spec.slotCount; i++)
              Tooltip(
                message:
                    'Slot ${i + 1}: ${describeSlots(spec.slots[i].alphabet, 1)}',
                child: Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: t.surface,
                    borderRadius: BorderRadius.circular(PdRadius.chip),
                    border: Border.all(color: t.divider),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        values[i] ?? '·',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: values[i] == null ? t.subtle : t.text,
                        ),
                      ),
                      Text(
                        '${i + 1}',
                        style: monoStyle(t, size: 10).copyWith(color: t.subtle),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.item});

  final CatalogueItem item;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final String package = packageOf(item);
    final String link = 'platexample.ir/#${PdLocation.playground(item).path}';
    final List<(String, String, VoidCallback?)> rows =
        <(String, String, VoidCallback?)>[
          ('Spec', specName(item) ?? item.entry.spec.id, null),
          ('Package', package, () => openExternal(repoOf(package))),
          ('Slots', slotPattern(item.entry.spec), null),
          ('Deep link', link, () => openExternal('https://$link')),
        ];
    return Column(
      children: <Widget>[
        for (final (String k, String v, VoidCallback? tap) in rows)
          Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: t.divider)),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 120, child: Text(k, style: body(t))),
                Expanded(
                  child: tap == null
                      ? Text(
                          v,
                          overflow: TextOverflow.ellipsis,
                          style: monoStyle(t),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: PdLink(
                            v,
                            onTap: tap,
                            style: monoStyle(t).copyWith(color: t.accent),
                          ),
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
