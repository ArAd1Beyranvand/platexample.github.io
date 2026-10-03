import 'dart:math' as math;
import 'dart:typed_data' show ByteData;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../theme/nocturne.dart';
import '../poster_scale.dart';
import '../poster_tokens.dart';

/// `transform: rotate(-14deg)` — the one angle the whole road shares, on the
/// panel (`Plate Gallery.dc.html` line 87) and on the dash strip (line 88).
const double kRoadDegrees = -14;

const double _kRoadRadians = kRoadDegrees * math.pi / 180;

/// The design's rotated panel, *unrotated*, in the stage's own pixels:
/// `left: -14%; right: -14%; top: 16%; height: 62%`.
///
/// Public because `SweepLight` rakes along this band and clips to it. Inside
/// the frame [roadFrame] sets up, the panel is this rect exactly — axis
/// aligned — which is what lets the sweep clip with a rect instead of a path.
Rect showcasePanelRect(Size stage) {
  return Rect.fromLTWH(
    -0.14 * stage.width,
    0.16 * stage.height,
    1.28 * stage.width,
    0.62 * stage.height,
  );
}

/// Moves [canvas] into the panel's own rotated frame: [kRoadDegrees] about the
/// centre of [showcasePanelRect], which is what CSS's default
/// `transform-origin: 50% 50%` does to the panel div.
///
/// Callers save and restore around this themselves.
void roadFrame(Canvas canvas, Size stage) {
  final Offset pivot = showcasePanelRect(stage).center;
  canvas.translate(pivot.dx, pivot.dy);
  canvas.rotate(_kRoadRadians);
  canvas.translate(-pivot.dx, -pivot.dy);
}

/// The ground behind `01 — Showcase`: the four layers the design paints inside
/// `<section data-screen-label="Showcase">` (`Plate Gallery.dc.html` lines
/// 86–91), bottom-up —
///
///  1. the page ground, `--color-bg`
///  2. the rotated panel, with a hairline of light along each long edge
///  3. the dash strip that runs down the middle of it
///  4. the accent bloom
///  5. the fade that sinks the bottom of the section back into the ground
///
/// — plus the grain the design has no equivalent for, kept from the old poster
/// at a fraction of its opacity. Layer 6, the rake during a device hop, is
/// [sweep]'s: it is painted last, over the grain and under the device stage.
///
/// Everything is measured as a fraction of the stage and drawn in the stage's
/// own pixels. The old road was drawn on a virtual 1920×1080 canvas scaled
/// non-uniformly onto the stage, which is right for a poster whose parts must
/// deform together and wrong here: a non-uniform scale turns the design's one
/// −14° into a different angle at every window aspect, and the panel and the
/// dashes would come apart.
///
/// Below [NBreak.panel] the design has no road at all — its mobile screens are
/// a phone panel over `.pg-app.pg-m`, which is the radial lift of line 47 and
/// a single accent bloom in the top-left corner (line 353). That layout is
/// painted instead, and [sweep] is dropped with the band it would have raked.
class PosterBackdrop extends StatefulWidget {
  const PosterBackdrop({super.key, this.sweep});

  /// The headlight rake of a device hop, painted above every layer here, in
  /// stage coordinates. Ignored in the phone-panel layout.
  final Widget? sweep;

  @override
  State<PosterBackdrop> createState() => _PosterBackdropState();
}

class _PosterBackdropState extends State<PosterBackdrop> {
  ui.Image? _grainA;
  ui.Image? _grainB;

  @override
  void initState() {
    super.initState();
    _loadGrain();
  }

  Future<void> _loadGrain() async {
    final ui.Image a = await _decodeAsset('assets/textures/bg_grain_a.png');
    final ui.Image b = await _decodeAsset('assets/textures/bg_grain_b.png');
    if (!mounted) {
      a.dispose();
      b.dispose();
      return;
    }
    setState(() {
      _grainA = a;
      _grainB = b;
    });
  }

  static Future<ui.Image> _decodeAsset(String key) async {
    final ByteData data = await rootBundle.load(key);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  void dispose() {
    _grainA?.dispose();
    _grainB?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PosterMetrics metrics = PosterMetrics.of(context);
    final bool panelLayout = metrics.size.width < NBreak.panel;

    return SizedBox(
      width: metrics.size.width,
      height: metrics.size.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // The road never changes after the grain decodes, but without a
          // boundary it shares a layer with the sweep above and with every
          // animating sibling in the showcase Stack — so the whole ground, its
          // two grain saveLayers and the panel's rotated frame were being
          // re-rasterised on every frame of every device hop. Retaining them
          // costs one texture and takes all of that off the per-frame path.
          RepaintBoundary(
            child: CustomPaint(
              painter: _BackdropPainter(
                grainA: _grainA,
                grainB: _grainB,
                panelLayout: panelLayout,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          // The rake, on its own boundary so its 1.5s travel never drags the
          // road back into the dirty set.
          if (!panelLayout && widget.sweep != null)
            Positioned.fill(child: RepaintBoundary(child: widget.sweep!)),
        ],
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter({
    required this.grainA,
    required this.grainB,
    required this.panelLayout,
  });

  final ui.Image? grainA;
  final ui.Image? grainB;

  /// The phone-panel presentation: ground and bloom only, no road.
  final bool panelLayout;

  /// The grain tiles, at a fraction of the opacity the old poster gave them.
  /// They sat on a lit road; these sit on near-black, where the same alpha
  /// reads as noise rather than as film. Both are meant to be felt and not
  /// seen — nudge them here, they are the only knob.
  static const double _grainAOpacity = 0.06;
  static const double _grainBOpacity = 0.10;

  /// Tile sizes, in logical px. The design has no grain to take these from;
  /// they are the old poster's design-px sizes, which at the width it was
  /// drawn for were these.
  static const double _grainATile = 256;
  static const double _grainBTile = 320;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final Rect stage = Offset.zero & size;

    // `overflow: hidden` on the wrapper (line 86). The panel and the dash
    // strip both overhang the stage by 14% on each side.
    canvas.save();
    canvas.clipRect(stage);

    _paintGround(canvas, stage);

    if (!panelLayout) {
      _paintPanel(canvas, size);
      _paintRoadDashes(canvas, size);
    }

    _paintAccentBloom(canvas, stage);

    // The design's own fade only exists under the desktop section; the phone
    // panel sinks into the header and bottom bar instead.
    if (!panelLayout) _paintGroundFade(canvas, stage);

    _paintGrain(canvas, stage, grainA, _grainATile, _grainAOpacity);
    _paintGrain(canvas, stage, grainB, _grainBTile, _grainBOpacity);

    canvas.restore();
  }

  /// 1 — `--color-bg`, and on the phone panel the lift `.pg-app.pg-m` carries:
  /// `radial-gradient(120% 100% at 50% 0%, #0d0f16, #050608 60%)` (line 47).
  void _paintGround(Canvas canvas, Rect stage) {
    canvas.drawRect(stage, Paint()..color = PosterColors.pageBlack);
    if (!panelLayout) return;

    _paintRadial(
      canvas,
      centre: Offset(stage.center.dx, stage.top),
      rx: 1.20 * stage.width,
      ry: 1.00 * stage.height,
      colors: <Color>[
        PosterColors.groundLiftCore,
        PosterColors.groundLiftEdge,
        PosterColors.groundLiftEdge,
      ],
      stops: const <double>[0.0, 0.60, 1.0],
    );
  }

  /// 2 — line 87: the panel, `linear-gradient(180deg, …)` down its own axis,
  /// under `box-shadow: 0 -1px 0 …, 0 1px 0 …`. A CSS box-shadow draws behind
  /// its element, so a 1px offset with no blur shows exactly one row of pixels
  /// outside each long edge — a hairline of light on the top, a fainter one
  /// under the bottom.
  void _paintPanel(Canvas canvas, Size size) {
    final Rect panel = showcasePanelRect(size);

    canvas.save();
    roadFrame(canvas, size);

    canvas.drawRect(
      panel,
      Paint()
        ..shader = ui.Gradient.linear(
          panel.topCenter,
          panel.bottomCenter,
          <Color>[
            PosterColors.panelHead,
            PosterColors.panelKnee,
            PosterColors.panelFoot,
          ],
          <double>[0.0, 0.55, 1.0],
        ),
    );
    canvas.drawRect(
      Rect.fromLTWH(panel.left, panel.top - 1, panel.width, 1),
      Paint()..color = PosterColors.panelEdgeTop,
    );
    canvas.drawRect(
      Rect.fromLTWH(panel.left, panel.bottom, panel.width, 1),
      Paint()..color = PosterColors.panelEdgeBottom,
    );

    canvas.restore();
  }

  /// 3 — line 88: a 2px strip at `top: 44%`, spanning the same `-14% … 114%`
  /// as the panel and rotated with it, filled by
  /// `repeating-linear-gradient(to right, … 0 68px, transparent 68px 132px)`.
  ///
  /// Drawn as rects rather than a tiled shader: there are two dozen of them,
  /// and a repeating gradient would have to be phase-anchored to the strip's
  /// left edge by hand anyway.
  void _paintRoadDashes(Canvas canvas, Size size) {
    const double dash = 68;
    const double period = 132;
    const double thickness = 2;

    final double left = -0.14 * size.width;
    final double width = 1.28 * size.width;
    final double top = 0.44 * size.height;
    final Rect strip = Rect.fromLTWH(left, top, width, thickness);

    canvas.save();
    // The strip has its own transform-origin: its centre sits 3% of the stage
    // above the panel's, so it rotates about a different point on the same
    // angle and lands just above the panel's mid-line.
    canvas.translate(strip.center.dx, strip.center.dy);
    canvas.rotate(_kRoadRadians);
    canvas.translate(-strip.center.dx, -strip.center.dy);

    final Paint paint = Paint()..color = PosterColors.roadStripe;
    for (double x = left; x < left + width; x += period) {
      canvas.drawRect(
        Rect.fromLTWH(x, top, math.min(dash, left + width - x), thickness),
        paint,
      );
    }

    canvas.restore();
  }

  /// 4 — the accent bloom: `radial-gradient(70% 52% at 62% 40%, accent 9%,
  /// transparent 74%)` behind the desktop section (line 89), and the
  /// top-left-corner bloom of the phone panel, `95% 62% at 12% 0%` at 16%
  /// (line 353).
  void _paintAccentBloom(Canvas canvas, Rect stage) {
    final Color core = panelLayout
        ? PosterColors.accentBloomPanel
        : PosterColors.accentBloom;
    final Color edge = core.withValues(alpha: 0);

    _paintRadial(
      canvas,
      centre: panelLayout
          ? Offset(0.12 * stage.width, stage.top)
          : Offset(0.62 * stage.width, 0.40 * stage.height),
      rx: (panelLayout ? 0.95 : 0.70) * stage.width,
      ry: (panelLayout ? 0.62 : 0.52) * stage.height,
      colors: <Color>[core, edge, edge],
      stops: <double>[0.0, panelLayout ? 0.72 : 0.74, 1.0],
    );
  }

  /// 5 — line 90: `linear-gradient(180deg, transparent 40%, var(--color-bg)
  /// 96%)`. The stat band's row of the section ends up on flat ground, which
  /// is what every reference render of this screen shows.
  void _paintGroundFade(Canvas canvas, Rect stage) {
    final Color ground = PosterColors.pageBlack;
    canvas.drawRect(
      stage,
      Paint()
        ..shader = ui.Gradient.linear(
          stage.topCenter,
          stage.bottomCenter,
          <Color>[
            ground.withValues(alpha: 0),
            ground.withValues(alpha: 0),
            ground,
            ground,
          ],
          const <double>[0.0, 0.40, 0.96, 1.0],
        ),
    );
  }

  /// A CSS radial gradient: an ellipse [rx] by [ry] about [centre], drawn as a
  /// circle under a one-axis scale so the stops stay evenly spaced.
  void _paintRadial(
    Canvas canvas, {
    required Offset centre,
    required double rx,
    required double ry,
    required List<Color> colors,
    required List<double> stops,
  }) {
    if (rx <= 0 || ry <= 0) return;
    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.scale(1, ry / rx);
    canvas.drawCircle(
      Offset.zero,
      rx,
      Paint()..shader = ui.Gradient.radial(Offset.zero, rx, colors, stops),
    );
    canvas.restore();
  }

  /// A repeating grain tile drawn at [tilePx] logical px a side, at [opacity]
  /// over everything already painted.
  ///
  /// `poster_textures.dart`'s `textureDecoration` cannot be used here: its
  /// `ColorFilter.mode` recolours the tile instead of blending it, and
  /// `DecorationImage` has no blend-against-destination at all. An
  /// `ImageShader` plus a `saveLayer` does both correctly.
  void _paintGrain(
    Canvas canvas,
    Rect rect,
    ui.Image? image,
    double tilePx,
    double opacity,
  ) {
    if (image == null || opacity <= 0) return;
    final Matrix4 tile = Matrix4.identity()
      ..scaleByDouble(tilePx / image.width, tilePx / image.height, 1, 1);
    final ui.ImageShader shader = ui.ImageShader(
      image,
      TileMode.repeated,
      TileMode.repeated,
      tile.storage,
    );
    canvas.saveLayer(
      rect,
      Paint()..color = Color.fromRGBO(255, 255, 255, opacity),
    );
    canvas.drawRect(rect, Paint()..shader = shader);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) {
    return oldDelegate.grainA != grainA ||
        oldDelegate.grainB != grainB ||
        oldDelegate.panelLayout != panelLayout;
  }
}
