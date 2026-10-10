import 'package:flutter/material.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/country_meta.dart';
import '../design/tokens.dart';
import '../landing/sections.dart';
import '../landing/text_styles.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
import 'breadcrumb.dart';
import 'filter_chips.dart';

/// A region's countries, one card each, filtered by name, endonym or ISO
/// code. Every card opens that country's own page.
class RegionPage extends StatefulWidget {
  const RegionPage({super.key, required this.region});

  final GallerySource region;

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  final TextEditingController _q = TextEditingController();

  /// The package selected, or null for "All". A region's countries split by
  /// the package that ships them, which is the division a reader of the
  /// catalogue actually acts on.
  String? _package;

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(RegionPage old) {
    super.didUpdateWidget(old);
    if (!identical(old.region, widget.region)) {
      _q.clear();
      _package = null;
    }
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final GallerySource region = widget.region;
    final String q = normaliseQuery(_q.text);

    final List<GallerySource> members = region.members;
    final List<String> packages = <String>{
      for (final GallerySource m in members) ...m.packageNames,
    }.toList();

    final List<GallerySource> shown = <GallerySource>[
      for (final GallerySource m in members)
        if (_package == null || m.packageNames.contains(_package))
          if (q.isEmpty ||
              <String>[
                m.countryName,
                countryMeta[m.countryName]?.$1 ?? '',
                countryMeta[m.countryName]?.$2 ?? '',
                ...m.packageNames,
              ].any((String h) => normaliseQuery(h).contains(q)))
            m,
    ];

    return ListView(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 64,
        left: pdClamp(context, 16, 3, 32),
        right: pdClamp(context, 16, 3, 32),
      ),
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                PdBreadcrumb(
                  trail: const <(String, PdLocation)>[
                    ('Plates', PdLocation.landing(LandingAnchor.coverage)),
                  ],
                  current: region.countryName,
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        region.countryName,
                        style: TextStyle(
                          fontSize: pdClamp(context, 28, 4, 40),
                          height: 1.15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02 * pdClamp(context, 28, 4, 40),
                          color: t.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(region.note, style: body(t, size: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 320,
                  height: 40,
                  child: PdTextField(
                    controller: _q,
                    hint: 'Country or code',
                    semanticLabel: 'Filter countries',
                  ),
                ),
                if (packages.length > 1) ...<Widget>[
                  const SizedBox(height: 12),
                  PdFilterRow(
                    children: <Widget>[
                      PdFilterChip(
                        label: 'All',
                        count: members.length,
                        selected: _package == null,
                        onTap: () => setState(() => _package = null),
                      ),
                      for (final String p in packages)
                        PdFilterChip(
                          label: p,
                          selected: _package == p,
                          onTap: () => setState(() => _package = p),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No country in ${region.countryName} matches '
                      '“${_q.text.trim()}”.',
                      style: body(t),
                    ),
                  )
                else
                  PdAutoGrid(
                    minWidth: 260,
                    gap: 12,
                    children: <Widget>[
                      for (final GallerySource m in shown) _CountryCard(source: m),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CountryCard extends StatelessWidget {
  const _CountryCard({required this.source});

  final GallerySource source;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final CatalogueItem? lead = firstItemOf(source);
    final String native = countryMeta[source.countryName]?.$2 ?? '';
    final int types = catalogueItems
        .where((CatalogueItem i) => identical(i.source, source))
        .length;

    return PdTappable(
      onTap: lead == null ? null : () => nav.go(PdLocation.country(source)),
      radius: PdRadius.stage,
      color: t.surface,
      border: t.divider,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (lead != null)
            StaticPlate(
              spec: lead.entry.spec,
              values: lead.entry.sampleValues,
              theme: lead.entry.theme,
              country: lead.entry.country,
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              Text(
                source.countryName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: t.text,
                ),
              ),
              if (native.isNotEmpty && native != source.countryName)
                Text(
                  native,
                  style: TextStyle(
                    fontFamily: PdFonts.persian,
                    fontSize: 14,
                    color: t.subtle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '$types plate ${types == 1 ? 'type' : 'types'}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: t.muted),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lead == null ? 'In package' : 'Open →',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: lead == null ? t.subtle : t.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
