import 'package:flutter/material.dart';
import 'package:plate_core/plate_core.dart';

import '../design/tokens.dart';
import '../widgets/controls.dart';

/// Persian alphabetical order; `الف` is one plate letter, so it leads as a unit.
const List<String> _persianOrder = <String>[
  'الف', 'ا', 'ب', 'پ', 'ت', 'ث', 'ج', 'چ', 'ح', 'خ', 'د', 'ذ', 'ر', 'ز', //
  'ژ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق', 'ک', 'گ', 'ل', //
  'م', 'ن', 'و', 'ه', 'ی',
];

/// Series values that mark a plate class rather than a county letter. `ژ`
/// is stored for the wheelchair symbol, so it is never offered as a letter.
const Map<String, ({IconData? icon, String mark, String label})> _special =
    <String, ({IconData? icon, String mark, String label})>{
      'ژ': (icon: Icons.accessible, mark: '', label: 'Disabled'),
      'D': (icon: null, mark: 'D', label: 'Diplomatic'),
      'S': (icon: null, mark: 'S', label: 'Service'),
    };

/// The Iran letter sheet: every letter visible at once, one tap commits and
/// closes. Dismissing returns null and leaves the slot empty.
class LetterSheet extends StatelessWidget {
  const LetterSheet({
    super.key,
    required this.alphabet,
    this.slot,
    this.slotCount,
  });

  final PlateAlphabet alphabet;
  final int? slot;
  final int? slotCount;

  static Future<String?> show(
    BuildContext context,
    PlateAlphabet alphabet, {
    int? slot,
    int? slotCount,
  }) => showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    constraints: const BoxConstraints(maxWidth: 480),
    builder: (_) =>
        LetterSheet(alphabet: alphabet, slot: slot, slotCount: slotCount),
  );

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final List<String> letters =
        alphabet.characters
            .where((String c) => !_special.containsKey(c))
            .toList()
          ..sort((String a, String b) {
            int rank(String c) {
              final int i = _persianOrder.indexOf(c);
              return i < 0 ? _persianOrder.length : i;
            }

            return rank(a).compareTo(rank(b));
          });
    final List<String> specials = alphabet.characters
        .where(_special.containsKey)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: t.raised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(PdRadius.stage),
        ),
        border: Border.all(color: t.divider),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: t.control,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _Header(slot: slot, slotCount: slotCount),
              const SizedBox(height: 16),
              _LetterGrid(alphabet: alphabet, letters: letters),
              if (specials.isNotEmpty) ...<Widget>[
                const SizedBox(height: 18),
                Text(
                  'Special plates',
                  style: TextStyle(fontSize: 13, color: t.muted),
                ),
                const SizedBox(height: 8),
                for (final String c in specials) ...<Widget>[
                  _SpecialRow(character: c),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.slot, required this.slotCount});

  final int? slot;
  final int? slotCount;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose a letter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: t.text,
                ),
              ),
              if (slot != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  slotCount == null
                      ? 'Slot ${slot! + 1}'
                      : 'Slot ${slot! + 1} of $slotCount',
                  style: TextStyle(fontSize: 13, color: t.muted),
                ),
              ],
            ],
          ),
        ),
        PdTappable(
          onTap: () => Navigator.of(context).pop(),
          semanticLabel: 'Close',
          width: 32,
          height: 32,
          hoverColor: t.surface,
          child: Icon(Icons.close, size: 18, color: t.muted),
        ),
      ],
    );
  }
}

class _LetterGrid extends StatelessWidget {
  const _LetterGrid({required this.alphabet, required this.letters});

  final PlateAlphabet alphabet;
  final List<String> letters;

  static const int _cols = 6;
  static const double _gap = 8;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints c) {
      final double key = (c.maxWidth - _gap * (_cols - 1)) / _cols;
      return Wrap(
        spacing: _gap,
        runSpacing: _gap,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          for (final String l in letters)
            _LetterKey(
              label: alphabet.render(l),
              width: key,
              onTap: () => Navigator.of(context).pop(l),
            ),
        ],
      );
    },
  );
}

class _LetterKey extends StatelessWidget {
  const _LetterKey({
    required this.label,
    required this.width,
    required this.onTap,
  });

  final String label;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    return PdTappable(
      onTap: onTap,
      semanticLabel: 'Letter $label',
      width: width,
      height: 52,
      radius: PdRadius.card,
      color: t.surface,
      hoverColor: t.accentSoft,
      pressScale: 0.96,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontFamily: PdFonts.persian,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: t.text,
          ),
        ),
      ),
    );
  }
}

class _SpecialRow extends StatelessWidget {
  const _SpecialRow({required this.character});

  final String character;

  @override
  Widget build(BuildContext context) {
    final PdTokens t = context.tokens;
    final ({IconData? icon, String mark, String label}) s =
        _special[character]!;
    return PdTappable(
      onTap: () => Navigator.of(context).pop(character),
      semanticLabel: '${s.label} plate',
      height: 52,
      radius: PdRadius.card,
      color: t.surface,
      hoverColor: t.accentSoft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 24,
            child: s.icon != null
                ? Icon(s.icon, size: 20, color: t.text)
                : Text(
                    s.mark,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: t.text,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              s.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: t.text,
              ),
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: t.muted),
        ],
      ),
    );
  }
}
