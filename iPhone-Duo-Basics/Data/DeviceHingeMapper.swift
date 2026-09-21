import SwiftUI

// MARK: - Mapper (converts SDK → Domain)
@available(anyAppleOS 27.1, *)
struct DeviceHingeMapper {
    func map(_ hinge: DeviceHinge, at date: Date = .now) -> HingeReading {
        HingeReading(
            angleDegrees: hinge.angle.degrees,
            status: status(from: hinge.status),
            timestamp: date
        )
    }

    private func status(from status: DeviceHinge.Status) -> HingeStatus {
        switch status {
        case .closed: .closed
        case .partiallyOpen: .partiallyOpen
        case .fullyOpen: .fullyOpen
        default: .unknown
        }
    }
}
