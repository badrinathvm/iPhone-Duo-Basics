import SwiftUI

extension Duo {
    var tint: Color {
        switch section {
        case .hinge: .indigo
//        case .reservedRegions: .pink
        case .arrangements: .teal
//        case .barsAndMargins: .orange
//        case .adaptivity: .green
        }
    }
}
