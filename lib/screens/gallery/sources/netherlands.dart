import 'package:netherlands_plate/netherlands_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `netherlands_plate`: three fields of letters and digits split by painted
/// dashes, black on yellow beside the EU panel.
class NetherlandsSource extends GallerySource {
  NetherlandsSource();

  @override
  String get countryName => 'Netherlands';

  @override
  String get packageName => 'netherlands_plate';

  @override
  String get note =>
      'Nine sidecodes (6–14) of letters and digits in three dashed fields, '
      'plus royal, trailer, special, diplomatic, consular, dealer and BFG '
      'plates. Not drawn: sidecodes 1–5, blue taxi and scooter plates, '
      'motorcycles, military and the Caribbean plates.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    String values,
  ) => GalleryEntry(
    id: 'nl.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: NetherlandsCountry.netherlands,
    validator: const NetherlandsValidator(),
    sampleValues: values.split('|'),
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Sidecodes — 520 × 110',
      note: 'One field per run; the dashes are painted.',
      entries: <GalleryEntry>[
        _e(
          'sidecode6',
          'Sidecode 6 · 99-XX-XX',
          NetherlandsPlates.sidecode6,
          NetherlandsThemes.standard,
          '99|XX|XX',
        ),
        _e(
          'sidecode7',
          'Sidecode 7 · 99-XXX-9',
          NetherlandsPlates.sidecode7,
          NetherlandsThemes.standard,
          '99|XXX|9',
        ),
        _e(
          'sidecode8',
          'Sidecode 8 · 9-XXX-99',
          NetherlandsPlates.sidecode8,
          NetherlandsThemes.standard,
          '9|XXX|99',
        ),
        _e(
          'sidecode9',
          'Sidecode 9 · XX-999-X',
          NetherlandsPlates.sidecode9,
          NetherlandsThemes.standard,
          'XX|999|X',
        ),
        _e(
          'sidecode10',
          'Sidecode 10 · X-999-XX',
          NetherlandsPlates.sidecode10,
          NetherlandsThemes.standard,
          'X|999|XX',
        ),
        _e(
          'sidecode11',
          'Sidecode 11 · XXX-99-X',
          NetherlandsPlates.sidecode11,
          NetherlandsThemes.standard,
          'XXX|99|X',
        ),
        _e(
          'sidecode12',
          'Sidecode 12 · X-99-XXX',
          NetherlandsPlates.sidecode12,
          NetherlandsThemes.standard,
          'X|99|XXX',
        ),
        _e(
          'sidecode13',
          'Sidecode 13 · 9-XX-999',
          NetherlandsPlates.sidecode13,
          NetherlandsThemes.standard,
          '9|XX|999',
        ),
        _e(
          'sidecode14',
          'Sidecode 14 · 999-XX-9',
          NetherlandsPlates.sidecode14,
          NetherlandsThemes.standard,
          '999|XX|9',
        ),
      ],
    ),
    GallerySection(
      title: 'Special plates',
      note: 'Royal, trailer, protocol, dealer and BFG.',
      entries: <GalleryEntry>[
        _e('royal', 'Royal family', NetherlandsPlates.royal, NetherlandsThemes.standard, 'AA|86'),
        _e('trailer', 'Trailer', NetherlandsPlates.trailer, NetherlandsThemes.standard, 'WX|12|NZ'),
        _e(
          'special',
          'Special (GV, BN, ZZ)',
          NetherlandsPlates.special,
          NetherlandsThemes.standard,
          'GV|78|54',
        ),
        _e(
          'diplomatic',
          'Diplomatic corps',
          NetherlandsPlates.diplomatic,
          NetherlandsThemes.standard,
          'CD|79|31',
        ),
        _e(
          'consular',
          'International Court of Justice',
          NetherlandsPlates.consular,
          NetherlandsThemes.standard,
          'CDJ|253',
        ),
        _e('dealer', 'Dealer', NetherlandsPlates.dealer, NetherlandsThemes.dealer, '49|47|HA'),
        _e(
          'bfg',
          'British Forces Germany',
          NetherlandsPlates.bfg,
          NetherlandsThemes.bfg,
          'EM|818|N',
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
