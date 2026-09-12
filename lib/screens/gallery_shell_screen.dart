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

  late GalleryEntry _entry;

  @override
  void initState() {
    super.initState();
    _entry = gallerySources.first.entries.first;
  }

  void _openPlayground(GalleryEntry entry) => setState(() {
    _entry = entry;
    _selectedTab = 3;
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

    final Widget body = IndexedStack(
      index: _selectedTab,
      children: <Widget>[
        const ShowcaseScreen(),
        DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
        BrowseScreen(onOpenPlate: _openPlate),
        PlaygroundScreen(entry: _entry, onEntryChanged: (GalleryEntry entry) => setState(() => _entry = entry)),
        const AboutScreen(),
      ],
    );

    if (wide) {
      return Scaffold(
        body: Row(
          children: <Widget>[
            Container(
              width: 80,
              color: Colors.grey.shade900,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  for (int i = 0; i < destinations.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: _NavButton(
                        icon: destinations[i].icon,
                        selectedIcon: destinations[i].selected,
                        label: destinations[i].label,
                        isSelected: _selectedTab == i,
                        onTap: () => setState(() => _selectedTab = i),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
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

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? Colors.white : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
