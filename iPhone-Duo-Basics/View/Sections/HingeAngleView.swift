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


/// Side view of the device opening like a laptop: the lid swings about the hinge
/// and a wedge marks the angle between the two halves.
struct HingeLaptopProfile: View {
    let reading: HingeReading

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let hinge = CGPoint(x: 170, y: 150)
    private let armLength: CGFloat = 110
    private let thickness: CGFloat = 8
    private let wedgeRadius: CGFloat = 44
    private let guideLength: CGFloat = 118

    private var degrees: Double { min(max(reading.angleDegrees, 0), 180) }
    private var tint: Color { reading.status.color }

    var body: some View {
        ZStack {
            desk
            guides
            wedge
            base
            lid
            Circle()
                .fill(.primary)
                .frame(width: 12, height: 12)
                .position(hinge)
            angleLabel
        }
        .frame(width: 300, height: 190)
        .animation(reduceMotion ? nil : .smooth, value: reading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hinge angle")
        .accessibilityValue("\(reading.status.title), \(reading.formattedAngle)")
    }

    private var desk: some View {
        Rectangle()
            .fill(.quaternary)
            .frame(width: 270, height: 2)
            .position(x: 155, y: hinge.y + thickness)
    }

    private var guides: some View {
        ZStack {
            Path { path in
                path.move(to: hinge)
                path.addLine(to: CGPoint(x: hinge.x, y: hinge.y - guideLength))
                path.move(to: hinge)
                path.addLine(to: CGPoint(x: hinge.x + guideLength, y: hinge.y))
            }
            .stroke(.tertiary, style: StrokeStyle(lineWidth: 1.2, dash: [3, 4]))

            Text("90° laptop")
                .frame(width: 90, alignment: .leading)
                .position(x: hinge.x + 8 + 45, y: hinge.y - 104)
            Text("180° flat")
                .frame(width: 90, alignment: .trailing)
                .position(x: hinge.x + 116 - 45, y: hinge.y - 8)
        }
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)
    }

    private var wedge: some View {
        ZStack {
            HingeWedge(degrees: degrees).fill(tint.opacity(0.22))
            HingeWedge(degrees: degrees).stroke(tint, lineWidth: 2)
        }
        .frame(width: wedgeRadius * 2, height: wedgeRadius * 2)
        .position(hinge)
    }

    /// The half that stays put, below the hinge line.
    private var base: some View {
        RoundedRectangle(cornerRadius: thickness / 2)
            .fill(Color.indigo.opacity(0.65))
            .frame(width: armLength, height: thickness)
            .position(x: hinge.x - armLength / 2, y: hinge.y + thickness / 2)
    }

    /// The half that swings: rotates clockwise about the hinge, from lying on
    /// the base (0°) up through vertical (90°) to flat (180°).
    private var lid: some View {
        RoundedRectangle(cornerRadius: thickness / 2)
            .fill(Color.indigo)
            .frame(width: armLength, height: thickness)
            .rotationEffect(.degrees(degrees), anchor: .bottomTrailing)
            .position(x: hinge.x - armLength / 2, y: hinge.y - thickness / 2)
    }

    private var angleLabel: some View {
        let mid = Angle.degrees(degrees / 2).radians
        let radius = wedgeRadius + 26
        return Text(reading.formattedAngle)
            .font(.subheadline.weight(.heavy))
            .foregroundStyle(tint)
            .contentTransition(.numericText(value: degrees))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.background.opacity(0.8), in: .capsule)
            .position(x: hinge.x - radius * cos(mid), y: hinge.y - radius * sin(mid) + 5)
    }
}

/// A pie slice that starts at the left arm and sweeps clockwise over the top by
/// `degrees`, centred in its rect. Built from line segments rather than
/// `Path.addArc` so the sweep direction is unambiguous.
nonisolated private struct HingeWedge: Shape {
    var degrees: Double

    var animatableData: Double {
        get { degrees }
        set { degrees = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        let steps = max(1, Int((degrees / 3).rounded(.up)))

        var path = Path()
        path.move(to: center)
        for step in 0...steps {
            // Screen y grows downward, so adding to 180° sweeps left → up → right.
            let angle = Angle.degrees(180 + degrees * Double(step) / Double(steps)).radians
            path.addLine(to: CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            ))
        }
        path.closeSubpath()
        return path
    }
}
