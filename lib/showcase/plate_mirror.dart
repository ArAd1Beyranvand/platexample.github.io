import 'package:core_plate/core_plate.dart';

/// Rewrites one plate's typed value into another plate's grammar, group by
/// keyed group.
///
/// This is what lets a single device show **two plates carrying one value**:
/// the laptop types Yemen's 2026 unified plate and the 1993 northern plate
/// fills in beneath it; the tablet types a legacy West Bank plate and the Gaza
/// plate follows. It knows no country — only [PlateSpec], [PlateTextGroup] and
/// [PlateAlphabet] — so any pair of specs whose registers correspond can be
/// mirrored by naming the correspondence in a [MirrorPairs] map.
///
/// **The crossover is a display device, not a claim.** A vehicle registered on
/// one of these systems does not also hold a plate on the other, and the digits
/// shown on the second plate are not that vehicle's real registration under the
/// second scheme. The pairing exists to show two grammars writing one value
/// side by side; read it as a demonstration of the library, never as a lookup.
///
/// Matching is **by group key, not by slot index**, because corresponding
/// registers do not sit in corresponding places: Yemen's unified plate leads
/// with a five-digit number and ends with a two-digit side code, while the
/// northern plate leads with the two-digit governorate and ends with the
/// serial. Mirroring those positionally would put the governorate where the
/// serial belongs.
typedef MirrorPairs = Map<String, String>;

/// Yemen's laptop pairing: the unified plate's `number` is the northern
/// plate's `serial`, and its `sideCode` is the northern `governorate`.
///
/// The side code and the governorate register are the same two digits meaning
/// the same governorate — `06` is Al Hudaydah on both — which is why this pair
/// reads as one value in two grammars rather than as two unrelated plates.
const MirrorPairs yemenUnifiedToNorthern = <String, String>{
  'number': 'serial',
  'sideCode': 'governorate',
};

/// The tablet pairing: a legacy West Bank plate onto a Gaza plate.
///
/// `serial` and `usage` cross over; `district` does not. The West Bank district
/// digit has no Gaza counterpart — Gaza's leading slot is the literal `3` — so
/// it is deliberately absent here and the constant fills itself (see
/// [mirrorByGroup]).
///
/// Note that `usage` crossing over is a crossover of *digits*, not of meaning:
/// the two schemes' code spaces are unrelated, and `40` is a private car in the
/// West Bank and a municipality vehicle in Gaza. The two plates are painted in
/// different colours from the same typed digits for exactly that reason.
const MirrorPairs palestineWestBankToGaza = <String, String>{
  'serial': 'serial',
  'usage': 'usage',
};

/// [values], read against [from], rewritten as a value list for [to].
///
/// Returns a list of length `to.slots.length`, ready to be written into the
/// target's [PlateCardBloc] slot by slot. Two rules decide what lands where:
///
/// - **A one-character alphabet is a constant, not input.** Gaza's leading `3`
///   is printed on every Gaza plate ever issued and its alphabet holds exactly
///   that one character, so the slot is filled from the alphabet rather than
///   from the source plate. Without this the mirror would sit with an empty
///   first slot forever while the plate above it shows a district digit.
/// - **A character the target will not accept is dropped, never forced.**
///   Pushing a value into a slot whose alphabet refuses it would draw a plate
///   that cannot exist. Clearing is the honest answer.
///
/// Within a paired group the copy is positional — first character of the source
/// group to the first slot of the target group — and stops at the shorter of
/// the two, so a five-digit number mirrored into a four-digit register drops
/// its tail rather than overflowing.
List<String?> mirrorByGroup({
  required PlateSpec from,
  required PlateSpec to,
  required List<String?> values,
  required MirrorPairs pairs,
}) {
  final result = List<String?>.filled(to.slots.length, null);

  // Constants first, so a pair that also covers the slot can still override it
  // — nothing does today, but the order makes the precedence explicit.
  for (var i = 0; i < to.slots.length; i++) {
    final characters = to.slots[i].alphabet.characters;
    if (characters.length == 1) result[i] = characters.single;
  }

  for (final MapEntry(key: fromKey, value: toKey) in pairs.entries) {
    final source = _groupNamed(from, fromKey);
    final target = _groupNamed(to, toKey);
    if (source == null || target == null) continue;

    // The source group's characters, in order, with unset slots skipped rather
    // than carried as gaps — a half-typed serial mirrors as far as it has got.
    final characters = <String>[
      for (final i in source.indices)
        if (i < values.length && (values[i] ?? '').isNotEmpty) values[i]!,
    ];

    for (var n = 0; n < target.indices.length; n++) {
      final slot = target.indices[n];
      final value = n < characters.length ? characters[n] : '';
      result[slot] = to.slots[slot].alphabet.accepts(value) ? value : '';
    }
  }

  return result;
}

PlateTextGroup? _groupNamed(PlateSpec spec, String key) {
  for (final group in spec.effectiveTextGroups) {
    if (group.key == key) return group;
  }
  return null;
}
