import 'package:flutter/material.dart';

import '../screens/gallery/catalogue_stats.dart';
import '../theme/nocturne.dart';
import 'mobile_tokens.dart';
import 'section_header.dart';

/// "THE ARCHIVE, REGISTERED" — stats rendered as a licence-plate strip
/// (PG band, four stat cells, ایران/MIT corner) with real counts.
///
/// Spec: `claude/mobile_view/MV6_archive_strip.md`
class ArchiveStrip extends StatelessWidget {
  const ArchiveStrip({super.key, required this.stats});

  final CatalogueStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
          child: SectionHeader(leading: 'THE ARCHIVE, REGISTERED'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[MobileTokens.n900, MobileTokens.bg],
              ),
              border: Border.all(color: MobileTokens.n700, width: 1.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: MobileTokens.accentAt(0.55),
                  blurRadius: 36,
                  spreadRadius: -12,
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _PGBand(),
                  ..._buildStatCells(),
                  _CornerLabel(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 36,
            left: 18,
            right: 18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'IRAN MADE · OPEN SOURCE',
                style: TextStyle(
                  fontFamily: 'MartianMono',
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                  letterSpacing: 0.10 * 9,
                  color: MobileTokens.n600,
                ),
              ),
              Text(
                'V1 · 2026',
                style: TextStyle(
                  fontFamily: 'MartianMono',
                  fontWeight: FontWeight.w400,
                  fontSize: 9,
                  letterSpacing: 0.10 * 9,
                  color: MobileTokens.n600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStatCells() {
    final List<({int value, String label})> tiles = stats.tiles;
    final List<String> shortLabels = <String>[
      'PKGS',
      'COUNTRIES',
      'SPECS',
      'FORMS',
    ];

    return <Widget>[
      for (int i = 0; i < tiles.length; i++)
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: MobileTokens.n800)),
            ),
            child: Center(
              child: _StatCell(value: tiles[i].value, label: shortLabels[i]),
            ),
          ),
        ),
    ];
  }
}

class _PGBand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      decoration: BoxDecoration(
        color: MobileTokens.accent900,
        border: Border(right: BorderSide(color: MobileTokens.n700, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: MobileTokens.accent400, width: 1),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'PG',
            style: TextStyle(
              fontFamily: 'MartianMono',
              fontWeight: FontWeight.w700,
              fontSize: 8.5,
              letterSpacing: 0.06 * 8.5,
              color: MobileTokens.accent200,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value',
              style: TextStyle(
                fontFamily: NType.archivo,
                fontWeight: FontWeight.w600,
                fontSize: 24,
                height: 1,
                letterSpacing: -0.02 * 24,
                color: MobileTokens.n100,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'MartianMono',
              fontWeight: FontWeight.w400,
              fontSize: 7.5,
              letterSpacing: 0.10 * 7.5,
              color: MobileTokens.n500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: MobileTokens.n700, width: 1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'ایران',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontWeight: FontWeight.w400,
              fontSize: 9,
              color: MobileTokens.n400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MIT',
            style: TextStyle(
              fontFamily: 'MartianMono',
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: -0.02 * 11,
              color: MobileTokens.accent300,
            ),
          ),
        ],
      ),
    );
  }
}
