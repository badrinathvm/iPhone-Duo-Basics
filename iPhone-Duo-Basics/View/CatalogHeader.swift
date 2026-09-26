import SwiftUI

@available(anyAppleOS 27.1, *)
struct CatalogHeader: View {
    let state: HingeState
    let onHingeChange: (DeviceHinge?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SwiftUI APIs for the foldable iPhone, one example at a time.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HingeBadge(reading: state.current)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .onHingeChange { oldContext, newContext in
            onHingeChange(newContext.hinge)
        }
    }
}

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
