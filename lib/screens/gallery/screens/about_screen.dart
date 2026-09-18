import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/section_header.dart';

/// What this app is, and which package draws which plates.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// The versions this app is built against, and where each package lives.
  /// Written out rather than read from a generated file: an app that wants its
  /// own dependency versions at runtime needs a build step, and this is a
  /// showcase.
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xl, Gap.lg, Gap.xl),
      children: <Widget>[
        Text('About', style: theme.textTheme.headlineMedium),
        const SizedBox(height: Gap.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'One app for every country package in this repo. Each package ships '
            'a ~30-line example that draws one plate; the catalogue lives here '
            'instead, so no publishable package carries a showcase.\n\n'
            'A plate is three independent render-time inputs: a PlateSpec for '
            'geometry, a PlateTheme for colour and a PlateCountry for the panel '
            'block. Nothing in this app depends on a country package knowing '
            'about any other, and no country package depends on this app.',
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
        ),
        const SizedBox(height: Gap.xl),
        const Eyebrow('Countries'),
        const SizedBox(height: Gap.md),
        for (final GallerySource source in gallerySources)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: Container(
              padding: const EdgeInsets.all(Gap.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: Radii.mdAll,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 4,
                    height: 34,
                    decoration: BoxDecoration(
                      color: source.accent ?? theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${source.countryName} · ${source.packageName}', style: theme.textTheme.titleSmall),
                        const SizedBox(height: Gap.xs),
                        Text(
                          source.note,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Gap.sm),
                  Text(
                    '${source.specIds.length} specs',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Gap.xl),
        const Eyebrow('Built against'),
        const SizedBox(height: Gap.md),
        for (final _PackageInfo package in _packages)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: _PackageCard(package: package),
          ),
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

/// One package, its version, and the two places to go read more about it.
///
/// A bare name-and-number row cannot answer "where do I file an issue" or
/// "what does the README say" — the whole point of naming a dependency is
/// that someone reading it might want to follow it somewhere.
class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final _PackageInfo package;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm + 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: Radii.mdAll,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(package.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  package.version,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          _LinkChip(icon: Icons.inventory_2_outlined, label: 'pub.dev', url: package.pubDevUrl),
          const SizedBox(width: Gap.xs),
          _LinkChip(icon: Icons.code_rounded, label: 'GitHub', url: package.githubUrl),
        ],
      ),
    );
  }
}

/// A small tappable pill that opens [url] in the platform's default browser.
class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.icon, required this.label, required this.url});

  final IconData icon;
  final String label;
  final String url;

  Future<void> _open() => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: Radii.smAll,
      child: InkWell(
        borderRadius: Radii.smAll,
        onTap: _open,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 5),
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
