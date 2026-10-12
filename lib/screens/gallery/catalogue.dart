import 'package:plate_core/plate_core.dart';
import 'package:flutter/foundation.dart';

/// One entry in the gallery: everything needed to draw one plate and say what
/// it is.
///
/// [spec] is geometry, [theme] is colour and [country] is the panel block —
/// three independent inputs to `PlateCanvas` since plate_core 0.6.0. An entry
/// binds one combination of the three and names it. Two entries can therefore
/// share a spec and still be two different plates, which is the whole point of
/// the collapse: a Yemeni government plate and a private one are one geometry
/// in two liveries, not two specs.
@immutable
class GalleryEntry {
  const GalleryEntry({
    required this.id,
    required this.label,
    required this.spec,
    this.theme,
    this.country,
    this.validator,
    this.sampleValues,
    this.themeForValues,
    this.note,
  });

  /// Stable across runs, for goldens and deep links. Never the spec's id
  /// alone: several entries share a spec.
  final String id;

  /// Human-readable, shown on the card.
  final String label;

  final PlateSpec spec;

  /// The livery, or null to inherit the app's [PlateTheme].
  final PlateTheme? theme;

  /// The panel block, or null to keep [PlateSpec.country].
  final PlateCountry? country;

  /// The advisory rule the canvas paints its red state from. Null where the
  /// package ships none.
  final PlateValidator? validator;

  /// What the catalogue draws into the plate. Null leaves it blank.
  final List<String?>? sampleValues;

  /// A livery that is a fact about the *value* rather than a choice.
  ///
  /// Gaza prints its usage class in the plate's own last two digits, so a Gaza
  /// plate recolours itself as the user types and no picker decides its
  /// colour. Every other entry leaves this null and answers from [theme].
  /// Keeping it here rather than in the card widget is what lets the card stay
  /// country-blind.
  final PlateTheme? Function(List<String?> values)? themeForValues;

  /// A line of small print under the label, where the entry needs one.
  final String? note;

  /// The livery to paint this entry in, given what is currently in its slots.
  PlateTheme? themeFor(List<String?> values) =>
      themeForValues?.call(values) ?? theme;
}

/// A run of entries under one heading — a system, a scheme, a form factor.
@immutable
class GallerySection {
  const GallerySection({
    required this.title,
    required this.note,
    required this.entries,
  });

  final String title;
  final String note;
  final List<GalleryEntry> entries;
}

/// Everything one country package offers, normalised.
///
/// This type lives in the gallery and not in `plate_core` on purpose. A
/// catalogue is a *presentation* concern: putting a `PlateCatalog` type into
/// the engine would make it know about lists of plates, which is one step from
/// knowing about countries. Each country exposes its plates its own way — two
/// bare consts, one const, `.all` lists, geometry maps — and the four adapters
/// under `sources/` are where those four idioms get normalised, once, in an
/// app instead of four times in four apps.
///
/// `abstract class`, not `interface class`: [highlights] ships a default
/// implementation in terms of [sections] so most sources need not repeat it,
/// and a source overrides it only where a section isn't one system 1:1
/// (Yemen). Sources reach that default via `extends`, not `implements`.
abstract class GallerySource {
  const GallerySource();

  /// The country, as the catalogue heads its block.
  String get countryName;

  /// The distinct countries this source actually draws, for anything that
  /// counts countries rather than sources — the stat band's
  /// COUNTRIES tile.
  ///
  /// Defaults to one-country-per-source, which is right for every source but
  /// `IranSource`: `iran_plate` also ships Bahrain and Azerbaijan behind their
  /// own sections, and [countryName] alone would undercount by two.
  List<String> get countryNames => <String>[countryName];

  /// The package that ships it.
  String get packageName;

  /// The distinct packages behind this source, for anything that counts
  /// packages — a region umbrella ships none of its own.
  List<String> get packageNames => <String>[packageName];

  /// One line for the About screen, pointing at the package's own README.
  String get note;

  List<GallerySection> get sections;

  /// One plate per system — what the home screen shows before "More" is
  /// tapped. Not one per section: Yemen's four sections are two systems (car
  /// and motorcycle are the same system in a different form factor), so its
  /// default would double up. A source overrides this where a section isn't
  /// a system 1:1; the default is right for one (Palestine: three sections,
  /// three systems) and trivially right for one section (Germany, Iran).
  List<GalleryEntry> get highlights => <GalleryEntry>[
    for (final GallerySection section in sections)
      if (section.entries.isNotEmpty) section.entries.first,
  ];

  /// The groups this source is an umbrella over — Iranshahr's countries,
  /// Yemen's systems. Non-empty makes the source's page an overview with one
  /// group per member, each linking to the member's own page, nested under
  /// this source's URL. Return the same instances on every read: routes and
  /// catalogue items compare sources by identity.
  List<GallerySource> get members => const <GallerySource>[];

  /// The overview's headline, when [members] is non-empty.
  String get overviewTitle => countryName;
}

/// A member made from one section of its umbrella — the usual shape when the
/// umbrella's sections already are its groups (Yemen's systems).
class GallerySectionSource extends GallerySource {
  GallerySectionSource(this.section, {required this.packageName});

  final GallerySection section;

  @override
  final String packageName;

  @override
  String get countryName => section.title;

  @override
  String get note => section.note;

  @override
  late final List<GallerySection> sections = <GallerySection>[section];
}

extension GallerySourceEntries on GallerySource {
  /// Every entry, sections flattened — what a picker offers and what a test
  /// counts.
  List<GalleryEntry> get entries => <GalleryEntry>[
    for (final GallerySection section in sections) ...section.entries,
  ];

  /// The distinct geometries the entries cover, by [PlateSpec.id]. The number
  /// a coverage test compares against the package's own catalogue surface.
  Set<String> get specIds => <String>{
    for (final GalleryEntry entry in entries) entry.spec.id,
  };
}
