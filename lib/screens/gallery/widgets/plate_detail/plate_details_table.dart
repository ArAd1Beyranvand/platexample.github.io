import 'package:flutter/material.dart';

import '../../../../theme/nocturne.dart';

/// One `PACKAGE` / `SPEC` / `COUNTRY BLOCK` / ... row: label left, value
/// right, a solid 1px divider under it (an in-control separator, so [NRule]
/// — which fades at its ends — is the wrong widget here).
class PlateDetailRow {
  const PlateDetailRow({required this.label, required this.value, this.mono = false, this.font});

  final String label;
  final String value;

  /// `SPEC`'s value is [NType.specId]; the rest are plain Archivo.
  final bool mono;

  /// The country block's value needs [NType.forScript] rather than a fixed
  /// family — Arabic-script text on `Archivo` tofu-boxes.
  final String? font;
}

/// `DETAILS`: the key/value rows the aside shows under the input picker.
/// `PACKAGE`, `SPEC`, `COUNTRY BLOCK`, `SLOTS`, `LIVERY`, `PROPORTIONS`,
/// `VALIDATOR` — kept in full; the design's own list is shorter only because
/// the mockup picked a subset.
class PlateDetailsTable extends StatelessWidget {
  const PlateDetailsTable({super.key, required this.rows});

  final List<PlateDetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        for (final PlateDetailRow row in rows) ...<Widget>[
          _Row(row: row),
          Container(height: 1, color: N.divider),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final PlateDetailRow row;

  @override
  Widget build(BuildContext context) {
    final bool isArabic = row.font != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: <Widget>[
          Text(row.label.toUpperCase(), style: NType.kicker.copyWith(color: N.n500)),
          const Spacer(),
          Flexible(
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: row.mono ? NType.mono : (row.font ?? NType.archivo),
                fontSize: 15,
                color: N.n100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
