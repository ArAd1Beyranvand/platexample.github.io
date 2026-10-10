import 'package:flutter/widgets.dart';

import 'location.dart';

/// What any widget on the site can do to move around: go to a location, and
/// reach the coverage search (the header's search button and the `/` key).
class PdNav extends InheritedWidget {
  const PdNav({
    super.key,
    required this.location,
    required this.go,
    required this.searchFocus,
    required super.child,
  });

  final PdLocation location;
  final ValueChanged<PdLocation> go;
  final FocusNode searchFocus;

  static PdNav of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PdNav>()!;

  /// Opens the landing at #coverage and focuses its search field.
  void openSearch() {
    go(const PdLocation.landing(LandingAnchor.coverage));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => searchFocus.requestFocus(),
    );
  }

  @override
  bool updateShouldNotify(PdNav oldWidget) => oldWidget.location != location;
}
