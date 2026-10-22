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
    : name = source.countryName,
      package = source.packageName,
      terms = source is RegionSource ? <String>[] : source.packageNames,
      iso =
          countryMeta[source.countryName == 'Korea' ? 'North Korea' : source.countryName]?.$1 ?? '',
      native =
          countryMeta[source.countryName == 'Korea' ? 'North Korea' : source.countryName]?.$2 ?? '',
      item = firstItemOf(source),
      alias = false;

  /// A country that has no package of its own: it lives in [parent]'s, so the
  /// row names the country and points at that package. It shows only in a
  /// search, and opens [target].
  _Row.alias(
    this.source,
    GallerySource parent, {
    required this.name,
    List<String> aka = const <String>[],
  }) : package = parent.packageName,
       terms = <String>[...parent.packageNames, ...aka],
       iso = countryMeta[name]?.$1 ?? '',
       native = countryMeta[name]?.$2 ?? '',
       item = firstItemOf(source),
       alias = true;

  final GallerySource source;
  final String name;
  final String package;
  final List<String> terms;
  final String iso;
  final String native;
  final bool alias;

  /// The country's leading plate, and null for a region (its plates are its
  /// members', so there is no one plate to call the region's own).
  final CatalogueItem? item;

  bool get isRegion => !alias && isUmbrella(source);

  /// A region opens even with no [item]; a country needs one.
  bool get opens => isRegion || item != null;

  late final List<String> _haystack = <String>[
    name,
    iso,
    ...terms,
    native,
  ].map(normaliseQuery).toList();

  /// Russia and China share their names with their regions; only the
  /// region leads.
  bool get isLead =>
      !alias &&
      _leadOrder.contains(source.countryName) &&
      ((source.countryName != 'Russia' && source.countryName != 'China') || isRegion);

  /// With no query only the lead rows show; every other country is found by
  /// searching.
  bool matches(String q) => q.isEmpty
      ? isLead
      : _haystack.any((String h) => h.contains(q)) || (q.length == 2 && iso.toLowerCase() == q);
}

/// The head of the list, in the order the catalogue leads with: Iran, the two
/// groups around it, Palestine, Russia, North Korea, then the four continents.
const List<String> _leadOrder = <String>[
  'Iran',
  'Iranshahr',
  'Yemen',
  'Palestine',
  'Russia',
  'China',
  'Korea',
  'Asia',
  'Africa',
  'Europe',
  'America',
  'Oceania',
];

/// The lead rows above, then every other country A–Z. Continents are spread
/// into their countries as well as keeping a row of their own; Iranshahr and
/// Yemen stay one row each.
final List<_Row> _rows = () {
  final List<GallerySource> all = <GallerySource>[];
  void add(GallerySource s) {
    if (!all.any((GallerySource a) => identical(a, s))) all.add(s);
  }

  for (final GallerySource s in gallerySources) {
    if (s is RegionSource) {
      add(s);
    } else if (isUmbrella(s) || s.sections.isNotEmpty) {
      add(s);
    }
  }
  // A continent's own countries (those with no top-level source). Iranshahr's
  // members reach the list as aliases below, so they are skipped here.
  for (final GallerySource s in gallerySources) {
    if (s is! RegionSource) continue;
    for (final GallerySource m in s.members) {
      final bool underOther = gallerySources.any(
        (GallerySource t) =>
            t is! RegionSource && t.members.any((GallerySource x) => identical(x, m)),
      );
      if (m.sections.isNotEmpty && !underOther) add(m);
    }
  }
  // A country that heads a region of the same name is reached through it.
  all.removeWhere(
    (GallerySource s) =>
        s is! RegionSource &&
        all.any((GallerySource r) => r is RegionSource && r.countryName == s.countryName),
  );
  final List<GallerySource> lead = <GallerySource>[
    for (final String name in _leadOrder)
      ...all.where((GallerySource s) => s.countryName == name).take(1),
  ];
  final List<GallerySource> rest = <GallerySource>[
    for (final GallerySource s in all)
      if (!lead.any((GallerySource l) => identical(l, s))) s,
  ]..sort((GallerySource a, GallerySource b) => a.countryName.compareTo(b.countryName));
  return <_Row>[
    for (final GallerySource s in <GallerySource>[...lead, ...rest]) _Row(s),
    for (final GallerySource s in all)
      if (s is! RegionSource && s.countryName != 'Yemen')
        for (final GallerySource m in s.members)
          if (m.countryName != 'North Korea') _Row.alias(m, s, name: m.countryName),
    _Row.alias(
      all.firstWhere((GallerySource s) => s.countryName == 'Yemen'),
      all.firstWhere((GallerySource s) => s.countryName == 'Yemen'),
      name: 'Riyadh',
      aka: <String>['Saudi Arabia'],
    ),
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
        Text('${stats.countries} countries · ${stats.specs} plate types', style: h2(context)),
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
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No plate matches “${_q.text.trim()}”. Try a country '
              'name, an ISO code like DE, or a package name.',
              style: body(t),
            ),
          )
        else
          for (final _Row row in rows) _CoverageRow(row: row),
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
        hoverColor: t.hover,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      row.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: t.text),
                    ),
                  ),
                  if (row.native.isNotEmpty && row.native != row.name)
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
                      row.package,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
