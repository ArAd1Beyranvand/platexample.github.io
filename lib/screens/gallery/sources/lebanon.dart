import 'dart:math';

import 'package:core_plate/core_plate.dart';
import 'package:lebanon_plate/lebanon_plate.dart';

import '../catalogue.dart';

/// `lebanon_plate` is the inverse of the other sources in this directory.
///
/// Yemen and Palestine are many geometries and few liveries, so their adapters
/// walk geometry maps and fix the usage. Lebanon is **two geometries and eight
/// liveries**: a private car, a consular car, a diplomatic car, a driving
/// school car and a tourist car are the same plate — a letter, six digits, a
/// blue band — printed on a different field. So this adapter walks the *usage*
/// enum and fixes the geometry, and the first section is the whole country.
///
/// That makes it the clearest demonstration in the catalogue of what
/// `GalleryEntry` is for: nine entries in section one share one `PlateSpec` and
/// are nine different plates, because `theme:` and `country:` are render-time
/// inputs and not properties of a geometry.
class LebanonSource extends GallerySource {
  LebanonSource();

  /// Seeded, so the page reads the same on every run and hot reload.
  final Random _rng = Random(1943);

  @override
  String get countryName => 'Lebanon';

  @override
  String get packageName => 'lebanon_plate';

  @override
  String get note =>
      'Two shapes and many colours — the inverse of the other packages here. '
      'The field colour is the usage class and the letter is the town of '
      'registration. See lebanon_plate/README.md.';

  /// The town a private plate is registered in, for the sample values.
  ///
  /// Fixed rather than drawn, because the letter is the one thing on a white
  /// Lebanese plate that carries information a viewer can read off it, and a
  /// reshuffling town on every rebuild would read as noise rather than as the
  /// point.
  static const LebanonLetter _town = LebanonLetter.b;

  /// A caption for [usage] that names the colour as well as the class, because
  /// the colour is the class here and a label that said only "consular" would
  /// leave the card's own field doing the explaining.
  static String _label(LebanonUsage usage) => switch (usage) {
    LebanonUsage.private => 'Private · white · ${_town.town}',
    LebanonUsage.consular => 'Consular · purple · C',
    LebanonUsage.diplomatic => 'Diplomatic · orange · D',
    LebanonUsage.publicInstitution => 'Public institutions · red · M',
    LebanonUsage.publicTransport => 'Public transport · red · P',
    LebanonUsage.drivingSchool => 'Driving school · yellow · M',
    LebanonUsage.transit => 'Transit · green',
    LebanonUsage.temporary => 'Temporary · brown',
    LebanonUsage.tourism => 'Tourism · pink',
  };

  /// One entry per usage in [usages], all on [spec].
  ///
  /// `letter:` and `usage:` are the generator's two ways of fixing the first
  /// slot and it refuses both at once, so a class that pins its own letter
  /// (consular `C`, diplomatic `D`) passes the usage and everything else passes
  /// the town.
  List<GalleryEntry> _liveries(PlateSpec spec, String form, Iterable<LebanonUsage> usages) => <GalleryEntry>[
    for (final LebanonUsage usage in usages)
      GalleryEntry(
        id: 'lb.$form.${usage.name}',
        label: _label(usage),
        spec: spec,
        country: LebanonCountry.forUsage(usage),
        theme: LebanonThemes.forUsage(usage),
        validator: const LebanonValidator(),
        sampleValues: usage.letter != null
            ? LebanonSerialGenerator.generate(spec, random: _rng, usage: usage)
            : LebanonSerialGenerator.generate(spec, random: _rng, letter: _town),
        note: usage.arabic == null && !usage.isWhite
            ? 'No source names the Arabic word on this band, so it carries لبنان alone.'
            : null,
      ),
  ];

  /// A short number on a full-size face — the geometry variants.
  List<GalleryEntry> _short() {
    final PlateSpec parliament = LebanonPlates.oneLineOf(digits: 3)!;
    final PlateSpec motorcycle = LebanonPlates.twoLineOf(digits: 4)!;
    return <GalleryEntry>[
      GalleryEntry(
        id: 'lb.short.mp',
        label: 'Parliament · MP · 3 digits',
        spec: parliament,
        country: LebanonCountry.forUsage(LebanonUsage.private),
        theme: LebanonThemes.forUsage(LebanonUsage.private),
        validator: const LebanonValidator(),
        sampleValues: LebanonSerialGenerator.generate(parliament, random: _rng, letter: LebanonLetter.mp),
        note:
            'Numbered 1..128, one per seat — the only documented number range '
            'in the system, and the only one the validator enforces. MP is one '
            'character in the alphabet and two glyphs on the face.',
      ),
      GalleryEntry(
        id: 'lb.short.moto',
        label: 'Motorcycle · M · 4 digits',
        spec: motorcycle,
        country: LebanonCountry.forUsage(LebanonUsage.private),
        theme: LebanonThemes.forUsage(LebanonUsage.private),
        validator: const LebanonValidator(),
        sampleValues: LebanonSerialGenerator.generate(motorcycle, random: _rng, letter: LebanonLetter.m),
        note: 'M plates have been issued with fewer than six digits since 2019.',
      ),
    ];
  }

  /// One plate per section is right here: the two geometries lead, and the
  /// short-number section leads with the plate that has a rule attached to it.
  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'One-line — the colour classes',
      note:
          'Nine cards, one PlateSpec. Lebanon colour-codes the field and not '
          'the band, so every plate here is the same geometry and the same '
          'blue band with a different theme under it. The letter is the town '
          'of registration on a white plate (B Beirut, T Tripoli, S Sidon, '
          'Z Zahleh) and the class on a coloured one.',
      entries: _liveries(LebanonPlates.oneLine, 'oneLine', LebanonUsage.values),
    ),
    GallerySection(
      title: 'Two-line — the other geometry',
      note:
          'The shorter, taller plate, band across the top instead of down the '
          'left edge. Both shapes are current; which one a vehicle carries is '
          'a matter of what fits its mounting, not of what it is for. Four of '
          'the nine liveries, since the colours are the section above.',
      entries: _liveries(LebanonPlates.twoLine, 'twoLine', const <LebanonUsage>[
        LebanonUsage.private,
        LebanonUsage.publicInstitution,
        LebanonUsage.drivingSchool,
        LebanonUsage.tourism,
      ]),
    ),
    GallerySection(
      title: 'Short numbers',
      note:
          'Six digits is the standard, and the package builds the same faces '
          'with one to six digit cells. The cells keep the six-digit pitch and '
          'stay left-aligned against the letter, because that is what a short '
          'number on a full-size plate looks like.',
      entries: _short(),
    ),
  ];

  List<GallerySection>? _sections;
}
