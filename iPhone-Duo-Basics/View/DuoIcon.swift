import SwiftUI

/// A rounded, tinted SF Symbol tile used to represent an example.
struct DuoIcon: View {
    let duo: Duo
    var size: CGFloat = 40

    var body: some View {
        Image(systemName: duo.symbol)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(duo.tint.gradient, in: .rect(cornerRadius: size * 0.28))
    }
}
