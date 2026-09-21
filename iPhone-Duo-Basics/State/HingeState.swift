import Observation

@Observable
final class HingeState {
    var current: HingeReading?
    var history: [HingeReading] = []
}
