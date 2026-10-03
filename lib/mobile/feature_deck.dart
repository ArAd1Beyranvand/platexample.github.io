import 'package:flutter/material.dart';

import '../../device_preview/device_config.dart';
import '../theme/nocturne.dart';
import 'mobile_tokens.dart';
import 'mono_label.dart';
import 'rolling_numeral.dart';
import 'segmented_progress.dart';

@immutable
class FeatureCard {
  const FeatureCard({required this.label, required this.title});

  final String label;
  final String title;
}

@immutable
class FeatureGroup {
  const FeatureGroup({required this.device, required this.cards});

  final DeviceType device;
  final List<FeatureCard> cards;
}

/// In design order (not `DeviceCycle.order`), three cards per device.
const List<FeatureGroup> featureGroups = <FeatureGroup>[
  FeatureGroup(
    device: DeviceType.mobile,
    cards: <FeatureCard>[
      FeatureCard(
        label: 'KEYPAD',
        title: 'An on-screen pad in the plate\'s own script',
      ),
      FeatureCard(label: 'FOCUS', title: 'Each slot hands off to the next'),
      FeatureCard(label: 'IME', title: 'No system keyboard pops up'),
    ],
  ),
  FeatureGroup(
    device: DeviceType.tablet,
    cards: <FeatureCard>[
      FeatureCard(
        label: 'RULES',
        title: 'Validation marks a bad plate red and never blocks a key',
      ),
      FeatureCard(
        label: 'CONTROLLER',
        title: 'Read and write the value from code',
      ),
      FeatureCard(label: 'STATE', title: 'No provider or bloc required'),
    ],
  ),
  FeatureGroup(
    device: DeviceType.desktop,
    cards: <FeatureCard>[
      FeatureCard(
        label: 'COUNTRIES',
        title: 'One package per country, one widget for all',
      ),
      FeatureCard(label: 'KEYBOARD', title: 'Physical keys type straight in'),
      FeatureCard(
        label: 'SPECS',
        title: 'A new plate is a const, not a widget',
      ),
    ],
  ),
];

/// The device whose group holds flat card index [i].
DeviceType deviceAt(int i) {
  int start = 0;
  for (final FeatureGroup group in featureGroups) {
    start += group.cards.length;
    if (i < start) return group.device;
  }
  return featureGroups.last.device;
}

/// Flat index of the first card in [device]'s group.
int firstIndexOf(DeviceType device) {
  int start = 0;
  for (final FeatureGroup group in featureGroups) {
    if (group.device == device) return start;
    start += group.cards.length;
  }
  return 0;
}

/// Lets the owner of a [FeatureDeck] observe and drive its position.
class FeatureDeckController {
  final ValueNotifier<int> index = ValueNotifier<int>(0);

  /// False holds the dwell at zero, e.g. while the device frame is still
  /// morphing to the current card's device.
  final ValueNotifier<bool> settled = ValueNotifier<bool>(true);

  void Function(int)? _jump;

  void jumpTo(int i) => _jump?.call(i);

  void dispose() {
    index.dispose();
    settled.dispose();
  }
}

/// "What it does": a story deck over [featureGroups] with a 4 s dwell.
class FeatureDeck extends StatefulWidget {
  const FeatureDeck({super.key, this.controller, this.onIndexChanged});

  final FeatureDeckController? controller;
  final ValueChanged<int>? onIndexChanged;

  static const Duration dwell = Duration(seconds: 4);
  static const double _backZone = 0.35;

  @override
  State<FeatureDeck> createState() => _FeatureDeckState();
}

class _FeatureDeckState extends State<FeatureDeck>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _dwell = AnimationController(
    vsync: this,
    duration: FeatureDeck.dwell,
  )..addStatusListener(_onStatus);

  final List<FeatureCard> _cards = <FeatureCard>[
    for (final FeatureGroup group in featureGroups) ...group.cards,
  ];
  final List<int> _groupSizes = <int>[
    for (final FeatureGroup group in featureGroups) group.cards.length,
  ];

  late final FeatureDeckController _own = FeatureDeckController();
  FeatureDeckController get _controller => widget.controller ?? _own;

  int _index = 0;
  bool _held = false;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bind(_controller);
  }

  void _bind(FeatureDeckController c) {
    c._jump = _goTo;
    c.index.value = _index;
    c.settled.addListener(_sync);
  }

  void _unbind(FeatureDeckController c) {
    c._jump = null;
    c.settled.removeListener(_sync);
  }

  @override
  void didUpdateWidget(FeatureDeck old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _unbind(old.controller ?? _own);
      _bind(_controller);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  /// Runs the dwell only while visible, in the foreground, and not held.
  void _sync() {
    final bool run =
        TickerMode.valuesOf(context).enabled &&
        _foreground &&
        !_held &&
        _controller.settled.value;
    if (run && !_dwell.isAnimating) {
      _dwell.forward();
    } else if (!run && _dwell.isAnimating) {
      _dwell.stop();
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _goTo(_index + 1);
  }

  void _goTo(int i) {
    final int n = _cards.length;
    setState(() => _index = (i % n + n) % n);
    _controller.index.value = _index;
    widget.onIndexChanged?.call(_index);
    _dwell.value = 0;
    _sync();
  }

  void _onTap(TapUpDetails d, double width) {
    _goTo(
      d.localPosition.dx > width * FeatureDeck._backZone
          ? _index + 1
          : _index - 1,
    );
  }

  void _hold(bool held) {
    setState(() => _held = held);
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unbind(_controller);
    _dwell.dispose();
    _own.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SegmentedProgress(
          groups: _groupSizes,
          index: _index,
          progress: _dwell,
          onSelect: _goTo,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints box) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (TapUpDetails d) => _onTap(d, box.maxWidth),
              onLongPressStart: (_) => _hold(true),
              onLongPressEnd: (_) => _hold(false),
              onLongPressCancel: () => _hold(false),
              child: _DeckCard(
                index: _index,
                count: _cards.length,
                card: _cards[_index],
                dwell: _dwell,
                paused: _held,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _DeckFooter(index: _index, count: _cards.length),
      ],
    );
  }
}

class _DeckCard extends StatelessWidget {
  const _DeckCard({
    required this.index,
    required this.count,
    required this.card,
    required this.dwell,
    required this.paused,
  });

  final int index;
  final int count;
  final FeatureCard card;
  final Animation<double> dwell;
  final bool paused;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 212),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment(-0.34, -1),
          end: Alignment(0.34, 1),
          colors: <Color>[MobileTokens.n900, MobileTokens.bg],
          stops: <double>[0, 0.7],
        ),
        border: Border.all(color: MobileTokens.n800),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -6,
            bottom: -30,
            child: RollingNumeral(
              value: index + 1,
              count: count,
              dwell: dwell,
              paused: paused,
              style: _numeralStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _AccentMark(),
                Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 290),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: _transition,
                      layoutBuilder: _layout,
                      child: _DeckText(key: ValueKey<int>(index), card: card),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const TextStyle _numeralStyle = TextStyle(
    fontFamily: NType.archivo,
    fontWeight: FontWeight.w700,
    fontSize: 150,
    height: 1,
  );

  static Widget _transition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  static Widget _layout(Widget? current, List<Widget> previous) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[...previous, ?current],
    );
  }
}

/// Short bar with a soft glow; padded so the shadow is never clipped.
class _AccentMark extends StatelessWidget {
  const _AccentMark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14).copyWith(left: 0, top: 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MobileTokens.accent,
          boxShadow: <BoxShadow>[
            BoxShadow(color: MobileTokens.accent, blurRadius: 12),
          ],
        ),
        child: const SizedBox(width: 28, height: 2),
      ),
    );
  }
}

class _DeckText extends StatelessWidget {
  const _DeckText({super.key, required this.card});

  final FeatureCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MonoLabel(card.label, color: MobileTokens.accent300, tone: 95),
        const SizedBox(height: 10),
        Text(
          card.title,
          style: const TextStyle(
            fontFamily: NType.archivo,
            fontWeight: FontWeight.w500,
            fontSize: 26,
            height: 1.08,
            letterSpacing: -0.03 * 26,
            color: MobileTokens.n100,
          ),
        ),
      ],
    );
  }
}

class _DeckFooter extends StatelessWidget {
  const _DeckFooter({required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    String two(int v) => '$v'.padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MonoLabel(
          '${two(index + 1)} / ${two(count)}',
          color: MobileTokens.n600,
          tone: 9,
        ),
        const MonoLabel('Tap to advance', color: MobileTokens.n600, tone: 9),
      ],
    );
  }
}
