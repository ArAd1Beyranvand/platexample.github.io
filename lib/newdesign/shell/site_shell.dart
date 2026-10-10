import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plate_core/plate_core.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../app/pd_app.dart';
import '../data/catalogue.dart';
import '../design/tokens.dart';
import '../widgets/controls.dart';

const double kHeaderHeight = 56;
const String kGithubUrl = 'https://github.com/ArAd1Beyranvand/plate-core';

/// Every page: the sticky header over the page body, the `/` shortcut, and
/// the mobile menu sheet.
class SiteShell extends StatefulWidget {
  const SiteShell({
    super.key,
    required this.location,
    required this.go,
    required this.searchFocus,
    required this.child,
  });

  final PdLocation location;
  final ValueChanged<PdLocation> go;
  final FocusNode searchFocus;
  final Widget child;

  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  /// `/` focuses search unless the user is typing into something.
  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent || event.character != '/') return false;
    final BuildContext? focused = FocusManager.instance.primaryFocus?.context;
    if (focused != null &&
        (focused.findAncestorWidgetOfExactType<EditableText>() != null ||
            focused.widget is EditableText ||
            focused.findAncestorWidgetOfExactType<PlateCanvas>() != null)) {
      return false;
    }
    _go(const PdLocation.landing(LandingAnchor.coverage));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.searchFocus.requestFocus(),
    );
    return true;
  }

  void _go(PdLocation location) {
    setState(() => _menuOpen = false);
    widget.go(location);
  }

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdNav(
      location: widget.location,
      go: _go,
      searchFocus: widget.searchFocus,
      child: Material(
        color: t.bg,
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: widget.child),
            if (_menuOpen)
              Positioned.fill(top: kHeaderHeight, child: const _MenuSheet()),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: _Header(
                menuOpen: _menuOpen,
                onMenu: () => setState(() => _menuOpen = !_menuOpen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink {
  const _NavLink(this.label, this.target, this.isActive);

  final String label;
  final PdLocation Function() target;
  final bool Function(PdLocation) isActive;
}

final List<_NavLink> _links = <_NavLink>[
  _NavLink(
    'Plates',
    () => const PdLocation.landing(LandingAnchor.coverage),
    (PdLocation l) => l.anchor == LandingAnchor.coverage && !l.isPlayground,
  ),
  _NavLink(
    'Europe',
    () => PdLocation.region(europeRegion),
    // Active on the region and on any country inside it, since that country
    // was reached through here.
    (PdLocation l) =>
        identical(l.source, europeRegion) ||
        (l.source != null && identical(regionOf(l.source!), europeRegion)),
  ),
  _NavLink(
    'Playground',
    () => PdLocation.defaultPlayground,
    (PdLocation l) => l.isPlayground,
  ),
  _NavLink(
    'Get started',
    () => const PdLocation.landing(LandingAnchor.start),
    (PdLocation l) => l.anchor == LandingAnchor.start && !l.isPlayground,
  ),
  _NavLink(
    'About',
    () => const PdLocation.landing(LandingAnchor.about),
    (PdLocation l) => l.anchor == LandingAnchor.about && !l.isPlayground,
  ),
];

class _Header extends StatelessWidget {
  const _Header({required this.menuOpen, required this.onMenu});

  final bool menuOpen;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final bool wide = MediaQuery.sizeOf(context).width >= 820;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: kHeaderHeight,
          decoration: BoxDecoration(
            color: t.bg.withValues(alpha: 0.85),
            border: Border(bottom: BorderSide(color: t.divider)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: pdClamp(context, 16, 3, 32),
          ),
          child: Row(
            children: <Widget>[
              PdTappable(
                onTap: () => nav.go(const PdLocation.landing()),
                semanticLabel: 'platexample home',
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: const _Logo(),
              ),
              const Spacer(),
              if (wide)
                // Shrinks rather than overflows when a fallback font runs wide.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: <Widget>[
                        for (final _NavLink link in _links)
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: _HeaderLink(
                              label: link.label,
                              active: link.isActive(nav.location),
                              onTap: () => nav.go(link.target()),
                            ),
                          ),
                        const SizedBox(width: 12),
                        _SearchButton(onTap: nav.openSearch),
                        const SizedBox(width: 8),
                        const _ThemeToggle(),
                        const SizedBox(width: 4),
                        _HeaderLink(
                          label: 'GitHub ↗',
                          active: false,
                          onTap: () => openExternal(kGithubUrl),
                        ),
                      ],
                    ),
                  ),
                )
              else ...<Widget>[
                _IconButton(
                  icon: Icons.search,
                  label: 'Search plates',
                  onTap: nav.openSearch,
                ),
                const _ThemeToggle(),
                _IconButton(
                  icon: menuOpen ? Icons.close : Icons.menu,
                  label: menuOpen ? 'Close menu' : 'Menu',
                  size: 44,
                  onTap: onMenu,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 30,
          height: 12,
          decoration: BoxDecoration(
            border: Border.all(color: t.text, width: 1.5),
            borderRadius: BorderRadius.circular(2),
          ),
          alignment: Alignment.centerLeft,
          child: Container(width: 6, color: t.accent),
        ),
        const SizedBox(width: 8),
        Text(
          'platexample',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: t.text,
          ),
        ),
      ],
    );
  }
}

class _HeaderLink extends StatelessWidget {
  const _HeaderLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      height: 36,
      selected: active,
      hoverColor: t.surface,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: active ? t.text : t.muted,
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      height: 36,
      border: t.divider,
      hoverColor: t.surface,
      padding: const EdgeInsets.only(left: 10, right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.search, size: 16, color: t.subtle),
          const SizedBox(width: 6),
          Text('Search plates', style: TextStyle(fontSize: 14, color: t.muted)),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(color: t.divider),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '/',
              style: TextStyle(
                fontFamily: PdFonts.mono,
                fontSize: 12,
                color: t.subtle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 36,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      width: size,
      height: size,
      hoverColor: t.surface,
      semanticLabel: label,
      child: Icon(icon, size: 20, color: t.muted),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return _IconButton(
      icon: b == Brightness.dark
          ? Icons.light_mode_outlined
          : Icons.dark_mode_outlined,
      label: b == Brightness.dark
          ? 'Switch to light theme'
          : 'Switch to dark theme',
      onTap: () => PdThemeScope.of(context).toggle(b),
    );
  }
}

class _MenuSheet extends StatelessWidget {
  const _MenuSheet();

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final PdNav nav = PdNav.of(context);
    final List<(String, VoidCallback)> items = <(String, VoidCallback)>[
      for (final _NavLink link in _links)
        (link.label, () => nav.go(link.target())),
      ('GitHub ↗', () => openExternal(kGithubUrl)),
    ];
    return Material(
      color: t.bg,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: pdClamp(context, 16, 3, 32)),
        children: <Widget>[
          for (final (String label, VoidCallback onTap) in items)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: t.divider)),
              ),
              child: PdTappable(
                onTap: onTap,
                height: 56,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
