FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

# plate_number_holder

The demo site and gallery for the plate library: every plate every country package draws, an interactive playground, and a page per country. It is an app, not a package (`publish_to: none`), kept outside the packages so they ship no demo-only fonts or dependencies.

Because it consumes only the packages' public API, it is also a compile-time check that the API is enough to build a real UI.

## Run

All packages sit side by side in one checkout; `pubspec.yaml` points at each by path, so editing a country and hot-reloading here is one loop.

```bash
flutter pub get
flutter run -d chrome
```

## Layout

```
lib/
  main.dart          entry point and wiring notes
  app/               URL strategy (path URLs on web)
  newdesign/         the site: shell, landing, playground, country pages
  screens/gallery/   the catalogue every page reads from
    sources/         one file per country: its GalleryEntry list
  minimal/           the smallest possible use of the library
test/                one render test per country gallery
```

A `GalleryEntry` pairs a spec with a theme, sample values and optional `bands:` chips that swap the country panel (and optionally the theme) for classes only a colour tells apart. `sampleValues` must match `spec.slotCount`; the render tests enforce it.

`lib/minimal/main.dart` is the one to read first: two imports and one `PlateCanvas`.

## Part of plate

[`plate_core`](https://pub.dev/packages/plate_core), [`plate_alphabet`](https://pub.dev/packages/plate_alphabet), [`plate_keypad`](https://pub.dev/packages/plate_keypad) and every `*_plate` country package.
