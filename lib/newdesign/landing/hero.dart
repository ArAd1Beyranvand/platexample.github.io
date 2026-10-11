import 'dart:async';

import 'package:flutter/material.dart';
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
    ('Iran', IranPlates.car),
    ('Yemen', YemenUnifiedPlates.car5),
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
      if (playgroundItems
              .where((CatalogueItem i) => identical(i.source, country))
              .firstOrNull
          case final CatalogueItem item)
        item,
  ];
  final int start = tour.indexWhere(
    (CatalogueItem i) => identical(i.source, heroPlates.first.$2.source),
  );
  return start <= 0
      ? tour
      : <CatalogueItem>[...tour.sublist(start), ...tour.sublist(0, start)];
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
              onTap: () =>
                  nav.go(const PdLocation.landing(LandingAnchor.start)),
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

class _StageState extends State<_Stage> {
  int _index = 0;
  late final PlateController _plate = PlateController(
    spec: heroTour.first.entry.spec,
  );

  /// Index into [heroTour].
  CatalogueItem get _item => heroTour[_index];

  /// How long each plate shows before the next one staggers in.
  static const Duration _dwell = Duration(seconds: 5);

  /// How long autoplay waits after the user touches the plate or keypad.
  static const Duration _idle = Duration(seconds: 10);

  Timer? _autoplay;

  @override
  void initState() {
    super.initState();
    _schedule(_dwell);
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _plate.dispose();
    super.dispose();
  }

  void _schedule(Duration after) {
    _autoplay?.cancel();
    _autoplay = Timer(after, () {
      if (!mounted) return;
      _select((_index + 1) % heroTour.length);
      _schedule(_dwell);
    });
  }

  void _select(int index) {
    if (index == _index) return;
    final PlateSpec next = heroTour[index].entry.spec;
    final List<String?> carried = carryValues(_plate.values, next);
    setState(() {
      _index = index;
      _plate.adoptSpec(next, preserve: PlateValuePreservation.none);
      _plate.setValues(carried);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
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
                child: Text(
                  '${item.source.countryName} · ${item.entry.label}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: t.muted,
                  ),
                ),
              ),
              Text(
                'Tap the plate and type',
                style: TextStyle(fontSize: 12, color: t.subtle),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Listener(
            onPointerDown: (_) => _schedule(_idle),
            child: LivePlate(
              controller: _plate,
              validName: validNameOf(item),
              theme: item.entry.themeFor(_plate.values),
              country: item.entry.country,
              validator: item.entry.validator,
              inputSource: PlateInputSource.packageKeypad,
              fixedSize: true,
              keypadBelow: SizedBox(
                height: kHeroKeypadHeight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 320,
                    child: SlotKeypad(controller: _plate),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              for (int i = 0; i < heroPlates.length; i++)
                CountryChip(
                  label: heroPlates[i].$1,
                  selected: identical(heroPlates[i].$2.source, _item.source),
                  onTap: () {
                    final int at = heroTour.indexWhere(
                      (CatalogueItem t) =>
                          identical(t.source, heroPlates[i].$2.source),
                    );
                    if (at >= 0) _select(at);
                    _schedule(_idle);
                  },
                ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: PdLink(
                  'All ${plateCountries.length} →',
                  onTap: () =>
                      nav.go(const PdLocation.landing(LandingAnchor.coverage)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CountryChip extends StatelessWidget {
  const CountryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      selected: selected,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: selected ? t.accentSoft : null,
      hoverColor: selected ? t.accentSoft : t.raised,
      border: selected ? t.accent : t.divider,
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
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
