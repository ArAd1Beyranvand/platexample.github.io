import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../poster/poster_tokens.dart';
import '../shell/mobile_panel.dart';
import '../shell/nocturne_bottom_bar.dart';
import '../shell/nocturne_mobile_header.dart';
import '../shell/nocturne_rail.dart';
import '../shell/page_rise_route.dart';
import '../shell/shell_route_state.dart';
import '../theme/nocturne.dart';
import 'showcase_screen.dart';
import 'gallery/screens/about_screen.dart';
import 'gallery/screens/country_detail_screen.dart';
import 'gallery/screens/discover_screen.dart';
import 'gallery/screens/plate_detail_screen.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/sources/sources.dart';

typedef _Destination = ({IconData icon, IconData selected, String label});

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
  State<GalleryShellScreen> createState() => GalleryShellState();
}

/// Public only for [AppRouterDelegate.popRoute], which needs to offer the back
/// gesture to the shell's nested Discover navigator before the root one. All
/// of it but [maybePopDiscover] is private in practice.
class GalleryShellState extends State<GalleryShellScreen> {
  /// The Discover tab's own navigator. Country and plate pages push here, not
  /// onto the root one, which is what keeps the rail/header/bottom bar in the
  /// tree while a detail page is open — the whole point of sk17.
  ///
  /// Only Discover needs one: Showcase and About push nothing.
  final GlobalKey<NavigatorState> _discoverNavigatorKey = GlobalKey<NavigatorState>();

  /// What the chrome renders off. Recomputed by [_syncRouteState] whenever the
  /// nested stack or the tab changes, and read by the rail, the header and the
  /// bottom bar through [ValueListenableBuilder], so a push repaints the
  /// chrome without rebuilding the tab bodies.
  late final ValueNotifier<ShellRouteState> _routeState =
      ValueNotifier<ShellRouteState>(ShellRouteState(tab: widget.tab));

  /// A mirror of the nested navigator's stack, kept here because a
  /// [NavigatorState] will not tell you what is on it. Each entry is whether
  /// that page is a plate detail; the list's length is the depth.
  final List<bool> _discoverStack = <bool>[];

  @override
  void didUpdateWidget(GalleryShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tab != widget.tab) _syncRouteState();
  }

  @override
  void dispose() {
    _routeState.dispose();
    super.dispose();
  }

  void _syncRouteState() {
    _routeState.value = ShellRouteState(
      tab: widget.tab,
      // Only Discover has a stack; on the other tabs the chrome must read
      // depth 0 even if a Discover detail page is still parked behind them.
      depth: widget.tab == AppTab.discover ? _discoverStack.length : 0,
      isPlateDetail: widget.tab == AppTab.discover && _discoverStack.isNotEmpty && _discoverStack.last,
    );
  }

  /// Pushes onto the Discover navigator and records what went on. The route's
  /// future completes on pop however it was popped — back gesture, breadcrumb,
  /// or [_resetDiscover] — so this is the one place the mirror is trimmed.
  void _pushDiscover({required bool isPlateDetail, required WidgetBuilder builder}) {
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null) return;

    final int depthAfterPush = _discoverStack.length + 1;
    _discoverStack.add(isPlateDetail);
    _syncRouteState();

    navigator.push(PageRiseRoute<void>(builder: builder)).then((_) {
      if (!mounted) return;
      // Trim to just below this route's own position rather than removing one
      // entry: `popUntil` can take several pages off at once, and the futures
      // then complete deepest-first.
      if (_discoverStack.length >= depthAfterPush) {
        _discoverStack.removeRange(depthAfterPush - 1, _discoverStack.length);
      }
      _syncRouteState();
    });
  }

  void _openPlate(CatalogueItem item, String heroTag) => _pushDiscover(
    isPlateDetail: true,
    builder: (BuildContext context) => PlateDetailScreen(
      item: item,
      heroTag: heroTag,
      onOpenDiscover: _resetDiscover,
      // Pops one level rather than pushing a country page: a plate opened off
      // a country page already has one underneath it on the stack, and a
      // plate opened straight from Discover has none to return to, so this
      // is the same "go back" the circular button offers, just from a second
      // place in the breadcrumb.
      onOpenCountry: (GallerySource source) => Navigator.of(context).maybePop(),
    ),
  );

  WidgetBuilder _countryBuilder(GallerySource source) => (BuildContext context) => CountryDetailScreen(
    source: source,
    onOpenPlate: _openPlate,
    onOpenDiscover: _resetDiscover,
    onSwitchCountry: _switchCountry,
  );

  void _openCountry(GallerySource source) =>
      _pushDiscover(isPlateDetail: false, builder: _countryBuilder(source));

  /// `OTHER COUNTRIES` on the mobile country page: replaces the current
  /// country page with another one, so the nested stack's depth never grows
  /// and the back gesture still returns to Discover rather than unwinding
  /// through every country visited along the way.
  void _switchCountry(GallerySource source) {
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.pushReplacement<void, void>(PageRiseRoute<void>(builder: _countryBuilder(source)));
  }

  /// Tapping the already-selected Discover destination returns to its index,
  /// the way tapping a selected tab does everywhere else. Tapping a *different*
  /// destination leaves the stack alone, so coming back to Discover lands on
  /// the page you left — the [IndexedStack] was already preserving the tab
  /// bodies that way, and the nested navigator now preserves the pushes too.
  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.discover && widget.tab == AppTab.discover) {
      _resetDiscover();
      return;
    }
    widget.onTabSelected(tab);
  }

  void _resetDiscover() => _discoverNavigatorKey.currentState?.popUntil((Route<void> route) => route.isFirst);

  /// Back, for [AppRouterDelegate]: pops one nested Discover page if there is
  /// one, and reports whether it did. Returning false lets the router fall
  /// through to the root navigator and then to changing tabs.
  Future<bool> maybePopDiscover() async {
    if (widget.tab != AppTab.discover) return false;
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return false;
    return navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> forceMobilePanel = MobilePanelScope.of(context);
    final int selected = widget.tab.index;

    final Widget body = IndexedStack(
      index: selected,
      children: <Widget>[
        ShowcaseScreen(onOpenTab: widget.onTabSelected),
        // Discover is the nested navigator, and the index screen is its root
        // page. The navigator sits *inside* the IndexedStack so switching tabs
        // keeps the pushed pages mounted, exactly as it keeps the scroll
        // offsets.
        Navigator(
          key: _discoverNavigatorKey,
          onGenerateRoute: (RouteSettings settings) => PageRiseRoute<void>(
            settings: settings,
            builder: (BuildContext context) =>
                DiscoverScreen(onOpenPlate: _openPlate, onOpenCountry: _openCountry),
          ),
        ),
        const AboutScreen(),
      ],
    );

    // A [LayoutBuilder], not [MediaQuery]: the showcase renders this shell
    // again inside its simulated device frames, and those frames need the
    // layout their own narrow width calls for, not the window's. Forcing the
    // mobile panel (below) relies on the same thing — [MobilePanelChrome]
    // narrows the constraints this builder sees, and that alone is what
    // switches the layout, with no need for this widget to read the toggle.
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= NBreak.shell;

        if (wide) {
          // The page and the rail are two columns of one Row, as the design's
          // `grid-template-columns: minmax(0,1fr) 208px` has them.
          //
          // The page column must be clipped. ShowcaseScreen's poster paints
          // full-bleed backdrop layers with `clipBehavior: Clip.none`, sized off
          // the whole window; unclipped they bleed straight across the rail's
          // column. An earlier pass floated the rail in a Stack painted on top to
          // dodge that, but the new rail has no fill of its own — only a
          // `border-left` — so bleed would still show through it. Clipping is
          // also what the export does: `<main>` carries `overflow: hidden`.
          return Scaffold(
            backgroundColor: PosterColors.pageBlack,
            body: Row(
              children: <Widget>[
                Expanded(child: ClipRect(child: body)),
                // The rail is always shown on desktop, and `02 Discover` stays
                // selected on the country and plate pages: they are Discover,
                // one level down, not somewhere else.
                ValueListenableBuilder<bool>(
                  valueListenable: forceMobilePanel,
                  builder: (BuildContext context, bool forced, _) => NocturneRail(
                    tab: widget.tab,
                    onTabSelected: _onTabSelected,
                    onToggleView: () => forceMobilePanel.value = !forceMobilePanel.value,
                    viewLabel: forced ? 'DESKTOP VIEW' : 'MOBILE VIEW',
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: PosterColors.pageBlack,
          body: ValueListenableBuilder<ShellRouteState>(
            valueListenable: _routeState,
            // The tab bodies are the one thing that must not rebuild when the
            // chrome does — the IndexedStack and the nested navigator both
            // hold state the pages depend on.
            child: body,
            builder: (BuildContext context, ShellRouteState route, Widget? tabBodies) {
              final String? label = route.headerLabel;
              return Column(
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: forceMobilePanel,
                    builder: (BuildContext context, bool forced, _) {
                      Widget? trailing;
                      if (forced) {
                        trailing = GestureDetector(
                          onTap: () => forceMobilePanel.value = false,
                          child: Text('DESKTOP VIEW', style: NType.pill.copyWith(color: N.accent)),
                        );
                      } else if (label != null) {
                        trailing = Text(label, style: NType.pill.copyWith(color: N.n600));
                      }
                      return NocturneMobileHeader(trailing: trailing);
                    },
                  ),
                  Expanded(child: tabBodies!),
                  if (route.showsBottomBar) NocturneBottomBar(tab: route.tab, onTabSelected: _onTabSelected),
                ],
              );
            },
          ),
        );
      },
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
///
/// Out of the widget tree as of sk4 — [NocturneRail] replaced it — but kept
/// here because [_BottomNavBar] still shares [_NavItem] and [_IndicatorBand]
/// with it. sk15 deletes the lot.
// ignore: unused_element
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
///
/// Out of the widget tree as of sk5 — [NocturneBottomBar] replaced it — but
/// kept, like [_SideNavBar], because it still shares [_NavItem] and
/// [_IndicatorBand] with it. sk15 deletes the lot.
// ignore: unused_element
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
