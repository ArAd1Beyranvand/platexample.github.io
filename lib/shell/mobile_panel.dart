import 'package:flutter/material.dart';

import '../theme/nocturne.dart';

/// Whether the app is forced into the design's phone-panel presentation.
///
/// [NocturneRail]'s `MOBILE VIEW` pill flips this; nothing else does. An
/// [InheritedNotifier] rather than `provider`/`riverpod` — the app has no
/// other shared state and does not need a package for one flag.
class MobilePanelScope extends InheritedNotifier<ValueNotifier<bool>> {
  const MobilePanelScope({super.key, required ValueNotifier<bool> notifier, required super.child})
      : super(notifier: notifier);

  /// The shared toggle. Reading it (rather than [ValueNotifier.value]
  /// directly) subscribes the caller to rebuilds when it flips.
  static ValueNotifier<bool> of(BuildContext context) {
    final MobilePanelScope? scope = context.dependOnInheritedWidgetOfExactType<MobilePanelScope>();
    assert(scope != null, 'No MobilePanelScope found in context');
    return scope!.notifier!;
  }
}

/// The design's forced phone frame: a centred 390×812 box that constrains
/// everything inside it to the mobile breakpoint regardless of the window's
/// real width.
///
/// [GalleryShellScreen] never reads [MobilePanelScope] itself — this box
/// narrowing its [LayoutBuilder] constraints is what switches it to the
/// mobile layout, the same way a genuinely narrow window would.
///
/// Scrollbars need no special handling here: [NocturneScrollBehavior] (sk3)
/// already suppresses them app-wide.
class MobilePanelChrome extends StatelessWidget {
  const MobilePanelChrome({super.key, required this.child});

  final Widget child;

  static const double _width = 390;
  static const double _height = 812;
  static const double _radius = 28;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          // The lift at the top is a gradient stop from the reference CSS,
          // a few points above N.bg rather than a palette entry of its own —
          // it exists only as this gradient's other end.
          colors: <Color>[Color(0xFF0D0F16), N.bg],
          stops: <double>[0.0, 0.6],
        ),
      ),
      child: Center(
        child: Container(
          width: _width,
          height: _height,
          margin: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            border: Border.all(color: N.divider),
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: NShadow.lgShadows,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: child,
          ),
        ),
      ),
    );
  }
}
