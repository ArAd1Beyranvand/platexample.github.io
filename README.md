# plate_number_holder

The showcase / poster app for the [`plate_number`](../plate-number-upgrade)
Flutter package. It used to live inside the package repo as `example/`; it was
split out so the package ships nothing demo-only.

## Why it is a separate project

| stays in the package | lives here |
| --- | --- |
| plate widgets, specs, validators, bloc | poster layout, callout cards, device frames |
| the flag SVG and EU stickers a real plate needs | Archivo / MartianMono / Newsreader / Vazirmatn fonts, grain + screen textures |
| `flutter_bloc`, `flutter_svg`, `country_flags` | everything the demo alone needs |

Because this app consumes only the package's public surface, it doubles as a
compile-time check that the published API is enough to build a real UI.

## Running it

The two checkouts must sit side by side:

```
StudioProjects/
  plate-number-upgrade/   # the package
  plate_number_holder/    # this app
```

```bash
flutter pub get
flutter run
```

`pubspec.yaml` points at the package by **path**, so editing the library and
hot-reloading here is one loop.

## Layout

```
lib/
  main.dart          entry point; wiring notes live at the top of this file
  app/               MaterialApp + theme
  screens/           the showcase screen
  showcase/          demo config, device cycling, the auto-typist
  widgets/           plate_display — the thin adapter onto the package widgets
  poster/            poster chrome: tokens, backdrop, callouts, cards
  device_preview/    phone / laptop frames and transitions
  dev/               galleries used while designing tokens, bevels, backdrops
  minimal/           the smallest possible use of the package
```

`lib/minimal/main.dart` is the one to read first if you want to see the package
used plainly, without any poster dressing.

## After the library split

Once `plate_number` becomes `core_plate` + `iran_plate` + `germany_plate`, only
`pubspec.yaml` and the `package:plate_number/...` import lines change here; no
widget in this project needs touching.
