import 'package:czech_republic_plate/czech_republic_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `czech_republic_plate`: the current `1A2 3456` plate with the EU band, the
/// older one-line plates and the two-line US-size and motorcycle plates.
class CzechRepublicSource extends GallerySource {
  CzechRepublicSource();

  @override
  String get countryName => 'Czech Republic';

  @override
  String get packageName => 'czech_republic_plate';

  @override
  String get note =>
      'Since 2001 a digit, the regional letter and a digit or letter, then '
      'four characters, black on white (520 × 110 mm); historic vehicles are '
      'green, diplomatic plates blue. Older plates are district letters and '
      'two pairs of digits. Not drawn: the inspection and emission stickers, '
      'the 2001 red rental and yellow technical-embassy plates (discontinued) '
      'and the vector two-line illustration. The 1970s, diplomatic, veteran, '
      'personalised, US-size and motorcycle geometry is estimated from '
      'flattened photos.';

  GalleryEntry _entry(String id, String label, PlateSpec spec, PlateTheme theme, String values) =>
      GalleryEntry(
        id: 'cz.$id',
        label: label,
        spec: spec,
        theme: theme,
        country: CzechRepublicCountry.czech_republic,
        validator: const CzechRepublicValidator(),
        sampleValues: values.split(' '),
      );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Registration',
      note: 'Two fields; the EU band is painted by the background.',
      entries: <GalleryEntry>[
        _entry(
          'private',
          'Private',
          CzechRepublicPlates.private,
          CzechRepublicThemes.private,
          '1A2 3456',
        ),
        _entry(
          'private_letter',
          'Private · letter in serial',
          CzechRepublicPlates.private,
          CzechRepublicThemes.private,
          '1AA B174',
        ),
        _entry(
          'electric',
          'Electric',
          CzechRepublicPlates.private,
          CzechRepublicThemes.private,
          'EL1 06AC',
        ),
        _entry(
          'personalised',
          'Personalised',
          CzechRepublicPlates.personalised,
          CzechRepublicThemes.private,
          'DIC TATOR',
        ),
        _entry(
          'veteran',
          'Historic · green',
          CzechRepublicPlates.veteran,
          CzechRepublicThemes.veteran,
          'V 7425',
        ),
        _entry(
          'diplomatic',
          'Diplomatic · blue',
          CzechRepublicPlates.diplomatic,
          CzechRepublicThemes.diplomatic,
          '017 CD 75',
        ),
      ],
    ),
    GallerySection(
      title: 'Older and special',
      note: 'No band: 2001–2004, 1992–2001, 1970s, military and export.',
      entries: <GalleryEntry>[
        _entry(
          'private2001',
          '2001–2004',
          CzechRepublicPlates.private2001,
          CzechRepublicThemes.plain2001,
          '2H2 7149',
        ),
        _entry(
          'classic',
          '1992–2001',
          CzechRepublicPlates.classic,
          CzechRepublicThemes.classic,
          'ALA 40 11',
        ),
        _entry(
          'commercial',
          'Commercial · yellow',
          CzechRepublicPlates.classic,
          CzechRepublicThemes.commercial,
          'RA 75 31',
        ),
        _entry(
          'classic70s',
          'Czechoslovak 1970s',
          CzechRepublicPlates.classic70s,
          CzechRepublicThemes.classic70s,
          'AZ 17 32',
        ),
        _entry(
          'military',
          'Military',
          CzechRepublicPlates.military,
          CzechRepublicThemes.military,
          '022 61 25',
        ),
        _entry(
          'export',
          'Export',
          CzechRepublicPlates.export,
          CzechRepublicThemes.export,
          'A67 38E',
        ),
      ],
    ),
    GallerySection(
      title: 'Two rows',
      note: 'Code above, serial below.',
      entries: <GalleryEntry>[
        _entry(
          'us_size',
          'US-size',
          CzechRepublicPlates.usSize,
          CzechRepublicThemes.private,
          '4B0 9595',
        ),
        _entry(
          'motorcycle',
          'Motorcycle',
          CzechRepublicPlates.motorcycle,
          CzechRepublicThemes.private,
          '3A 6789',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
