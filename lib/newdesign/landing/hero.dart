import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:germany_plate/germany_plate.dart';
import 'package:iran_plate/iran_plate.dart';
import 'package:lebanon_plate/lebanon_plate.dart';
import 'package:palestine_plate/palestine_plate.dart';
import 'package:plate_core/plate_core.dart';
import 'package:yemen_plate/yemen_plate.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
import 'text_styles.dart';

/// The catalogue entry drawing [spec], so a plate shows with the theme,
/// country panel and validator the catalogue gives it.
CatalogueItem? itemForSpec(PlateSpec spec) {
  for (final CatalogueItem item in playgroundItems) {
    if (identical(item.entry.spec, spec)) return item;
  }
  return null;
}

/// The plates the hero's chips switch between, in order.
final List<(String, CatalogueItem)> heroPlates = <(String, CatalogueItem)>[
  for (final (String, PlateSpec) p in <(String, PlateSpec)>[
    ('Iran', IranPlates.civil),
    ('Yemen', YemenUnifiedPlates.car),
    ('Palestine', PSWestBankPlates.modernCar),
    ('Germany', GermanPlates.car),
    ('Lebanon', LebanonPlates.oneLine),
  ])
    if (itemForSpec(p.$2) case final CatalogueItem item) (p.$1, item),
];

/// One plate per country, in catalogue order, for the hero to cycle through,
/// starting from the first chip.
final List<CatalogueItem> heroTour = () {
  final List<CatalogueItem> tour = <CatalogueItem>[
    for (final GallerySource country in plateCountries)
      if (playgroundItems.where((CatalogueItem i) => identical(i.source, country)).firstOrNull
          case final CatalogueItem item)
        item,
  ];
  final int start = tour.indexWhere(
    (CatalogueItem i) => identical(i.source, heroPlates.first.$2.source),
  );
  return start <= 0 ? tour : <CatalogueItem>[...tour.sublist(start), ...tour.sublist(0, start)];
}();

String validNameOf(CatalogueItem item) =>
    '${item.source.countryName} ${item.entry.label.toLowerCase()}';

class LandingHero extends StatelessWidget {
  const LandingHero({super.key, required this.installLine});

  final String installLine;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final double lede = width < 600 ? 16 : 18;
    final Widget copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('FLUTTER · MIT · OPEN SOURCE', style: eyebrow(t)),
        const SizedBox(height: 16),
        Text(
          'Licence-plate input for Flutter.',
          style: TextStyle(
            fontSize: pdClamp(context, 32, 5.2, 52),
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.025 * pdClamp(context, 32, 5.2, 52),
            color: t.text,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: lede * 0.5 * 44),
          child: Text(
            'Enter or display any licence plate in its real form, in any '
            'codebase and any design system. Each country brings its own '
            'alphabet, direction, layout and colours.',
            style: TextStyle(fontSize: lede, height: 1.55, color: t.muted),
          ),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            PdButton(
              label: 'Get started',
              onTap: () => nav.go(const PdLocation.landing(LandingAnchor.start)),
            ),
            PdButton(
              label: 'Open playground',
              kind: PdButtonKind.outline,
              onTap: () => nav.go(PdLocation.defaultPlayground),
            ),
          ],
        ),
        const SizedBox(height: 20),
        InstallLine(command: installLine),
      ],
    );
    return PdAutoGrid(
      minWidth: 440,
      gap: pdClamp(context, 32, 5, 64),
      children: <Widget>[
        Align(alignment: Alignment.centerLeft, child: copy),
        const _Stage(),
      ],
    );
  }
}

/// `$ command` in the code style, with a Copy button.
class InstallLine extends StatelessWidget {
  const InstallLine({super.key, required this.command});

  final String command;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: t.code,
        borderRadius: BorderRadius.circular(PdRadius.card),
        border: Border.all(color: t.divider),
      ),
      padding: const EdgeInsets.only(left: 14, right: 6),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text.rich(
                TextSpan(
                  children: <InlineSpan>[
                    TextSpan(
                      text: r'$ ',
                      style: TextStyle(color: t.subtle),
                    ),
                    TextSpan(text: command),
                  ],
                ),
                style: monoStyle(t, size: 13),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PdCopyButton(text: () => command),
        ],
      ),
    );
  }
}

/// Tall enough for the hero keypad (258 for every hero spec); a keypad
/// that grows scales down instead of moving the chips.
const double kHeroKeypadHeight = 260;

class _Stage extends StatefulWidget {
  const _Stage();

  @override
  State<_Stage> createState() => _StageState();
}

class _StageState extends State<_Stage> with SingleTickerProviderStateMixin {
  int _index = 0;

  /// Drives the chip row's bounce when the user steps with Previous / Next.
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  double _bounceDir = 1;

  late final PlateController _plate = PlateController(spec: heroTour.first.entry.spec);

  /// Index into [heroTour].
  CatalogueItem get _item => heroTour[_index];

  /// How long each plate shows before the next one staggers in.
  static const Duration _dwell = Duration(seconds: 7);

  /// How long autoplay waits after the user touches the plate or keypad.
  static const Duration _idle = Duration(seconds: 15);

  Timer? _autoplay;
  Timer? _labelSwap;

  /// The plate the name above the plate describes; follows [_item] once the
  /// old plate has staggered out.
  late CatalogueItem _labelItem = heroTour.first;
  bool _labelVisible = true;

  /// Set while [_select] changes the controller, so only the user's edits
  /// hold autoplay back.
  bool _selecting = false;

  @override
  void initState() {
    super.initState();
    _plate.addListener(_edited);
    _schedule(_dwell);
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _labelSwap?.cancel();
    _plate.removeListener(_edited);
    _plate.dispose();
    _bounce.dispose();
    super.dispose();
  }

  void _edited() {
    if (!_selecting) _schedule(_idle);
  }

  /// Waits [after], then moves on and waits the transition plus [_dwell].
  void _schedule(Duration after) {
    _autoplay?.cancel();
    _autoplay = Timer(after, () {
      if (!mounted) return;
      final Duration moved = _select((_index + 1) % heroTour.length);
      _schedule(moved + _dwell);
    });
  }

  /// Upper bound of the stagger out of [from] and in of [to].
  Duration _transitionLength(PlateSpec from, PlateSpec to) {
    const PlateAnimationStyle style = PlateAnimationStyle();
    const Duration step = Duration(milliseconds: 60);
    final Map<PlatePartId, Duration> out = PlateStagger.sequence(from, step: step, reverse: true);
    final Map<PlatePartId, Duration> incoming = PlateStagger.sequence(to, step: step);
    return plateCueLength(style, out.keys, out) + plateCueLength(style, incoming.keys, incoming);
  }

  /// Chips shown on each side of the centred, selected one.
  static const int _reach = 2;

  /// Chip opacity by distance from the centre.
  static const List<double> _fade = <double>[1, 0.6, 0.25];

  CatalogueItem _at(int offset) => heroTour[(_index + offset) % heroTour.length];

  void _step(int by) {
    if (by == 0) return;
    _bounceDir = by.sign.toDouble();
    _bounce.forward(from: 0);
    final Duration moved = _select((_index + by) % heroTour.length);
    _schedule(moved + _idle);
  }

  /// Returns how long the plate takes to change over.
  Duration _select(int index) {
    if (index == _index) return Duration.zero;
    final PlateSpec next = heroTour[index].entry.spec;
    final Duration length = _transitionLength(_item.entry.spec, next);
    final List<String?> carried = carryValues(_plate.values, next);
    _selecting = true;
    setState(() {
      _index = index;
      _labelVisible = false;
      _plate.adoptSpec(next, preserve: PlateValuePreservation.none);
      _plate.setValues(carried);
    });
    _selecting = false;
    _labelSwap?.cancel();
    _labelSwap = Timer(length ~/ 2, () {
      if (!mounted) return;
      setState(() {
        _labelItem = _item;
        _labelVisible = true;
      });
    });
    return length;
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final CatalogueItem item = _item;
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(PdRadius.stage),
        border: Border.all(color: t.divider),
      ),
      padding: EdgeInsets.all(pdClamp(context, 20, 3, 32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _labelVisible ? 1 : 0,
                  child: Text(
                    '${_labelItem.source.countryName} · '
                    '${_labelItem.entry.label}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: t.muted),
                  ),
                ),
              ),
              Text('Tap the plate and type', style: TextStyle(fontSize: 12, color: t.subtle)),
            ],
          ),
          const SizedBox(height: 18),
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _schedule(_idle),
            onPointerUp: (_) => _schedule(_idle),
            child: LivePlate(
              controller: _plate,
              validName: validNameOf(item),
              theme: item.entry.themeFor(_plate.values),
              country: item.entry.country,
              validator: item.entry.validator,
              inputSource: PlateInputSource.keypadFirst,
              fixedSize: true,
              keypadBelow: SizedBox(
                height: kHeroKeypadHeight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: SizedBox(width: 320, child: SlotKeypad(controller: _plate)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              PdLink('← Previous', onTap: () => _step(-1)),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedBuilder(
                  animation: _bounce,
                  builder: (BuildContext context, Widget? child) => Transform.translate(
                    offset: Offset(
                      _bounceDir * -28 * (1 - Curves.elasticOut.transform(_bounce.value)),
                      0,
                    ),
                    child: child,
                  ),
                  child: ClipRect(
                    child: OverflowBox(
                      maxWidth: double.infinity,
                      fit: OverflowBoxFit.deferToChild,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (int o = -_reach; o <= _reach; o++) ...<Widget>[
                            if (o > -_reach) const SizedBox(width: 6),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _fade[o.abs()],
                              child: CountryChip(
                                label: _at(o).source.countryName,
                                selected: o == 0,
                                onTap: () => _step(o),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PdLink('Next →', onTap: () => _step(1)),
            ],
          ),
        ],
      ),
    );
  }
}

class CountryChip extends StatelessWidget {
  const CountryChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      selected: selected,
      width: 112,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: selected ? t.accentSoft : null,
      hoverColor: selected ? t.accentSoft : t.hover,
      border: selected ? t.accent : t.divider,
      child: Center(
        child: Text(
          label,
          maxLines: 3,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? t.text : t.muted,
          ),
        ),
      ),
    );
  }
}
