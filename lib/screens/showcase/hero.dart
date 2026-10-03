import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../device_preview/device_config.dart';
import '../../poster/callouts/callout_card.dart';
import '../../poster/chrome/poster_links.dart';
import '../../theme/nocturne.dart';
import '../../widgets/nocturne/n_button.dart';
import '../../widgets/nocturne/n_pill.dart';
import '../../widgets/nocturne/n_segmented.dart';

/// The showcase's hero block: the masthead line, the headline, the paragraph,
/// the two calls to action, and the device stage with its picker and stamp.
///
/// Transcribed from the `.pg-hero` block in `design_ref/Plate Gallery.dc.html`
/// (lines 92–161) and its `max-width: 1180px` media query (lines 58–62). Two
/// columns — `minmax(0,1.05fr) minmax(0,1fr)` with a 56px gap — collapsing to
/// one under [NBreak.hero], text above the stage.
///
/// **The hero never grows past the height it is given.** The design's section
/// is `min-height: 100vh` over `grid-template-rows: 1fr auto`, so the hero is
/// the `1fr` row: it takes the space left over and the stage fills whatever
/// remains inside it. An earlier pass let the column run to its natural height
/// inside a scroll view, which turned the page into a long ribbon and pushed
/// the device below the fold — the one thing every reference render of this
/// screen shows *not* happening.
///
/// The device stage arrives as [stage] rather than being built here: sk9 owns
/// the frames and sk10 the backdrop, and this prompt only gives the existing
/// stage the column proportion and the chrome the design asks for.
///
/// The callouts *are* built here, in both of the presentations the design
/// gives them: floating over the stage in the two-column layout ([CalloutLayer])
/// and a stacked list under it once the hero collapses ([CalloutList]). They
/// belong to the hero rather than to the stage because only the hero knows
/// which of the two is in play.
class ShowcaseHero extends StatelessWidget {
  const ShowcaseHero({
    super.key,
    required this.device,
    required this.onPickDevice,
    required this.onOpenArchive,
    required this.stage,
  });

  /// The device the stage is currently showing, which is what the picker
  /// renders as selected. The hero owns none of it — the stage reports the
  /// device back up as each hop starts.
  final DeviceType device;

  /// Picking a cell pins the stage to that device and stops the auto-cycle.
  final ValueChanged<DeviceType> onPickDevice;

  /// `Browse plates` — navigates to `/discover`.
  final VoidCallback onOpenArchive;

  /// The right column's content: the device stage itself. The callouts that
  /// float over it are the hero's, not the stage's — see [_Stage].
  final Widget stage;

  /// No country names and no counts: the stat band under the hero counts the
  /// catalogue itself, and a list written here goes stale with the next
  /// package.
  static const String _paragraph =
      'A Flutter widget for typing licence plates. It is filled slot by slot, '
      'in the plate\'s own alphabet and direction, and rendered the way the '
      'plate is printed. Each country is a separate package: add the ones you '
      'ship and pass a const spec.';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The media query measures the viewport; this measures the page
        // column, which on a desktop window is the viewport less the 208px
        // rail. Using the local width instead keeps the hero correct inside
        // the forced mobile panel, which narrows its constraints without
        // touching the window.
        final double width = constraints.maxWidth;

        final Widget content = switch (width) {
          >= NBreak.hero => _wide(width),
          _ => _stacked(),
        };

        // `min-height: 100vh`, and nothing more: fill the height given, and
        // grow past it only when the *text* genuinely does not fit — a window
        // barely taller than the headline. The old gate scrolled on width
        // instead, so every layout under 1180px became a ribbon with the
        // device somewhere below the fold.
        //
        // [IntrinsicHeight] is what makes the distinction, and it is cheap
        // here: the stage columns are [Stack]s of positioned children, whose
        // intrinsic height is zero, so the measurement never descends into the
        // device frames. Their floors are stated as constraints instead.
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: content),
          ),
        );
      },
    );
  }

  /// `grid-template-columns: minmax(0,1.05fr) minmax(0,1fr); gap: 56px;
  /// padding: 88px 0 56px 72px; align-items: center`.
  Widget _wide(double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(72, 88, 0, 56),
      child: Row(
        // `align-items: center` is done by the [Align] below rather than by
        // the Row: the stage column has to receive the row's full height —
        // `.pg-stage` centres the device inside itself — and a centred Row
        // would hand it a loose one and let it shrink to the device.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 105,
            child: Align(
              alignment: Alignment.centerLeft,
              // `max-width: 620px` on the left column.
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: _HeroText(
                  metrics: _HeroMetrics.wide(width),
                  onOpenArchive: onOpenArchive,
                ),
              ),
            ),
          ),
          const SizedBox(width: 56),
          Expanded(
            flex: 100,
            // `.pg-hero-r { padding-right: 56px }`.
            child: Padding(
              padding: const EdgeInsets.only(right: 56),
              // `.pg-stage { min-height: 420px }`. A floor, not a height: the
              // row's own height wins wherever it is larger, which is every
              // window the design is drawn at.
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _stageMin),
                child: _Stage(
                  stage: stage,
                  device: device,
                  onPickDevice: onPickDevice,
                  floatingCallouts: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `@media (max-width: 1180px)`: one column, `padding: 64px 48px 48px`,
  /// `gap: 48px`, `align-items: start`, h1 56px.
  Widget _stacked() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 64, 48, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _HeroText(
            metrics: _HeroMetrics.stacked(),
            onOpenArchive: onOpenArchive,
          ),
          const SizedBox(height: 48),
          Expanded(
            // Tight, so the measurement above reads [_stageMin] and stops
            // there; [Expanded]'s own tight height overrides it in layout.
            child: SizedBox(
              height: _stageMin,
              child: _Stage(
                stage: stage,
                device: device,
                onPickDevice: onPickDevice,
              ),
            ),
          ),
          // `.pg-feat`, under the stage: floating them here would drop a card
          // on the headline, which now sits directly above the stage.
          CalloutList(
            device: device,
            padding: const EdgeInsets.only(bottom: 8),
          ),
        ],
      ),
    );
  }
}

/// `.pg-stage { min-height: 420px }`.
///
/// Floors rather than heights: the stage takes the row it is in, and these
/// only decide how short a window has to get before the hero stops shrinking
/// the device and starts scrolling instead.
const double _stageMin = 420;

/// `.pg-stage`: the device centred in its column, the device picker 22px under
/// it, and the `IRAN MADE · OPEN SOURCE` stamp pinned to the column's
/// bottom-left corner (`position: absolute; bottom: -6px; left: 16px`).
class _Stage extends StatelessWidget {
  const _Stage({
    required this.stage,
    required this.device,
    required this.onPickDevice,
    this.floatingCallouts = false,
  });

  final Widget stage;
  final DeviceType device;
  final ValueChanged<DeviceType> onPickDevice;

  /// Whether the callouts float over this box. Only the two-column hero says
  /// yes; the stacked layouts put them in a list under the stage instead, and
  /// rendering both would draw each card twice.
  final bool floatingCallouts;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // The callouts hang outside this box on purpose: the top card clears
      // the stage's top edge and the bottom one its bottom edge.
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          // `padding: 56px 0 30px` — the 30px is what the stamp sits in.
          child: Padding(
            padding: const EdgeInsets.only(top: 56, bottom: 30),
            child: Column(
              children: <Widget>[
                Expanded(child: stage),
                const SizedBox(height: 22),
                // `.pg-devdots`. The design renders these as three separate
                // `radius: 999` buttons with no selected state; sk6 asks for
                // the DS `.seg` instead, which is the same control with the
                // selection the dots lack — and the widget sk11–sk14 reuse.
                NSegmented<DeviceType>(
                  value: device,
                  onChanged: onPickDevice,
                  options: const <NSegmentedOption<DeviceType>>[
                    NSegmentedOption<DeviceType>(
                      value: DeviceType.mobile,
                      label: 'Mobile',
                    ),
                    NSegmentedOption<DeviceType>(
                      value: DeviceType.tablet,
                      label: 'Tablet',
                    ),
                    NSegmentedOption<DeviceType>(
                      value: DeviceType.desktop,
                      label: 'Desktop',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Over the device, under the stamp: the design's cards sit above the
        // stage's own contents, and the pill is the one thing it draws over
        // them both.
        if (floatingCallouts)
          Positioned.fill(child: CalloutLayer(device: device)),
        const Positioned(
          left: 16,
          bottom: 0,
          child: NPill(label: 'Iran made · open source'),
        ),
      ],
    );
  }
}

/// The type sizes and rhythm of the hero's text column at one width.
///
/// Three sets rather than one interpolated scale: the design gives exact
/// values at two of them and the reference render gives the third, and a
/// curve fitted through the lot would match none of them.
@immutable
class _HeroMetrics {
  const _HeroMetrics({
    required this.heading,
    required this.masthead,
    required this.paragraph,
    required this.buttonsFillWidth,
    required this.showMastheadRule,
    required this.mastheadColor,
    required this.afterMasthead,
    required this.afterHeading,
    required this.afterParagraph,
  });

  /// `font-size: clamp(52px, 5.6vw, 80px)`.
  factory _HeroMetrics.wide(double width) => _HeroMetrics(
    heading: (width * 0.056).clamp(52.0, 80.0),
    masthead: 11,
    paragraph: 20,
    buttonsFillWidth: false,
    showMastheadRule: true,
    mastheadColor: N.n400,
    afterMasthead: 40,
    afterHeading: 28,
    afterParagraph: 36,
  );

  factory _HeroMetrics.stacked() => const _HeroMetrics(
    heading: 56,
    masthead: 11,
    paragraph: 20,
    buttonsFillWidth: false,
    showMastheadRule: true,
    mastheadColor: N.n400,
    afterMasthead: 40,
    afterHeading: 28,
    afterParagraph: 36,
  );

  factory _HeroMetrics.compact() => const _HeroMetrics(
    heading: 40,
    masthead: 10,
    paragraph: 17,
    buttonsFillWidth: true,
    // The panel render drops the accent rule and tints the credit itself
    // instead — there is no room for a 28px rule plus a 12px gap in a
    // 354px column that the credit already fills.
    showMastheadRule: false,
    mastheadColor: N.accent300,
    afterMasthead: 22,
    afterHeading: 18,
    afterParagraph: 24,
  );

  final double heading;
  final double masthead;
  final double paragraph;
  final bool buttonsFillWidth;
  final bool showMastheadRule;
  final Color mastheadColor;
  final double afterMasthead;
  final double afterHeading;
  final double afterParagraph;
}

/// The hero's left column, top to bottom: masthead, headline, paragraph,
/// actions. Nothing else — the device picker and the stamp belong to the
/// stage column, where the design puts them.
class _HeroText extends StatelessWidget {
  const _HeroText({required this.metrics, required this.onOpenArchive});

  final _HeroMetrics metrics;
  final VoidCallback onOpenArchive;

  /// `View on pub.dev` goes to the package's pub.dev page — the docs this app
  /// has always linked. The URL lives in [PosterLinks] and is read, not
  /// restated.
  Future<void> _openDocs() => launchUrl(
    Uri.parse(PosterLinks.pubDevUrl),
    mode: LaunchMode.externalApplication,
  );

  /// `.pg-actions`: `display: flex; gap: 12px; align-items: center`.
  ///
  /// A [Row] at every width the design draws two columns at, because that is
  /// what the design does — it never wraps this pair, it stacks the hero
  /// instead. In the phone panel the pair goes full-width and stacks, which is
  /// what the render of that width shows and what a Row there cannot do: the
  /// two buttons are together wider than the column they sit in.
  Widget _actions() {
    final NButton primary = NButton(
      label: 'Browse plates',
      variant: NButtonVariant.primary,
      fontSize: 15,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      onPressed: onOpenArchive,
    );
    final NButton secondary = NButton(
      label: 'View on pub.dev',
      fontSize: 15,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
      onPressed: _openDocs,
    );

    if (metrics.buttonsFillWidth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[primary, const SizedBox(height: 12), secondary],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[primary, const SizedBox(width: 12), secondary],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            // A 28×1px accent rule, then the credit in mono at +0.13em.
            if (metrics.showMastheadRule) ...<Widget>[
              Container(width: 28, height: 1, color: N.accent),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(
                'ARAD BEYRANVAND — SOLE AUTHOR',
                style: NType.kicker.copyWith(
                  fontSize: metrics.masthead,
                  letterSpacing: 0.13 * metrics.masthead,
                  color: metrics.mastheadColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: metrics.afterMasthead),
        Text(
          'Plate input\nfor Flutter.',
          style: TextStyle(
            fontFamily: NType.archivo,
            fontWeight: FontWeight.w800,
            fontSize: metrics.heading,
            height: 0.92,
            letterSpacing: -0.04 * metrics.heading,
            color: N.n100,
          ),
        ),
        SizedBox(height: metrics.afterHeading),
        ConstrainedBox(
          // `max-width: 46ch` at 20px Newsreader.
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            ShowcaseHero._paragraph,
            style: TextStyle(
              // The one place the design leaves Archivo for the serif.
              fontFamily: NType.serif,
              fontSize: metrics.paragraph,
              height: 1.5,
              color: N.n300,
            ),
          ),
        ),
        SizedBox(height: metrics.afterParagraph),
        _actions(),
      ],
    );
  }
}

/// The hero's text column at phone-panel scale, for the mobile body.
class MobileHeroText extends StatelessWidget {
  const MobileHeroText({super.key, required this.onOpenArchive});

  final VoidCallback onOpenArchive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 32, 18, 30),
      child: _HeroText(
        metrics: _HeroMetrics.compact(),
        onOpenArchive: onOpenArchive,
      ),
    );
  }
}
