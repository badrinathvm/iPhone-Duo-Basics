import SwiftUI

/// A grabber for resizing a split: drag it along `axis` to change `ratio`.
struct SeamHandle: View {
    @Binding var ratio: Double
    /// The axis the two panes are laid out along.
    let axis: Axis
    /// The container's size along `axis`, in points.
    let length: CGFloat
    var range: ClosedRange<Double> = 0.2...0.8

    @State private var dragStart: Double?

    private let step = 0.05

    var body: some View {
        Capsule()
            .fill(.white.opacity(0.85))
            .frame(
                width: axis == .horizontal ? 6 : 44,
                height: axis == .horizontal ? 44 : 6
            )
            .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
            .padding(12) // larger hit area than the visible grabber
            .contentShape(.rect)
            .gesture(drag)
            .sensoryFeedback(.selection, trigger: Int((ratio * 100).rounded()))
            .accessibilityElement()
            .accessibilityLabel("Layout ratio")
            .accessibilityValue(Text(ratio, format: .percent.precision(.fractionLength(0))))
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: ratio = min(ratio + step, range.upperBound)
                case .decrement: ratio = max(ratio - step, range.lowerBound)
                @unknown default: break
                }
            }
    }

    // The global space is deliberate: the handle rides on the primary pane, which
    // moves as the ratio changes, so a local translation would feed back on itself.
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                guard length > 0 else { return }
                let start = dragStart ?? ratio
                dragStart = start
                let travel = axis == .horizontal ? value.translation.width : value.translation.height
                ratio = min(max(start + travel / length, range.lowerBound), range.upperBound)
            }
            .onEnded { _ in dragStart = nil }
    }
}
