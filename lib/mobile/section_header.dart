import 'package:flutter/material.dart';

import 'mobile_tokens.dart';

/// Section header with leading label and optional trailing accent label.
///
/// Example: `ONE COUNTRY PER PACKAGE` (leading) · `ALL COUNTRIES` (trailing).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.leading,
    this.trailing,
    this.trailingColor = MobileTokens.n600,
  });

  final String leading;
  final String? trailing;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            leading.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'MartianMono',
              fontWeight: FontWeight.w400,
              fontSize: 10,
              letterSpacing: 0.12 * 10,
              color: MobileTokens.n400,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!.toUpperCase(),
            style: TextStyle(
              fontFamily: 'MartianMono',
              fontWeight: FontWeight.w400,
              fontSize: 9.5,
              letterSpacing: 0.10 * 9.5,
              color: trailingColor,
            ),
          ),
      ],
    );
  }
}
