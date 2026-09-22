import 'package:flutter/foundation.dart';

import '../app/app_routes.dart';

/// What the chrome needs to know about the nested Discover stack.
///
/// The rail, the mobile header and the bottom bar all vary with how deep
/// Discover is pushed, but none of them should be inspecting routes to find
/// out: a widget that calls `ModalRoute.of` reads whatever route happens to
/// enclose *it*, which for the chrome is always the shell's own page, never
/// the nested one. So the shell publishes this instead, and the chrome reads
/// a plain value.
///
/// [depth] is the number of pages pushed *on top of* the tab body — 0 on the
/// Discover index, 1 on a country page, 2 on a plate opened from one. A plate
/// can also be opened straight off the Discover index, which is why
/// [isPlateDetail] is carried rather than derived from [depth].
@immutable
class ShellRouteState {
  const ShellRouteState({required this.tab, this.depth = 0, this.isPlateDetail = false});

  /// The tab the URL names.
  final AppTab tab;

  /// How many pages the nested Discover navigator has above its root.
  final int depth;

  /// Whether the topmost nested page is a plate detail.
  final bool isPlateDetail;

  /// The mobile header's trailing text: the tab's `01 / SHOWCASE` marker
  /// normally, `PLATE DETAIL` on a plate page, and nothing on a country page —
  /// the design gives that screen a `DISCOVER / IRAN` breadcrumb in the body
  /// instead, and repeating the tab name in the corner would say it twice.
  String? get headerLabel {
    if (isPlateDetail) return 'PLATE DETAIL';
    if (depth > 0) return null;
    return '${(tab.index + 1).toString().padLeft(2, '0')} / ${_tabLabels[tab]!}';
  }

  /// The bottom bar is hidden on a plate page, where the design pins the
  /// page's own `Submit plate` bar in that space.
  bool get showsBottomBar => !isPlateDetail;

  static const Map<AppTab, String> _tabLabels = <AppTab, String>{
    AppTab.showcase: 'SHOWCASE',
    AppTab.discover: 'DISCOVER',
    AppTab.about: 'ABOUT',
  };

  @override
  bool operator ==(Object other) =>
      other is ShellRouteState &&
      other.tab == tab &&
      other.depth == depth &&
      other.isPlateDetail == isPlateDetail;

  @override
  int get hashCode => Object.hash(tab, depth, isPlateDetail);

  @override
  String toString() => 'ShellRouteState(tab: $tab, depth: $depth, isPlateDetail: $isPlateDetail)';
}
