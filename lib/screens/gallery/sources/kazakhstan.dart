import 'package:iranshahr_plate/iranshahr_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `kazakhstan_plate`: the 2012 plate — a region number, three letters and a
/// two-digit tail, with the flag and the KZ code on the right.
class KazakhstanSource extends GallerySource {
  KazakhstanSource();

  @override
  String get countryName => 'Kazakhstan';

  @override
  String get packageName => 'kazakhstan_plate';

  @override
  String get note =>
      'A region number, a letter block and a two-digit tail, black on white '
      'with the flag and the KZ code on the right. The non-private plate drops '
      'a letter; the diplomatic plate leads with the status letter. Not drawn: '
      'the Kazakh caption under the flag and the older Soviet-era formats.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values, {
    PlateValidator validator = const KazakhstanValidator(),
  }) => GalleryEntry(
    id: 'kz.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: KazakhstanCountry.kazakhstan,
    validator: validator,
    sampleValues: values.split(' '),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — 520 × 112',
      note: 'Three digits, three letters, two digits.',
      entries: <GalleryEntry>[
        _e(
          'private',
          'Private car',
          KazakhstanPlates.private,
          KazakhstanThemes.private,
          '017 ABC 02',
        ),
      ],
    ),
    GallerySection(
      title: 'Non-private and diplomatic',
      note:
          'The non-private plate carries two letters rather than three; the '
          'diplomatic plate leads with the status letter.',
      entries: <GalleryEntry>[
        _e(
          'non_private',
          'Commercial and state',
          KazakhstanPlates.nonPrivate,
          KazakhstanThemes.nonPrivate,
          '050 AB 02',
          validator: const KazakhstanValidator(letters: 2),
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          KazakhstanPlates.diplomatic,
          KazakhstanThemes.diplomatic,
          'D 001 023',
          validator: const KazakhstanDiplomaticValidator(),
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
