import 'package:flutter/material.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/country_meta.dart';
import '../design/tokens.dart';
import '../widgets/controls.dart';
import 'sections.dart';
import 'text_styles.dart';

class _Row {
  _Row(this.source)
    : iso = countryMeta[source.countryName]?.$1 ?? '',
      native = countryMeta[source.countryName]?.$2 ?? '',
      item = firstItemOf(source);

  final GallerySource source;
  final String iso;
  final String native;

  /// The country's leading plate, and null for a region (its plates are its
  /// members', so there is no one plate to call the region's own).
  final CatalogueItem? item;

  bool get isRegion => isUmbrella(source);

  /// A region opens even with no [item]; a country needs one.
  bool get opens => isRegion || item != null;

  /// A region also matches on its members' names, so searching a member
  /// surfaces Iranshahr alongside the member itself.
  late final List<String> _haystack = <String>[
    source.countryName,
    iso,
    ...source.packageNames,
    native,
    for (final GallerySource m in source.members) m.countryName,
  ].map(normaliseQuery).toList();

  bool matches(String q) =>
      q.isEmpty ||
      _haystack.any((String h) => h.contains(q)) ||
      (q.length == 2 && iso.toLowerCase() == q);
}

/// The head of the list, in the order the catalogue leads with: Iran, the two
/// groups around it, then Palestine.
const List<String> _leadOrder = <String>[
  'Iran',
  'Iranshahr',
  'Yemen',
  'Palestine',
];

/// The lead rows above, then every other country A–Z. Continents are spread
/// into their countries; Iranshahr and Yemen stay one row each.
final List<_Row> _rows = () {
  final List<GallerySource> all = <GallerySource>[
    for (final GallerySource s in gallerySources)
      if (s is RegionSource)
        ...s.members.where((GallerySource m) => m.sections.isNotEmpty)
      else if (isUmbrella(s) || s.sections.isNotEmpty)
        s,
  ];
  final List<GallerySource> lead = <GallerySource>[
    for (final String name in _leadOrder)
      ...all.where((GallerySource s) => s.countryName == name),
  ];
  final List<GallerySource> rest =
      <GallerySource>[
        for (final GallerySource s in all)
          if (!lead.any((GallerySource l) => identical(l, s))) s,
      ]..sort(
        (GallerySource a, GallerySource b) =>
            a.countryName.compareTo(b.countryName),
      );
  return <_Row>[
    for (final GallerySource s in <GallerySource>[...lead, ...rest]) _Row(s),
  ];
}();

class CoverageSection extends StatefulWidget {
  const CoverageSection({super.key});

  @override
  State<CoverageSection> createState() => _CoverageSectionState();
}

class _CoverageSectionState extends State<CoverageSection> {
  final TextEditingController _q = TextEditingController();

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final CatalogueStats stats = CatalogueStats.of(gallerySources);
    final String q = normaliseQuery(_q.text);
    final List<_Row> rows = _rows.where((_Row r) => r.matches(q)).toList();

    final Widget intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${stats.countries} countries · ${stats.specs} plate types',
          style: h2(context),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const TextSpan(
                text:
                    'One package per country, so your app ships only the ones '
                    'it uses. A new plate is a new ',
              ),
              TextSpan(text: 'const', style: monoStyle(t, size: 14)),
              const TextSpan(text: ', not a new widget.'),
            ],
          ),
          style: body(t, size: 16),
        ),
      ],
    );

    final bool landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final Widget list = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 44,
          child: PdTextField(
            controller: _q,
            focusNode: nav.searchFocus,
            hint: 'Country, ISO code, script or package',
            semanticLabel: 'Search plates',
            prefix: Icon(Icons.search, size: 18, color: t.subtle),
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 480,
            minHeight: landscape ? 480 : 0,
          ),
          child: rows.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No plate matches “${_q.text.trim()}”. Try a country '
                    'name, an ISO code like DE, or a package name.',
                    style: body(t),
                  ),
                )
              : PdScrollHandoff(
                  child: ListView.builder(
                    shrinkWrap: !landscape,
                    itemCount: rows.length,
                    itemBuilder: (BuildContext context, int i) =>
                        _CoverageRow(row: rows[i]),
                  ),
                ),
        ),
      ],
    );

    return PdAutoGrid(
      minWidth: 400,
      gap: pdClamp(context, 32, 5, 64),
      children: <Widget>[intro, list],
    );
  }
}

class _CoverageRow extends StatelessWidget {
  const _CoverageRow({required this.row});

  final _Row row;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: t.divider)),
      ),
      child: PdTappable(
        onTap: row.opens ? () => nav.go(PdLocation.of(row.source)) : null,
        height: 60,
        width: double.infinity,
        hoverColor: t.surface,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      row.source.countryName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: t.text,
                      ),
                    ),
                  ),
                  if (row.native.isNotEmpty &&
                      row.native != row.source.countryName)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        row.native,
                        style: TextStyle(
                          fontFamily: PdFonts.persian,
                          fontSize: 14,
                          color: t.subtle,
                        ),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      row.source.packageName,
                      overflow: TextOverflow.ellipsis,
                      style: monoStyle(t, size: 12).copyWith(color: t.muted),
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: row.opens ? t.accent : t.divider),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  row.isRegion
                      ? 'Region →'
                      : row.opens
                      ? 'Open →'
                      : 'In package',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: row.opens ? t.accent : t.subtle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
