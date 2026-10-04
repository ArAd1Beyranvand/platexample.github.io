import 'package:oman_plate/oman_plate.dart';

import '../catalogue.dart';

/// `oman_plate`: the 2001 series, one design in two liveries.
///
/// Only the private and taxi classes have artwork in the article, so the
/// other classes are not implemented. Only the letters A, B, K and M are
/// sourced; the rest of the alphabet is not in the article.
class OmanSource extends GallerySource {
  OmanSource();

  @override
  String get countryName => 'Oman';

  @override
  String get packageName => 'oman_plate';

  @override
  String get note =>
      'One three-panel design — number, letters, عمان — in black '
      'on yellow (private) and white on red (taxi), with four or five digits '
      'and one or two letters.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Private — black on yellow',
      note:
          'The 2001 series. Letters are printed twice: Latin, and Arabic above in the opposite order. Four digits with two letters and five with one are measured; the other two use the same rule.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'om.private.d4l1',
          label: 'Four digits, one letter',
          spec: OmanPlates.fourDigitOneLetter,
          theme: OmanThemes.private,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['4', '5', '1', '7', 'B'],
        ),
        GalleryEntry(
          id: 'om.private.d4l2',
          label: 'Four digits, two letters',
          spec: OmanPlates.fourDigitTwoLetter,
          theme: OmanThemes.private,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['4', '5', '1', '7', 'B', 'M'],
        ),
        GalleryEntry(
          id: 'om.private.d5l1',
          label: 'Five digits, one letter',
          spec: OmanPlates.fiveDigitOneLetter,
          theme: OmanThemes.private,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['9', '1', '1', '6', '9', 'B'],
        ),
        GalleryEntry(
          id: 'om.private.d5l2',
          label: 'Five digits, two letters',
          spec: OmanPlates.fiveDigitTwoLetter,
          theme: OmanThemes.private,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['9', '1', '1', '6', '9', 'B', 'M'],
        ),
      ],
    ),
    GallerySection(
      title: 'Taxi — white on red',
      note: 'The same design in white on red.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'om.taxi.d4l1',
          label: 'Four digits, one letter',
          spec: OmanPlates.fourDigitOneLetter,
          theme: OmanThemes.taxi,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['4', '5', '1', '7', 'K'],
        ),
        GalleryEntry(
          id: 'om.taxi.d4l2',
          label: 'Four digits, two letters',
          spec: OmanPlates.fourDigitTwoLetter,
          theme: OmanThemes.taxi,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['4', '5', '1', '7', 'K', 'K'],
        ),
        GalleryEntry(
          id: 'om.taxi.d5l1',
          label: 'Five digits, one letter',
          spec: OmanPlates.fiveDigitOneLetter,
          theme: OmanThemes.taxi,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['9', '1', '1', '6', '9', 'K'],
        ),
        GalleryEntry(
          id: 'om.taxi.d5l2',
          label: 'Five digits, two letters',
          spec: OmanPlates.fiveDigitTwoLetter,
          theme: OmanThemes.taxi,
          country: OmanCountry.oman,
          validator: const OmanPlateValidator(),
          sampleValues: <String?>['9', '1', '1', '6', '9', 'K', 'K'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
