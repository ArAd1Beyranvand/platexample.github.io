import 'package:flutter/material.dart';
import 'package:plate_core/plate_core.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/catalogue.dart';
import '../data/country_meta.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../landing/sections.dart';
import '../landing/text_styles.dart';
import '../plate/live_plate.dart';
import '../widgets/controls.dart';
import 'breadcrumb.dart';
import 'filter_chips.dart';

/// One country's plate types: the list on the left, the selected type's
/// facts on the right.
///
/// The types are the country's own catalogue items and their categories are
/// the section titles the packages already group them under — nothing here is
/// a second list of plates to keep in step with the sources.
class CountryPage extends StatefulWidget {
  const CountryPage({super.key, required this.source});

  final GallerySource source;

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final TextEditingController _q = TextEditingController();

  /// The section title selected, or null for "All".
  String? _category;

  /// Null until the user picks one, so the first visible row leads.
  CatalogueItem? _selected;

  @override
  void initState() {
    super.initState();
    _q.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(CountryPage old) {
    super.didUpdateWidget(old);
    if (!identical(old.source, widget.source)) {
      _q.clear();
      _category = null;
      _selected = null;
    }
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  List<CatalogueItem> get _items => <CatalogueItem>[
    for (final CatalogueItem item in catalogueItems)
      if (identical(item.source, widget.source)) item,
  ];

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final GallerySource source = widget.source;
    final List<CatalogueItem> items = _items;

    // Section order, deduplicated: a section is one category chip.
    final List<String> categories = <String>{
      for (final CatalogueItem item in items) item.section.title,
    }.toList();

    final String q = normaliseQuery(_q.text);
    final List<CatalogueItem> shown = <CatalogueItem>[
      for (final CatalogueItem item in items)
        if (_category == null || item.section.title == _category)
          if (q.isEmpty ||
              normaliseQuery(
                '${item.entry.label} ${item.section.title}',
              ).contains(q))
            item,
    ];
    final CatalogueItem? selected = shown.contains(_selected)
        ? _selected
        : (shown.isNotEmpty ? shown.first : null);

    final GallerySource? region = regionOf(source);
    final (String iso, String native) = (
      countryMeta[source.countryName]?.$1 ?? '',
      countryMeta[source.countryName]?.$2 ?? '',
    );

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
                  trail: <(String, PdLocation)>[
                    (
                      'Countries',
                      const PdLocation.landing(LandingAnchor.coverage),
                    ),
                    if (region != null)
                      (region.countryName, PdLocation.region(region)),
                  ],
                  current: source.countryName,
                ),
                const SizedBox(height: 24),
                _Header(
                  source: source,
                  native: native,
                  iso: iso,
                  types: items.length,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 320,
                  height: 40,
                  child: PdTextField(
                    controller: _q,
                    hint: 'Filter plate types',
                    semanticLabel: 'Filter plate types',
                  ),
                ),
                if (categories.length > 1) ...<Widget>[
                  const SizedBox(height: 12),
                  PdFilterRow(
                    children: <Widget>[
                      PdFilterChip(
                        label: 'All',
                        count: items.length,
                        selected: _category == null,
                        onTap: () => setState(() => _category = null),
                      ),
                      for (final String c in categories)
                        PdFilterChip(
                          label: c,
                          count: items
                              .where((CatalogueItem i) => i.section.title == c)
                              .length,
                          selected: _category == c,
                          onTap: () => setState(() => _category = c),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                PdAutoGrid(
                  minWidth: 380,
                  gap: 24,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (shown.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            child: Text(
                              'No plate type matches '
                              '“${_q.text.trim()}”.',
                              style: body(t),
                            ),
                          ),
                        for (final CatalogueItem item in shown) ...<Widget>[
                          _TypeRow(
                            item: item,
                            selected: identical(item, selected),
                            onTap: () => setState(() => _selected = item),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                    if (selected != null)
                      _TypeDetail(
                        item: selected,
                        onPlay: () => nav.go(PdLocation.playground(selected)),
                      ),
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

class _Header extends StatelessWidget {
  const _Header({
    required this.source,
    required this.native,
    required this.iso,
    required this.types,
  });

  final GallerySource source;
  final String native;
  final String iso;
  final int types;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final String packages = source.packageNames.join(' ');
    return PdAutoGrid(
      minWidth: 340,
      gap: 48,
      rowGap: 16,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
              spacing: 12,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                Text(
                  source.countryName,
                  style: TextStyle(
                    fontSize: pdClamp(context, 28, 4, 40),
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.02 * pdClamp(context, 28, 4, 40),
                    color: t.text,
                  ),
                ),
                if (native.isNotEmpty && native != source.countryName)
                  Text(
                    native,
                    style: TextStyle(
                      fontFamily: PdFonts.persian,
                      fontSize: 20,
                      color: t.muted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              <String>[
                '$types plate ${types == 1 ? 'type' : 'types'}',
                if (iso.isNotEmpty) iso,
                ...source.packageNames,
              ].join(' · '),
              style: body(t),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: PdInstallBar(command: 'flutter pub add plate_core $packages'),
        ),
      ],
    );
  }
}

/// One plate type: its plate at thumbnail width, its label, its section and
/// the spec the developer would name.
class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CatalogueItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PlateSpec spec = item.entry.spec;
    return PdTappable(
      onTap: onTap,
      radius: PdRadius.card,
      selected: selected,
      color: selected ? t.surface : null,
      hoverColor: selected ? null : t.surface,
      border: selected ? t.accent : t.divider,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 132,
            child: StaticPlate(
              spec: spec,
              values: item.entry.sampleValues,
              theme: item.entry.theme,
              country: item.entry.country,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.entry.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.section.title} · ${spec.slotCount} slots',
                  style: TextStyle(fontSize: 13, color: t.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  specName(item) ?? spec.id,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: PdFonts.mono,
                    fontSize: 12,
                    color: t.subtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The selected type at full width, with the facts the playground would
/// otherwise be the only place to read.
class _TypeDetail extends StatelessWidget {
  const _TypeDetail({required this.item, required this.onPlay});

  final CatalogueItem item;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final GalleryEntry entry = item.entry;
    final PlateSpec spec = entry.spec;
    final String package = packageOf(item);
    final List<(String, String, bool)> facts = <(String, String, bool)>[
      ('Spec', specName(item) ?? spec.id, true),
      ('Slots', slotPattern(spec), false),
      ('Colours', entry.theme == null ? 'Ambient theme' : 'Own livery', false),
      ('Package', package, true),
      ('Route', PdLocation.playground(item).path, true),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(PdRadius.stage),
        border: Border.all(color: t.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.section.title,
            style: TextStyle(fontSize: 13, color: t.subtle),
          ),
          const SizedBox(height: 4),
          Text(entry.label, style: h3(t).copyWith(fontSize: 20, height: 1.3)),
          const SizedBox(height: 16),
          StaticPlate(
            spec: spec,
            values: entry.sampleValues,
            theme: entry.theme,
            country: entry.country,
          ),
          if (entry.note != null) ...<Widget>[
            const SizedBox(height: 16),
            Text(entry.note!, style: body(t, size: 15)),
          ],
          const SizedBox(height: 16),
          for (final (String k, String v, bool mono) in facts)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 72,
                    child: Text(
                      k,
                      style: TextStyle(fontSize: 14, color: t.subtle),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      v,
                      style: mono
                          ? monoStyle(t, size: 13)
                          : TextStyle(fontSize: 14, color: t.text),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: PdButton(
              label: 'Try in playground →',
              onTap: onPlay,
              kind: PdButtonKind.outline,
            ),
          ),
        ],
      ),
    );
  }
}
