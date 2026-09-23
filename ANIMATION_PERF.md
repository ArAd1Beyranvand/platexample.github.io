# Animation performance

The rules the showcase's device hop is built to, and how to check it still
obeys them. Written in sk23.5, which restored the callout tile transition and
found that the document its prompt told it to read had never existed — the
rules below were reconstructed from the code and from the prompt's own account
of the P12/P12B/P12C rounds.

## The hop

One device hop is `DeviceTransitionDurations.total` = **4220ms**: 1500 fade
out, 1100 frame morph, 120 blank hold, 1500 fade in
(`lib/device_preview/device_transition.dart`). Three things animate across it:

| Layer | Driver | Window |
| --- | --- | --- |
| Device frame + content | `DeviceFrame`'s single controller, split into three intervals | the whole hop |
| Backdrop sweep | `SweepLight`, on the rising edge of `frameTransform` | the morph |
| Callout sets | `CalloutSwap`, exit `[0, 0.46]` / entry `[0.54, 1]` | the whole hop |

The callouts run the full hop rather than the morph deliberately: they read as
prose, and a sentence cannot be taken apart and put back inside 1100ms. The two
windows bracket the crossover, so **the cards are never mid-tile while the
device is at rest**.

## The four rules

These are structural — they hold or they don't, and you can check each by
reading the code. They are what made the effect cheap the first time.

### 1. Constant tree shape

`TileTransition` stays mounted at rest with `enabled: false`. Never write
`settled ? cards : TileTransition(cards)`. A shape change on the settling frame
remounts every card underneath, which is a pop on exactly the frame the card is
supposed to be crisp and still.

Enforced by `test/showcase_callouts_test.dart`, which asserts three
`TileTransition`s are mounted with the hop finished.

### 2. No per-frame rebuilds

The card set is built **once per phase** — three times a hop: hop start,
crossover, settle. `TileTransition` repaints from its own snapshot via
`SnapshotPainter.notifyListeners`, which marks the render object dirty for
paint without rebuilding anything. Nothing under it lays out text, measures an
intrinsic, or runs a `LayoutBuilder` while tiles are moving; in `CalloutLayer`
the `LayoutBuilder` sits *above* `CalloutSwap` for that reason.

### 3. Snapshot once

Each card is rasterised once, at the start of a tile phase, and the tiles paint
slices of that one `ui.Image`. `SnapshotController.clear()` is called at exactly
two moments — when `enabled` turns on, and at the crossover where the child
swaps sets — because `SnapshotWidget` holds its image for as long as
snapshotting stays on and will happily fade the *outgoing* card back in
otherwise. That was the bug fixed in `20083f1`.

### 4. Nothing paints outside the snapshot box

A snapshot rasterises the widget's own box; anything drawn beyond it is clipped
the instant tiling starts, which reads as a pop. The Nocturne `CalloutCard` has
no drop shadow, so this is currently satisfied by construction — but the
floating layer is a `Stack` the cards deliberately hang *outside*, which is why
the tiles wrap **each card** rather than the set. If a glow or shadow is ever
added to the card, give it layout room inside the card's own box.

## Measuring

No baseline frame numbers survive from the P12 rounds, so there is nothing to
regress against yet. To establish one:

1. Run in **profile** mode — debug mode's timings are meaningless here, since
   `SnapshotWidget` and the shader warm-up both behave differently.
2. Open the Showcase at 1440 wide and let the auto-cycle run three full hops.
3. In DevTools' Performance view, record across the hops and note the worst
   raster and UI frame times, then fill the table below.

| Date | Build | Worst UI | Worst raster | Notes |
| --- | --- | --- | --- | --- |
| _tbd_ | | | | first measurement after sk23.5 |

The shape of a regression to look for: a spike on the **crossover frame**
(rebuild plus two `clear()`s plus a fresh raster of three cards land together)
and on the **settle frame** (rule 1). Everything between those should be flat —
tiling frames do `rows × cols` `drawImageRect` calls and no layout at all.
