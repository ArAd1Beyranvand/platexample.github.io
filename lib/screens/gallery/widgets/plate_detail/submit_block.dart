import 'package:plate_core/plate_core.dart';
import 'package:flutter/material.dart';

import '../../../../theme/nocturne.dart';
import '../../../../widgets/nocturne/n_button.dart';

/// The aside's bottom: the validator's live message (if any), then a
/// full-width `Submit plate` button, then `NOTHING LEAVES THE PAGE` centred
/// under it. Pinned to the bottom of the aside by the caller's
/// `margin-top: auto` (a [Spacer] above this in the column).
///
/// A plate with no validator shows `This plate has no validator` here instead of in a footer; a failing validator's reason
/// renders here too, never in a `SnackBar`.
class SubmitBlock extends StatelessWidget {
  const SubmitBlock({
    super.key,
    required this.verdict,
    required this.completed,
    required this.onSubmit,
  });

  final PlateValidation? verdict;
  final bool completed;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final String? message = switch (verdict) {
      null => 'This plate has no validator',
      final PlateValidation v when !v.isValid => v.reason,
      _ => null,
    };
    final Color messageColor = (verdict != null && !verdict!.isValid)
        ? N.accent300
        : N.n500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (message != null) ...<Widget>[
          Text(
            message,
            style: TextStyle(
              fontFamily: NType.archivo,
              fontSize: 13,
              color: messageColor,
            ),
          ),
          const SizedBox(height: 16),
        ],
        NButton(
          label: 'Submit plate',
          variant: NButtonVariant.primary,
          fontSize: 15,
          padding: const EdgeInsets.symmetric(vertical: 14),
          onPressed: onSubmit ?? _noop,
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            'Nothing leaves the page'.toUpperCase(),
            style: NType.kicker.copyWith(color: N.n600),
          ),
        ),
      ],
    );
  }

  static void _noop() {}
}
