import 'package:flutter/material.dart';

import '../../../../theme/nocturne.dart';

/// `← DISCOVER / IRAN / IR.CAR`: a round back button, then the trail in mono
/// caps. The plate-detail extension of [CountryDetailScreen]'s breadcrumb —
/// one more segment, the spec id, which is never a link because the page it
/// would point to (this one) is already open.
class PlateBreadcrumb extends StatelessWidget {
  const PlateBreadcrumb({
    super.key,
    required this.countryName,
    required this.specId,
    this.onOpenDiscover,
    this.onOpenCountry,
    this.isIranshahirOverview = false,
  });

  final String countryName;
  final String specId;

  /// `DISCOVER`. Null leaves the word inert.
  final VoidCallback? onOpenDiscover;

  /// The country segment. Null leaves it inert.
  final VoidCallback? onOpenCountry;

  /// Whether this plate is in the Iranshahr context.
  final bool isIranshahirOverview;

  /// The circle in the picture, measured off it.
  static const double buttonSize = 36;

  @override
  Widget build(BuildContext context) {
    final TextStyle crumb = NType.kicker.copyWith(color: N.n500);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _BackButton(onPressed: () => Navigator.of(context).maybePop()),
        const SizedBox(width: 16),
        _CrumbLink(label: 'Discover'.toUpperCase(), style: crumb, onPressed: onOpenDiscover),
        Text(' / ', style: crumb),
        _CrumbLink(label: countryName.toUpperCase(), style: crumb, onPressed: onOpenCountry),
        Text(' / ', style: crumb),
        Text(specId.toUpperCase(), style: crumb.copyWith(color: N.n300)),
      ],
    );
  }
}

/// The breadcrumb's circular back affordance: a 1px divider ring and an arrow,
/// lighting to the accent on hover like every other Nocturne control.
class _BackButton extends StatefulWidget {
  const _BackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: Container(
            width: PlateBreadcrumb.buttonSize,
            height: PlateBreadcrumb.buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _hovered ? N.accent700 : N.divider),
              color: _hovered ? N.accentAt(0.10) : null,
            ),
            child: Icon(
              Icons.arrow_back,
              size: 16,
              color: _hovered ? N.accent300 : N.n200,
            ),
          ),
        ),
      ),
    );
  }
}

/// One tappable word in the trail. Inert — and unhoverable — when its
/// callback is null.
class _CrumbLink extends StatefulWidget {
  const _CrumbLink({required this.label, required this.style, required this.onPressed});

  final String label;
  final TextStyle style;
  final VoidCallback? onPressed;

  @override
  State<_CrumbLink> createState() => _CrumbLinkState();
}

class _CrumbLinkState extends State<_CrumbLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.onPressed == null) return Text(widget.label, style: widget.style);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: Text(
          widget.label,
          style: widget.style.copyWith(color: _hovered ? N.n200 : widget.style.color),
        ),
      ),
    );
  }
}
