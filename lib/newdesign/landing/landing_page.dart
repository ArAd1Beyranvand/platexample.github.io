import 'package:flutter/material.dart';

import '../app/location.dart';
import '../app/nav.dart';
import '../data/plate_code.dart';
import '../design/tokens.dart';
import '../shell/site_shell.dart';
import '../widgets/controls.dart';
import 'coverage.dart';
import 'hero.dart';
import 'sections.dart';

/// One scrolling page: hero, why, compare, #coverage, #start, #about.
class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
    required this.anchor,
    required this.visit,
    this.focusSearch = false,
  });

  final LandingAnchor anchor;

  /// Changes on every navigation, so re-selecting an anchor scrolls again.
  final int visit;

  /// Focus the coverage search once the scroll has arrived.
  final bool focusSearch;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scroll = ScrollController();
  final Map<LandingAnchor, GlobalKey> _keys = <LandingAnchor, GlobalKey>{
    for (final LandingAnchor a in LandingAnchor.values) a: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollToAnchor(animate: false);
  }

  @override
  void didUpdateWidget(LandingPage old) {
    super.didUpdateWidget(old);
    if (old.visit != widget.visit) _scrollToAnchor(animate: true);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToAnchor({required bool animate}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      double target = 0;
      final BuildContext? section = _keys[widget.anchor]!.currentContext;
      if (widget.anchor != LandingAnchor.top && section != null) {
        final RenderBox box = section.findRenderObject()! as RenderBox;
        final RenderBox viewport = context.findRenderObject()! as RenderBox;
        final double top = box
            .localToGlobal(Offset.zero, ancestor: viewport)
            .dy;
        target = (_scroll.offset + top - headerExtent(context) - 24).clamp(
          0,
          _scroll.position.maxScrollExtent,
        );
      }
      final Duration d = PdMotion.of(
        context,
        const Duration(milliseconds: 400),
      );
      final FocusNode? search = widget.focusSearch
          ? PdNav.of(context).searchFocus
          : null;
      if (!animate || d == Duration.zero) {
        _scroll.jumpTo(target);
        search?.requestFocus();
      } else {
        _scroll.animateTo(target, duration: d, curve: Curves.easeOutCubic).then(
          (_) {
            if (mounted) search?.requestFocus();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double gap = pdClamp(context, 48, 7, 96);
    Widget section(LandingAnchor? anchor, Widget child) => Padding(
      key: anchor == null ? null : _keys[anchor],
      padding: EdgeInsets.only(bottom: gap),
      child: PdContainer(child: child),
    );
    return SingleChildScrollView(
      controller: _scroll,
      padding: EdgeInsets.only(
        top: headerExtent(context) + pdClamp(context, 32, 5, 72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          section(
            LandingAnchor.top,
            LandingHero(
              installLine: 'flutter pub add plate_core --git-url $kCoreRepo',
            ),
          ),
          section(null, const WhySection()),
          section(null, const CompareSection()),
          section(LandingAnchor.coverage, const CoverageSection()),
          section(LandingAnchor.start, const StartSection()),
          section(LandingAnchor.about, const AboutSection()),
        ],
      ),
    );
  }
}
