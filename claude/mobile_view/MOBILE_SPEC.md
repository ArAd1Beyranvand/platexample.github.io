# MOBILE_SPEC — frozen by MV0

Sources: `claude/mobile_view/design/plate_gallery.html` (mobile `onShowcaseM` block, lines 401–522; header
388–399; tab bar 738–751; script 786–1025) and the live code under `lib/`. No Dart was changed.

The design's mobile frame is **390 × 812, radius 28** (`.pg-main.pg-m`), i.e. the same panel as
`MobilePanelChrome`. Design px == Flutter logical px at 390 wide.

---

## 1. Tokens

All colours/radii/fonts already exist in `lib/theme/nocturne.dart` (`N`, `NType`, `NRadius`, `NShadow`).
Only three accent steps are missing; the design reads them from `design_ref/_ds/*/styles.css`.

| Design token | Value | Dart | Used by |
|---|---|---|---|
| `--color-bg` | `#050608` | `N.bg` | body, deck gradient end |
| `--color-surface` | `#141926` | `N.surface` | carousel card gradient start |
| `--color-divider` | `rgba(255,255,255,.10)` | `N.divider` | section `border-top`, header/tab bar border |
| neutral 100/200/300/400/500/600/700/800/900 | `#EAF0FB #D6E1F1 #C4D0E2 #A5B4C7 #8592A3 #6A7484 #39414F #232C42 #0E1219` | `N.n100…n900` | see blocks |
| `--color-accent` / 300 / 700 / 800 / 900 | `#7C5CFF #B9A7FF #4A3A93 #2E2560 #1A1540` | `N.accent`, `accent300/700/800/900` | |
| **accent-200 / 400 / 500** | `#E7E5FE #B5ABFC #968AE0` | **missing — add `N.accent200/400/500`** | archive strip (`PG`, ring), progress "done" fill |
| `--radius-lg` / md / sm | 14 / 8 / 4 | `NRadius.lg/md/sm` | cards |
| `--shadow-md` | `0 0 0 1px rgba(255,255,255,.10), 0 10px 26px rgba(0,0,0,.70)` | `NShadow.mdShadows` (+ hairline) | plate on carousel card |
| Fonts | Archivo (heading 800), MartianMono, Newsreader, Vazirmatn | `NType.archivo/mono/serif/arabic` | |
| Page bg (panel) | `radial-gradient(120% 100% at 50% 0%, #0d0f16, #050608 60%)` | already in `MobilePanelChrome` | |
| Entry animation | `pg-rise .4s ease` (10px up + fade) | `PageRiseRoute` / local | section mount |
| Story dwell | **4 s** per card, linear fill `scaleX 0→1`, `animation: pg-fill 4s linear` | `Duration(seconds: 4)` | deck progress |
| Device morph | `.7s cubic-bezier(.2,.8,.2,1)` | frozen in `device_preview/**` | frame |

Type used by the mobile showcase (all MartianMono unless noted; `ls` = letter-spacing in em; size in px):

| Role | size / weight / ls / colour | Notes |
|---|---|---|
| Header brand `PLATE GALLERY` | 10 / 400 / .14 / n100 | preceded by 16×1 accent rule, gap 10 |
| Header right `01 / SHOWCASE` | 9.5 / 400 / .12 / n600 | |
| Section label (`ONE COUNTRY PER PACKAGE`, `WHAT IT DOES`, `THE ARCHIVE, REGISTERED`) | 10 / 400 / .12 / n400, uppercase | |
| Section aside (`ALL COUNTRIES`) | 9.5 / .10 / n600 | |
| Deck aside (`MOBILE PREVIEW`) | 9.5 / .10 / accent300 | |
| Device chip | 9.5 / .10 / n500 (hover n200), border 1 n800, pill, pad 5×12 | |
| Deck eyebrow | 9.5 / .12 / accent300 | = `CalloutSpec.kicker` |
| Deck title (Archivo) | 26 / **500** / −.03 / h 1.08 / n100, balance wrap, `\n` honoured | note weight 500, not 800 |
| Deck body (Newsreader) | 16 / h 1.45 / n400 | design shows it; real data has none (see §5) |
| Deck numeral | 150 / 700 / −.06 / h 1, transparent fill + 1px stroke n800 | `right:-6 bottom:-30`; slashed zero → MV5 |
| Deck foot `01 / 09`, `TAP TO ADVANCE` | 9 / .10 / n600 | |
| Carousel plate text | 21 / 700 / .05 / `f.ink`, centred; code 10/700 | plate drawn by real `PlateView`, not text |
| Carousel country (Archivo) | 14 / n100 | |
| Carousel spec id | 9.5 / .06 / n500 | `NType.specId` family |
| Archive number | 24 / 600 / −.02 / n100 | |
| Archive cell label | 7.5 / .10 / n500, nowrap, uppercase | `PKGS COUNTRIES SPECS FORMS` |
| Archive `ایران` (Vazirmatn) | 9 / n400 | |
| Archive `MIT` | 11 / 600 / accent300 | |
| Archive caption | 9 / .10 / n600, uppercase | `IRAN MADE · OPEN SOURCE` / `V1 · 2026` |
| Tab label | 10 / .11 / n500 (hover n200), uppercase | active: accent bar above |
| Hero credit | 10 / .13 / accent300 | |
| Hero h1 (Archivo) | 40 / 800 / −.04 / h .94 | |
| Hero para (Newsreader) | 17 / h 1.48 / n300 | |

### Geometry

| Block | Spec |
|---|---|
| Header | padding 15×18, `border-bottom` divider, space-between |
| Hero | padding 32/18/30; accent radial `95% 62% at 12% 0%` @16%; buttons stacked, gap 10, 100% wide, 15px, pad 14; margin-top 24 |
| Device section | `border-top`; padding 28/0/24; chips `margin-top:16`, gap 6 |
| Carousel section | `border-top`; padding 24/0/20; header row padding 0/18/16 |
| Carousel track | gap 12, padding 0/18/6, scroll-snap x mandatory, **start**-aligned |
| Carousel card | `flex 0 0 262`, pad 16/16/14, grid gap 16, r14, `linear-gradient(180deg, surface, n900)`, border 1 n800 |
| Plate strip in card | r6, panel pad 0/9, plate pad 14/12 (illustrative only; use the real plate) |
| Card footer | `border-top` n800, pad-top 12, country left / spec right (baseline) |
| Deck section | `border-top`; padding 24/18/8 |
| Segmented bar | 3 groups, gap 6; each group 3 segs, gap 3; seg hit area pad 8/0; bar 2px, r2, n800; done = accent-500; active = accent + 6px glow, fills 4 s |
| Deck card | min-height **212**, r14, `linear-gradient(160deg, n900, bg 70%)`, inset 1px n800 |
| Deck accent mark | `left:18 top:0 28×2`, accent, glow `0 0 12px accent` |
| Deck text block | pad 22/18/20, gap 10, max-width 290 |
| Tap zones | left **35 %** = back, right **65 %** = next (task says "right half"; HTML is 35/65) |
| Archive section | padding 28/18/36 |
| Archive strip | r10, `linear-gradient(180deg,n900,bg)`, inset 1.5px n700 + glow `0 0 36px -12px accent@55%`, **`direction:ltr`** |
| Archive `PG` band | 30 wide, `accent900`, right hairline n700, ring 12×12 inset 1px accent400 (top), `PG` 8.5/700/.06 accent200 (bottom) |
| Archive cells | flex 1, pad 14/2/12, gap 6, right hairline n800 |
| Archive corner | 44 wide, `ایران` over `MIT`, gap 4 |
| Tab bar | 3 equal cells, `min-height 60`, `border-top` divider, bg n900, `border-right` n800 per cell; accent bar 18×2 above label, gap 7 |

---

## 2. Block → new file → data source

New code root: **`lib/mobile/`** (README assumed `example/lib/mobile/`; this app has no `example/`).

| # | Design block | New file | Data source |
|---|---|---|---|
| 0 | tokens/primitives (`MonoLabel`, `SectionHeader`, three accent steps) | `mobile/mobile_tokens.dart`, `mono_label.dart`, `section_header.dart` | `N`, `NType` |
| 1 | Header `— PLATE GALLERY` / `01 / SHOWCASE` | `mobile/mobile_header.dart` (or keep `NocturneMobileHeader`, see §3) | `ShellRouteState.headerLabel` (already `01 / SHOWCASE`) |
| 2 | Hero (credit, h1, para, 2 buttons) | keep `ShowcaseHero` compact text (`_HeroText`) — see Q1 | `hero.dart` |
| 3 | Device frame + 3 chips | reuse `DeviceStage` + `_cycle` from `ShowcaseScreen`; chips = new `mobile/device_chips.dart` | `DeviceType`, `DeviceCycleController.pin` |
| 4 | "ONE COUNTRY PER PACKAGE · ALL COUNTRIES" carousel | `mobile/package_carousel.dart` | `gallerySources` → `source.highlightItems.first` (`CatalogueItem`: `source.countryName`, `entry.spec.id`, plate via `PlateFrame`/`PlateTile` internals) |
| 5 | "WHAT IT DOES" deck | `mobile/feature_deck.dart`, `mobile/segmented_progress.dart` | `calloutSets[DeviceType]` (`kicker`, `title`) flattened Mobile→Tablet→Desktop |
| 5a | Rolling outlined numeral | `mobile/rolling_numeral.dart` (MV5) | deck index; preview in `design/rolling_numeral_preview.html` |
| 6 | "THE ARCHIVE, REGISTERED" plate strip | `mobile/archive_strip.dart` | `CatalogueStats.of(gallerySources).tiles` (labels need a `short` form: `pkgs / countries / specs / forms`) |
| 7 | Tab bar | **no new file** — `NocturneBottomBar` already matches (60px, accent bar, n900, `SHOWCASE/DISCOVER/ABOUT`) | `AppTab` |
| 8 | Composition | `mobile/mobile_showcase_body.dart`, used by `ShowcaseScreen` below the breakpoint | — |

Section order in the HTML (differs from the task prose, which lists the carousel before the device):
**header → hero → device frame + chips → carousel → deck → archive strip → tab bar.**

---

## 3. Current-file inventory

| File | Verdict | Why |
|---|---|---|
| `lib/screens/showcase_screen.dart` | **rewrite** (mobile branch only) | keeps `_cycle/_device/_phase`; add width switch to the mobile body |
| `lib/screens/showcase/hero.dart` | **keep**; `_compact()` **delete/replace** at MV7 | `_HeroText` + `_HeroMetrics.compact()` are reused; `_compact` stacks stage + `CalloutList` which the new body replaces. `_wide`/`_stacked` untouched |
| `lib/screens/showcase/stat_band.dart` | **keep** | desktop only; mobile 2×2 grid is dropped (it is only used by the hero stack today) |
| `lib/poster/callouts/callout_card.dart` → `CalloutList` | **delete** after MV7 if unused; `CalloutLayer`/`CalloutCard` **keep** | `CalloutList` is the stacked RULES/CONTROLLER/STATE cards. Check `showcase_callouts_test.dart` first |
| `lib/poster/callouts/callout_data.dart` | **keep** | the deck's data |
| `lib/shell/nocturne_mobile_header.dart` | **keep** (verify `trailing` styling) | already `PLATE GALLERY`; spec at 10/.14 |
| `lib/shell/nocturne_bottom_bar.dart` | **keep** | matches |
| `lib/shell/mobile_panel.dart` | **rewrite** | add the out-of-panel `DESKTOP VIEW` button (Q3) |
| `lib/screens/gallery_shell_screen.dart` | **rewrite** (small) | remove the `DESKTOP VIEW` header `trailing` (L493–501) |
| `lib/showcase/device_stage.dart`, `device_cycle.dart`, `device_preview/**` | **frozen** | consume only |
| `lib/screens/gallery/catalogue*.dart` | keep | data |
| `test/showcase_hero_test.dart`, `showcase_callouts_test.dart`, `nocturne_rail_test.dart` | rewrite as needed | MV8 |

---

## 4. Breakpoint

- Shell already switches at `NBreak.shell = 900` (rail vs. header + bottom bar). The forced panel is 390 wide, so it
  lands in the phone branch regardless of the window.
- The hero today has three modes: `≥1180` wide, `≥560` stacked, `<560` compact (`NBreak.panel`).
- **Decision:** the new mobile body replaces **only the compact (`< NBreak.panel = 560`) mode**, measured with the
  `LayoutBuilder` inside the page column (not `MediaQuery`, so the forced panel and device-frame re-embeds work).
  560–900 keeps the stacked hero + tab bar (task is "mobile body only"; the HTML defines nothing for that range).

## 5. Open questions — answers

1. **Hero kept?** Yes, **kept above everything**: credit line, h1, paragraph, two full-width buttons (HTML 403–414).
   Copy differs from the app: HTML says `Plate input for the road.` / `Open the archive` / `Read the docs` /
   "Five country packages ship today"; the app says `Browse plates` / `View on pub.dev` with a count-free paragraph.
   Layout is taken from the HTML; **copy stays the app's** (HTML copy is mock). → **ASK USER** only if the
   headline `Plate input for the road.` vs. `…for Flutter.` should change.
2. **Device frame / chips.** Directly **under the hero, above the carousel**, in its own divider-topped section; chips
   centred **below** the frame (gap 16). The HTML frame is an empty bezel; the Flutter one hosts the real
   `DeviceStage`. Chips: Mobile / Tablet / Desktop, tap → jump deck to that group's **first** card (`i*3`) which pins
   the device. HTML defines no active-chip style → use `n200` text + `n700` border (own call, flagged).
   **Overflow risk:** HTML scales are mobile 0.44 (172×371), tablet 0.34 → **406 wide**, desktop 0.34 → 401 wide
   (deck 425), all wider than the 390 panel. Fit-to-width (≤ panel − 36) is required; `device_preview/**` is frozen,
   so scale from outside.
3. **`DESKTOP VIEW`.** The HTML header never carries it. The toggle is `.pg-mtoggle`, a pill `position:fixed;
   top:18; right:18` **outside the 390 panel** on the viewport, 9.5 / .10 / pad 9×16, `btn-secondary`, shown only
   in mobile view. → Header always shows `01 / SHOWCASE`; the toggle moves to `MobilePanelChrome`'s outer
   ground, visible only while `forceMobilePanel` is true. A real narrow window has no toggle.
4. **Feature count per group.** Real data is exactly **3 + 3 + 3 = 9** (`calloutSets`: mobile KEYPAD/FOCUS/IME,
   tablet RULES/CONTROLLER/STATE, desktop COUNTRIES/KEYBOARD/SPECS). Matches the design; keep the
   `01 / 09` and 3-3-3 segmented bar, but build both from the data length, not a literal. Two gaps:
   - Every real `CalloutSpec.body` is **null** → the deck is eyebrow + title only; no paragraph path needed
     (keep it optional).
   - Titles are sentences with no `\n`; at 26px / max-width 290 they wrap to 3–4 lines (e.g. `Validation marks a bad plate
     red and never blocks a key`). Card is `min-height 212`, so must grow, not clip.

## 6. Behaviour notes for later phases

- **Device order differs:** deck = Mobile, Tablet, Desktop (design); `DeviceCycle.order` = desktop, mobile, tablet;
  `calloutSets` map = mobile, tablet, desktop. The deck must define its own order and drive the device via
  `DeviceCycleController.pin(DeviceType)`.
- `pin` is permanent (stops `advance()`), which is what we want: the `DeviceStage`'s own 4 s dwell timer then no-ops,
  so only the deck's timer runs. Pin to an already-showing device is ignored by `DeviceCycle` (no hop, no callback).
  `onFrameDeviceChanged` fires when the hop starts.
- Auto-advance runs only on the Showcase tab (`screen === 'showcase'`); `IndexedStack` keeps the screen mounted, so
  pause the timer when the tab is not selected. Tapping a segment or a zone **restarts** the 4 s timer.
- `story = (i % 9 + 9) % 9` wraps both ways.
- Carousel: one card per **gallery source** (today **9**: iran, iranshahr, palestine, yemen, lebanon, cuba,
  venezuela, india, germany). Iranshahr is an umbrella of 9 countries; one card, country label from
  `countryName`. Next card must peek (262 + 12 gap + 18 inset → ~98px of the second card shows).
- Plates in cards: use real plate rendering (`PlateFrame`), **not** the HTML's text imitation.

## 7. Real stat values (today)

Measured by running `CatalogueStats.of(gallerySources)`:

| Cell | Mock (HTML) | **Real** |
|---|---|---|
| PKGS | 5 | **11** (`PlateMetadata.packageCount`, hard-coded; the gallery draws from 9 sources) |
| COUNTRIES | 7 | **17** |
| SPECS | 51 | **148** |
| FORMS | 2 | **2** |

Warnings:
- README's "11 / 16 / 140 / 2" is stale (India was added).
- `test/catalogue_stats_test.dart` asserts `6 / 10 / 81 / 2` and is stale against the live catalogue (already marked `// currently failing`); fix in MV8.
- `ایران` / `MIT` / `V1 · 2026` are literals in the design; `V1` has no version source — keep literal.
