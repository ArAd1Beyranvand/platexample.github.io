import 'package:iran_plate/iran_plate.dart';

import '../catalogue.dart';

/// `iran_plate` keys everything off one axis — [IranUsage] — and answers both
/// `IranPlates.forUsage` and `IranThemes.forUsage` from it. So this adapter
/// walks the enum rather than naming consts: adding a vehicle class to the
/// package shows up here without the gallery being edited.
///
/// The sample values are written out rather than generated: the package ships
/// no serial generator, and adding one to it so that a showcase could fill a
/// plate would be the gallery driving library API. Every standard-blank class
/// takes the same four fields, one string per field.
class IranSource extends GallerySource {
  const IranSource();

  @override
  String get countryName => 'Iran';

  @override
  List<String> get countryNames => const <String>['Iran'];

  @override
  String get packageName => 'iran_plate';

  @override
  String get note =>
      'One civil blank whose colours follow the series letter, plus protocol, '
      'historic and motorcycle. Persian digits and right-to-left input.';

  /// Built once, and returned by identity: the pickers select a section by
  /// equality, and a fresh list per read would make the selected one never
  /// equal the one in the list.
  @override
  List<GallerySection> get sections => _sections;

  /// One per section would drop everything but the private car. Iran's four
  /// sections are one system in many liveries plus three separate blanks, so
  /// the home screen takes the private plate, a taxi to show the letter is
  /// fixed and the field recolours, and the two odd blanks.
  ///
  /// Picked *out of* [_sections] rather than rebuilt: `CatalogueSourceLook`
  /// pairs a highlight back up with its section by `identical`, so a freshly
  /// constructed entry here — equal in every field, but not the same object —
  /// matches nothing and throws. Same reason [sections] is cached.
  @override
  List<GalleryEntry> get highlights => _highlights;

  /// The cached entry whose spec is [usage]'s. Looks the entry up by spec id
  /// so that reordering a section cannot silently change which plate the home
  /// screen leads with.
  static GalleryEntry _highlight(IranUsage usage) {
    final String id = IranPlates.forUsage(usage).id;
    for (final GallerySection section in _sections) {
      for (final GalleryEntry entry in section.entries) {
        if (entry.id == id) return entry;
      }
    }
    throw StateError('IranSource has no entry for $id; every IranUsage must sit in a section.');
  }

  static final List<GalleryEntry> _highlights = <GalleryEntry>[
    _highlight(IranUsage.private),
    _highlight(IranUsage.protocol),
    _highlight(IranUsage.motorcycle),
  ];

  /// Four fields on the shared 520x110 blank: `12 ب 345 - 11`, the number the
  /// article's own reference images carry.
  static const List<String?> _standardValues = <String?>['12', null, '345', '11'];

  /// The five digits of a protocol or historic plate.
  static const List<String?> _fiveDigits = <String?>['13901'];

  /// A motorcycle's three-digit provincial code over its five-digit serial.
  /// Neither register may contain a zero.
  static const List<String?> _motorcycleValues = <String?>['123', '56789'];

  /// The entry for one vehicle class. Spec, theme and label all come from
  /// [usage]; the only thing this adds is what to draw into the slots.
  ///
  /// The letter slot is left `null` on the standard blank when the class fixes
  /// it: a fixed letter is not a value the gallery supplies, and filling it
  /// here would hide the fact that the plate carries it for free.
  static GalleryEntry _entry(IranUsage usage) {
    final spec = IranPlates.forUsage(usage);
    final values = switch (usage) {
      IranUsage.protocol || IranUsage.historic => _fiveDigits,
      IranUsage.motorcycle => _motorcycleValues,
      _ => <String?>[..._standardValues]..[1] = 'ب',
    };
    return GalleryEntry(
      id: spec.id,
      label: _label(usage),
      spec: spec,
      theme: IranThemes.forUsage(usage),
      sampleValues: values,
      note: usage.description,
    );
  }

  static String _label(IranUsage usage) => switch (usage) {
    IranUsage.protocol => 'Protocol',
    IranUsage.historic => 'Historic',
    IranUsage.motorcycle => 'Motorcycle',
    _ => 'Civil',
  };

  static List<GalleryEntry> _entriesFor(List<IranUsage> usages) => <GalleryEntry>[
    for (final IranUsage usage in usages) _entry(usage),
  ];

  static final List<GallerySection> _sections = <GallerySection>[
    GallerySection(
      title: 'Civil',
      note:
          'One 520x110 blank for private, taxi, public, agricultural, '
          'government, temporary, police, IRGC, army, defence, general staff, '
          'political and service plates. The series letter picks the class: '
          'the field fades to its colour and, for a taxi, TAXI appears above '
          'the letter. ژ prints as the wheelchair symbol.',
      entries: _entriesFor(const <IranUsage>[IranUsage.private]),
    ),
    GallerySection(
      title: 'Other blanks',
      note:
          'The three Iranian plates that are not the standard blank: protocol '
          '(wording beside a bare serial, no letter and no province square), '
          'historic (American size, brown) and the motorcycle plate (a '
          'three-digit provincial code over a five-digit serial).',
      entries: _entriesFor(const <IranUsage>[
        IranUsage.protocol,
        IranUsage.historic,
        IranUsage.motorcycle,
      ]),
    ),
  ];
}
