# Plate Gallery Design Map

## Design tokens
- **`:root` CSS variables**: lines 18–43
  - Colors: `--color-bg`, `--color-surface`, `--color-text`, `--color-divider`, `--color-neutral-*`, `--color-accent*`
  - Fonts: `--font-heading`, `--font-body`, `--font-heading-weight`
  - Shadows: `--shadow-sm`, `--shadow-md`, `--shadow-lg`

## Style block offsets
- **`<style>` tag**: lines 13–74
  - Font-face declarations: lines 14–17
  - Root CSS variables: lines 18–43
  - Keyframes & utility classes: lines 44–74

## JavaScript logic
- **`devicePresets()` function**: lines 659–665
  - Mobile: 390×844, 54px radius, 12px bezel, 126×32 notch
  - Tablet: 1194×834, 38px radius, 16px bezel, no notch
  - Desktop: 1180×740, 38px radius, 22px bezel, 180×22 notch

- **`tiles()` function**: lines 669–687
  - 7-row × 9-col tile grid for callout animations
  - Randomized finish times seeded per callout

## Desktop layout

### Showcase (desktop)
- **Lines**: 85–172
- **Outermost element**: `<section>`, no explicit class, inline `style="min-height:100vh;display:grid;grid-template-rows:1fr auto;animation:pg-rise .5s ease both"`
- **Description**: Hero section with animated gradient background, device preview with rotating presets, three animated callouts, and a stat band at bottom showing 4 metrics
- **Key components**:
  - Hero left (lines 93–104): heading, subheading, two CTA buttons
  - Hero right / device stage (lines 106–161): device frame with notch, deck, device preset buttons, animated callout cards, stamp
  - Stat band (lines 164–171): 4-column grid of stats

### Discover (desktop)
- **Lines**: 175–227
- **Outermost element**: `<section class="pg-discover">`, inline `style="padding:72px 64px 96px 72px;animation:pg-rise .4s ease both"`
- **Description**: Plate archive catalog with country groups; each group has a sidebar and grid of plate specimens
- **Key components**:
  - Header (lines 177–191): "02 — Discover" label, heading, description, 3 stat cards
  - Country groups (lines 193–225): repeating group with title/description on left, 3-column plate grid on right

### About (desktop)
- **Lines**: 229–273
- **Outermost element**: `<section class="pg-discover">`, inline `style="padding:72px 64px 96px 72px;animation:pg-rise .4s ease both"`
- **Description**: Background on architecture (plate = spec + theme + country) and dependency list
- **Key components**:
  - Header (lines 231–240): "03 — About" label, heading, 2-paragraph intro
  - Countries section (lines 242–254): table-like list of 5 countries with package, specs count, and description
  - Built against (lines 256–272): grid of 3 dependency cards (core_plate, core_plate_bloc, plate_keypad)

### Plate detail (desktop)
- **Lines**: 276–334
- **Outermost element**: `<section class="pg-detail">`, inline `style="min-height:100vh;display:grid;grid-template-columns:minmax(0,1.15fr) 380px;animation:pg-rise .4s ease both"`
- **Description**: Large plate preview with input mode picker and details sidebar
- **Key components**:
  - Main left (lines 278–301): back button, title, large plate render, slot count
  - Aside right (lines 303–333): Input section (radio-like mode picker), Details (key-value list), Submit button

## Mobile layout (`.pg-m` modifier)

### Side navigation (desktop)
- **Lines**: 626–646
- **Outermost element**: `<nav class="pg-sidenav">`, inline `style="border-left:1px solid var(--color-divider);padding:44px 0;...position:sticky;top:0;...height:100vh"`
- **Description**: Sticky right sidebar with branding, nav items (01 Showcase, 02 Discover, 03 About), view toggle button, footer
- **Nav items**: lines 631–641 (4 items including view toggle)

### Mobile sheets
- **Mobile wrapper**: lines 337–623 (within `<sc-if value="{{ mobileView }}">`)
- **Layout structure**: header + scrollable content + bottom nav

#### Showcase (mobile)
- **Lines**: 350–433
- **Data attribute**: `data-screen-label="Showcase"`
- **Description**: Stacked layout with hero text, centered device preview, featured plate carousel, stats grid, callout cards, footer stamp

#### Discover (mobile)
- **Lines**: 436–500
- **Data attribute**: `data-screen-label="Discover"`
- **Description**: Country selector header, scrollable plate list, "Other countries" button grid

#### About (mobile)
- **Lines**: 502–543
- **Data attribute**: `data-screen-label="About"`
- **Description**: Intro text, countries list, dependencies grid

#### Plate detail (mobile)
- **Lines**: 545–597
- **Data attribute**: `data-screen-label="Plate detail"`
- **Description**: Back button, centered large plate, title, input mode picker, details list

### Mobile navigation
- **Bottom nav bar**: lines 601–614
  - 3-button nav (Showcase, Discover, About) with accent underline indicator
  - Only shown when `{{ tabsShown }}` is true (not on plate detail)

## Fonts

Declared in `pubspec.yaml` as vendored assets:
- **Archivo** (latin, latin-ext): heading & body font, weights 100–900
- **MartianMono** (latin, latin-ext): monospace UI font, weights 100–800
- **Newsreader** (latin, latin-ext): serif body copy, weights 200–800
- **Vazirmatn** (arabic): RTL content, weights 100–900

Files verified under `assets/fonts/`:
- `Archivo-latin.ttf`
- `MartianMono-latin.ttf`
- `Newsreader-latin.ttf`
- `Vazirmatn-arabic.ttf`

## Design system (Nocturne)
- **Path**: `design_ref/_ds/nocturne-3f3a99e9-4727-4100-a8c9-4ab51064b2b5/`
- **Files**:
  - `styles.css`: Nocturne token CSS (linked in `<link>` line 11)
  - `_ds_bundle.js`: Nocturne JS bundle (linked in `<script>` line 12)
  - `readme.md`: Token definitions and semantics

## Screenshot assets
- **Path**: `design_ref/uploads/`
- **Files**: 5 PNG screenshots (pasted-*) showing reference UI states (from Figma captures)
