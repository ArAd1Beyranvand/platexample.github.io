import 'package:flutter/widgets.dart';

import 'location.dart';

/// What any widget on the site can do to move around: go to a location, and
/// reach the coverage search (the header's search button and the `/` key).
class PdNav extends InheritedWidget {
  const PdNav({
    super.key,
    required this.location,
    required this.go,
    required this.openSearch,
    required this.searchFocus,
    required super.child,
  });

  final PdLocation location;
  final ValueChanged<PdLocation> go;
  final FocusNode searchFocus;

  /// Opens the landing at #coverage and focuses its search field.
  final VoidCallback openSearch;

  static PdNav of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PdNav>()!;

  @override
  bool updateShouldNotify(PdNav oldWidget) => oldWidget.location != location;
}
