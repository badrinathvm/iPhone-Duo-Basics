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
