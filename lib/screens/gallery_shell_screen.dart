import 'dart:ui';

import 'package:flutter/material.dart';

import '../poster/poster_tokens.dart';
import 'showcase_screen.dart';
import 'gallery/screens/about_screen.dart';
import 'gallery/screens/browse_screen.dart';
import 'gallery/screens/country_detail_screen.dart';
import 'gallery/screens/discover_screen.dart';
import 'gallery/screens/plate_detail_screen.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/sources/sources.dart';

typedef _Destination = ({IconData icon, IconData selected, String label});

class GalleryShellScreen extends StatefulWidget {
  const GalleryShellScreen({super.key});

  @override
  State<GalleryShellScreen> createState() => _GalleryShellScreenState();
}

class _GalleryShellScreenState extends State<GalleryShellScreen> {
  int _selectedTab = 0;

  void _openPlate(CatalogueItem item, String heroTag) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => PlateDetailScreen(item: item, heroTag: heroTag),
    ),
  );

  void _openCountry(GallerySource source) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => CountryDetailScreen(source: source, onOpenPlate: _openPlate),
    ),
  );

  static const List<_Destination> _destinations = <_Destination>[
    (icon: Icons.photo_library_outlined, selected: Icons.photo_library, label: 'Showcase'),
    (icon: Icons.auto_awesome_outlined, selected: Icons.auto_awesome, label: 'Discover'),
    (icon: Icons.grid_view_outlined, selected: Icons.grid_view, label: 'Browse'),
    (icon: Icons.info_outline, selected: Icons.info, label: 'About'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 840;

    final Widget body = IndexedStack(
      index: _selectedTab,
      children: <Widget>[
        const ShowcaseScreen(),
        DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
        BrowseScreen(onOpenPlate: _openPlate),
        const AboutScreen(),
      ],
    );

    if (wide) {
      // A Row with the bar in its own column looks right on paper, but
      // ShowcaseScreen's poster paints itself with `clipBehavior: Clip.none`
      // full-bleed backdrop layers sized off the whole window — sharing a
      // Row with them means their sibling paints (later in the list) bleed
      // straight over the bar's column and hide it completely. Floating the
      // bar in its own Stack, painted after the poster, keeps it on top no
      // matter what the content underneath decides to bleed into.
      return Scaffold(
        backgroundColor: PosterColors.pageBlack,
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: body),
            Positioned(
              top: 28,
              left: 0,
              right: 0,
              child: Center(
                child: _TopNavBar(
                  destinations: _destinations,
                  selectedIndex: _selectedTab,
                  onSelected: (int index) => setState(() => _selectedTab = index),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: PosterColors.pageBlack,
      body: body,
      bottomNavigationBar: _GlassBottomBar(
        destinations: _destinations,
        selectedIndex: _selectedTab,
        onSelected: (int index) => setState(() => _selectedTab = index),
      ),
    );
  }
}

/// A floating glass capsule with a sliding accent-glow indicator behind the
/// active label — the wide-layout nav. It used to be a slim vertical rail of
/// bare icons pinned to the left edge: unlabelled, only 60px wide, and easy
/// to miss (or dismiss as decoration) against the poster's own artwork. This
/// is a wide horizontal bar docked to the top of the stage instead, every
/// destination spelled out in full next to its icon, so the thing that lets
/// you navigate the app actually reads as the thing that lets you navigate
/// the app.
class _TopNavBar extends StatelessWidget {
  const _TopNavBar({required this.destinations, required this.selectedIndex, required this.onSelected});

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _itemWidth = 176;
  static const double _itemHeight = 72;
  static const double _barPadding = 10;

  @override
  Widget build(BuildContext context) {
    final double indicatorLeft = _barPadding + selectedIndex * _itemWidth;

    // The glow has to be painted by a box that is *not* clipped, or the
    // rounded clip below eats every pixel the shadow spread past the bar's
    // own edge — which is exactly what made the first pass of this nav
    // invisible: the glow was there in code and nowhere on screen. The fill
    // itself no longer leans on translucency either: blurring a backdrop
    // that is itself near-black just produces more near-black, so the bar
    // is a lit, opaque object in its own right rather than a pane of glass
    // hoping for something bright behind it to bend.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        boxShadow: <BoxShadow>[
          BoxShadow(color: PosterColors.accent.withValues(alpha: 0.55), blurRadius: 64, spreadRadius: 2),
          const BoxShadow(color: Color(0xE6000000), blurRadius: 28, offset: Offset(0, 18)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF241C42), Color(0xFF140F26)],
              ),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: PosterColors.accent.withValues(alpha: 0.45), width: 1.4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _barPadding, vertical: 10),
              child: SizedBox(
                width: _itemWidth * destinations.length,
                height: _itemHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      left: indicatorLeft - _barPadding,
                      top: 0,
                      bottom: 0,
                      width: _itemWidth,
                      child: Center(
                        child: Container(
                          width: _itemWidth - 12,
                          height: _itemHeight - 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[PosterColors.accent, PosterColors.accent.withValues(alpha: 0.72)],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: PosterColors.accentRailGlow.withValues(alpha: 0.7), blurRadius: 34, spreadRadius: 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    for (int i = 0; i < destinations.length; i++)
                      Positioned(
                        left: i * _itemWidth,
                        top: 0,
                        bottom: 0,
                        width: _itemWidth,
                        child: _NavItem(
                          index: i,
                          destination: destinations[i],
                          isSelected: selectedIndex == i,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({required this.index, required this.destination, required this.isSelected, required this.onTap});

  final int index;
  final _Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected;
    final Color foreground = active
        ? Colors.white
        : _hovered
        ? PosterColors.inkDisplay2
        : PosterColors.inkMutedItalic;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          scale: active
              ? 1.0
              : _hovered
              ? 1.04
              : 1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                (widget.index + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: PosterFonts.martianMono,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: active ? Colors.white.withValues(alpha: 0.75) : PosterColors.inkMetaWeak.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 10),
              Icon(active ? widget.destination.selected : widget.destination.icon, color: foreground, size: 26),
              const SizedBox(width: 10),
              Text(
                widget.destination.label,
                style: TextStyle(
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.2,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The compact-width companion to [_OrbitRail]: the same glass and glow, laid
/// out as a floating bottom dock instead of a side rail.
class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar({required this.destinations, required this.selectedIndex, required this.onSelected});

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      // Shadow lives on this outer box, outside the clip below it — see the
      // note on [_OrbitRail.build] for why that split matters.
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: <BoxShadow>[
            BoxShadow(color: PosterColors.accent.withValues(alpha: 0.45), blurRadius: 40, spreadRadius: 0),
          ],
        ),
        // No BackdropFilter here. On mobile web the blur layer composites the
        // bar's own children into a separate surface that the browser then
        // draws flat, which swallowed the selected pill's gradient and glow —
        // the bar showed up, the indicator did not. The blur bought nothing
        // anyway: the fill underneath it is a near-opaque near-black gradient,
        // so blurring whatever sits behind it produces more of the same.
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFF241C42), Color(0xFF140F26)],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: PosterColors.accent.withValues(alpha: 0.45), width: 1.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (int i = 0; i < destinations.length; i++)
                  _BottomBarItem(
                    destination: destinations[i],
                    isSelected: selectedIndex == i,
                    onTap: () => onSelected(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({required this.destination, required this.isSelected, required this.onTap});

  final _Destination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? Colors.white : PosterColors.inkMutedItalic;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        // Both states describe the *same* shape — a gradient plus a shadow,
        // faded to nothing when unselected — rather than swapping a decoration
        // in against null. Lerping to a null gradient is where the pill went
        // missing on some renderers, and it costs nothing to keep it defined.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? <Color>[PosterColors.accent, PosterColors.accent.withValues(alpha: 0.72)]
                : <Color>[PosterColors.accent.withValues(alpha: 0), PosterColors.accent.withValues(alpha: 0)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: PosterColors.accentRailGlow.withValues(alpha: isSelected ? 0.5 : 0),
              blurRadius: 18,
            ),
          ],
        ),
        child: Icon(isSelected ? destination.selected : destination.icon, color: color, size: 22),
      ),
    );
  }
}
