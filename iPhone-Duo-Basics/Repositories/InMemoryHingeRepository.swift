import Foundation

// MARK: - Repository Implementation
final class InMemoryHingeRepository: HingeRepositoryInterface {
    private var readings: [HingeReading] = []

    func history() async throws -> [HingeReading] {
        readings
    }

    func append(_ reading: HingeReading) async throws {
        readings.append(reading)
    }

    func trim(toLast limit: Int) async throws {
        guard readings.count > limit else { return }
        readings.removeFirst(readings.count - limit)
    }
}
