import SwiftUI

struct DuoRow: View {
    let duo: Duo

    var body: some View {
        HStack(spacing: 14) {
            DuoIcon(duo: duo)
            VStack(alignment: .leading, spacing: 2) {
                Text(duo.title)
                    .font(.headline)

                Text(duo.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .foregroundStyle(Color.black)
        }
        .padding(.vertical, 4)
    }
}
