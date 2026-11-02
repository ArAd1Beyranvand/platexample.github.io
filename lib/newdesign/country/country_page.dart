import 'dart:async';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:plate_core/plate_core.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/country_meta.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../landing/text_styles.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
import '../embed/language_tabs.dart';
import 'breadcrumb.dart';
import 'swap.dart';

/// One country's plate types: the list on the left, the selected type's
/// facts on the right.
///
/// The types are the country's own catalogue items and their categories are
/// the section titles the packages already group them under — nothing here is
/// a second list of plates to keep in step with the sources.
class CountryPage extends StatefulWidget {
  const CountryPage({super.key, required this.source, this.lang});

  final GallerySource source;

  /// The language tab from the URL; null is the in-app Flutter page.
  final String? lang;

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> with SingleTickerProviderStateMixin {
  /// Drives every swap on the page; a new [_wave] starts each country change.
  late final AnimationController _clock =
      AnimationController(vsync: this, value: 1, duration: PdSwapScope.span(PdSwap.maxOrder))
        ..addStatusListener((AnimationStatus s) {
          if (s == AnimationStatus.completed && _rowsKept > 0) setState(() => _rowsKept = 0);
        });
  int _wave = 0;

  void _startWave() {
    _wave++;
    if (MediaQuery.disableAnimationsOf(context)) {
      _clock.value = 1;
      _rowsKept = 0;
    } else {
      _clock.forward(from: 0);
    }
  }

  /// Null until the user picks one, so the first visible row leads.
  CatalogueItem? _selected;

  final ScrollController _scroll = ScrollController();

  /// Bumped once a picked row has scrolled the playground button into view,
  /// which replays its beckon.
  int _beckon = 0;

  /// The latest pick still scrolling; the detail's plate holds the old type
  /// until it lands, so it staggers over in view.
  int _picks = 0;
  bool _scrolling = false;

  Future<void> _pick(CatalogueItem item) async {
    final int pick = ++_picks;
    setState(() {
      _selected = item;
      _scrolling = true;
      _startWave();
    });
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || pick != _picks) return;
    if (!_scroll.hasClients) {
      setState(() => _scrolling = false);
      return;
    }
    final Duration d = PdMotion.of(context, const Duration(milliseconds: 450));
    final double end = _scroll.position.maxScrollExtent;
    // Side by side (see the PdAutoGrid below) the detail is already in view.
    final double pad = pdClamp(context, 16, 3, 32);
    final double content = (MediaQuery.sizeOf(context).width - 2 * pad).clamp(0, 1200);
    if (content >= 2 * 380 + 24) {
      setState(() {
        _scrolling = false;
        _beckon++;
      });
      return;
    }
    if (d == Duration.zero) {
      _scroll.jumpTo(end);
    } else if (_scroll.offset < end) {
      await _scroll.animateTo(end, duration: d, curve: Curves.easeInOutCubic);
    }
    if (!mounted || pick != _picks) return;
    setState(() {
      _scrolling = false;
      _beckon++;
    });
  }

  @override
  void didUpdateWidget(CountryPage old) {
    super.didUpdateWidget(old);
    if (identical(old.source, widget.source)) return;
    _selected = null;
    _picks++;
    _scrolling = false;
    // The old country's extra rows stay mounted long enough to stagger out.
    _rowsKept = _itemsOf(old.source).length;
    _startWave();
  }

  /// Rows the previous country had, kept while its extras stagger out.
  int _rowsKept = 0;

  @override
  void dispose() {
    _scroll.dispose();
    _clock.dispose();
    super.dispose();
  }

  List<CatalogueItem> get _items => _itemsOf(widget.source);

  static List<CatalogueItem> _itemsOf(GallerySource source) => <CatalogueItem>[
    for (final CatalogueItem item in catalogueItems)
      if (identical(item.source, source)) item,
  ];

  @override
  Widget build(BuildContext context) {
    final PdNav nav = PdNav.of(context);
    final GallerySource source = widget.source;
    final List<CatalogueItem> items = _items;

    final List<CatalogueItem> shown = items;
    final CatalogueItem? selected = shown.contains(_selected)
        ? _selected
        : (shown.isNotEmpty ? shown.first : null);

    final GallerySource? region = regionOf(source);
    final (String iso, String native) = (
      countryMeta[source.countryName]?.$1 ?? '',
      countryMeta[source.countryName]?.$2 ?? '',
    );

    final double viewport = MediaQuery.sizeOf(context).width;
    final bool sidePager = viewport >= 1700;
    Widget row(int i) {
      final CatalogueItem? item = i < shown.length ? shown[i] : null;
      // A row the other country also has stays put and swaps its insides;
      // only rows one side lacks fade in or out as a whole.
      return PdSwap(
        id: item != null,
        order: 3 + i.clamp(0, 10),
        child: item == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _TypeRow(
                  item: item,
                  order: 3 + i.clamp(0, 10),
                  selected: identical(item, selected),
                  onTap: () => _pick(item),
                ),
              ),
      );
    }

    final Widget content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PdBreadcrumb(
            trail: <(String, PdLocation)>[
              ('Countries', const PdLocation.landing(LandingAnchor.coverage)),
              if (region != null) (region.countryName, PdLocation.region(region)),
            ],
            current: source.countryName,
          ),
          const SizedBox(height: 24),
          _Header(source: source, native: native, iso: iso, types: items.length),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          LanguageTabs(
            source: source,
            lang: widget.lang,
            onLang: (String? lang) =>
                Router.neglect(context, () => nav.go(PdLocation.country(source, lang))),
            flutter: PdAutoGrid(
              minWidth: 380,
              gap: 24,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (int i = 0; i < (shown.length > _rowsKept ? shown.length : _rowsKept); i++)
                      row(i),
                  ],
                ),
                if (selected != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _TypeDetail(
                        item: selected,
                        beckon: _beckon,
                        hold: _scrolling,
                        onPlay: () => nav.go(PdLocation.playground(selected)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!sidePager) ...<Widget>[const SizedBox(height: 32), _CountryPager(source: source)],
        ],
      ),
    );

    return PdSwapScope(
      clock: _clock,
      generation: _wave,
      child: ListView(
        controller: _scroll,
        padding: EdgeInsets.only(
          top: 16,
          bottom: 64,
          left: pdClamp(context, 16, 3, 32),
          right: pdClamp(context, 16, 3, 32),
        ),
        children: <Widget>[
          Center(
            child: sidePager
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _SidePager(source: source, forward: false),
                      const SizedBox(width: 24),
                      Flexible(child: content),
                      const SizedBox(width: 24),
                      _SidePager(source: source, forward: true),
                    ],
                  )
                : content,
          ),
        ],
      ),
    );
  }
}

/// Previous / next country in catalogue order, wrapping at the ends. Two
/// cards share the row on narrow viewports; on wide ones they sit at either
/// edge of the content column.
class _CountryPager extends StatelessWidget {
  const _CountryPager({required this.source});

  final GallerySource source;

  @override
  Widget build(BuildContext context) {
    final int i = plateCountries.indexWhere((GallerySource c) => identical(c, source));
    if (i < 0 || plateCountries.length < 2) return const SizedBox.shrink();
    final int n = plateCountries.length;
    final GallerySource prev = plateCountries[(i - 1 + n) % n];
    final GallerySource next = plateCountries[(i + 1) % n];
    final PdNav nav = PdNav.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: _PagerCard(
              target: prev,
              forward: false,
              onTap: () => nav.go(PdLocation.of(prev)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _PagerCard(
              target: next,
              forward: true,
              onTap: () => nav.go(PdLocation.of(next)),
            ),
          ),
        ),
      ],
    );
  }
}

/// One pager card in the margin beside the content on wide viewports.
class _SidePager extends StatelessWidget {
  const _SidePager({required this.source, required this.forward});

  final GallerySource source;
  final bool forward;

  @override
  Widget build(BuildContext context) {
    final int i = plateCountries.indexWhere((GallerySource c) => identical(c, source));
    final int n = plateCountries.length;
    if (i < 0 || n < 2) return const SizedBox.shrink();
    final GallerySource target = plateCountries[(i + (forward ? 1 : n - 1)) % n];
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: _PagerCard(
        target: target,
        forward: forward,
        onTap: () => PdNav.of(context).go(PdLocation.of(target)),
      ),
    );
  }
}

class _PagerCard extends StatelessWidget {
  const _PagerCard({required this.target, required this.forward, required this.onTap});

  final GallerySource target;
  final bool forward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final Widget arrow = Icon(
      forward ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
      size: 20,
      color: t.accent,
    );
    final Widget label = Flexible(
      child: Column(
        crossAxisAlignment: forward ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            forward ? 'Next country' : 'Previous country',
            style: TextStyle(fontSize: 12, color: t.subtle),
          ),
          const SizedBox(height: 2),
          PdSwap(
            id: target,
            child: Text(
              target.countryName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: t.text),
            ),
          ),
        ],
      ),
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: PdTappable(
        onTap: onTap,
        radius: PdRadius.card,
        border: t.divider,
        hoverColor: t.hover,
        semanticLabel: '${forward ? 'Next' : 'Previous'} country: ${target.countryName}',
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: forward
              ? <Widget>[label, const SizedBox(width: 12), arrow]
              : <Widget>[arrow, const SizedBox(width: 12), label],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.source,
    required this.native,
    required this.iso,
    required this.types,
  });

  final GallerySource source;
  final String native;
  final String iso;
  final int types;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final String packages = source.packageNames.join(' ');
    Widget swap(int order, Widget child) => PdSwap(id: source, order: order, child: child);
    return PdAutoGrid(
      minWidth: 340,
      gap: 48,
      rowGap: 16,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                swap(
                  0,
                  Text(
                    source.countryName,
                    style: TextStyle(
                      fontSize: pdClamp(context, 28, 4, 40),
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.02 * pdClamp(context, 28, 4, 40),
                      color: t.text,
                    ),
                  ),
                ),
                swap(
                  1,
                  native.isNotEmpty && native != source.countryName
                      ? Text(
                          native,
                          style: TextStyle(
                            fontFamily: PdFonts.persian,
                            fontSize: 20,
                            color: t.muted,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            swap(
              2,
              Text(
                <String>[
                  '$types plate ${types == 1 ? 'type' : 'types'}',
                  if (iso.isNotEmpty) iso,
                  ...source.packageNames,
                ].join(' · '),
                style: body(t),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: PdInstallBar(
            command: 'flutter pub add plate_core $packages',
            stable: 'flutter pub add plate_core '.length,
            swap: (Widget tail) => swap(1, tail),
          ),
        ),
      ],
    );
  }
}

/// One plate type: its plate at thumbnail width, its label, its section and
/// the spec the developer would name.
class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.item,
    required this.order,
    required this.selected,
    required this.onTap,
  });

  final CatalogueItem item;
  final int order;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PlateSpec spec = item.entry.spec;
    return PdTappable(
      onTap: onTap,
      radius: PdRadius.card,
      selected: selected,
      color: selected ? t.surface : null,
      hoverColor: selected ? null : t.hover,
      border: selected ? t.accent : t.divider,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 132,
            child: _StaggeredPlate(entry: item.entry, hold: false, autoType: true),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PdSwap(
                  id: item,
                  order: order,
                  child: Text(
                    item.entry.label,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.text),
                  ),
                ),
                const SizedBox(height: 2),
                PdSwap(
                  id: item,
                  order: order + 1,
                  child: Text(
                    '${item.section.title} · ${spec.slotCount} slots',
                    style: TextStyle(fontSize: 13, color: t.muted),
                  ),
                ),
                const SizedBox(height: 2),
                PdSwap(
                  id: item,
                  order: order + 2,
                  child: Text(
                    specName(item) ?? spec.id,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: PdFonts.mono, fontSize: 12, color: t.subtle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The selected type at full width, with the facts the playground would
/// otherwise be the only place to read.
class _TypeDetail extends StatelessWidget {
  const _TypeDetail({
    required this.item,
    required this.beckon,
    required this.hold,
    required this.onPlay,
  });

  final CatalogueItem item;
  final int beckon;

  /// Keeps the plate on the previous type while the page scrolls.
  final bool hold;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final GalleryEntry entry = item.entry;
    final PlateSpec spec = entry.spec;
    final String package = packageOf(item);
    final List<(String, String, bool)> facts = <(String, String, bool)>[
      ('Spec', specName(item) ?? spec.id, true),
      ('Slots', slotPattern(spec), false),
      ('Colours', entry.theme == null ? 'Ambient theme' : 'Own livery', false),
      ('Package', package, true),
      ('Route', PdLocation.playground(item).path, true),
    ];
    Widget swap(int order, Widget child) => PdSwap(id: item, order: order, child: child);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(PdRadius.stage),
        border: Border.all(color: t.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          swap(0, Text(item.section.title, style: TextStyle(fontSize: 13, color: t.subtle))),
          const SizedBox(height: 4),
          swap(1, Text(entry.label, style: h3(t).copyWith(fontSize: 20, height: 1.3))),
          const SizedBox(height: 16),
          _StaggeredPlate(entry: entry, hold: hold),
          if (entry.note != null) ...<Widget>[
            const SizedBox(height: 16),
            swap(2, Text(entry.note!, style: body(t, size: 15))),
          ],
          const SizedBox(height: 16),
          for (final (int i, (String k, String v, bool mono)) in facts.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 72,
                    child: Text(k, style: TextStyle(fontSize: 14, color: t.subtle)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PdSwap(
                      id: v,
                      order: 3 + i,
                      child: Text(
                        v,
                        style: mono
                            ? monoStyle(t, size: 13)
                            : TextStyle(fontSize: 14, color: t.text),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: _Beckon(
              trigger: beckon,
              child: PdButton(
                label: 'Try in playground →',
                onTap: onPlay,
                kind: PdButtonKind.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The detail's plate: a new [entry] morphs in place like the landing hero,
/// so identical parts and the background stay still. Waits while [hold] is
/// set.
class _StaggeredPlate extends StatefulWidget {
  const _StaggeredPlate({required this.entry, required this.hold, this.autoType = false});

  final GalleryEntry entry;
  final bool hold;
  final bool autoType;

  @override
  State<_StaggeredPlate> createState() => _StaggeredPlateState();
}

class _StaggeredPlateState extends State<_StaggeredPlate> {
  final PlateAnimationController _anim = PlateAnimationController();
  late GalleryEntry _shown = widget.entry;

  @override
  void didUpdateWidget(_StaggeredPlate old) {
    super.didUpdateWidget(old);
    if (!widget.hold) _shown = widget.entry;
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StaticPlate(
    spec: _shown.spec,
    values: _shown.sampleValues,
    theme: _shown.theme,
    country: _shown.country,
    autoType: widget.autoType,
    animation: _anim,
    specTransition: const PlateSpecTransition(keepIdentical: true, morphBackground: true),
  );
}

/// Each new [trigger] bounces [child] and runs an accent ring around it: the
/// ring grows from one point all the way round, then is erased from that same
/// point in the same direction — the way a plate's border staggers in and out.
class _Beckon extends StatefulWidget {
  const _Beckon({required this.trigger, required this.child});

  final int trigger;
  final Widget child;

  @override
  State<_Beckon> createState() => _BeckonState();
}

class _BeckonState extends State<_Beckon> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  static final Animatable<double> _bounce = TweenSequence<double>(<TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1, end: 1.08).chain(CurveTween(curve: Curves.easeOut)),
      weight: 1,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 1.08, end: 0.97).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 1,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.97, end: 1).chain(CurveTween(curve: Curves.easeOut)),
      weight: 1,
    ),
    TweenSequenceItem<double>(tween: ConstantTween<double>(1), weight: 5),
  ]);

  @override
  void didUpdateWidget(_Beckon old) {
    super.didUpdateWidget(old);
    if (old.trigger == widget.trigger) return;
    if (MediaQuery.disableAnimationsOf(context)) return;
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = context.tokens.accent;
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => Transform.scale(
        scale: _bounce.evaluate(_c),
        child: CustomPaint(
          foregroundPainter: _BeckonRingPainter(progress: _c, color: color),
          child: child,
        ),
      ),
    );
  }
}

class _BeckonRingPainter extends CustomPainter {
  _BeckonRingPainter({required this.progress, required this.color}) : super(repaint: progress);

  final Animation<double> progress;
  final Color color;

  static const double _gap = 3;
  static const double _width = 2;

  /// Where the ring starts, as a fraction of its length clockwise from the
  /// top edge's left end.
  static const double _startPoint = 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress.value;
    if (p <= 0 || p >= 1) return;
    final double head = Curves.easeInOutCubic.transform((p / 0.55).clamp(0.0, 1.0));
    final double tail = Curves.easeInOutCubic.transform(((p - 0.45) / 0.55).clamp(0.0, 1.0));
    if (head <= tail) return;

    final RRect ring = RRect.fromRectAndRadius(
      (Offset.zero & size).inflate(_gap),
      const Radius.circular(PdRadius.card + _gap),
    );
    final PathMetric metric = (Path()..addRRect(ring)).computeMetrics().first;
    final double length = metric.length;
    final double from = (_startPoint + tail) * length % length;
    final double span = (head - tail) * length;
    final Path segment = Path();
    if (from + span <= length) {
      segment.addPath(metric.extractPath(from, from + span), Offset.zero);
    } else {
      segment
        ..addPath(metric.extractPath(from, length), Offset.zero)
        ..addPath(metric.extractPath(0, from + span - length), Offset.zero);
    }
    canvas.drawPath(
      segment,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _width
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_BeckonRingPainter old) => old.progress != progress || old.color != color;
}
