import SwiftUI

@available(anyAppleOS 27.1, *)
struct HingeAction {
    private let state: HingeState
    private let usecase: HingeUseCase
    private let mapper: DeviceHingeMapper

    init(
        state: HingeState,
        usecase: HingeUseCase,
        mapper: DeviceHingeMapper
    ) {
        self.state = state
        self.usecase = usecase
        self.mapper = mapper
    }

    func execute(hinge: DeviceHinge?) async {
        guard let hinge else {
            state.current = nil
            return
        }
        let reading = mapper.map(hinge)
        // Show the live reading right away; history follows once recorded.
        state.current = reading
        do {
            state.history = try await usecase.record(reading)
        } catch {
            print("Failed to record hinge reading: \(error)")
        }
    }
}
