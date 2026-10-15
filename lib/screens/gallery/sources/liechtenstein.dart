import 'package:liechtenstein_plate/liechtenstein_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `liechtenstein_plate`: `FL`, the lesser arms and up to five digits in five
/// formats, with the dealer, temporary and customs marks and eight liveries.
class LiechtensteinSource extends GallerySource {
  LiechtensteinSource();

  @override
  String get countryName => 'Liechtenstein';

  @override
  String get packageName => 'liechtenstein_plate';

  @override
  String get note =>
      'FL, the lesser arms and up to five digits, white on black; other '
      'categories change the colours (yellow ink for short-term plates; '
      'green, light blue, ochre, red, yellow and amber fields). Dealer plates '
      'end in a dot and U, temporary plates carry the expiry month on a red '
      'bar, customs plates a blank red bar and Z. Not drawn: the series '
      'before 2019, the withdrawn CC/CD plates and the insurance sticker.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    LiechtensteinLivery livery,
    LiechtensteinValidator validator,
    String values,
  ) => GalleryEntry(
    id: 'li.$id',
    label: label,
    spec: spec,
    theme: LiechtensteinThemes.of(livery, spec),
    country: LiechtensteinCountry.liechtenstein,
    validator: validator,
    sampleValues: values.split(' '),
  );

  static const LiechtensteinLivery _std = LiechtensteinLivery.standard;

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Standard',
      note:
          'Front 300 × 80, rear 500 × 110 or 300 × 160, motorcycle '
          '180 × 140.',
      entries: <GalleryEntry>[
        _e(
          'front',
          'Front',
          LiechtensteinPlates.front,
          _std,
          LiechtensteinValidator.standard,
          '12345',
        ),
        _e(
          'long',
          'Rear, long',
          LiechtensteinPlates.long,
          _std,
          LiechtensteinValidator.standard,
          '12345',
        ),
        _e(
          'square',
          'Rear, square',
          LiechtensteinPlates.square,
          _std,
          LiechtensteinValidator.standard,
          '12345',
        ),
        _e(
          'motorcycle',
          'Motorcycle',
          LiechtensteinPlates.motorcycle,
          _std,
          LiechtensteinValidator.standard,
          '1234',
        ),
        _e(
          'trailer',
          'Trailer',
          LiechtensteinPlates.long,
          _std,
          LiechtensteinValidator.trailer,
          '65100',
        ),
      ],
    ),
    GallerySection(
      title: 'Categories',
      note: 'The same plates in each category\'s colours.',
      entries: <GalleryEntry>[
        _e(
          'short_term',
          'Short-term',
          LiechtensteinPlates.long,
          LiechtensteinLivery.shortTerm,
          LiechtensteinValidator.shortTerm,
          '50123',
        ),
        _e(
          'agricultural',
          'Agricultural',
          LiechtensteinPlates.front,
          LiechtensteinLivery.agricultural,
          LiechtensteinValidator.special,
          '1943',
        ),
        _e(
          'utility',
          'Utility vehicle',
          LiechtensteinPlates.square,
          LiechtensteinLivery.utility,
          LiechtensteinValidator.special,
          '345',
        ),
        _e(
          'exceptional',
          'Exceptional vehicle',
          LiechtensteinPlates.long,
          LiechtensteinLivery.exceptional,
          LiechtensteinValidator.special,
          '5012',
        ),
        _e(
          'repeater',
          'Repeater (rear carrier)',
          LiechtensteinPlates.long,
          LiechtensteinLivery.repeater,
          LiechtensteinValidator.standard,
          '23456',
        ),
        _e(
          'light_motorcycle',
          'Light motorcycle',
          LiechtensteinPlates.motorcycle,
          LiechtensteinLivery.lightMotorcycle,
          LiechtensteinValidator.lightMotorcycle,
          '7123',
        ),
        _e(
          'moped',
          'Moped',
          LiechtensteinPlates.moped,
          LiechtensteinLivery.moped,
          LiechtensteinValidator.moped,
          '87 013',
        ),
      ],
    ),
    GallerySection(
      title: 'Dealer',
      note: 'Three digits, a dot and U.',
      entries: <GalleryEntry>[
        _e(
          'dealer_long',
          'Long',
          LiechtensteinPlates.dealerLong,
          _std,
          LiechtensteinValidator.dealer,
          '101',
        ),
        _e(
          'dealer_square',
          'Square',
          LiechtensteinPlates.dealerSquare,
          _std,
          LiechtensteinValidator.dealer,
          '102',
        ),
        _e(
          'dealer_motorcycle',
          'Motorcycle',
          LiechtensteinPlates.dealerMotorcycle,
          _std,
          LiechtensteinValidator.dealerMotorcycle,
          '507',
        ),
      ],
    ),
    GallerySection(
      title: 'Temporary',
      note: 'The expiry month on a red bar.',
      entries: <GalleryEntry>[
        _e(
          'temporary_front',
          'Front',
          LiechtensteinPlates.temporaryFront,
          _std,
          LiechtensteinValidator.temporary,
          '92999 12',
        ),
        _e(
          'temporary_long',
          'Long',
          LiechtensteinPlates.temporaryLong,
          _std,
          LiechtensteinValidator.temporary,
          '92999 12',
        ),
        _e(
          'temporary_square',
          'Square',
          LiechtensteinPlates.temporarySquare,
          _std,
          LiechtensteinValidator.temporary,
          '95008 6',
        ),
        _e(
          'temporary_motorcycle',
          'Motorcycle',
          LiechtensteinPlates.temporaryMotorcycle,
          _std,
          LiechtensteinValidator.temporaryMotorcycle,
          '1843 9',
        ),
      ],
    ),
    GallerySection(
      title: 'Customs',
      note: 'Three digits, a blank red bar and Z.',
      entries: <GalleryEntry>[
        _e(
          'customs_front',
          'Front',
          LiechtensteinPlates.customsFront,
          _std,
          LiechtensteinValidator.customs,
          '612',
        ),
        _e(
          'customs_long',
          'Long',
          LiechtensteinPlates.customsLong,
          _std,
          LiechtensteinValidator.customs,
          '612',
        ),
        _e(
          'customs_square',
          'Square',
          LiechtensteinPlates.customsSquare,
          _std,
          LiechtensteinValidator.customs,
          '655',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
