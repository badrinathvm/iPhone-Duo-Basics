import SwiftUI

// MARK: - Entry Point
@available(anyAppleOS 27.1, *)
struct iPhoneDuoBasicsView: View {
    private let composer = CatalogComposer()

    var body: some View {
        HingeFlow(
            content: composer.compose
        )
    }
}

// MARK: - State Manager
struct HingeFlow<Content: View>: View {
    @State private var state: HingeState
    private let content: (HingeState) -> Content

    init(
        content: @escaping (HingeState) -> Content
    ) {
        self._state = State(wrappedValue: HingeState())
        self.content = content
    }

    var body: some View {
        content(state)
    }
}
