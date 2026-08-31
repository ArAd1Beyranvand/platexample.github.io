// STABLE — presentation subsystem. Do not refactor for consistency with other
// layers; change only for rendering bugs.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'device_config.dart';

/// Where the page on the glass is in its fade, published by [DeviceFrame] so
/// individual pieces of that page can run their own entrance/exit on top of the
/// frame's plain cross-fade.
///
/// [progress] is LINEAR — deliberately not the eased curve that drives the
/// frame's opacity. A per-tile "random velocity" only reads as constant speed if
/// the clock it runs on is uniform; feeding it an easeIn would make every tile
/// accelerate together and swamp the randomness.
@immutable
class ContentDissolve {
  const ContentDissolve({
    required this.progress,
    required this.appearing,
    required this.from,
    required this.to,
    required this.transitionId,
  });

  /// The at-rest value: content fully present, no hop in flight.
  const ContentDissolve.settled(DeviceType device)
      : progress = 1.0,
        appearing = true,
        from = device,
        to = device,
        transitionId = 0;

  /// 0 → 1 across the active phase, linear.
  final double progress;

  /// True while the incoming page is fading IN, false while the outgoing page
  /// is fading OUT.
  final bool appearing;

  /// The hop in flight. Equal when nothing is happening.
  final DeviceType from;
  final DeviceType to;

  /// Bumped once per hop, so an effect can reseed its randomness per transition
  /// instead of replaying the same pattern every cycle.
  final int transitionId;

  bool get isHop => from != to;

  @override
  bool operator ==(Object other) =>
      other is ContentDissolve &&
      other.progress == progress &&
      other.appearing == appearing &&
      other.from == from &&
      other.to == to &&
      other.transitionId == transitionId;

  @override
  int get hashCode => Object.hash(progress, appearing, from, to, transitionId);
}

/// Publishes the live [ContentDissolve] to the page on the glass.
///
/// It carries a [ValueListenable], not a value: the page widget itself is cached
/// across animation ticks (see `_DeviceFrameState._screenContent`), so a scope
/// holding a changing value would either break that cache or never update. With
/// a stable listenable the cached page stays cached and only the few widgets
/// that actually paint per frame subscribe.
class ContentDissolveScope extends InheritedWidget {
  const ContentDissolveScope({
    super.key,
    required this.dissolve,
    required super.child,
  });

  final ValueListenable<ContentDissolve> dissolve;

  static ValueListenable<ContentDissolve>? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ContentDissolveScope>()
      ?.dissolve;

  @override
  bool updateShouldNotify(ContentDissolveScope old) =>
      !identical(old.dissolve, dissolve);
}
