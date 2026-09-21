import Foundation

// MARK: - Business Logic
struct HingeUseCase {
    private let repository: HingeRepositoryInterface
    private let historyLimit: Int

    init(
        repository: HingeRepositoryInterface,
        historyLimit: Int = 200
    ) {
        self.repository = repository
        self.historyLimit = historyLimit
    }

    /// Records the reading unless the hinge hasn't moved since the latest one,
    /// and returns the resulting history, oldest first.
    func record(_ reading: HingeReading) async throws -> [HingeReading] {
        let existing = try await repository.history()
        if let latest = existing.last, latest.hasSameHinge(as: reading) {
            return existing
        }
        try await repository.append(reading)
        try await repository.trim(toLast: historyLimit)
        return try await repository.history()
    }

    func history() async throws -> [HingeReading] {
        try await repository.history()
    }
}
