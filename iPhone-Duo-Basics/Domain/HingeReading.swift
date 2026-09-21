import Foundation

enum HingeStatus: Equatable {
    case closed
    case partiallyOpen
    case fullyOpen
    case unknown
}

/// A single hinge sample, independent of the platform SDK.
struct HingeReading: Equatable {
    let angleDegrees: Double
    let status: HingeStatus
    let timestamp: Date

    /// Whether the hinge is in the same position, ignoring when it was sampled.
    func hasSameHinge(as other: HingeReading) -> Bool {
        angleDegrees == other.angleDegrees && status == other.status
    }
}
