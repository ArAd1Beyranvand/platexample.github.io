GO VEGAN 🌱

FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

==================================


# plate_number_holder

The showcase / poster app for the plate library — [`plate_core`](../core-plate)
plus [`iran_plate`](../iran-plate), [`germany_plate`](../germany-plate) and
[`plate_keypad`](../plate-keypad). It used to live inside the package repo as
`example/`; it was split out so the packages ship nothing demo-only.

The app keeps its name. It is an app, not a package, and renaming its repo,
Android namespace and Linux binary would churn a lot of files for no benefit.

## Why it is a separate project

| stays in the packages | lives here |
| --- | --- |
| plate widgets, specs, validators, bloc | poster layout, callout cards, device frames |
| the flag SVGs and EU stickers a real plate needs (in `iran_plate` / `germany_plate`) | Archivo / MartianMono / Newsreader / Vazirmatn fonts, grain + screen textures |
| `flutter_bloc`, `flutter_svg` | everything the demo alone needs |

Because this app consumes only the packages' public surfaces, it doubles as a
compile-time check that the API is enough to build a real UI.

## Running it

The five checkouts must sit side by side:

```
StudioProjects/plate/
  core-plate/
  iran-plate/
  germany-plate/
  plate-keypad/
  plate_number_holder/    # this app
```

```bash
flutter pub get
flutter run
```

`pubspec.yaml` points at every package by **path**, so editing a library and
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
  minimal/           the smallest possible use of the library
```

`lib/minimal/main.dart` is the one to read first if you want to see the library
used plainly, without any poster dressing. After the split it is two imports and
one `PlateCanvas`:

```dart
import 'package:plate_core/plate_core.dart';
import 'package:iran_plate/iran_plate.dart';
```

It also imports `plate_keypad` — the showcase uses the bundled on-screen keypad
and the `chosen`-slot picker, which is a demo choice, not a requirement of
rendering an Iranian plate.

## Known remaining work

The libraries have no widget-returning functions left. The holder still does —
`device_stage.dart` and the poster layer (`PLAN.md` §5). That is a future holder
cleanup, out of scope for the split.
## Also available

- [`plate_core`](https://pub.dev/packages/plate-core) - Paint license plates.
- [`plate_alphabet`](https://pub.dev/packages/plate-alphabet) - A library of alphabets for license plates.
- [`plate_keypad`](https://pub.dev/packages/plate-keypad) - A character picker for license plates.
- [`algeria_plate`](https://pub.dev/packages/algeria-plate) - Algeria's licence plates.
- [`bolivia_plate`](https://pub.dev/packages/bolivia-plate) - Bolivia's licence plates.
- [`colombia_plate`](https://pub.dev/packages/colombia-plate) - Colombia's licence plates.
- [`cuba_plate`](https://pub.dev/packages/cuba-plate) - Cuba's licence plates.
- [`germany_plate`](https://pub.dev/packages/germany-plate) - Germany's licence plates.
- [`india_plate`](https://pub.dev/packages/india-plate) - India's licence plates.
- [`indonesia_plate`](https://pub.dev/packages/indonesia-plate) - Indonesia's licence plates.
- [`iran_plate`](https://pub.dev/packages/iran-plate) - Iran's licence plates.
- [`iranshahr_plate`](https://pub.dev/packages/iranshahr-plate) - Iranshahr region's licence plates.
- [`lebanon_plate`](https://pub.dev/packages/lebanon-plate) - Lebanon's licence plates.
- [`malaysia_plate`](https://pub.dev/packages/malaysia-plate) - Malaysia's licence plates.
- [`mali_plate`](https://pub.dev/packages/mali-plate) - Mali's licence plates.
- [`niger_plate`](https://pub.dev/packages/niger-plate) - Niger's licence plates.
- [`palestine_plate`](https://pub.dev/packages/palestine-plate) - Palestine's licence plates.
- [`sudan_plate`](https://pub.dev/packages/sudan-plate) - Sudan's licence plates.
- [`tunisia_plate`](https://pub.dev/packages/tunisia-plate) - Tunisia's licence plates.
- [`venezuela_plate`](https://pub.dev/packages/venezuela-plate) - venezuela_ licence plates.
- [`yemen_plate`](https://pub.dev/packages/yemen-plate) - Yemen's licence plates.
