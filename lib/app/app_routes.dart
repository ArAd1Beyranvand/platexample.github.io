/// The app's address space.
///
/// Three tabs, three paths, and one alias: `/` is the showcase, so
/// `platexample.ir` and `platexample.ir/showcase` are the same page. Paths are
/// declared here and nowhere else — the shell's nav bar, the parser and the
/// delegate all read them off this enum, so renaming a URL is a one-line edit.
enum AppTab {
  showcase('/showcase'),
  discover('/discover'),
  about('/about');

  const AppTab(this.path);

  /// The path this tab is addressed by. [AppTab.showcase] additionally answers
  /// to `/` — see [fromUri] — but reports `/showcase` as its canonical form so
  /// the address bar settles on one spelling.
  final String path;

  /// The tab a browser location names, defaulting to the showcase for `/`,
  /// for an empty path, and for anything unrecognised — an app with no
  /// server-side 404 has nothing better to show than its front page.
  static AppTab fromUri(Uri uri) {
    final String path = uri.path.endsWith('/') && uri.path.length > 1
        ? uri.path.substring(0, uri.path.length - 1)
        : uri.path;
    for (final AppTab tab in AppTab.values) {
      if (tab.path == path) return tab;
    }
    return AppTab.showcase;
  }
}
