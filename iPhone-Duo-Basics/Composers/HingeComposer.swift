import SwiftUI

enum HingeFactory {
    // Shared so the history survives the composer being re-run on view updates.
    private static let repository = InMemoryHingeRepository()

    static func useCase() -> HingeUseCase {
        HingeUseCase(
            repository: repository
        )
    }
}
