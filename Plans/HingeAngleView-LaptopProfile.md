# Hinge Angle screen — Laptop Profile (option B)

Design options page (all six, interactive): https://claude.ai/artifact/CUMmBepkUAxx22aXJ4ojzF
Offline copy: [`hinge-angle-designs.html`](hinge-angle-designs.html) (open in a browser).

## Decision
From six directions (A Fold + Gauge, **B Laptop Profile**, C Protractor Dial, D Posture Hero, E Glass Dashboard, F 3D Device) we chose **B**: a side view of two slabs joined at a hinge dot, a filled angle wedge labelled at the hinge, dashed ghost guides at 90° and 180°, and the posture name below.

Validation is manual, in Xcode on the 27.1 SDK, using the `#Preview`s.

## Files (under `iPhone-Duo-Basics/iPhone-Duo-Basics/`)
| File | Change |
|---|---|
| `View/HingeAngleView.swift` | Screen. `state.current` present → `HingeLaptopProfile` + posture title + "lid opened to N°". `nil` → `ContentUnavailableView("No hinge on this device")`. Has the `#Preview`s. |
| `View/HingeLaptopProfile.swift` | Draws the profile in a fixed 300×190 space (hinge at (170,150), arms 110 long, 8 thick). Contains the private `HingeWedge` shape. |
| `Utils/Hinge+Display.swift` | Unchanged. Reuses `formattedAngle` and `HingeStatus.title/symbol/color`. |
| `Domain/`, `Actions/`, `Data/`, `Repositories/`, `Composers/` | Unchanged. |

## Drawing
- **Base slab:** `.indigo.opacity(0.65)`, below the hinge line.
- **Lid slab:** `.indigo`, above the line, rotated with `rotationEffect(.degrees(angle), anchor: .bottomTrailing)`. 0° lies on the base, 90° points up, 180° lies flat.
- **Wedge:** `HingeWedge`, an `Animatable` `Shape`. It is a polyline sector (3° steps) from the left arm to the lid, filled with `status.color.opacity(0.22)` and stroked in `status.color`. A polyline is used instead of `Path.addArc` so there is no arc-direction quirk to get wrong.
- **Angle label:** at the wedge's mid-direction (radius 70), `contentTransition(.numericText)`, on a soft capsule so it stays legible over the slabs.
- **Guides:** dashed lines at 90° (up) and 180° (right), captions "90° laptop" / "180° flat", a hinge dot, and a thin desk line under the base.
- **Motion:** angle clamped to 0…180; `.smooth` animation moves lid, wedge and label together; disabled under Reduce Motion.
- **Accessibility:** one combined element, label "Hinge angle", value "Partially Open, 120°".

## Previews
- **Hinge angle:** a demo wrapper with a 0–180° slider writing a synthetic `HingeReading` into a `HingeState`. `HingeReading` is SDK-free, so this works with no foldable and without the 27.1 SDK. It uses the page's placeholder cut-offs (closed < 10°, fully open ≥ 170°).
- **No hinge:** the empty state.

## Assumptions to check
- The hinge range is 0–180° (from the reference screenshot). Check against the real `DeviceHinge` docs.
- The status cut-offs used in the preview are placeholders; the app uses the SDK's own `status`.
- Empty state only, no in-app demo mode (the preview slider covers exploring without a hinge).
- The sidebar header keeps `HingeBadge`.
