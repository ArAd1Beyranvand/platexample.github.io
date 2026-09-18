import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../poster/poster_tokens.dart';
import 'showcase_screen.dart';
import 'gallery/screens/about_screen.dart';
import 'gallery/screens/country_detail_screen.dart';
import 'gallery/screens/discover_screen.dart';
import 'gallery/screens/plate_detail_screen.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/sources/sources.dart';

typedef _Destination = ({IconData icon, IconData selected, String label});

/// The horizontal band the side rail claims. The rail is docked flush to the
/// right edge and spans the full window height, so this is simply its width.
/// Wide-layout content is padded by it so the poster lays itself out in the
/// space left over rather than underneath the rail.
const double _kSideNavGutter = _SideNavBar.totalWidth;

class GalleryShellScreen extends StatefulWidget {
  const GalleryShellScreen({super.key, required this.tab, required this.onTabSelected});

  /// The tab the URL currently names. The shell does not own this — the router
  /// does, so that the address bar and the highlighted rail row can never
  /// disagree.
  final AppTab tab;

  /// Selecting a destination asks the router to navigate; the new tab comes
  /// back down through [tab] on the next build.
  final ValueChanged<AppTab> onTabSelected;

  @override
  State<GalleryShellScreen> createState() => _GalleryShellScreenState();
}

class _GalleryShellScreenState extends State<GalleryShellScreen> {

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

  /// One entry per [AppTab], in enum order — the nav bar's indexes *are* the
  /// enum's indexes, so a tab added to [AppTab] shows up here and nowhere else
  /// needs touching.
  static const Map<AppTab, _Destination> _destinationsByTab = <AppTab, _Destination>{
    AppTab.showcase: (icon: Icons.photo_library_outlined, selected: Icons.photo_library, label: 'Showcase'),
    AppTab.discover: (icon: Icons.auto_awesome_outlined, selected: Icons.auto_awesome, label: 'Discover'),
    AppTab.about: (icon: Icons.info_outline, selected: Icons.info, label: 'About'),
  };

  static final List<_Destination> _destinations = <_Destination>[
    for (final AppTab tab in AppTab.values) _destinationsByTab[tab]!,
  ];

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= 840;
    final int selected = widget.tab.index;

    final Widget body = IndexedStack(
      index: selected,
      children: <Widget>[
        const ShowcaseScreen(),
        DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
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
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(right: _kSideNavGutter),
                child: body,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: _SideNavBar(
                destinations: _destinations,
                selectedIndex: selected,
                onSelected: (int index) => widget.onTabSelected(AppTab.values[index]),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: PosterColors.pageBlack,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 68),
              child: body,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomNavBar(
              destinations: _destinations,
              selectedIndex: selected,
              onSelected: (int index) => widget.onTabSelected(AppTab.values[index]),
            ),
          ),
        ],
      ),
    );
  }
}

/// The wide-layout nav: a full-height rail docked flush to the right edge of
/// the window, with every destination spelled out in full next to its icon.
///
/// The indicator is the point of the thing. Each destination owns an equal
/// share of the *window's* height, and selecting one fills that entire share
/// with accent blue — a band running the rail's full width and a third of the
/// screen, not a pill floating in a capsule. Earlier passes kept the rail as a
/// small centred capsule and tried to stretch a pill inside it, which could
/// never read as more than a button: the capsule was the ceiling. Making the
/// rail itself full height removes the ceiling.
class _SideNavBar extends StatelessWidget {
  const _SideNavBar({required this.destinations, required this.selectedIndex, required this.onSelected});

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _borderWidth = 1.4;

  /// The rail's full painted width, its left border included.
  static const double totalWidth = 248 + _borderWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          // A vertical seam of light down the left edge, where the rail meets
          // the poster. It replaces the old capsule's all-round glow: a
          // full-height panel has only one edge facing the content, so that is
          // the only edge worth lighting.
          border: Border(left: BorderSide(color: PosterColors.navAccent.withValues(alpha: 0.5), width: _borderWidth)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[PosterColors.navSurfaceTop, PosterColors.navSurfaceBottom],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: PosterColors.navAccent.withValues(alpha: 0.3), blurRadius: 48, spreadRadius: -8),
            const BoxShadow(color: Color(0xCC000000), blurRadius: 32, offset: Offset(-12, 0)),
          ],
        ),
        // Each row is an equal fraction of whatever height the rail is given,
        // so the indicator scales with the window instead of being pinned to a
        // fixed item height. A Column of Expanded rows would do the same, but
        // the band has to slide between rows rather than cut, and only a Stack
        // lets one animated child travel behind all of them.
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double rowHeight = constraints.maxHeight / destinations.length;

            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  top: selectedIndex * rowHeight,
                  left: 0,
                  right: 0,
                  height: rowHeight,
                  child: const _IndicatorBand(),
                ),
                for (int i = 0; i < destinations.length; i++)
                  Positioned(
                    top: i * rowHeight,
                    left: 0,
                    right: 0,
                    height: rowHeight,
                    child: _NavItem(
                      index: i,
                      destination: destinations[i],
                      isSelected: selectedIndex == i,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// The selected row's fill: edge-to-edge accent blue with a bright stripe on
/// the leading edge, so the band has a crisp line where it meets the poster
/// instead of fading out into the rail's own surface.
class _IndicatorBand extends StatelessWidget {
  const _IndicatorBand({this.isVertical = true});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isVertical ? Alignment.centerLeft : Alignment.topCenter,
          end: isVertical ? Alignment.centerRight : Alignment.bottomCenter,
          colors: <Color>[PosterColors.navAccent, PosterColors.navAccent.withValues(alpha: 0.82)],
        ),
        border: isVertical
            ? Border(left: BorderSide(color: PosterColors.navAccentGlow, width: 4))
            : Border(top: BorderSide(color: PosterColors.navAccentGlow, width: 4)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: PosterColors.navAccentGlow.withValues(alpha: 0.45), blurRadius: 40, spreadRadius: -4),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.index,
    required this.destination,
    required this.isSelected,
    required this.onTap,
    this.isVertical = true,
  });

  final int index;
  final _Destination destination;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isVertical;

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

    final borderSide = widget.isVertical
        ? Border(
            left: BorderSide(
              color: PosterColors.navAccentGlow.withValues(alpha: !active && _hovered ? 0.7 : 0),
              width: 4,
            ),
          )
        : Border(
            top: BorderSide(
              color: PosterColors.navAccentGlow.withValues(alpha: !active && _hovered ? 0.7 : 0),
              width: 4,
            ),
          );

    final child = widget.isVertical
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                (widget.index + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  fontFamily: PosterFonts.martianMono,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: active ? Colors.white.withValues(alpha: 0.75) : PosterColors.inkMetaWeak.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              Icon(active ? widget.destination.selected : widget.destination.icon, color: foreground, size: 30),
              const SizedBox(width: 12),
              Text(
                widget.destination.label,
                style: TextStyle(
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 17,
                  letterSpacing: 0.2,
                  color: foreground,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(active ? widget.destination.selected : widget.destination.icon, color: foreground, size: 24),
            ],
          );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: PosterColors.navAccent.withValues(alpha: !active && _hovered ? 0.22 : 0),
            border: borderSide,
          ),
          padding: widget.isVertical ? const EdgeInsets.symmetric(horizontal: 22) : EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// The narrow-layout nav: a horizontal rail docked flush to the bottom of
/// the window, with the same visual treatment as [_SideNavBar] but rotated.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.destinations, required this.selectedIndex, required this.onSelected});

  final List<_Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _borderWidth = 1.4;
  static const double totalHeight = 68 + _borderWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: totalHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: PosterColors.navAccent.withValues(alpha: 0.5), width: _borderWidth)),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[PosterColors.navSurfaceTop, PosterColors.navSurfaceBottom],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(color: PosterColors.navAccent.withValues(alpha: 0.3), blurRadius: 48, spreadRadius: -8),
            const BoxShadow(color: Color(0xCC000000), blurRadius: 32, offset: Offset(0, -12)),
          ],
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double itemWidth = constraints.maxWidth / destinations.length;

            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOutCubic,
                  left: selectedIndex * itemWidth,
                  top: 0,
                  bottom: 0,
                  width: itemWidth,
                  child: const _IndicatorBand(isVertical: false),
                ),
                for (int i = 0; i < destinations.length; i++)
                  Positioned(
                    left: i * itemWidth,
                    top: 0,
                    bottom: 0,
                    width: itemWidth,
                    child: _NavItem(
                      index: i,
                      destination: destinations[i],
                      isSelected: selectedIndex == i,
                      onTap: () => onSelected(i),
                      isVertical: false,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
