import 'package:flutter/widgets.dart';

import '../../device_preview/device_config.dart';
import '../../device_preview/device_transition.dart';
import '../../theme/nocturne.dart';
import '../callout_motion.dart';
import 'callout_data.dart';

/// The type sizes and rhythm of a callout at one of its two presentations.
///
/// Two sets rather than one scaled pair: the design draws these cards twice,
/// once floating over the desktop stage (`Plate Gallery.dc.html` line 140) and
/// once as a stacked `.pg-feat` list in the phone panel (line 419), and it
/// gives each its own sizes. A 16px title is what fits a card a quarter of the
/// stage wide; an 18px one is what the full-width list wants.
@immutable
class CalloutStyle {
  const CalloutStyle({
    required this.title,
    required this.titleHeight,
    required this.body,
    required this.bodyHeight,
    required this.afterKicker,
    required this.afterTitle,
  });

  /// The floating cards: title 16/1.2, body 12/1.4.
  static const CalloutStyle floating = CalloutStyle(
    title: 16,
    titleHeight: 1.2,
    body: 12,
    bodyHeight: 1.4,
    afterKicker: 6,
    afterTitle: 8,
  );

  /// `.pg-feat-card`: title 18/1.22, body 13/1.45.
  static const CalloutStyle stacked = CalloutStyle(
    title: 18,
    titleHeight: 1.22,
    body: 13,
    bodyHeight: 1.45,
    afterKicker: 8,
    afterTitle: 6,
  );

  final double title;
  final double titleHeight;
  final double body;
  final double bodyHeight;
  final double afterKicker;
  final double afterTitle;
}

/// One callout: a hairline panel over a dark diagonal gradient, holding a
/// kicker, a title and an optional paragraph.
///
/// `.pg-feat-card` — `border: 1px n800; radius: lg; padding: 16px 18px;
/// background: linear-gradient(158deg, #1C2233, #0D1017)`. No shadow: the
/// device mockup is what casts one on this page, not the cards.
class CalloutCard extends StatelessWidget {
  const CalloutCard({
    super.key,
    required this.spec,
    this.style = CalloutStyle.floating,
  });

  final CalloutSpec spec;
  final CalloutStyle style;

  /// `linear-gradient(158deg, …)`. CSS measures the gradient line clockwise
  /// from "to top", so 158° points down and slightly right: `(sin θ, -cos θ)`
  /// in a y-down space, taken from `-v` to `+v`.
  static const LinearGradient _ground = LinearGradient(
    begin: Alignment(-0.37, -0.93),
    end: Alignment(0.37, 0.93),
    // Both stops are the CSS's own, not palette entries: they read between
    // N.n800 and N.bg and exist only as the two ends of this gradient.
    colors: <Color>[Color(0xFF1C2233), Color(0xFF0D1017)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: _ground,
        border: Border.all(color: N.n800),
        borderRadius: BorderRadius.circular(NRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            spec.kicker.toUpperCase(),
            style: NType.kicker.copyWith(
              fontSize: 9,
              letterSpacing: 0.10 * 9,
              color: N.accent300,
            ),
          ),
          SizedBox(height: style.afterKicker),
          Text(
            spec.title,
            style: TextStyle(
              fontFamily: NType.archivo,
              fontWeight: FontWeight.w800,
              fontSize: style.title,
              height: style.titleHeight,
              letterSpacing: -0.02 * style.title,
              color: N.n100,
            ),
          ),
          if (spec.body != null) ...<Widget>[
            SizedBox(height: style.afterTitle),
            Text(
              spec.body!,
              style: TextStyle(
                fontFamily: NType.archivo,
                fontSize: style.body,
                height: style.bodyHeight,
                color: N.n400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The design's `pg-rise` entrance: 10px up and transparent, to place and
/// opaque, over 0.45s of `ease`.
///
/// A [TweenAnimationBuilder] rather than a controller because it plays once,
/// when the cards are first built, and nothing replays it. The *set* changing
/// with the device is [CalloutSwap]'s business, and it sits under this widget
/// precisely so a hop does not re-run the rise: the cards arrive by tile, not
/// by sliding up again.
class CalloutRise extends StatefulWidget {
  const CalloutRise({super.key, required this.child});

  final Widget child;

  static const Duration _duration = Duration(milliseconds: 450);

  @override
  State<CalloutRise> createState() => _CalloutRiseState();
}

class _CalloutRiseState extends State<CalloutRise> {
  /// Keeps the set's element — and every [State] under it — alive as the cards
  /// move between the two shapes [build] wraps them in.
  ///
  /// The same reparenting trick [DeviceFrame] needs for the page on the glass,
  /// and it matters more here: everything below this widget is stateful. A
  /// remount on the settling frame would take `_CalloutSwapState` with it — its
  /// controller, its hop counter, its outgoing set — and the three
  /// [TileTransition]s with their [SnapshotController]s. `Widget.canUpdate`
  /// matches on runtime type, so without a key crossing 0.999 throws all of
  /// that away and rebuilds three cards' worth of text on exactly the frame
  /// they are supposed to be crisp and still.
  final GlobalKey _setKey = GlobalKey(debugLabel: 'callout-set');

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: CalloutRise._duration,
      curve: Curves.ease,
      builder: (BuildContext context, double t, Widget? child) {
        // Settled — and the cards spend all but 450ms of their life here. The
        // set is painted straight into the parent's layer: no Opacity, no
        // Transform, no boundary.
        //
        // Leaving the wrappers in at t == 1 is not free, and the cost is the
        // one thing you can see. A boundary that never repaints is a
        // raster-cache candidate and the engine takes it, so the card becomes a
        // texture and its text — which is the whole card — comes back soft; the
        // Opacity above it adds a saveLayer for an alpha of 255. Both go away
        // the moment the rise is over.
        if (t >= 0.999) return KeyedSubtree(key: _setKey, child: child!);
        // Mid-rise, and deliberately NO `t <= 0.001` branch dropping the child:
        // swapping the set out for a SizedBox at the bottom end would unmount
        // it and land the whole inflate — three cards, their text, the swap
        // controller — on the first frame it comes back. Opacity paints nothing
        // at all at alpha 0, so staying mounted through the bottom of the rise
        // costs layout and no raster.
        //
        // The boundary is what makes the 27 frames between the ends cheap: with
        // a composited child RenderOpacity blends a cached texture, instead of
        // re-rasterising three cards into a saveLayer every frame. The
        // translate sits above it, so the offset moves the cached layer rather
        // than dirtying it.
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - t)),
            child: RepaintBoundary(
              child: KeyedSubtree(key: _setKey, child: child!),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Wraps the card at [index] of a set in its own tile transition.
///
/// Per card rather than per set, which is where this differs from the code
/// sk23.5 restores. The floating layer is a [Stack] the cards hang *outside*
/// — the top one clears the stage's top edge, the bottom one its bottom edge —
/// and a snapshot of that stack would rasterise its own box and clip both of
/// them on the frame the hop starts. A snapshot per card has no outside to
/// lose, and it gives the tiles the card's aspect to be square against rather
/// than the whole stage's.
typedef CalloutTiler = Widget Function(int index, Widget card);

/// Swaps one device's callout set for the next one's, by tile.
///
/// The set does not cross-fade and it does not travel: the outgoing set comes
/// apart into tiles where it stands over the first half of the hop, the set
/// flips at the crossover, and the incoming set assembles from tiles over the
/// second half. Restored with [TileTransition] in sk23.5.
///
/// Timed off [DeviceTransitionDurations.total] rather than off the frame
/// morph. The morph is 1100ms and the cards read as prose — a sentence cannot
/// be taken apart and put back inside it. Running the full hop instead also
/// gets the guarantee that matters: the exit window closes and the entry one
/// opens around the crossover, so the cards are never mid-tile while the
/// device is sitting still.
class CalloutSwap extends StatefulWidget {
  const CalloutSwap({super.key, required this.device, required this.builder});

  /// The device the stage is showing. Changing it starts a swap — which covers
  /// the auto-cycle and the segmented control identically, since a pin reaches
  /// this widget as the same changed value.
  final DeviceType device;

  /// Builds one set, wrapping each card in the `tile` it is handed.
  ///
  /// Called once per phase — three times a hop — never per frame:
  /// [TileTransition] repaints from its own snapshot without rebuilding
  /// anything underneath it, so no text is laid out and no card is measured
  /// while the tiles are moving.
  final Widget Function(
    BuildContext context,
    List<CalloutSpec> specs,
    CalloutTiler tile,
  )
  builder;

  @override
  State<CalloutSwap> createState() => _CalloutSwapState();
}

class _CalloutSwapState extends State<CalloutSwap>
    with SingleTickerProviderStateMixin {
  /// The whole hop, so the two tile windows bracket the device's own fade-out
  /// and fade-in.
  static final Duration _swap = const DeviceTransitionDurations().total;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _swap,
  );

  /// Exit closes just before the midpoint and entry opens just after, leaving
  /// a beat of nothing at the crossover — the callouts' own [blankHold].
  late final Animation<double> _exit = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.46),
  );
  late final Animation<double> _entry = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.54, 1),
  );

  /// The device being tiled away, or null at rest.
  DeviceType? _outgoing;

  /// Which half of the hop is showing. Flips exactly once per hop.
  bool _showingOutgoing = false;

  /// Counts hops, so the tiles reseed their per-tile clocks each time instead
  /// of taking the set apart in the same order every lap of the cycle.
  int _hop = 0;

  @override
  void initState() {
    super.initState();
    _controller
      ..addListener(_onTick)
      ..addStatusListener(_onStatus);
  }

  /// The only per-frame work this widget does, and it rebuilds on one frame of
  /// the hop: the crossover.
  void _onTick() {
    if (_outgoing == null) return;
    final bool showing = _controller.value < 0.5;
    if (showing != _showingOutgoing) setState(() => _showingOutgoing = showing);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _outgoing != null) {
      setState(() => _outgoing = null);
    }
  }

  @override
  void didUpdateWidget(covariant CalloutSwap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device != widget.device) {
      // Assigned rather than `setState`: this runs inside the parent's own
      // rebuild, which rebuilds this widget the moment it returns, and
      // markNeedsBuild during build is an assertion failure.
      _outgoing = oldWidget.device;
      _showingOutgoing = true;
      _hop++;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hopping = _outgoing != null;
    final DeviceType shown = _showingOutgoing ? _outgoing! : widget.device;
    // At rest the animation is the entry window at its end — value 1, every
    // tile opaque — so [enabled] is all that separates tiling from settled.
    final Animation<double> phase = _showingOutgoing ? _exit : _entry;
    return widget.builder(
      context,
      calloutSetFor(shown),
      (int index, Widget card) => TileTransition(
        animation: phase,
        entering: !_showingOutgoing,
        enabled: hopping,
        // Offset per card as well as per hop, so the three do not come apart
        // in lockstep.
        seed: _hop * 9 + index,
        child: card,
      ),
    );
  }
}

/// The three cards floating over the device stage, each placed by its
/// fractions of this box — the design's `position: absolute; left: {{c.x}}%`.
///
/// Unclipped on purpose: the top card hangs a little above the stage and the
/// bottom one below it, exactly as the reference render has them. Also
/// non-interactive — the stage underneath carries a live keypad and a laptop
/// deck, and a decorative card must not eat their taps.
///
/// The [LayoutBuilder] sits *above* [CalloutSwap] so the stage's box is
/// measured when the window changes, not on each of the three phases of a hop.
class CalloutLayer extends StatelessWidget {
  const CalloutLayer({super.key, required this.device});

  /// Which set to show. See [CalloutSwap].
  final DeviceType device;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CalloutRise(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            return CalloutSwap(
              device: device,
              builder:
                  (
                    BuildContext context,
                    List<CalloutSpec> specs,
                    CalloutTiler tile,
                  ) => Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      for (final (int i, CalloutSpec spec) in specs.indexed)
                        Positioned(
                          left: width * spec.anchorFx,
                          top: height * spec.anchorFy,
                          width: width * spec.widthFx,
                          child: tile(i, CalloutCard(spec: spec)),
                        ),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }
}

/// `.pg-feat`: the current device's three cards.
///
/// What the design does with them below the hero breakpoint, where there is no
/// stage beside the text to float over and an absolutely-placed card would
/// land on the headline. The stage is still hopping underneath, so the set
/// swaps by tile here exactly as it does floating — this is the presentation
/// MOBILE VIEW gets, and it would be the one place the effect went missing.
///
/// Layout: two small cards side-by-side on top, one larger card below.
class CalloutList extends StatelessWidget {
  const CalloutList({
    super.key,
    required this.device,
    this.padding = EdgeInsets.zero,
  });

  /// Which set to show. See [CalloutSwap].
  final DeviceType device;

  /// `padding: 0 18px 8px` in the phone panel; the wider stacked hero already
  /// has its own 48px gutter and passes only the 8px bottom.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CalloutRise(
        child: CalloutSwap(
          device: device,
          builder:
              (
                BuildContext context,
                List<CalloutSpec> specs,
                CalloutTiler tile,
              ) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final (int i, CalloutSpec spec)
                      in specs.indexed) ...<Widget>[
                    if (i > 0) const SizedBox(height: 10),
                    tile(
                      i,
                      CalloutCard(spec: spec, style: CalloutStyle.stacked),
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
