import 'package:flutter/material.dart';

/// The design's `pg-rise` entrance, as a route transition: a 10px rise under a
/// fade, over 200ms.
///
/// Material's own page routes are wrong for the nested stack twice over. The
/// slide (or zoom, depending on platform) reads as leaving the app, when the
/// chrome around the page is visibly staying put; and on web the default is a
/// fade-upwards that animates the *whole* page including the scrim behind it.
/// This is the same motion the design's pages use when their content arrives.
class PageRiseRoute<T> extends PageRouteBuilder<T> {
  /// [instant] skips the fade/rise entirely — used when a page is only being
  /// built to sit underneath another one that's about to push on top of it,
  /// so it should never itself be visible mid-transition (e.g. the country
  /// page built as the plate page's ancestor when opening a plate straight
  /// from Showcase, where nothing on the Discover stack exists yet).
  PageRiseRoute({required WidgetBuilder builder, super.settings, bool instant = false})
      : super(
          transitionDuration: instant ? Duration.zero : const Duration(milliseconds: 200),
          reverseTransitionDuration: instant ? Duration.zero : const Duration(milliseconds: 200),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondary) =>
              builder(context),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final CurvedAnimation curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                // 10px of a 812px-tall phone panel, expressed as a fraction of
                // the page's own height so it is 10px on any device.
                position: Tween<Offset>(
                  begin: const Offset(0, 10 / 812),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );

  /// Opaque, like the pages it replaces: the nested navigator's root stays
  /// mounted underneath, and letting it show through would double-paint the
  /// Discover index behind a detail page.
  @override
  bool get opaque => true;
}
