import 'package:flutter/material.dart';

import '../screens/gallery/catalogue_index.dart';
import '../screens/gallery/catalogue_stats.dart';
import '../screens/showcase/hero.dart';
import 'archive_strip.dart';
import 'deck_device_sync.dart';
import 'mobile_deck_section.dart';
import 'mobile_device_section.dart';
import '../screens/gallery/sources/sources.dart';
import 'package_carousel.dart';

/// The showcase below [NBreak.panel]: hero, device frame, package carousel,
/// feature deck, archive strip, in the design's order.
///
/// The header and tab bar belong to the shell, which pins them around every tab.
class MobileBody extends StatefulWidget {
  const MobileBody({
    super.key,
    required this.stats,
    required this.onOpenArchive,
    required this.onOpenPlate,
    required this.onOpenCountry,
  });

  final CatalogueStats stats;
  final VoidCallback onOpenArchive;
  final void Function(CatalogueItem item, String heroTag) onOpenPlate;

  final ValueChanged<GallerySource> onOpenCountry;

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  final DeckDeviceSync _sync = DeckDeviceSync();

  @override
  void dispose() {
    _sync.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MobileHeroText(onOpenArchive: widget.onOpenArchive),
          MobileDeviceSection(sync: _sync, onOpenPlate: widget.onOpenPlate),
          PackageCarousel(onOpenCountry: widget.onOpenCountry),
          MobileDeckSection(sync: _sync),
          ArchiveStrip(stats: widget.stats),
        ],
      ),
    );
  }
}
