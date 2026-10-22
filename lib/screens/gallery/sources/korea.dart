import '../catalogue.dart';
import 'north_korea.dart';
import 'south_korea.dart';

/// `north_korea_plate` ships both Koreas, so they sit under one umbrella as
/// Iranshahr's countries do. It has no sections of its own: its members carry
/// every plate, so each one is listed once.
class KoreaSource extends GallerySource {
  KoreaSource();

  @override
  String get countryName => 'Korea';

  @override
  List<String> get countryNames => const <String>['North Korea', 'South Korea'];

  @override
  String get packageName => 'north_korea_plate';

  @override
  late final List<GallerySource> members = <GallerySource>[NorthKoreaSource(), SouthKoreaSource()];

  @override
  String get overviewTitle => 'Two countries, one package';

  @override
  String get note =>
      'North Korea and South Korea in one package: the 1990s northern '
      'liveries and the southern plates.';

  @override
  List<GallerySection> get sections => const <GallerySection>[];

  @override
  List<GalleryEntry> get highlights => const <GalleryEntry>[];
}
