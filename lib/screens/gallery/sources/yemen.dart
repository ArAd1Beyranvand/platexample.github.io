import 'dart:math';

import 'package:plate_core/plate_core.dart';
import 'package:yemen_plate/yemen_plate.dart';

import '../catalogue.dart';

/// `yemen_plate` has one car and one moto spec per system; their fields are
/// variable-length (number 4–6, governorate 1–2, serial 4–6), so one spec
/// covers every length and the samples are drawn at random lengths.
///
/// **A usage is not a spec.** It selects a country block (the panel caption on
/// System A, the usage word on System B) and, on System B, the field colour.
/// Both are render-time inputs: two entries can share a spec and still be two
/// different plates.
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
      'The 2026 unified white plate, the 1993 northern format, the southern '
      'governorate, Aden and Taiz plates, and Riyadh — one section each.';

  /// The word the plate itself prints for [usage] on this system, falling back
  /// to the enum's name where no source names one — a northern government or
  /// military plate carries no usage word that any source attests.
  String _word(YemenUsage usage, {required bool unified}) =>
      (unified ? usage.unifiedArabic : usage.northernArabic) ?? usage.name;

  /// System A paints every usage in the same white field — only the word in
  /// the blue side panel changes — so one usage stands for all five.
  static const YemenUsage _unifiedUsage = YemenUsage.private;

  List<GalleryEntry> _unified() => <GalleryEntry>[
    for (final (String form, PlateSpec spec) in <(String, PlateSpec)>[
      ('car', YemenUnifiedPlates.car),
      ('moto', YemenUnifiedPlates.moto),
    ])
      GalleryEntry(
        id: 'ye.unified.$form.${_unifiedUsage.name}',
        label: '${_word(_unifiedUsage, unified: true)} · $form',
        spec: spec,
        country: YemenCountry.unifiedFor(_unifiedUsage),
        theme: YemenThemes.forUnifiedUsage(_unifiedUsage),
        validator: const YemenUnifiedValidator(),
        sampleValues: YemenUnifiedSerialGenerator.generate(spec, random: _rng),
      ),
  ];

  /// System B's field colour *is* the usage class; one colour (`private`,
  /// blue, and its white variant) stands for the format.
  static const YemenUsage _northernUsage = YemenUsage.private;

  List<GalleryEntry> _northern() => <GalleryEntry>[
    for (final (String form, PlateSpec spec) in <(String, PlateSpec)>[
      ('car', YemenNorthernPlates.car),
      // ignore: deprecated_member_use
      ('moto', YemenNorthernPlates.moto),
    ])
      for (final bool white in const <bool>[false, true])
        GalleryEntry(
          id: <String>[
            'ye.northern.$form',
            _northernUsage.name,
            white ? 'white' : 'blue',
          ].join('.'),
          label: <String>[
            _word(_northernUsage, unified: false),
            form,
            white ? 'white' : 'blue',
          ].join(' · '),
          spec: spec,
          country: YemenCountry.northernFor(_northernUsage),
          theme: YemenThemes.forNorthernUsage(
            _northernUsage,
            style: YemenMilitaryStyle.classic,
            whiteBackground: white,
          ),
          validator: const YemenNorthernValidator(),
          sampleValues: YemenNorthernSerialGenerator.generate(
            spec,
            random: _rng,
          ),
        ),
  ];

  /// A southern entry: digits only, so the sample is drawn here.
  GalleryEntry _southern(
    String id,
    String label,
    PlateSpec spec,
    PlateCountry country, [
    PlateTheme theme = YemenThemes.southern,
  ]) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    country: country,
    theme: theme,
    validator: const YemenSouthernValidator(),
    sampleValues: <String?>[
      for (int i = 0; i < spec.slotCount; i++) '${1 + _rng.nextInt(9)}',
    ],
  );

  List<GalleryEntry> _governorates() => <GalleryEntry>[
    for (final (String key, YemenSouthernGovernorate g, PlateSpec car)
        in <(String, YemenSouthernGovernorate, PlateSpec)>[
          (
            'hadhramaut',
            YemenSouthernGovernorate.hadhramaut,
            YemenGovernoratePlates.hadhramaut,
          ),
          (
            'mahrah',
            YemenSouthernGovernorate.alMahrah,
            YemenGovernoratePlates.alMahrah,
          ),
          (
            'shabwah',
            YemenSouthernGovernorate.shabwah,
            YemenGovernoratePlates.shabwah,
          ),
          (
            'marib',
            YemenSouthernGovernorate.marib,
            YemenGovernoratePlates.marib,
          ),
        ])
      for (final YemenUsage usage in const <YemenUsage>[
        YemenUsage.private,
        YemenUsage.forHire,
        YemenUsage.transport,
        YemenUsage.government,
      ])
        if (!(g.banded && usage == YemenUsage.government))
          _southern(
            'ye.$key.${usage.name}',
            '$key · ${usage.name}',
            car,
            YemenCountry.southernFor(usage),
          ),
    _southern(
      'ye.hadhramaut.private.5',
      'hadhramaut · private · 5 digits',
      YemenGovernoratePlates.hadhramautFiveDigit,
      YemenCountry.southernPrivate,
    ),
    _southern(
      'ye.hadhramaut.temporary',
      'hadhramaut · temporary',
      YemenGovernoratePlates.hadhramautTemporary,
      YemenCountry.southernTemporary,
    ),
    _southern(
      'ye.shabwah.temporary',
      'shabwah · temporary',
      YemenGovernoratePlates.shabwahTemporary,
      YemenCountry.southernTemporary,
    ),
    _southern(
      'ye.hadhramaut.police',
      'hadhramaut · police',
      YemenGovernoratePlates.hadhramautPolice,
      YemenCountry.southernPolice,
    ),
    _southern(
      'ye.shabwah.police',
      'shabwah · police',
      YemenGovernoratePlates.shabwahPolice,
      YemenCountry.southernPolice,
    ),
    for (final PlateSpec moto in <PlateSpec>[
      YemenGovernoratePlates.hadhramautMotorcycle,
      YemenGovernoratePlates.alMahrahMotorcycle,
      YemenGovernoratePlates.shabwahMotorcycle,
      YemenGovernoratePlates.maribMotorcycle,
    ])
      _southern(
        moto.id,
        '${moto.id.split('.')[1]} · motorcycle',
        moto,
        moto.country,
      ),
  ];

  List<GalleryEntry> _adenTaiz() => <GalleryEntry>[
    _southern(
      'ye.aden.520x110',
      'aden · 520 x 110',
      YemenAdenPlates.oneLine,
      YemenCountry.plain,
      YemenThemes.aden,
    ),
    _southern(
      'ye.aden.335x170',
      'aden · 335 x 170',
      YemenAdenPlates.twoLine,
      YemenCountry.plain,
      YemenThemes.aden,
    ),
    _southern(
      'ye.taiz.private',
      'taiz · private and for hire',
      YemenTaizPlates.temporary,
      YemenCountry.plain,
      YemenThemes.taizPrivate,
    ),
    _southern(
      'ye.taiz.commercial',
      'taiz · commercial',
      YemenTaizPlates.temporary,
      YemenCountry.plain,
      YemenThemes.taizCommercial,
    ),
  ];

  /// One section per system, as the Iranshahr page has one per country; each
  /// leads with its car plate.
  @override
  List<GalleryEntry> get highlights => <GalleryEntry>[
    for (final GallerySection section in sections) section.entries.first,
  ];

  List<GalleryEntry> _riyadh() => <GalleryEntry>[
    for (final (String size, String values, List<PlateSpec> specs)
        in <(String, String, List<PlateSpec>)>[
          (
            'us',
            'T N J 7 6 5 3',
            <PlateSpec>[
              RiyadhPlates.private,
              RiyadhPlates.publicTransport,
              RiyadhPlates.commercial,
              RiyadhPlates.temporary,
              RiyadhPlates.diplomatic,
            ],
          ),
          (
            'eu',
            'T N J 7 3 5 6',
            <PlateSpec>[
              RiyadhPlates.euPrivate,
              RiyadhPlates.euPublicTransport,
              RiyadhPlates.euCommercial,
              RiyadhPlates.euTemporary,
              RiyadhPlates.euDiplomatic,
            ],
          ),
        ])
      for (final (int i, MapEntry<String, PlateCountry> category)
          in RiyadhCountry.byCategory.entries.indexed)
        GalleryEntry(
          id: 'ye.riyadh.$size.${category.key}',
          label:
              '${category.key.replaceAll('_', ' ')} · '
              '${size == 'us' ? '335 × 155' : '550 × 110'}',
          spec: specs[i],
          theme: RiyadhThemes.standard,
          country: category.value,
          validator: const RiyadhValidator(),
          sampleValues: values.split(' '),
        ),
  ];

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Unified (2026)',
      note:
          'The white plate the internationally recognised government began '
          'issuing in mid-2026, car then motorcycle. The field is white for '
          'every usage — only the word in the blue side panel changes — so '
          'one usage (private) stands for all five here.',
      entries: _unified(),
    ),
    GallerySection(
      title: 'Northern (1993)',
      note:
          'Still in force across the Houthi-controlled north, and still the '
          'larger share of the fleet. Governorate code above the rule, serial '
          'below; the field colour is the usage class, shown here in blue and '
          'white (private). The motorcycle geometry is unverified — a guess, marked '
          'as one in the package.',
      entries: _northern(),
    ),
    GallerySection(
      title: 'Hadhramaut, Al Mahrah, Shabwah, Marib',
      note:
          'The coloured-strip governorate plates. The strip is the usage: '
          'blue private, yellow for hire, red commercial, green government. '
          'Temporary, police and motorcycle layouts where the article shows '
          'them.',
      entries: _governorates(),
    ),
    GallerySection(
      title: 'Aden and Taiz',
      note:
          "Aden's lighthouse plate in both sizes, and Taiz's temporary plate "
          '(blue first class, red second class).',
      entries: _adenTaiz(),
    ),
    GallerySection(
      title: 'Riyadh',
      note:
          'Black on white, Arabic over a Latin echo, with a strip carrying '
          'the emblem and a category symbol; the strip colour is the '
          'category. US size with the strip on the right, EU size with it in '
          'the middle.',
      entries: _riyadh(),
    ),
  ];

  List<GallerySection>? _sections;

  /// One group per system on Yemen's page, each opening its own page.
  @override
  late final List<GallerySource> members = <GallerySource>[
    for (final GallerySection section in sections)
      GallerySectionSource(section, packageName: packageName),
  ];

  @override
  String get overviewTitle => 'Five systems, one country';
}
