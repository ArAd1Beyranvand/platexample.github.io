import 'dart:math';

import 'package:plate_core/core_plate.dart';
import 'package:yemen_plate/yemen_plate.dart';

import '../catalogue.dart';

/// `yemen_plate` exposes geometry maps — `carGeometries` / `motoGeometries` on
/// each of the two systems, eleven specs in all — plus `car(...)` / `moto(...)`
/// lookups over them. This adapter walks the maps rather than naming consts, so
/// a geometry added to the package shows up here without this file changing.
///
/// **A usage is not a spec.** It selects a country block (the panel caption on
/// System A, the usage word on System B) and, on System B, the field colour.
/// Both are render-time inputs, so the walk below is geometries × usages: two
/// entries can share a spec and still be two different plates. That is the
/// whole of P4, seen from the outside.
class YemenSource extends GallerySource {
  YemenSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1970);

  @override
  String get countryName => 'Yemen';

  @override
  String get packageName => 'yemen_plate';

  @override
  String get note =>
      'Both systems in use today: the 2026 unified white plate and the 1993 '
      'northern format, each for cars and motorcycles. The northern '
      'motorcycle geometry is unverified and marked so in the package.';

  /// The word the plate itself prints for [usage] on this system, falling back
  /// to the enum's name where no source names one — a northern government or
  /// military plate carries no usage word that any source attests.
  String _word(YemenUsage usage, {required bool unified}) =>
      (unified ? usage.unifiedArabic : usage.northernArabic) ?? usage.name;

  /// System A paints every usage in the same white field — the only thing
  /// that changes is the word in the blue side panel — so five usages here
  /// read as one plate typed five ways, not five plates. The gallery shows
  /// the one usage that actually varies by digit count, `private`; the other
  /// four are a caption swap on an otherwise identical geometry.
  static const YemenUsage _unifiedUsage = YemenUsage.private;

  List<GalleryEntry> _unified({required bool motorcycle}) {
    final String form = motorcycle ? 'moto' : 'car';
    return <GalleryEntry>[
      for (final MapEntry<int, PlateSpec> geometry
          in (motorcycle
                  ? YemenUnifiedPlates.motoGeometries
                  : YemenUnifiedPlates.carGeometries)
              .entries)
        GalleryEntry(
          id: 'ye.unified.$form.${_unifiedUsage.name}.${geometry.key}',
          label:
              '${_word(_unifiedUsage, unified: true)} · ${geometry.key} digits',
          spec: geometry.value,
          country: YemenCountry.unifiedFor(_unifiedUsage),
          theme: YemenThemes.forUnifiedUsage(_unifiedUsage),
          validator: const YemenUnifiedValidator(),
          sampleValues: YemenUnifiedSerialGenerator.generate(
            geometry.value,
            random: _rng,
          ),
        ),
    ];
  }

  /// System B's field colour *is* the usage class, so unlike System A this is
  /// a genuine livery difference — but five colours side by side in a gallery
  /// that is meant to say "here is System B" is noise, not information. One
  /// colour (`private`, blue) stands for the format; the others are a
  /// `theme:` swap on an identical layout, same as any other usage here.
  static const YemenUsage _northernUsage = YemenUsage.private;

  List<GalleryEntry> _northern({required bool motorcycle}) {
    final String form = motorcycle ? 'moto' : 'car';
    return <GalleryEntry>[
      for (final MapEntry<(int, int), PlateSpec> geometry
          in (motorcycle
                  ? YemenNorthernPlates.motoGeometries
                  : YemenNorthernPlates.carGeometries)
              .entries)
        GalleryEntry(
          id: <String>[
            'ye.northern.$form',
            _northernUsage.name,
            '${geometry.key.$1}+${geometry.key.$2}',
          ].join('.'),
          label: <String>[
            _word(_northernUsage, unified: false),
            '${geometry.key.$1} + ${geometry.key.$2}',
          ].join(' · '),
          spec: geometry.value,
          country: YemenCountry.northernFor(_northernUsage),
          theme: YemenThemes.forNorthernUsage(
            _northernUsage,
            style: YemenMilitaryStyle.classic,
          ),
          validator: const YemenNorthernValidator(),
          sampleValues: YemenNorthernSerialGenerator.generate(
            geometry.value,
            random: _rng,
          ),
        ),
    ];
  }

  /// One plate per system, not per section: the four sections below are two
  /// systems shown in two form factors each, so the car entry leads for both
  /// — the home screen isn't the place to also distinguish car from moto.
  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    sections[0].entries.first,
    sections[2].entries.first,
  ];

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'System A — 2026 unified, car',
      note:
          'The white plate the internationally recognised government began '
          'issuing in mid-2026. The field is white for every usage — only the '
          'word in the blue side panel changes — so one usage (private) '
          'stands for all five here.',
      entries: _unified(motorcycle: false),
    ),
    GallerySection(
      title: 'System A — 2026 unified, motorcycle',
      note: 'The same content in the square form factor.',
      entries: _unified(motorcycle: true),
    ),
    GallerySection(
      title: 'System B — 1993 northern, car',
      note:
          'Still in force across the Houthi-controlled north, and still the '
          'larger share of the fleet — not a legacy format. Governorate code '
          'above the rule, serial below. The field colour is the usage class '
          '(blue private, yellow for hire, red transport, green government, '
          'black military); shown here in the one colour, blue private.',
      entries: _northern(motorcycle: false),
    ),
    GallerySection(
      title: 'System B — 1993 northern, motorcycle',
      note:
          'Unverified geometry. No official northern motorcycle design has '
          'been published, so this spec is the car content rendered into the '
          'motorcycle form factor — a guess, and marked as one in the package.',
      entries: _northern(motorcycle: true),
    ),
  ];

  List<GallerySection>? _sections;
}
