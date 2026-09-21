import SwiftUI

struct HingeAngleView: View {
    let state: HingeState

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if let reading = state.current {
                VStack(spacing: 20) {
                    HingeLaptopProfile(reading: reading)

                    VStack(spacing: 4) {
                        Text(reading.status.title)
                            .font(.largeTitle.bold())
                            .contentTransition(.interpolate)
                        Text("lid opened to \(reading.formattedAngle)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .contentTransition(.numericText(value: reading.angleDegrees))
                    }
                    .animation(reduceMotion ? nil : .smooth, value: reading)
                }
            } else {
                ContentUnavailableView(
                    "No hinge on this device",
                    systemImage: "iphone.slash",
                    description: Text("The hinge angle appears here on a foldable iPhone.")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

///// Drives the screen with a synthetic reading, so it can be explored in a preview
///// with no foldable device.
private struct HingeAngleDemo: View {
    @State private var degrees = 120.0
    @State private var state = HingeState()

    var body: some View {
        VStack(spacing: 24) {
            HingeAngleView(state: state)
            Slider(value: $degrees, in: 0...180, step: 1) { Text("Angle") }
                .padding(.horizontal)
        }
        .onChange(of: degrees, initial: true) { _, newValue in
            state.current = HingeReading(
                angleDegrees: newValue,
                status: Self.status(for: newValue),
                timestamp: .now
            )
        }
    }

    private static func status(for degrees: Double) -> HingeStatus {
        degrees < 10 ? .closed : degrees >= 170 ? .fullyOpen : .partiallyOpen
    }
}
