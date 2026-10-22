import 'package:ivory_coast_plate/ivory_coast_plate.dart';
import 'package:plate_core/plate_core.dart';

import '../catalogue.dart';

/// `ivory_coast_plate`: the private, temporary, diplomatic and military plates.
class IvoryCoastSource extends GallerySource {
  IvoryCoastSource();

  @override
  String get countryName => 'Ivory Coast';

  @override
  String get packageName => 'ivory_coast_plate';

  @override
  String get note =>
      'Number, two letters and a two-digit region code, with an orange or '
      'white strip at the right carrying the country outline and CI. Not '
      'drawn: the sticker line along the temporary plate.';

  static GalleryEntry _e(
    String id,
    String label,
    PlateSpec spec,
    PlateTheme theme,
    List<String?> values,
  ) => GalleryEntry(
    id: 'ci.$id',
    label: label,
    spec: spec,
    theme: theme,
    country: IvoryCoastCountry.ivory_coast,
    validator: const IvoryCoastValidator(),
    sampleValues: values,
  );

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Civil',
      note:
          'Four digits, two letters and the region of origin; temporary and '
          'diplomatic plates carry three digits.',
      entries: <GalleryEntry>[
        _e('private', 'Private', IvoryCoastPlates.private, IvoryCoastThemes.private, <String?>[
          '1234',
          'AB',
          '56',
        ]),
        _e(
          'temporary',
          'Temporary',
          IvoryCoastPlates.temporary,
          IvoryCoastThemes.temporary,
          <String?>['123', 'IT', '56'],
        ),
        _e(
          'diplomatic',
          'Diplomatic',
          IvoryCoastPlates.diplomatic,
          IvoryCoastThemes.diplomatic,
          <String?>['123', 'CD', '45'],
        ),
      ],
    ),
    GallerySection(
      title: 'Military',
      note: 'The flag and five digits, white on black.',
      entries: <GalleryEntry>[
        _e('military', 'Military', IvoryCoastPlates.military, IvoryCoastThemes.military, <String?>[
          '12345',
        ]),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
