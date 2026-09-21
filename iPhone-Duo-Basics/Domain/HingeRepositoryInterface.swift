import Foundation

/**
 Domain Layer (HingeRepositoryInterface)
         ↑ depends on
 Data Layer (InMemoryHingeRepository implements HingeRepositoryInterface)
 */

// MARK: - Domain Interface (abstract contract)
protocol HingeRepositoryInterface {
    func history() async throws -> [HingeReading]
    func append(_ reading: HingeReading) async throws
    func trim(toLast limit: Int) async throws
}
