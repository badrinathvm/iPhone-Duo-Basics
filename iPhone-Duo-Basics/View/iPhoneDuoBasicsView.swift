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
