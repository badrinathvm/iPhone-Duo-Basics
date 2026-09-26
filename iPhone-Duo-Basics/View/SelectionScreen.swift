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
            .sheet(isPresented: $isInfoPresented) {
                InfoSheetView(duo: selection)
            }
    }
}

private struct InfoSheetView: View {
    let duo: Duo
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        DuoIcon(duo: duo, size: 52)
                        Text(duo.summary)
                            .font(.callout)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("APIs") {
                    ForEach(duo.apis, id: \.self) { api in
                        Text(api)
                            .font(.callout.monospaced())
                    }
                }
            }
            .navigationTitle(duo.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") { dismiss() }
                }
            }
        }
    }
}
