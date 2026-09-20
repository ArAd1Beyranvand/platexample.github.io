# theme

Nocturne's tokens, transcribed once in `nocturne.dart` so later sessions read
this list instead of the whole file.

- `N` — the colour ramp: `bg`, `surface`, `text`, `divider`, `n100`..`n900`,
  `accent`, `accent300`, `accent700`, `accent800`, `accent900`.
- `N.textAt(opacity)` — `text` at an alpha, for `color-mix(text N%)` spots.
- `N.accentAt(opacity)` — same for `accent` (hover fills: 12% / 22%).
- `NType.archivo` / `.mono` / `.serif` / `.arabic` — the four font family
  names, for one-off `TextStyle`s that don't fit a named role.
- `NType.h1`..`NType.h5` — Archivo w800 headings, 42/32/25/20/16.
- `NType.h6` — the uppercase eyebrow (13px); uppercase the string yourself.
- `NType.body` — Archivo 15/1.55/w400, the default paragraph style.
- `NType.railNumber` — MartianMono 10, for `01`/`02`/`03` rail markers.
- `NType.kicker` — MartianMono 11 uppercase, for `RULES`/`FEATURE`/etc.
- `NType.specId` — MartianMono 11, for spec ids like `ir.car`.
- `NType.pill` — MartianMono 9.5 uppercase, for pills and segmented controls.
- `NType.forScript(text)` — returns `arabic` or `archivo` by script.
- `NSpace.s1`..`.s8` — the spacing scale, 2.8 to 22.4px.
- `NRadius.sm`/`.md`/`.lg`/`.pill` — corner radii, 4/8/14/999px.
- `NShadow.hairline(opacity)` — a 1px `Border` in white at an alpha.
- `NShadow.smBorder`/`.mdBorder`/`.lgBorder` — the three hairlines.
- `NShadow.smShadows`/`.mdShadows`/`.lgShadows` — the matching blur lists;
  use border + shadows together on one `BoxDecoration`.
- `NBreak.hero`/`.detail`/`.shell`/`.stats` — page breakpoints, 1180/1040/900/760.
- `NRule` — a widget: a 1px divider that fades over its first/last 48px.
