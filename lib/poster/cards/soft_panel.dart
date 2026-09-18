import 'package:flutter/material.dart';

import '../poster_scale.dart';
import '../poster_tokens.dart';

/// A friendly, "app UI" alternative to [BevelPanel] for the callout cards:
/// rounded corners, a soft layered drop shadow and a faint glass highlight
/// instead of the industrial hard-offset shadow / bevel / screw stack.
///
/// Kept deliberately simple — no grain, no sheen, no screws — so the cards
/// read like modern product-UI callouts rather than machined plaques.
class SoftPanel extends StatelessWidget {
  const SoftPanel({
    super.key,
    this.groundColor,
    this.groundGradient,
    this.radius = 22,
    this.tintedShadow,
    this.width,
    this.height,
    this.child,
  }) : assert(
         groundColor != null || groundGradient != null,
         'SoftPanel needs a ground: pass groundColor or groundGradient.',
       );

  /// Flat ground colour (hero cards).
  final Color? groundColor;

  /// Gradient ground (steel / dark cards).
  final Gradient? groundGradient;

  /// Corner radius, in DESIGN px.
  final double radius;

  /// Optional colour cast for the ambient shadow — lets hero cards throw a
  /// faint tint of their own ground instead of plain black.
  final Color? tintedShadow;

  /// Panel size in DESIGN px. Null means "size to the child".
  final double? width;
  final double? height;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final metrics = PosterMetrics.of(context);
    final double r = metrics.px(radius);
    final BorderRadius borderRadius = BorderRadius.circular(r);
    final Color ambient = (tintedShadow ?? Colors.black).withValues(alpha: 0.38);
    final Color contact = Colors.black.withValues(alpha: 0.30);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          // Soft, wide ambient shadow — the "it's floating" cue.
          BoxShadow(color: ambient, blurRadius: metrics.px(28), offset: Offset(0, metrics.px(14))),
          // Tighter contact shadow, close under the card.
          BoxShadow(color: contact, blurRadius: metrics.px(6), offset: Offset(0, metrics.px(2))),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: groundColor,
            gradient: groundGradient,
            borderRadius: borderRadius,
            border: Border.all(color: PosterColors.inkDisplay1.withValues(alpha: 0.10), width: metrics.px(1)),
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              SizedBox(
                width: width == null ? null : metrics.px(width!),
                height: height == null ? null : metrics.px(height!),
                child: child ?? const SizedBox.shrink(),
              ),
              // A faint top highlight — the only nod to "sheen" this style
              // keeps, softened into a gentle glass edge.
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[PosterColors.inkDisplay1.withValues(alpha: 0.06), Colors.transparent],
                        stops: const <double>[0.0, 0.30],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
