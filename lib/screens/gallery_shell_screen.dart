import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../mobile/mobile_header.dart';
import '../mobile/mobile_tab_bar.dart';
import '../poster/poster_tokens.dart';
import '../shell/mobile_panel.dart';
import '../shell/nocturne_rail.dart';
import '../shell/page_rise_route.dart';
import '../shell/shell_route_state.dart';
import '../theme/nocturne.dart';
import 'showcase_screen.dart';
import 'gallery/screens/about_screen.dart';
import 'gallery/screens/country_detail_screen.dart';
import 'gallery/screens/discover_screen.dart';
import 'gallery/screens/iranshahr_overview_screen.dart';
import 'gallery/screens/plate_detail_screen.dart';
import 'gallery/catalogue_index.dart';
import 'gallery/sources/sources.dart';

typedef _Destination = ({IconData icon, IconData selected, String label});

class GalleryShellScreen extends StatefulWidget {
  const GalleryShellScreen({
    super.key,
    required this.location,
    required this.onNavigate,
  });

  /// The page the URL currently names. The shell does not own this — the router
  /// does, so that the address bar, the highlighted rail row and the nested
  /// Discover stack can never disagree.
  final AppLocation location;

  /// Asks the router to navigate; the new location comes back down through
  /// [location] on the next build, and [_syncToLocation] then moves the nested
  /// stack to match.
  final ValueChanged<AppLocation> onNavigate;

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
  final GlobalKey<NavigatorState> _discoverNavigatorKey =
      GlobalKey<NavigatorState>();

  /// What the chrome renders off. Recomputed by [_syncRouteState] whenever the
  /// nested stack or the tab changes, and read by the rail, the header and the
  /// bottom bar through [ValueListenableBuilder], so a push repaints the
  /// chrome without rebuilding the tab bodies.
  late final ValueNotifier<ShellRouteState> _routeState =
      ValueNotifier<ShellRouteState>(ShellRouteState(tab: widget.location.tab));

  /// A mirror of the nested navigator's stack, kept here because a
  /// [NavigatorState] will not tell you what is on it. Each entry is the
  /// location that page shows; the list's length is the depth.
  final List<AppLocation> _discoverStack = <AppLocation>[];

  /// How many pops [_syncToLocation] has issued whose completion is still
  /// pending.
  ///
  /// A pop reports the page it uncovered back up to the router, which is what
  /// keeps the address bar in step when the user pops with the back gesture or
  /// the breadcrumb. A pop that the router itself ordered — the browser's back
  /// button, or a pasted link landing shallower — must not report, because the
  /// router is already *at* that location and `goTo` would push a second,
  /// duplicate history entry over the forward one. That is what broke browser
  /// forward: back popped the plate, the pop reported `/discover/iran`, and
  /// the new entry replaced the `/discover/iran/car` that forward would have
  /// returned to.
  ///
  /// A counter, not a bool that brackets the call to `_syncToLocation`: each
  /// `pop()` finishes only once its exit animation does, well after
  /// `_syncToLocation` itself has returned, so a bool reset at the end of that
  /// call closes the window before the pop futures it started have fired. This
  /// is incremented once per pop issued here and decremented as each one's
  /// future resolves, so the suppression lasts exactly as long as there is a
  /// router-issued pop still in flight.
  int _pendingSyncPops = 0;

  @override
  void initState() {
    super.initState();
    // A deep link is the app's first location, and the nested navigator does
    // not exist until this build completes — so the initial reconcile has to
    // wait a frame. Every later one runs synchronously in didUpdateWidget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncToLocation();
    });
  }

  @override
  void didUpdateWidget(GalleryShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) _syncToLocation();
  }

  @override
  void dispose() {
    _routeState.dispose();
    super.dispose();
  }

  /// Moves the nested Discover stack to whatever [widget.location] names.
  ///
  /// This is the one place the stack is reconciled with the URL, and it is
  /// what makes a pasted link, a browser back button and a tile tap all land
  /// in the same state. The three cases are:
  ///
  ///  * **shallower** (`/discover/iran/x` → `/discover/iran`) — pop down to the
  ///    depth the location wants;
  ///  * **deeper or sideways** — pop to the common ancestor, then push the
  ///    missing pages, so opening a plate from a link builds the country page
  ///    underneath it and back still walks plate → country → Discover;
  ///  * **already there** — the common case after a tile tap, and a no-op.
  void _syncToLocation() {
    final AppLocation target = widget.location;

    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null) {
      // Not mounted yet — only possible before the first frame, which
      // initState's callback covers. Keep the chrome honest meanwhile.
      _syncRouteState();
      return;
    }

    final List<AppLocation> wanted = _stackFor(target);

    // How much of the current stack the target shares. Countries and plates
    // are compared by identity, which is what [AppLocation]'s `==` does.
    int shared = 0;
    while (shared < wanted.length &&
        shared < _discoverStack.length &&
        _discoverStack[shared] == wanted[shared]) {
      shared++;
    }

    // Popped one at a time rather than with `popUntil`: the predicate form
    // cannot count, and the mirror is the only record of how deep the stack
    // is. Each pop's future trims the mirror once it completes, but that
    // completion lands on a later microtask — well after this loop has
    // finished running — so the number of pops to issue is fixed up front
    // from [_discoverStack]'s length *now*, rather than re-read on every
    // turn. Re-reading it here used to cap this at a single pop no matter how
    // deep the stack was, since the mirror looked unchanged immediately after
    // every `pop()` call: fine one gesture at a time (the Discover tab's own
    // navigation never asks for more than one), but wrong the moment a plate
    // opened straight from Showcase — two synthesized pages — sends the user
    // back to the bare Discover index in one hop.
    //
    // Each pop bumps [_pendingSyncPops] before it is issued, so none of these
    // reports back to the router when its future resolves — see that field's
    // doc comment.
    final int popsNeeded = _discoverStack.length - shared;
    for (int i = 0; i < popsNeeded && navigator.canPop(); i++) {
      _pendingSyncPops++;
      navigator.pop();
    }

    // [PageRiseRoute]'s fade blends its whole subtree's alpha with whatever
    // is already underneath, so it only reads right when that "underneath"
    // is a page the user was just looking at — genuine forward navigation
    // within an already-open Discover stack (`shared > 0`). Every other push
    // in this sync must be instant:
    //
    //  * ancestor pages (all but the last) are built solely so the back
    //    stack is correct and were never themselves shown, so animating them
    //    in would itself be the flash;
    //  * when `shared == 0` there is no visible predecessor at all — the
    //    stack is being built from scratch (e.g. opening a plate straight
    //    from Showcase) — so even the last page has nothing valid to fade
    //    over, and doing so just lets the freshly (instantly) built country
    //    page underneath it show through for the fade's duration. That is
    //    the "Discover flashes before the plate" bug.
    final bool hadVisiblePredecessor = shared > 0;
    for (int i = shared; i < wanted.length; i++) {
      final bool isLast = i == wanted.length - 1;
      _pushDiscover(wanted[i], instant: !isLast || !hadVisiblePredecessor);
    }
    _syncRouteState();
  }

  /// The pages that must be on the nested stack for [location] to be showing:
  /// nothing for a tab, the country for a country page, and the country *then*
  /// the plate for a plate page — so a plate opened from a link still has its
  /// country underneath it to go back to.
  List<AppLocation> _stackFor(AppLocation location) {
    final GallerySource? source = location.source;
    if (source == null) return const <AppLocation>[];
    if (location.item == null) return <AppLocation>[location];
    return <AppLocation>[
      AppLocation.country(
        source,
        isIranshahirOverview: location.isIranshahirOverview,
      ),
      location,
    ];
  }

  void _syncRouteState() {
    final AppTab tab = widget.location.tab;
    _routeState.value = ShellRouteState(
      tab: tab,
      // Only Discover has a stack; on the other tabs the chrome must read
      // depth 0 even if a Discover detail page is still parked behind them.
      depth: tab == AppTab.discover ? _discoverStack.length : 0,
      isPlateDetail:
          tab == AppTab.discover &&
          _discoverStack.isNotEmpty &&
          _discoverStack.last.isPlate,
    );
  }

  /// Pushes one page onto the Discover navigator and records what went on.
  ///
  /// The route's future completes on pop however it was popped — back gesture,
  /// breadcrumb, browser back, or [_syncToLocation] itself — so this is the one
  /// place the mirror is trimmed, and the one place a pop the router did not
  /// initiate gets reported back up to it.
  void _pushDiscover(AppLocation location, {bool instant = false}) {
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null) return;

    final int depthAfterPush = _discoverStack.length + 1;
    _discoverStack.add(location);
    _syncRouteState();

    navigator
        .push(
          PageRiseRoute<void>(builder: _builderFor(location), instant: instant),
        )
        .then((_) {
          if (!mounted) return;
          // Trim to just below this route's own position rather than removing one
          // entry: `popUntil` can take several pages off at once, and the futures
          // then complete deepest-first.
          if (_discoverStack.length >= depthAfterPush) {
            _discoverStack.removeRange(
              depthAfterPush - 1,
              _discoverStack.length,
            );
          }
          _syncRouteState();
          // Claim this resolution against a pending router-issued pop if there is
          // one. [_syncToLocation] pops deepest-first and each `push` future
          // likewise resolves deepest-first, so the counter and the futures drain
          // in the same order — the first future to resolve after N pops were
          // issued is always the deepest page's, which is always what the Nth
          // pop removed.
          final bool wasSyncPop = _pendingSyncPops > 0;
          if (wasSyncPop) _pendingSyncPops--;

          // A gesture-driven pop leaves the URL a level too deep. Report the
          // stack's new top, unless this pop was the router's own doing — see
          // [_pendingSyncPops].
          final AppLocation top = _discoverStack.isEmpty
              ? AppLocation.discover
              : _discoverStack.last;
          if (!wasSyncPop &&
              widget.location.tab == AppTab.discover &&
              widget.location != top) {
            widget.onNavigate(top);
          }
        });
  }

  WidgetBuilder _builderFor(AppLocation location) {
    final GallerySource source = location.source!;
    final CatalogueItem? item = location.item;
    if (item == null) {
      // Iranshahr overview: show the four countries as groups like Discover.
      // Only the umbrella source itself renders the overview; its four member
      // countries (which also carry `isIranshahirOverview`) fall through to the
      // regular country page below — otherwise "All plates" on a member group
      // would re-render the overview instead of that country's detail page.
      if (location.isIranshahirOverview && source.countryName == 'Iranshahr') {
        return (BuildContext context) => IranshahirOverviewScreen(
          onOpenPlate: _openPlate,
          onOpenCountry: (GallerySource countrySource) => widget.onNavigate(
            AppLocation.country(countrySource, isIranshahirOverview: true),
          ),
        );
      }
      // Regular country detail page.
      return (BuildContext context) => CountryDetailScreen(
        source: source,
        onOpenPlate: _openPlate,
        onOpenDiscover: () => widget.onNavigate(AppLocation.discover),
        onSwitchCountry: _switchCountry,
      );
    }
    return (BuildContext context) => PlateDetailScreen(
      item: item,
      heroTag: _heroTags[item] ?? 'plate-${item.entry.id}',
      isIranshahirOverview: location.isIranshahirOverview,
      onOpenDiscover: () => widget.onNavigate(AppLocation.discover),
      // Goes to the country page by URL rather than popping: a plate opened
      // from a link has its country underneath it just as a tapped one does
      // (see [_stackFor]), so this is one consistent destination either way.
      onOpenCountry: (GallerySource source) => widget.onNavigate(
        AppLocation.country(
          source,
          isIranshahirOverview: location.isIranshahirOverview,
        ),
      ),
    );
  }

  /// The hero tag the tile that opened a plate was drawn with, so the detail
  /// page can fly from it.
  ///
  /// Kept beside the stack rather than in [AppLocation]: a tag names a widget
  /// on screen, which is not something a URL can carry — a plate reached by a
  /// pasted link simply has no tile to fly from, and falls back to a tag of
  /// its own.
  final Map<CatalogueItem, String> _heroTags = <CatalogueItem, String>{};

  void _openPlate(CatalogueItem item, String heroTag) {
    _heroTags[item] = heroTag;
    widget.onNavigate(item.location);
  }

  /// Opens a plate tapped on the Showcase tab's device stage. The plate detail
  /// page lives under Discover — that is the tab whose breadcrumb and back
  /// gesture it unwinds into — so this is the same navigation a Discover tile
  /// makes, and [_syncToLocation] builds the country page underneath it.
  void _openShowcasePlate(CatalogueItem item, String heroTag) =>
      _openPlate(item, heroTag);

  void _openCountry(GallerySource source) {
    final bool isIranshahirOverview = source.countryName == 'Iranshahr';
    widget.onNavigate(
      AppLocation.country(source, isIranshahirOverview: isIranshahirOverview),
    );
  }

  /// `OTHER COUNTRIES` on the mobile country page: replaces the current
  /// country page with another one, so the nested stack's depth never grows
  /// and the back gesture still returns to Discover rather than unwinding
  /// through every country visited along the way.
  ///
  /// [_syncToLocation] would pop-then-push for this, which is a page leaving
  /// and another arriving; `pushReplacement` is the one transition the design
  /// asks for here, so the stack is moved directly and the router told after.
  void _switchCountry(GallerySource source) {
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null || _discoverStack.isEmpty) return;
    final AppLocation location = AppLocation.country(source);
    _discoverStack[_discoverStack.length - 1] = location;
    _syncRouteState();
    navigator.pushReplacement<void, void>(
      PageRiseRoute<void>(builder: _builderFor(location)),
    );
    widget.onNavigate(location);
  }

  /// Tapping the already-selected Discover destination returns to its index,
  /// the way tapping a selected tab does everywhere else. Tapping a *different*
  /// destination leaves the stack alone, so coming back to Discover lands on
  /// the page you left — the [IndexedStack] was already preserving the tab
  /// bodies that way, and the nested navigator now preserves the pushes too.
  void _onTabSelected(AppTab tab) {
    if (tab != AppTab.discover || widget.location.tab != AppTab.discover) {
      // Returning to Discover restores the page it was left on, so the URL
      // must name that page and not the bare index.
      if (tab == AppTab.discover && _discoverStack.isNotEmpty) {
        widget.onNavigate(_discoverStack.last);
        return;
      }
      widget.onNavigate(AppLocation.tab(tab));
      return;
    }
    widget.onNavigate(AppLocation.discover);
  }

  /// Back, for [AppRouterDelegate]: pops one nested Discover page if there is
  /// one, and reports whether it did. Returning false lets the router fall
  /// through to the root navigator and then to the browser's own history.
  ///
  /// The pop's own future reports the shallower location up to the router —
  /// see [_pushDiscover] — so back and the address bar stay in step.
  Future<bool> maybePopDiscover() async {
    if (widget.location.tab != AppTab.discover) return false;
    final NavigatorState? navigator = _discoverNavigatorKey.currentState;
    if (navigator == null || !navigator.canPop()) return false;
    return navigator.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> forceMobilePanel = MobilePanelScope.of(context);
    final int selected = widget.location.tab.index;

    final Widget body = IndexedStack(
      index: selected,
      children: <Widget>[
        ShowcaseScreen(
          onOpenTab: (AppTab tab) => widget.onNavigate(AppLocation.tab(tab)),
          onOpenPlate: _openShowcasePlate,
          onOpenCountry: _openCountry,
        ),
        // Discover is the nested navigator, and the index screen is its root
        // page. The navigator sits *inside* the IndexedStack so switching tabs
        // keeps the pushed pages mounted, exactly as it keeps the scroll
        // offsets.
        Navigator(
          key: _discoverNavigatorKey,
          onGenerateRoute: (RouteSettings settings) => PageRiseRoute<void>(
            settings: settings,
            builder: (BuildContext context) => DiscoverScreen(
              onOpenPlate: _openPlate,
              onOpenCountry: _openCountry,
            ),
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
                  builder: (BuildContext context, bool forced, _) =>
                      NocturneRail(
                        tab: widget.location.tab,
                        onTabSelected: _onTabSelected,
                        onToggleView: () =>
                            forceMobilePanel.value = !forceMobilePanel.value,
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
            builder:
                (
                  BuildContext context,
                  ShellRouteState route,
                  Widget? tabBodies,
                ) {
                  return Column(
                    children: <Widget>[
                      MobileHeader(label: route.headerLabel),
                      Expanded(child: tabBodies!),
                      if (route.showsBottomBar)
                        MobileTabBar(
                          tab: route.tab,
                          onTabSelected: _onTabSelected,
                        ),
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
  const _SideNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

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
          border: Border(
            left: BorderSide(
              color: PosterColors.navAccent.withValues(alpha: 0.5),
              width: _borderWidth,
            ),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              PosterColors.navSurfaceTop,
              PosterColors.navSurfaceBottom,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: PosterColors.navAccent.withValues(alpha: 0.3),
              blurRadius: 48,
              spreadRadius: -8,
            ),
            const BoxShadow(
              color: Color(0xCC000000),
              blurRadius: 32,
              offset: Offset(-12, 0),
            ),
          ],
        ),
        // Each row is an equal fraction of whatever height the rail is given,
        // so the indicator scales with the window instead of being pinned to a
        // fixed item height. A Column of Expanded rows would do the same, but
        // the band has to slide between rows rather than cut, and only a Stack
        // lets one animated child travel behind all of them.
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double rowHeight =
                constraints.maxHeight / destinations.length;

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
          colors: <Color>[
            PosterColors.navAccent,
            PosterColors.navAccent.withValues(alpha: 0.82),
          ],
        ),
        border: isVertical
            ? Border(
                left: BorderSide(color: PosterColors.navAccentGlow, width: 4),
              )
            : Border(
                top: BorderSide(color: PosterColors.navAccentGlow, width: 4),
              ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: PosterColors.navAccentGlow.withValues(alpha: 0.45),
            blurRadius: 40,
            spreadRadius: -4,
          ),
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
              color: PosterColors.navAccentGlow.withValues(
                alpha: !active && _hovered ? 0.7 : 0,
              ),
              width: 4,
            ),
          )
        : Border(
            top: BorderSide(
              color: PosterColors.navAccentGlow.withValues(
                alpha: !active && _hovered ? 0.7 : 0,
              ),
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
                  color: active
                      ? Colors.white.withValues(alpha: 0.75)
                      : PosterColors.inkMetaWeak.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                active ? widget.destination.selected : widget.destination.icon,
                color: foreground,
                size: 30,
              ),
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
              Icon(
                active ? widget.destination.selected : widget.destination.icon,
                color: foreground,
                size: 24,
              ),
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
            color: PosterColors.navAccent.withValues(
              alpha: !active && _hovered ? 0.22 : 0,
            ),
            border: borderSide,
          ),
          padding: widget.isVertical
              ? const EdgeInsets.symmetric(horizontal: 22)
              : EdgeInsets.zero,
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
  const _BottomNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

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
          border: Border(
            top: BorderSide(
              color: PosterColors.navAccent.withValues(alpha: 0.5),
              width: _borderWidth,
            ),
          ),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              PosterColors.navSurfaceTop,
              PosterColors.navSurfaceBottom,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: PosterColors.navAccent.withValues(alpha: 0.3),
              blurRadius: 48,
              spreadRadius: -8,
            ),
            const BoxShadow(
              color: Color(0xCC000000),
              blurRadius: 32,
              offset: Offset(0, -12),
            ),
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
