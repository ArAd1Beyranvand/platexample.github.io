import 'dart:async';

import 'package:plate_core/core_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../showcase/plate_typist.dart';
import '../../../theme/nocturne.dart';
import '../catalogue.dart';
import 'plate_binding.dart';

/// The stage a plate stands on inside a card.
///
/// Was a lit board with its own gradient fill, from the pass before Nocturne:
/// a surface inside a surface, which on a dark card read as a second card. The
/// design draws no board at all (`Plate Gallery.dc.html`, the `.pg-group`
/// plate row) — the plate is dropped straight onto the card's own gradient
/// with `--shadow-md` under it, and the only fill on screen is the plate's.
/// So this is now a stage, not a board: a fixed box the plate is fitted into,
/// and a shadow that says the plate sits *on* the card rather than in it.
///
/// The frame stays the fixed thing. Plates run from 3.5:1 (a Yemeni car) to
/// nearly 1:1 (a two-line Palestinian one); sizing a card off its plate gave
/// a row of cards no two of which were the same height. Here every card in a
/// grid is one size whatever it holds, and the plate keeps its true
/// proportions inside it.
class PlateFrame extends StatelessWidget {
  const PlateFrame({
    super.key,
    required this.spec,
    required this.child,
    this.padding = 0,
  });

  final PlateSpec spec;

  /// The `PlateView` (or canvas) that draws the plate itself.
  final Widget child;

  /// Inset between the stage's box and the plate. Zero by default: the card
  /// around it already carries the design's padding, and a second inset here
  /// only shrinks the plate.
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            // Rounded to the plate's own corner radius, so the shadow does not
            // square off the corners it falls under.
            borderRadius: BorderRadius.circular(NRadius.sm),
            boxShadow: NShadow.mdShadows,
          ),
          child: FittedBox(
            // contain, not fill: a plate drawn at the wrong aspect ratio is a
            // different plate.
            fit: BoxFit.contain,
            child: SizedBox(
              width: spec.canvasWidth,
              height: spec.canvasHeight,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A wall of plates, as many columns as the window affords.
///
/// A real [SliverGrid] with a fixed tile extent, which the old `Wrap`-based
/// grid could not be: it sized every card off its plate's aspect ratio, so
/// tiles had no common height and nothing could be virtualised. Now that
/// [PlateFrame] makes all tiles one size, the grid builds only what is on
/// screen — which is what lets a grid hold a whole country's catalogue at
/// once without dropping frames.
class PlateSliverGrid extends StatelessWidget {
  const PlateSliverGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.stageHeight = PlateTile.defaultStageHeight,
    this.maxCrossAxisExtent = 420,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double stageHeight;

  /// Passed straight through to [SliverGridDelegateWithMaxCrossAxisExtent] —
  /// a caller on a narrow window shrinks this along with [stageHeight] so
  /// mobile gets smaller tiles rather than one desktop-sized column.
  final double maxCrossAxisExtent;

  @override
  Widget build(BuildContext context) => SliverGrid(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: maxCrossAxisExtent,
      mainAxisSpacing: PlateTile.gridGap,
      crossAxisSpacing: PlateTile.gridGap,
      // Fixed, not an aspect ratio: the tile is a stage of known height plus
      // one footer line, and that total does not scale with column width.
      mainAxisExtent: PlateTile.heightFor(stageHeight),
    ),
    delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
  );
}

/// One plate as a card: the plate on its stage, then a divider and a footer
/// naming the livery on the left and the spec id on the right.
///
/// Transcribed from the `.pg-group` plate button in
/// `design_ref/Plate Gallery.dc.html` (lines 201–222): a
/// `surface → n900` gradient behind a 1px `n800` border at `radius-lg`,
/// `22px 20px 16px` of padding, a 20px gap down to an `n800` rule, and under
/// it 13.5px `n200` against 10px MartianMono `n500`. Hover swaps the gradient
/// end for end and takes the border to `accent-700`.
///
/// The plate inside is drawn by the country package through the usual
/// `PlateView` path and is not styled here — the card is the surface the
/// plate sits on, and nothing more.
class PlateTile extends StatefulWidget {
  const PlateTile({
    super.key,
    required this.entry,
    required this.heroTag,
    this.onTap,
    this.stageHeight = defaultStageHeight,
    this.autoReplay = false,
  });

  /// Loops the sample-value replay continuously, independent of hover, so the
  /// card fills itself in over and over without a pointer on it. Hover then
  /// only lifts the card to its lit style; the run keeps going underneath.
  /// The showcase device stage and the country grid both turn this on, so
  /// every tile [SliverGrid] actually builds — i.e. every card on or near
  /// screen — types itself without a pointer.
  final bool autoReplay;

  /// The design's plate row is a modest band inside the card — the plate is
  /// the card's subject, not its whole surface.
  static const double defaultStageHeight = 96;

  /// `gap: 20px` between cards in the design's plate grid.
  static const double gridGap = 20;

  /// Card padding, `22px 20px 16px`.
  static const EdgeInsets padding = EdgeInsets.fromLTRB(20, 22, 20, 16);

  /// Stage to divider.
  static const double _stageToRule = 20;

  /// Divider to footer text.
  static const double _ruleToFooter = 12;

  static const double _footerFontSize = 13.5;

  /// The footer's line box. Pinned rather than left to the two fonts' own
  /// metrics: the label is 13.5px Archivo and the spec id 10px MartianMono,
  /// and whichever of the two happened to be taller would otherwise decide
  /// the card's height — differently on web than on the test fonts.
  static const double _footerLineHeight = 18;

  /// The press give. Hover is instant, as it is on every other Nocturne
  /// control ([NButton] changes colour with no transition at all); only the
  /// scale is animated, because a tile that snaps between two sizes reads as
  /// a glitch rather than as a press.
  static const Duration _pressDuration = Duration(milliseconds: 140);

  /// One card's total height, given its stage. Every part of the card below
  /// the stage is fixed — both footer texts are single-line — so the grid can
  /// pin `mainAxisExtent` instead of measuring.
  ///
  /// The `+ 2` is the card's own 1px border, which a [Container] lays out
  /// inside its box rather than around it.
  static double heightFor(double stageHeight) =>
      padding.vertical +
      2 +
      stageHeight +
      _stageToRule +
      1 +
      _ruleToFooter +
      _footerLineHeight +
      1;

  final GalleryEntry entry;

  /// Unique *per screen*, not per entry: the same plate appears on the
  /// discover index and in a country's grid, and more than one can be alive
  /// at once. Two heroes sharing a tag in one subtree is an error, so callers
  /// prefix with the screen's name.
  final String heroTag;

  final VoidCallback? onTap;
  final double stageHeight;

  @override
  State<PlateTile> createState() => _PlateTileState();
}

class _PlateTileState extends State<PlateTile> {
  /// Scoped to this tile: one controller shared down a grid would show the
  /// same characters on every plate in it.
  late final PlateController _plate = PlateController(
    spec: widget.entry.spec,
    values: widget.entry.sampleValues,
  );

  /// Replays the entry's sample values into [_plate] on hover/focus, so the
  /// card demonstrates the plate filling in the way the showcase's device
  /// stage does — driven off the same generic [scriptFromValues] rather than a
  /// hand-authored script, which is what lets *any* discover plate auto-type.
  final PlateTypist _typist = PlateTypist();

  bool _pressed = false;
  bool _hovered = false;

  /// True while the [autoReplay] loop is meant to keep running. Cleared on
  /// dispose so a pending gap between passes doesn't restart a torn-down tile.
  bool _looping = false;

  /// The hold between passes, in flight. Tracked (rather than a bare
  /// `Future.delayed`) so [dispose] can cancel the real [Timer] underneath —
  /// otherwise a torn-down tile leaves one ticking for up to its own length,
  /// which widget tests that assert no timers survive teardown catch on the
  /// very first grid of auto-replaying cards.
  Timer? _holdTimer;
  Completer<bool>? _holdCompleter;

  @override
  void initState() {
    super.initState();
    if (widget.autoReplay && _canReplay) {
      // The replay opens no modal here (useLetterPicker is false), but it still
      // reads context and drives controllers, so wait for the first layout.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _looping = true;
        _loopReplay();
      });
    }
  }

  @override
  void dispose() {
    _looping = false;
    _holdTimer?.cancel();
    final holdCompleter = _holdCompleter;
    if (holdCompleter != null && !holdCompleter.isCompleted)
      holdCompleter.complete(false);
    _typist.dispose();
    _plate.dispose();
    super.dispose();
  }

  /// Runs the sample replay end to end, then, after a beat, again — forever,
  /// until the tile is disposed. Each pass clears and re-types from scratch, so
  /// the card is seen filling in rather than sitting full.
  Future<void> _loopReplay() async {
    while (_looping && mounted) {
      if (!context.mounted) break;
      final BuildContext ctx = context;
      _plate.clear();
      await _typist.run(
        spec: widget.entry.spec,
        controller: _plate,
        steps: scriptFromValues(
          spec: widget.entry.spec,
          values: widget.entry.sampleValues!,
        ),
        useLetterPicker: false,
        context: ctx,
      );
      if (!_looping || !mounted) break;
      // Hold on the completed plate before wiping it and starting over.
      if (!await _hold(const Duration(milliseconds: 1400))) break;
    }
  }

  /// Awaits [d], returning false immediately if [dispose] cancels it first.
  Future<bool> _hold(Duration d) {
    final completer = Completer<bool>();
    _holdCompleter = completer;
    _holdTimer = Timer(d, () {
      _holdTimer = null;
      if (!completer.isCompleted) completer.complete(true);
    });
    return completer.future;
  }

  /// True once the entry has values worth replaying. A plate with no sample
  /// (or only printed constants) has nothing to type, so hover leaves it be.
  bool get _canReplay {
    final values = widget.entry.sampleValues;
    return values != null && values.any((v) => v != null && v.isNotEmpty);
  }

  /// Clears the plate and auto-types its sample values. A no-op if a run is
  /// already going, so re-entering hover mid-run doesn't restart it.
  Future<void> _startReplay() async {
    if (!_canReplay || _typist.isRunning) return;
    _plate.clear();
    await _typist.run(
      spec: widget.entry.spec,
      controller: _plate,
      steps: scriptFromValues(
        spec: widget.entry.spec,
        values: widget.entry.sampleValues!,
      ),
      // No picker and no keypad: a grid of tiles must never raise a modal or an
      // IME, so letters land straight on the controller like digits.
      useLetterPicker: false,
      context: context,
    );
  }

  /// Stops any run and restores the resting sample so the card doesn't sit
  /// half-typed once the pointer leaves.
  void _stopReplay() {
    if (!_canReplay) return;
    _typist.cancel();
    _plate.setValues(widget.entry.sampleValues!);
  }

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    // In auto-replay the run is already looping on its own — hover only lifts
    // the card to its lit style and must not restart or stop the typing.
    if (widget.autoReplay) return;
    if (value) {
      _startReplay();
    } else {
      _stopReplay();
    }
  }

  /// The design's `{{ p.label }}`: the entry's name, and the note where it has
  /// one — `2012 · colour read from the plate`.
  String get _label {
    final String? note = widget.entry.note;
    return note == null ? widget.entry.label : '${widget.entry.label} · $note';
  }

  bool get _lit => _hovered || _pressed;

  @override
  Widget build(BuildContext context) {
    final GalleryEntry entry = widget.entry;
    return Semantics(
      button: widget.onTap != null,
      label: entry.label,
      child: FocusableActionDetector(
        mouseCursor: widget.onTap == null
            ? MouseCursor.defer
            : SystemMouseCursors.click,
        onShowHoverHighlight: _setHovered,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            // The whole card gives under the finger. Cheap, and it makes a
            // wall of static artefacts feel like a set of controls.
            scale: _pressed ? 0.98 : 1,
            duration: PlateTile._pressDuration,
            curve: Curves.easeOutCubic,
            child: Container(
              padding: PlateTile.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(NRadius.lg),
                border: Border.all(color: _lit ? N.accent700 : N.n800),
                // `linear-gradient(180deg, surface, n900)`, end for end on
                // hover — the card lifts towards the light rather than
                // brightening.
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _lit
                      ? const <Color>[N.n900, N.surface]
                      : const <Color>[N.surface, N.n900],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: widget.stageHeight,
                    child: Hero(
                      tag: widget.heroTag,
                      child: PlateFrame(
                        spec: entry.spec,
                        // Bound to the value, not read once at build: an entry
                        // whose livery is a fact about its digits (Gaza reads
                        // its usage class off its own last two) recolours as
                        // the hover replay types, since the tile itself does
                        // not rebuild on each keystroke.
                        child: PlateBinding<PlateTheme?>(
                          controller: _plate,
                          select: (c) => entry.themeFor(c.values),
                          builder: (context, theme) => PlateView(
                            controller: _plate,
                            theme: theme,
                            country: entry.country,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: PlateTile._stageToRule),
                  Container(height: 1, color: N.n800),
                  const SizedBox(height: PlateTile._ruleToFooter),
                  // The design aligns these two on their baselines. Centred
                  // instead, because both carry the same pinned line box and
                  // baseline alignment makes the row as tall as the deepest
                  // descender of *either* font — a height the card cannot know
                  // in advance and the grid has already committed to.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: NType.archivo,
                            fontSize: PlateTile._footerFontSize,
                            height:
                                PlateTile._footerLineHeight /
                                PlateTile._footerFontSize,
                            color: N.n200,
                          ),
                        ),
                      ),
                      const SizedBox(width: NSpace.s4),
                      Text(
                        entry.spec.id,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: NType.specId.copyWith(
                          fontSize: 10,
                          letterSpacing: 0.04 * 10,
                          height: PlateTile._footerLineHeight / 10,
                          color: N.n500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
