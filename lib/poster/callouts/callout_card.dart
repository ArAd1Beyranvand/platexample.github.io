import 'package:flutter/widgets.dart';

import '../../theme/nocturne.dart';
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
  const CalloutCard({super.key, required this.spec, this.style = CalloutStyle.floating});

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
/// when the cards are first built, and nothing ever replays it: the callouts
/// no longer change with the device the stage is showing.
class CalloutRise extends StatelessWidget {
  const CalloutRise({super.key, required this.child});

  final Widget child;

  static const Duration _duration = Duration(milliseconds: 450);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: _duration,
      curve: Curves.ease,
      builder: (BuildContext context, double t, Widget? child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
      ),
      child: child,
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
class CalloutLayer extends StatelessWidget {
  const CalloutLayer({super.key, this.specs = calloutSpecs});

  final List<CalloutSpec> specs;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CalloutRise(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final double height = constraints.maxHeight;
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                for (final CalloutSpec spec in specs)
                  Positioned(
                    left: width * spec.anchorFx,
                    top: height * spec.anchorFy,
                    width: width * spec.widthFx,
                    child: CalloutCard(spec: spec),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// `.pg-feat`: the same three cards as a plain stacked list, `gap: 10px`.
///
/// What the design does with them below the hero breakpoint, where there is no
/// stage beside the text to float over and an absolutely-placed card would
/// land on the headline.
class CalloutList extends StatelessWidget {
  const CalloutList({super.key, this.specs = calloutSpecs, this.padding = EdgeInsets.zero});

  final List<CalloutSpec> specs;

  /// `padding: 0 18px 8px` in the phone panel; the wider stacked hero already
  /// has its own 48px gutter and passes only the 8px bottom.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: CalloutRise(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final CalloutSpec spec in specs) ...<Widget>[
              if (spec != specs.first) const SizedBox(height: 10),
              CalloutCard(spec: spec, style: CalloutStyle.stacked),
            ],
          ],
        ),
      ),
    );
  }
}
