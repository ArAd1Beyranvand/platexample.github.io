import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';

import '../catalogue.dart';
import '../theme/tokens.dart';

/// The lit backdrop a plate is shown against.
///
/// The single most consequential change in the redesign. The old catalogue
/// drew every plate 74 logical pixels tall and let its width fall out of the
/// aspect ratio, so a Yemeni car plate (3.5:1) came out a thin strip and a
/// two-line Palestinian one (nearly 1:1) came out a stamp, and the two sat
/// side by side at wildly different visual weights in the same row.
///
/// Here the *frame* is the fixed thing and the plate is fitted inside it, so
/// every tile in a grid is the same size and shape whatever it contains — the
/// mounting board, not the artefact, is what lines up. The plate keeps its
/// true proportions; it just no longer dictates the layout.
class PlateFrame extends StatelessWidget {
  const PlateFrame({super.key, required this.spec, required this.child, this.padding = Gap.md});

  final PlateSpec spec;

  /// The `PlateView` (or canvas) that draws the plate itself.
  final Widget child;

  final double padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Radii.mdAll,
        // Top-lit, very slightly: enough to read as a surface with a light
        // source rather than a flat swatch, not enough to notice.
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[colors.surfaceContainerHigh, colors.surfaceContainer],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: DecoratedBox(
            // The plate sits *on* the board rather than in it. Plates are
            // physical objects and the shadow is most of what says so.
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: FittedBox(
              // contain, not fill: a plate drawn at the wrong aspect ratio is
              // a different plate.
              fit: BoxFit.contain,
              child: SizedBox(width: spec.canvasWidth, height: spec.canvasHeight, child: child),
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
/// screen — which is what lets the browse screen hold the whole catalogue at
/// once without dropping frames.
class PlateSliverGrid extends StatelessWidget {
  const PlateSliverGrid({super.key, required this.itemCount, required this.itemBuilder, this.stageHeight = 112});

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double stageHeight;

  @override
  Widget build(BuildContext context) => SliverGrid(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 300,
      mainAxisSpacing: Gap.lg,
      crossAxisSpacing: Gap.md,
      // Fixed, not an aspect ratio: the tile is a frame of known height plus
      // two lines of text, and that total does not scale with column width.
      mainAxisExtent: stageHeight + 56,
    ),
    delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
  );
}

/// One plate in a grid or a shelf: the framed plate, its name, and one line
/// of small print.
class PlateTile extends StatefulWidget {
  const PlateTile({
    super.key,
    required this.entry,
    required this.heroTag,
    this.onTap,
    this.stageHeight = 112,
    this.subtitle,
  });

  final GalleryEntry entry;

  /// Unique *per screen*, not per entry: the same plate appears on the
  /// discover shelf and in the browse grid, and both are alive at once inside
  /// the shell's [IndexedStack]. Two heroes sharing a tag in one subtree is
  /// an error, so callers prefix with the screen's name.
  final String heroTag;

  final VoidCallback? onTap;
  final double stageHeight;

  /// Overrides the small print, which is otherwise the entry's note or the
  /// spec id. The browse grid uses it to name the country, which in that
  /// context is the thing you cannot otherwise tell.
  final String? subtitle;

  @override
  State<PlateTile> createState() => _PlateTileState();
}

class _PlateTileState extends State<PlateTile> {
  /// Scoped to this tile: one controller shared down a grid would show the
  /// same characters on every plate in it.
  late final PlateController _plate = PlateController(spec: widget.entry.spec, values: widget.entry.sampleValues);

  bool _pressed = false;

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final GalleryEntry entry = widget.entry;
    return Semantics(
      button: widget.onTap != null,
      label: entry.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          // The whole tile gives under the finger. Cheap, and it makes a wall
          // of static artefacts feel like a set of controls.
          scale: _pressed ? 0.97 : 1,
          duration: Motion.fast,
          curve: Motion.curve,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: widget.stageHeight,
                width: double.infinity,
                child: Hero(
                  tag: widget.heroTag,
                  child: PlateFrame(
                    spec: entry.spec,
                    child: PlateView(controller: _plate, theme: entry.themeFor(_plate.values), country: entry.country),
                  ),
                ),
              ),
              const SizedBox(height: Gap.sm),
              Text(entry.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
              Text(
                widget.subtitle ?? entry.note ?? entry.spec.id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
