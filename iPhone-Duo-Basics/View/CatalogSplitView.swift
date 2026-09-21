import SwiftUI

struct CatalogSplitView<Header: View, Detail: View>: View {
    @State private var selection: Duo?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    private let header: Header
    private let detail: (Duo) -> Detail

    init(
        header: Header,
        @ViewBuilder detail: @escaping (Duo) -> Detail
    ) {
        self.header = header
        self.detail = detail
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selection) {
                // header
                header

                // sections
                ForEach(DuoSection.allCases) { section in
                    Section(section.rawValue) {
                        ForEach(section.duoSections) { entry in
                            NavigationLink(value: entry) {
                                DuoRow(duo: entry)
                            }
                        }
                    }
                }

                .navigationTitle("iPhone Duo Basics")
            }
        } detail: {
            if let selection {
                detail(selection)
            } else {
                ContentUnavailableView(
                    "Pick an Example",
                    systemImage: "iphone.gen3",
                    description: Text("Choose an example from the sidebar to explore an iPhone Duo API.")
                )
            }
        }
        .onChange(of: selection, initial: true) {
            columnVisibility = (selection == nil) ? .all : .detailOnly
        }
    }
}
