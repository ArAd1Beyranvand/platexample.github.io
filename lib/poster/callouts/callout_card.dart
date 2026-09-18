import 'package:flutter/material.dart';

import '../cards/card_decorations.dart';
import '../cards/dashed_rule.dart';
import '../cards/soft_panel.dart';
import '../poster_scale.dart';
import '../poster_tokens.dart';
import 'callout_data.dart';

class CalloutCard extends StatelessWidget {
  const CalloutCard({super.key, required this.spec, this.widthDesignPx});

  final CalloutSpec spec;
  final double? widthDesignPx;

  /// A faint tint for the card's own drop shadow, so hero cards throw a
  /// shadow that reads as "this card", not just generic black.
  Color? get _shadowTint {
    switch (spec.kind) {
      case CalloutKind.heroIr:
        return PosterColors.cardHeroIr;
      case CalloutKind.heroDe:
        return PosterColors.cardHeroDe;
      case CalloutKind.steel:
      case CalloutKind.dark:
        return null;
    }
  }

  Color? get _groundColor {
    switch (spec.kind) {
      case CalloutKind.heroIr:
        return PosterColors.cardHeroIr;
      case CalloutKind.heroDe:
        return PosterColors.cardHeroDe;
      case CalloutKind.steel:
      case CalloutKind.dark:
        return null;
    }
  }

  Gradient? get _groundGradient {
    switch (spec.kind) {
      case CalloutKind.steel:
      case CalloutKind.dark:
        // Each numbered card gets its own plate-face colour so they don't read
        // as one repeated slab — blues echo the hero cards, 07/08/11 are a
        // green family, 02/03 share a slate tone.
        return PosterGradients.calloutFace(spec.index);
      case CalloutKind.heroIr:
      case CalloutKind.heroDe:
        return null;
    }
  }

  TextStyle _titleStyle(double f) {
    final size = spec.titleSizeDesignPx;
    if (spec.textDirection == TextDirection.rtl) {
      return PosterType.cardTitleFa(f, size);
    }
    switch (spec.kind) {
      case CalloutKind.heroIr:
      case CalloutKind.heroDe:
        if (size >= 40) {
          return PosterType.cardTitleEnHero(f, size);
        } else {
          return PosterType.cardTitleEnSmall(f, size);
        }
      case CalloutKind.steel:
      case CalloutKind.dark:
        return PosterType.cardTitleEnSmall(f, size);
    }
  }

  TextStyle _bodyStyle(double f) {
    if (spec.textDirection == TextDirection.rtl) {
      return PosterType.cardBodyFa(f, spec.bodySizeDesignPx);
    }
    return PosterType.cardBodyEn(f, spec.bodySizeDesignPx);
  }

  Widget _buildEyebrow(PosterMetrics metrics, TextDirection direction) {
    // A soft pill instead of bare tracked-out caps — a small nod to the
    // "chip" pattern common to friendly, modern UI cards.
    return Padding(
      padding: EdgeInsets.only(bottom: metrics.px(12)),
      child: Align(
        alignment: spec.isCentered
            ? Alignment.center
            : (direction == TextDirection.rtl ? Alignment.centerRight : Alignment.centerLeft),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: PosterColors.inkDisplay1.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(metrics.px(999)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: metrics.px(10), vertical: metrics.px(5)),
            child: Text(spec.eyebrow, style: PosterType.eyebrow(metrics.f), textDirection: direction),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(PosterMetrics metrics, TextDirection direction) {
    final baseStyle = _titleStyle(metrics.f);

    if (spec.title.startsWith(RegExp(r'\d'))) {
      final digitMatch = RegExp(r'^(\d+)(.*)').firstMatch(spec.title);
      if (digitMatch != null) {
        final digit = digitMatch.group(1)!;
        final rest = digitMatch.group(2)!;
        final double badgeSize = (baseStyle.fontSize ?? 24) * 1.05;

        // A rounded accent chip in front of the number instead of a hard red
        // digit — reads as a friendly numbered-feature badge.
        return RichText(
          textAlign: spec.isCentered ? TextAlign.center : TextAlign.start,
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(right: metrics.px(8)),
                  child: Container(
                    width: badgeSize,
                    height: badgeSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: PosterColors.accent,
                      borderRadius: BorderRadius.circular(badgeSize * 0.32),
                    ),
                    child: Text(
                      digit,
                      style: baseStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: badgeSize * 0.62,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              TextSpan(text: rest, style: baseStyle),
            ],
          ),
        );
      }
    }

    return Text(
      spec.title,
      style: baseStyle,
      textAlign: spec.isCentered
          ? TextAlign.center
          : (direction == TextDirection.rtl ? TextAlign.right : TextAlign.left),
    );
  }

  Color _dashedRuleColor(PosterMetrics metrics) {
    switch (spec.kind) {
      case CalloutKind.heroIr:
      case CalloutKind.heroDe:
        return PosterColors.inkDisplay3.withValues(alpha: 0.5);
      case CalloutKind.steel:
        return PosterColors.inkDisplay3.withValues(alpha: 0.5);
      case CalloutKind.dark:
        return PosterColors.inkDisplay3.withValues(alpha: 0.4);
    }
  }

  /// Title boxed by an L of dashed rule — vertical leg down its right edge,
  /// horizontal leg along its bottom — with the body flowing around it: the
  /// first lines sit in the column right of the vertical leg, the rest run
  /// full width under the horizontal one.
  Widget _buildLRuleBody(PosterMetrics metrics, TextDirection direction) {
    final Color ruleColor = _dashedRuleColor(metrics);
    final TextStyle bodyStyle = _bodyStyle(metrics.f);
    final Widget titleWithEyebrow = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: direction == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [_buildEyebrow(metrics, direction), _buildTitle(metrics, direction)],
    );
    final Widget title = DashedLBorder(
      color: ruleColor,
      child: Directionality(textDirection: direction, child: titleWithEyebrow),
    );

    if (spec.body == null) return title;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The L sizes itself to the title, so measure the title to learn how
        // wide the notch the body has to flow around is.
        final TextPainter titlePainter = TextPainter(
          text: TextSpan(text: spec.title, style: _titleStyle(metrics.f)),
          textDirection: direction,
        )..layout();
        final double notchWidth = titlePainter.width + metrics.px(DashedLBorder.defaultInset + 2);

        final double gap = metrics.px(18);
        final double trailing = spec.hasEuBadge ? metrics.px(30) : 0;
        final double columnWidth = constraints.maxWidth - notchWidth - gap - trailing;

        final int split = columnWidth <= 0
            ? 0
            : _splitBodyAt(text: spec.body!, style: bodyStyle, direction: direction, width: columnWidth);
        final String beside = spec.body!.substring(0, split).trimRight();
        final String below = spec.body!.substring(split).trimLeft();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Stretched so the L's legs run to the bottom of whichever is
            // taller, title or the lines beside it — no dead space under the
            // short side before the full-width block picks up.
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  title,
                  SizedBox(width: gap),
                  if (beside.isNotEmpty)
                    SizedBox(
                      width: columnWidth,
                      child: Directionality(
                        textDirection: direction,
                        child: Text(beside, style: bodyStyle),
                      ),
                    ),
                ],
              ),
            ),
            if (below.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: metrics.px(6), right: trailing),
                child: Directionality(
                  textDirection: direction,
                  child: Text(below, style: bodyStyle),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Number of lines of the full-width block under the L, regardless of how
  /// tall the L's notch is.
  static const int _linesBelow = 2;

  /// Index in [text] where the body has to drop below the L, keeping the
  /// last [_linesBelow] lines (as wrapped at [width]) full width.
  int _splitBodyAt({
    required String text,
    required TextStyle style,
    required TextDirection direction,
    required double width,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
    )..layout(maxWidth: width);

    final List<LineMetrics> lines = painter.computeLineMetrics();
    final int besideCount = lines.length - _linesBelow;
    if (besideCount <= 0) return 0;

    // End of the last beside line: probe just past its right edge.
    return painter.getPositionForOffset(Offset(width, lines[besideCount - 1].baseline)).offset;
  }

  @override
  Widget build(BuildContext context) {
    final metrics = PosterMetrics.of(context);
    final direction = spec.textDirection;

    Widget cardContent = Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.px(28),
        spec.isCentered ? metrics.px(22) : metrics.px(26),
        metrics.px(28),
        spec.isCentered ? metrics.px(22) : metrics.px(26),
      ),
      child: spec.hasLRule
          ? _buildLRuleBody(metrics, direction)
          : Column(
              mainAxisAlignment: spec.isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: spec.isCentered
                  ? CrossAxisAlignment.center
                  : (direction == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start),
              children: <Widget>[
                // Eyebrow label
                Directionality(textDirection: direction, child: _buildEyebrow(metrics, direction)),
                // Title
                Directionality(textDirection: direction, child: _buildTitle(metrics, direction)),
                if (!spec.isCentered) SizedBox(height: metrics.px(16)),

                // Dashed rule
                if (spec.hasDashedRule && !spec.hasDivider) DashedRule.thin(color: _dashedRuleColor(metrics)),
                if (spec.hasDivider) const TwoToneDivider(),

                if (!spec.isCentered) SizedBox(height: metrics.px(16)),

                // Body
                if (spec.body != null)
                  Directionality(
                    textDirection: direction,
                    child: Text(
                      spec.body!,
                      style: _bodyStyle(metrics.f),
                      textAlign: direction == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                    ),
                  ),

                // Footer (card 05)
                if (spec.hasFooter) ...[SizedBox(height: metrics.px(12)), const IrFlagFooter()],
              ],
            ),
    );

    // Build decorations
    if (spec.hasIrFlag) {
      // Card 01
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          cardContent,
          Positioned(
            left: metrics.px(22),
            top: metrics.px(22),
            bottom: metrics.px(22),
            child: const IrFlagStrip(width: 26),
          ),
        ],
      );
    }

    if (spec.hasFadedFlag) {
      // Card 02
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          cardContent,
          Positioned(
            right: metrics.px(20),
            top: metrics.px(20),
            bottom: metrics.px(20),
            child: const FadedFlagStrip(width: 5),
          ),
        ],
      );
    }

    if (spec.hasEuBadge) {
      // Card 09
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          cardContent,
          Positioned(right: metrics.px(14), top: metrics.px(22), child: const EuBadgeColumn(width: 34)),
        ],
      );
    }

    if (spec.hasFlareTag) {
      // Card 09 — pulled in from the edge now that the tag is a rounded
      // pill; flush-right read fine for a hard-edged banner but a pill
      // wants a little breathing room before the card's own rounded corner.
      cardContent = Stack(
        children: <Widget>[
          cardContent,
          Positioned(right: metrics.px(16), bottom: metrics.px(16), child: const RedTag()),
        ],
      );
    }

    if (spec.hasDeBranding) {
      // Card 10
      cardContent = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          cardContent,
          Positioned(
            right: metrics.px(16),
            top: metrics.px(16),
            bottom: metrics.px(16),
            child: const DeStrip(width: 8),
          ),
        ],
      );
    }

    // Main card — a soft, rounded UI-style panel instead of the machined
    // bevel-and-screws plaque.
    final Widget card = SoftPanel(
      groundColor: _groundColor,
      groundGradient: _groundGradient,
      tintedShadow: _shadowTint,
      child: SizedBox(width: metrics.px(widthDesignPx ?? spec.widthFx * 1920), child: cardContent),
    );

    return card;
  }
}
