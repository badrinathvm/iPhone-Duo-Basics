import SwiftUI

extension HingeReading {
    /// The hinge angle in whole degrees, formatted for display.
    var formattedAngle: String {
        angleDegrees.formatted(.number.precision(.fractionLength(0))) + "°"
    }
}

extension HingeStatus {
    var title: String {
        switch self {
        case .closed: "Closed"
        case .partiallyOpen: "Partially Open"
        case .fullyOpen: "Fully Open"
        case .unknown: "Unknown"
        }
    }

    var symbol: String {
        switch self {
        case .closed: "iphone.gen3"
        case .partiallyOpen: "laptopcomputer"
        case .fullyOpen: "ipad.landscape"
        case .unknown: "questionmark.circle"
        }
    }

    var color: Color {
        switch self {
        case .closed: .gray
        case .partiallyOpen: .orange
        case .fullyOpen: .green
        case .unknown: .secondary
        }
    }
}
