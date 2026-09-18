import 'package:core_plate/core_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Rebuilds [builder] when, and only when, [select]'s result changes.
///
/// This is core's `PlateSelector` with one addition it cannot make: the
/// notification is allowed to arrive mid-build. `PlateCanvas` notifies this
/// controller synchronously from `initState` (when it attaches its input
/// machine) and from `didUpdateWidget` (when a picker swaps the spec and the
/// controller migrates its values), and both of those run while this screen is
/// building — where `setState` on an already-built sibling is an error. The
/// screen used to dodge that by deferring one screen-wide `setState` to the
/// next frame, which rebuilt the canvas, the pad and all four pickers on every
/// keystroke. Deferring the same way per binding keeps the safety and drops
/// everything else.
class PlateBinding<T> extends StatefulWidget {
  const PlateBinding({super.key, required this.controller, required this.select, required this.builder});

  final PlateController controller;

  /// Called on every notification, so keep it cheap and free of side effects.
  final T Function(PlateController) select;

  final Widget Function(BuildContext, T) builder;

  @override
  State<PlateBinding<T>> createState() => _PlateBindingState<T>();
}

class _PlateBindingState<T> extends State<PlateBinding<T>> {
  late T _value = widget.select(widget.controller);

  /// True between noticing a change mid-build and settling it after the frame,
  /// so a burst of notifications in one frame schedules one rebuild.
  bool _settling = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(PlateBinding<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      oldWidget.controller.removeListener(_handleChange);
      widget.controller.addListener(_handleChange);
    }
    // Re-select on a swapped controller *or* a swapped selector: either can
    // pick a different value out of the same keystrokes. The selector here
    // closes over the current entry, so a picker swapping the plate lands in
    // this branch.
    _value = widget.select(widget.controller);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    // A notification can arrive in the same frame the element is retired.
    if (!mounted || _settling) return;
    final T next = widget.select(widget.controller);
    if (next == _value) return;

    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks || phase == SchedulerPhase.midFrameMicrotasks) {
      _settling = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _settling = false;
        // Re-selected rather than reusing `next`: more notifications may have
        // landed between then and now.
        if (mounted) setState(() => _value = widget.select(widget.controller));
      });
      return;
    }
    setState(() => _value = next);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}

/// The live verdict, as a quiet line rather than a red wall of text.
class VerdictBar extends StatelessWidget {
  const VerdictBar({super.key, required this.verdict, required this.completed});

  /// Null when the entry's package ships no validator for this plate.
  final PlateValidation? verdict;

  /// Whether every slot is filled. Passed in rather than read off the
  /// controller so this widget rebuilds only with the binding that selected it.
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final (IconData icon, Color color, String message) = switch (verdict) {
      null => (Icons.remove_circle_outline, colors.onSurfaceVariant, 'This package ships no validator for this plate.'),
      final PlateValidation v when !v.isValid => (Icons.info_outline, colors.error, v.reason!),
      _ when !completed => (
        Icons.more_horiz,
        colors.onSurfaceVariant,
        'Nothing wrong so far — the rule stays quiet until the last register.',
      ),
      _ => (Icons.check_circle_outline, colors.primary, 'Valid plate'),
    };
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}
