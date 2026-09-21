# Split Arrangement: Role Cards panes (A) + Seam Handle (D)

Design options page (all six, interactive): https://claude.ai/artifact/VvdFXWvZnK6mEpFSxosAnD
Offline copy: [`split-pane-designs.html`](split-pane-designs.html) (open in a browser).

## Decision
From six directions (A Role Cards, B Blueprint, C Mail App, D Seam Handle, E Layout Map, F Glass Aurora) we chose the recommended mix: **A for the Primary and Secondary panes, plus D's seam handle for the layout ratio.**

Validation is manual, in Xcode on the 27.1 SDK.

## Rule: existing comments are never removed
All comments in `View/SplitArrangementView.swift` are preserved verbatim, including the header, the `///` doc line, the two comments above `.arrangementViewStyle(.split.axes(axes.value))`, and the commented-out `axisDescription` chip block. Edits were targeted replacements, and the file was diffed against a snapshot afterwards (14/14 original comment lines intact).

The comment above `.arrangementViewStyle` matters for the design: with `.horizontal`, both panes show in landscape but in portrait **only the primary is shown**. So the seam handle only exists while the secondary pane is on screen.

## What changed
| File | Change |
|---|---|
| `View/SplitArrangementView.swift` | Panes now carry a role skeleton and chips; the in-pane ratio slider is gone; the primary pane hosts the `SeamHandle`. |
| `View/SeamHandle.swift` (new) | Draggable grabber that edits `ratio`. |
| `Utils/DuoSections.swift` | Title typo fix: "Split Arrangments" → "Split Arrangement". |

### `SplitArrangementView`
- **State:** `isSecondaryVisible` (set by the secondary pane's `onAppear`/`onDisappear`) and `containerSize` (from `.onGeometryChange`, placed right after the `.arrangementViewStyle` line).
- **Panes:** `PaneView` takes `skeleton` (`.list` / `.document`), `axes` and `share` instead of the `ratio` binding. `ViewThatFits(in: .vertical)` now tries icon + title + skeleton + chips, then icon + title + chips, then title only.
- **Skeletons:** four list rows for Primary (first highlighted); a hero block and text lines for Secondary.
- **Chips:** `axis: horizontal` and the live share (40% / 60%), styled like the commented-out chip.
- **Seam handle:** an overlay on the primary pane at its trailing (horizontal) or bottom (vertical) edge, shown only when the secondary is visible, applied before `.splitArrangementLayoutRatio(ratio)`.
- **`AxesOption`:** gained `var axis: Axis`.

### `SeamHandle`
- `SeamHandle(ratio:axis:length:range:)`, range defaults to 0.2…0.8.
- `DragGesture(minimumDistance: 0, coordinateSpace: .global)`: ratio = start + translation ÷ container length, clamped. The global space is deliberate; the handle rides on the primary pane, which moves as the ratio changes, so a local translation would feed back on itself.
- Selection haptic on each whole percent; accessibility label "Layout ratio", percent value, and ±5% adjustable action.

## Left out on purpose
- The mockup's subtitle line ("list · drives layout"): it would have meant restructuring around `Text(title)` and the commented-out chip block.
- D's percent hero numerals: the live share chip covers it.
- The commented-out chip block was not uncommented; the new chip code is separate.

## Assumptions to check
- The ratio is the primary pane's share of the split, clamped to 0.2–0.8 as in the old slider.
- A hidden secondary pane doesn't fire `onAppear`. If `ArrangementView` keeps it alive but hidden, the handle would still show in the single-pane case.
- Dragging maps 1:1 to the ratio (Δpoints ÷ container length); the real spacing inside `ArrangementView` may make it feel slightly off.
- The handle sits just inside the primary card's edge rather than centred on the seam, so `ArrangementView` can't clip it.
