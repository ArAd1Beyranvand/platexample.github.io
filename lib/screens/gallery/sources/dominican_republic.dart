import 'package:dominican_republic_plate/dominican_republic_plate.dart';

import '../catalogue.dart';

/// `dominican_republic_plate`: the pressed-metal series and the 2017 exempt plate.
class DominicanRepublicSource extends GallerySource {
  DominicanRepublicSource();

  @override
  String get countryName => 'Dominican Republic';

  @override
  String get packageName => 'dominican_republic_plate';

  @override
  String get note =>
      'Plates are 300 × 152 mm. Until 1989 one plate was issued per semester '
      'in a new colour each time; the 1980, 1986, 1990 and 1994 plates are the '
      'ones with a photograph, and the 2017 exempt plate is the current design. '
      'Not drawn: the other semesters (colours only, no photograph), the '
      '1996–2003 LA-B123 plate (no usable photograph) and the 2018 paper '
      'temporary plate.';

  @override
  List<GallerySection> get sections => _sections ??= <GallerySection>[
    GallerySection(
      title: 'Pressed-metal series',
      note: 'Two fields of three digits, or a letter and two fields of digits.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'do.private1990',
          label: '1990 private',
          spec: DominicanRepublicPlates.private1990,
          theme: DominicanRepublicThemes.private1990,
          country: DominicanRepublicCountry.dominican_republic,
          validator: const DominicanRepublicValidator(),
          sampleValues: <String?>['953', '147'],
        ),
        GalleryEntry(
          id: 'do.passenger1980',
          label: '1980 passenger, first semester',
          spec: DominicanRepublicPlates.passenger1980,
          theme: DominicanRepublicThemes.passenger1980,
          country: DominicanRepublicCountry.dominican_republic,
          validator: const DominicanRepublicValidator(),
          sampleValues: <String?>['122', '066'],
        ),
        GalleryEntry(
          id: 'do.private1994',
          label: '1994 private',
          spec: DominicanRepublicPlates.private1994,
          theme: DominicanRepublicThemes.private1994,
          country: DominicanRepublicCountry.dominican_republic,
          validator: const DominicanRepublicValidator(),
          sampleValues: <String?>['185', '435'],
        ),
        GalleryEntry(
          id: 'do.passenger1986',
          label: '1986 passenger, first semester',
          spec: DominicanRepublicPlates.passenger1986,
          theme: DominicanRepublicThemes.passenger1986,
          country: DominicanRepublicCountry.dominican_republic,
          validator: const DominicanRepublicLetteredValidator(),
          sampleValues: <String?>['P', '06', '2686'],
        ),
      ],
    ),
    GallerySection(
      title: 'Current',
      note: 'Exempt state vehicles, from 2017: two letters and five digits.',
      entries: <GalleryEntry>[
        GalleryEntry(
          id: 'do.exempt',
          label: 'Exempt state vehicle',
          spec: DominicanRepublicPlates.exempt,
          theme: DominicanRepublicThemes.exempt,
          country: DominicanRepublicCountry.dominican_republic,
          validator: const DominicanRepublicExemptValidator(),
          sampleValues: <String?>['EA', '01320'],
        ),
      ],
    ),
  ];

  List<GallerySection>? _sections;
}
