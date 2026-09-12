import 'package:flutter/material.dart';

import 'package:core_plate/core_plate.dart';

import '../poster/poster_tokens.dart';
import 'showcase_screen.dart';
import 'gallery/screens/about_screen.dart';
import 'gallery/screens/browse_screen.dart';
import 'gallery/screens/country_detail_screen.dart';
import 'gallery/screens/discover_screen.dart';
import 'gallery/screens/plate_detail_screen.dart';
import 'gallery/screens/playground_screen.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/sources/sources.dart';

class GalleryShellScreen extends StatefulWidget {
  const GalleryShellScreen({super.key});

  @override
  State<GalleryShellScreen> createState() => _GalleryShellScreenState();
}

class _GalleryShellScreenState extends State<GalleryShellScreen> {
  int _selectedTab = 0;

  static const int _playgroundIndex = 2;

  late GalleryEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = gallerySources.first.entries.first;
  }

  void _openPlayground(GalleryEntry entry) => setState(() {
    _entry = entry;
    _selectedTab = 4;
  });

  void _openPlate(CatalogueItem item, String heroTag) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          PlateDetailScreen(item: item, heroTag: heroTag, onOpenPlayground: _openPlayground),
    ),
  );

  void _openCountry(GallerySource source) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => CountryDetailScreen(source: source, onOpenPlate: _openPlate),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 840;

    final List<({IconData icon, IconData selected, String label})> destinations = <
        ({IconData icon, IconData selected, String label})>[
      (icon: Icons.photo_library_outlined, selected: Icons.photo_library, label: 'Showcase'),
      (icon: Icons.auto_awesome_outlined, selected: Icons.auto_awesome, label: 'Discover'),
      (icon: Icons.grid_view_outlined, selected: Icons.grid_view, label: 'Browse'),
      (icon: Icons.edit_outlined, selected: Icons.edit, label: 'Playground'),
      (icon: Icons.info_outline, selected: Icons.info, label: 'About'),
    ];

    if (wide) {
      return Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedTab,
            onDestinationSelected: (int index) => setState(() => _selectedTab = index),
            labelType: NavigationRailLabelType.all,
            destinations: <NavigationRailDestination>[
              for (final (:IconData icon, :IconData selected, :String label) in destinations)
                NavigationRailDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: Text(label)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: <Widget>[
                const ShowcaseScreen(),
                DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
                BrowseScreen(onOpenPlate: _openPlate),
                PlaygroundScreen(entry: _entry, onEntryChanged: (GalleryEntry entry) => setState(() => _entry = entry)),
                const AboutScreen(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: <Widget>[
          const ShowcaseScreen(),
          DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
          BrowseScreen(onOpenPlate: _openPlate),
          PlaygroundScreen(entry: _entry, onEntryChanged: (GalleryEntry entry) => setState(() => _entry = entry)),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (int index) => setState(() => _selectedTab = index),
        destinations: <Widget>[
          for (final (:IconData icon, :IconData selected, :String label) in destinations)
            NavigationDestination(icon: Icon(icon), selectedIcon: Icon(selected), label: label),
        ],
      ),
    );
  }
}
