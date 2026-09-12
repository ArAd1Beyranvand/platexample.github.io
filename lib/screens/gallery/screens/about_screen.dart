import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/section_header.dart';

/// What this app is, and which package draws which plates.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  /// The versions this app is built against. Written out rather than read from
  /// a generated file: an app that wants its own dependency versions at runtime
  /// needs a build step, and this is a showcase.
  static const List<(String, String)> _packages = <(String, String)>[
    ('core_plate', '0.5.0'),
    ('core_plate_bloc', '0.1.0'),
    ('plate_keypad', '0.1.0'),
    ('iran_plate', '0.1.0'),
    ('germany_plate', '0.1.0'),
    ('palestine_plate', '0.2.0'),
    ('yemen_plate', '0.3.0'),
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
            'a ~30-line example that draws one plate; the catalogue and the '
            'playground live here instead, so no publishable package carries a '
            'showcase.\n\n'
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
        for (final (String name, String version) in _packages)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(name, style: theme.textTheme.bodyMedium)),
                Text(
                  version,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
