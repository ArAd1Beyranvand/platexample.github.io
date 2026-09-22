import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/nocturne.dart';
import '../sources/sources.dart';

/// `03 — About`: what this app is, and which package draws which plates.
///
/// Transcribed from `.pg-discover` (About shares Discover's section shell) in
/// `design_ref/Plate Gallery.dc.html` (lines 229–273 desktop, 502–539
/// mobile): a two-column header over a rule, a flat divided list of country
/// rows, then a card grid of the packages this app is built against.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// The versions this app is built against, and where each package lives.
  ///
  /// Written out rather than read from a generated file: an app that wants
  /// its own dependency versions at runtime needs a build step, and this is
  /// a showcase.
  // TODO(sk14): generate this from pubspec.lock at build time instead of
  // hardcoding it here, so a `pub upgrade` can't leave it stale again.
  static const List<_PackageInfo> _packages = <_PackageInfo>[
    _PackageInfo('core_plate', '0.5.0', 'https://github.com/ArAd1Beyranvand/core-plate'),
    _PackageInfo('core_plate_bloc', '0.1.0', 'https://github.com/ArAd1Beyranvand/core-plate-bloc'),
    _PackageInfo('plate_keypad', '0.1.0', 'https://github.com/ArAd1Beyranvand/keypad-plate'),
    _PackageInfo('iran_plate', '0.1.0', 'https://github.com/ArAd1Beyranvand/iran-plate'),
    _PackageInfo('germany_plate', '0.2.0', 'https://github.com/ArAd1Beyranvand/germany-plate'),
    _PackageInfo('palestine_plate', '0.2.0', 'https://github.com/ArAd1Beyranvand/plate-palestine'),
    _PackageInfo('yemen_plate', '0.3.0', 'https://github.com/ArAd1Beyranvand/plate-yemen'),
    _PackageInfo('lebanon_plate', '0.1.0', 'https://github.com/ArAd1Beyranvand/lebanon-plate'),
  ];

  /// `padding: 72px 64px 96px 72px`, and the media query's
  /// `56px 40px 72px` under [NBreak.detail].
  static const EdgeInsets _padding = EdgeInsets.fromLTRB(72, 72, 64, 96);
  static const EdgeInsets _compactPadding = EdgeInsets.fromLTRB(40, 56, 40, 72);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < NBreak.detail;
        final EdgeInsets padding = compact ? _compactPadding : _padding;
        return ListView(
          padding: padding,
          children: <Widget>[
            _Header(compact: compact),
            const SizedBox(height: 28),
            const NRule(),
            SizedBox(height: compact ? 32 : 44),
            Text('Countries'.toUpperCase(), style: NType.kicker.copyWith(color: N.n500)),
            const SizedBox(height: 8),
            for (final GallerySource source in gallerySources) _CountryRow(source: source, compact: compact),
            SizedBox(height: compact ? 40 : 52),
            Text('Built against'.toUpperCase(), style: NType.kicker.copyWith(color: N.n500)),
            SizedBox(height: compact ? 14 : 16),
            _PackageGrid(compact: compact),
          ],
        );
      },
    );
  }
}

/// `.pg-dhead`: eyebrow + title on the left, the two lede paragraphs on the
/// right, `align-items: start`.
class _Header extends StatelessWidget {
  const _Header({required this.compact});

  final bool compact;

  static const String _p1 =
      'Each package ships a ~30-line example that draws one plate; the '
      'catalogue lives here instead, so no publishable package carries a '
      'showcase.';
  static const String _p2 =
      'A plate is three independent render-time inputs: a PlateSpec for '
      'geometry, a PlateTheme for colour and a PlateCountry for the panel '
      'block. Nothing in this app depends on a country package knowing about '
      'any other, and no country package depends on this app.';

  @override
  Widget build(BuildContext context) {
    final Widget titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '03 — About'.toUpperCase(),
          style: NType.kicker.copyWith(fontSize: 11, letterSpacing: 0.12 * 11, color: N.accent300),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          // `font-size: clamp(34px, 3.6vw, 48px)`, measured against this
          // column rather than the viewport — see DiscoverScreen's header.
          builder: (BuildContext context, BoxConstraints constraints) => Text(
            'One app for every country package.',
            style: TextStyle(
              fontFamily: NType.archivo,
              fontWeight: FontWeight.w800,
              fontSize: (constraints.maxWidth * 0.036).clamp(34.0, 48.0),
              height: 0.95,
              letterSpacing: -0.035 * (constraints.maxWidth * 0.036).clamp(34.0, 48.0),
              color: N.n100,
            ),
          ),
        ),
      ],
    );

    final Widget paragraphs = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(_p1, style: const TextStyle(fontFamily: NType.serif, fontSize: 18.5, height: 1.55, color: N.n300)),
          const SizedBox(height: 18),
          Text(_p2, style: const TextStyle(fontFamily: NType.serif, fontSize: 18.5, height: 1.55, color: N.n400)),
        ],
      ),
    );

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[titleColumn, const SizedBox(height: 20), paragraphs],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: titleColumn),
        const SizedBox(width: 56),
        Expanded(flex: 2, child: paragraphs),
      ],
    );
  }
}

/// One country: `name + package | description | spec count`, `230px | 1fr |
/// 84px`, divided by a solid 1px line. Under [NBreak.detail] the spec count
/// moves up next to the name and the description drops to its own line.
class _CountryRow extends StatelessWidget {
  const _CountryRow({required this.source, required this.compact});

  final GallerySource source;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Widget nameAndPackage = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(source.countryName, style: const TextStyle(fontFamily: NType.archivo, fontSize: 17, color: N.n100)),
        const SizedBox(width: 10),
        Text(source.packageName, style: NType.specId.copyWith(letterSpacing: 0.06 * 11, color: N.n600)),
      ],
    );
    final Widget specCount = Text(
      '${source.specIds.length} specs',
      style: NType.specId.copyWith(letterSpacing: 0.1 * 11, color: N.accent300),
    );
    final Widget description = Text(
      source.note,
      style: const TextStyle(fontFamily: NType.serif, fontSize: 16.5, height: 1.5, color: N.n400),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 18 : 20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: N.n900))),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Flexible(child: nameAndPackage), specCount],
                ),
                const SizedBox(height: 10),
                description,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                SizedBox(width: 230, child: nameAndPackage),
                const SizedBox(width: 28),
                Expanded(child: description),
                const SizedBox(width: 28),
                SizedBox(width: 84, child: Align(alignment: Alignment.centerRight, child: specCount)),
              ],
            ),
    );
  }
}

class _PackageGrid extends StatelessWidget {
  const _PackageGrid({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        children: <Widget>[
          for (final _PackageInfo package in AboutScreen._packages)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: _PackageCard(package: package)),
        ],
      );
    }
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: <Widget>[
        for (final _PackageInfo package in AboutScreen._packages)
          SizedBox(width: 260, child: _PackageCard(package: package)),
      ],
    );
  }
}

class _PackageInfo {
  const _PackageInfo(this.name, this.version, this.githubUrl);

  final String name;
  final String version;
  final String githubUrl;

  String get pubDevUrl => 'https://pub.dev/packages/$name';
}

/// One dependency card: name and version, and two ghost buttons to its
/// pub.dev listing and its GitHub repo.
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final _PackageInfo package;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(color: N.n800),
        borderRadius: BorderRadius.circular(NRadius.lg),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[N.surface, N.n900],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            package.name,
            style: const TextStyle(fontFamily: NType.mono, fontSize: 14, letterSpacing: 0.02 * 14, color: N.n100),
          ),
          const SizedBox(height: 5),
          Text(package.version, style: NType.specId.copyWith(fontSize: 11, letterSpacing: 0, color: N.n500)),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              _LinkChip(label: 'pub.dev', url: package.pubDevUrl),
              const SizedBox(width: 8),
              _LinkChip(label: 'GitHub', url: package.githubUrl),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small ghost pill that opens [url] in the platform's default browser.
class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, required this.url});

  final String label;
  final String url;

  Future<void> _open() => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(NRadius.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(NRadius.sm),
        onTap: _open,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(border: Border.all(color: N.n800), borderRadius: BorderRadius.circular(NRadius.sm)),
          child: Text(label, style: NType.specId.copyWith(fontSize: 12, letterSpacing: 0, color: N.n300)),
        ),
      ),
    );
  }
}
