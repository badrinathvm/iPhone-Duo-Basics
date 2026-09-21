import SwiftUI

struct SelectionScreen<Content: View>: View {
    var selection: Duo
    @State private var isInfoPresented = false
    @ViewBuilder var content: Content

    var body: some View {
        content
            .navigationTitle(selection.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("About", systemImage: "info.circle") {
                        isInfoPresented = true
                    }
                }
            }
    }
}
