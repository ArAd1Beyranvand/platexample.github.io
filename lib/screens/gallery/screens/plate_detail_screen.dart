import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';

import '../catalogue_index.dart';
import '../sources/sources.dart';
import '../theme/tokens.dart';
import '../widgets/plate_tile.dart';
import '../widgets/section_header.dart';

/// One plate, on its own, at size — the page a tile opens into.
///
/// The old app had nowhere to put this. Tapping a card jumped straight to the
/// playground, which meant the only way to look closely at a plate was to
/// enter edit mode on it, and the facts about it — which package draws it,
/// which spec, how many slots, whether a validator covers it — were nowhere
/// on screen at all. A catalogue that cannot answer "what am I looking at"
/// is a screensaver.
class PlateDetailScreen extends StatefulWidget {
  const PlateDetailScreen({super.key, required this.item, required this.heroTag, required this.onOpenPlayground});

  final CatalogueItem item;
  final String heroTag;
  final ValueChanged<GalleryEntry> onOpenPlayground;

  @override
  State<PlateDetailScreen> createState() => _PlateDetailScreenState();
}

class _PlateDetailScreenState extends State<PlateDetailScreen> {
  late final GalleryEntry _entry = widget.item.entry;
  late final PlateController _plate = PlateController(spec: _entry.spec, values: _entry.sampleValues);

  @override
  void dispose() {
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CatalogueItem item = widget.item;
    final PlateSpec spec = _entry.spec;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(item.source.countryName)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xl),
        children: <Widget>[
          // Tall, and left to breathe: this is the whole reason for the page.
          SizedBox(
            height: 240,
            child: Hero(
              tag: widget.heroTag,
              child: PlateFrame(
                spec: spec,
                padding: Gap.lg,
                child: PlateView(controller: _plate, theme: _entry.themeFor(_plate.values), country: _entry.country),
              ),
            ),
          ),
          const SizedBox(height: Gap.lg),
          Text(_entry.label, style: theme.textTheme.headlineSmall),
          const SizedBox(height: Gap.xs),
          Text(
            item.section.title,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: Gap.lg),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onOpenPlayground(_entry);
            },
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Open in playground'),
          ),
          const SizedBox(height: Gap.xl),
          const Eyebrow('Details'),
          const SizedBox(height: Gap.sm),
          _Fact(label: 'Package', value: item.source.packageName),
          _Fact(label: 'Spec', value: spec.id),
          _Fact(label: 'Slots', value: '${spec.slotCount}'),
          _Fact(label: 'Proportions', value: '${(spec.canvasWidth / spec.canvasHeight).toStringAsFixed(2)} : 1'),
          _Fact(
            label: 'Validator',
            value: _entry.validator == null ? 'none in this package' : _entry.validator.runtimeType.toString(),
          ),
          if (_entry.note != null) _Fact(label: 'Note', value: _entry.note!),
          const SizedBox(height: Gap.lg),
          Text(
            item.section.note,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// One label-and-value row. A table rather than prose, because these are
/// lookups: nobody reads a spec id, they check it.
class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 116,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
