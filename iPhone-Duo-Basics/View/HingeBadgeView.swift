import SwiftUI

struct HingeBadge: View {
    var reading: HingeReading?

    var body: some View {
        HStack(spacing: 8) {
            if let reading {
                Image(systemName: reading.status.symbol)
                Text(reading.status.title)
                Text(reading.formattedAngle)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText(value: reading.angleDegrees))
            } else {
                Image(systemName: "iphone.slash")
                    .symbolRenderingMode(.hierarchical)
                Text("No hinge on this device")
            }
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.fill.tertiary, in: .capsule)
        .animation(.default, value: reading)
    }
}
