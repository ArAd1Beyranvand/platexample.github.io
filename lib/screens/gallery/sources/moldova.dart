import 'package:moldova_plate/moldova_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `moldova_plate`: the current series on the blue band. Every field is one
/// slot, so a value is one token per field (`['ABC', '012']`).
class MoldovaSource extends GallerySource {
  MoldovaSource();

  @override
  String get countryName => 'Moldova';

  @override
  String get packageName => 'moldova_plate';

  @override
  String get note =>
      'Blue band with the flag and MD, black on white for private and state '
      'plates, red for foreign entities, blue for the diplomatic corps. The '
      'pre-2015 plates are not drawn.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: id,
    label: label,
    spec: spec,
    theme: theme,
    country: MoldovaCountry.moldova,
    validator: const MoldovaValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private and state — 520 × 110',
      note: 'Ink is ~72% of the reference height.',
      entries: <GalleryEntry>[
        _e('md.private', 'Private', MoldovaPlates.private, MoldovaThemes.private, <String?>[
          'ABC',
          '012',
        ]),
        _e(
          'md.state',
          'Government, Parliament, ministries',
          MoldovaPlates.state,
          MoldovaThemes.state,
          <String?>['RMG', '123'],
        ),
        _e(
          'md.interior',
          'Ministry of Internal Affairs',
          MoldovaPlates.interior,
          MoldovaThemes.state,
          <String?>['MAI', '1234'],
        ),
        _e(
          'md.armedForces',
          'Armed forces',
          MoldovaPlates.armedForces,
          MoldovaThemes.state,
          <String?>['FA', '1234'],
        ),
        _e(
          'md.president',
          'President (rear)',
          MoldovaPlates.president,
          MoldovaThemes.state,
          <String?>['RM', '0001'],
        ),
        _e(
          'md.protection',
          'State Protection Service',
          MoldovaPlates.protection,
          MoldovaThemes.state,
          <String?>['SP', '123'],
        ),
      ],
    ),
    GallerySection(
      title: 'Foreign entities',
      note: 'Red; the expiry month and year are estimated off the sheet.',
      entries: <GalleryEntry>[
        _e(
          'md.foreign',
          'Foreign entity / temporary import',
          MoldovaPlates.foreign,
          MoldovaThemes.foreign,
          <String?>['H', '1234', '03', '21'],
        ),
        _e('md.exported', 'Exported', MoldovaPlates.exported, MoldovaThemes.foreign, <String?>[
          'T',
          '123',
          'A',
          '03',
          '21',
        ]),
        _e(
          'md.resident',
          'Permanent resident',
          MoldovaPlates.resident,
          MoldovaThemes.foreign,
          <String?>['H', '1234'],
        ),
      ],
    ),
    GallerySection(
      title: 'Diplomatic',
      note: 'Diplomatic, consular and technical staff share one design.',
      entries: <GalleryEntry>[
        _e(
          'md.diplomatic',
          'Diplomatic corps',
          MoldovaPlates.diplomatic,
          MoldovaThemes.diplomatic,
          <String?>['CD', '123', 'AB'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
