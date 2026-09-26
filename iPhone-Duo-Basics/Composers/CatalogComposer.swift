import SwiftUI

// MARK: - Main Composer
@available(anyAppleOS 27.1, *)
struct CatalogComposer {

    func compose(_ state: HingeState) -> some View {
        CatalogSplitView(
            header: CatalogHeader(
                state: state,
                onHingeChange: { hinge in
                    Task {
                        await HingeAction(
                            state: state,
                            usecase: HingeFactory.useCase(),
                            mapper: DeviceHingeMapper()
                        )
                        .execute(hinge: hinge)
                    }
                }
            ),
            detail: { duo in
                SelectionScreen(selection: duo) {
                    destination(for: duo, state: state)
                }
            }
        )
    }

    @ViewBuilder
    private func destination(for duo: Duo, state: HingeState) -> some View {
        switch duo {
        case .hingeAngle:  HingeAngleView(state: state)
        case .hingeHistory: HingeHistoryView(state: state)
        case .splitArrangement: SplitArrangementView()
        case .reservedRegions: EmptyView()
        case .tabletop: TableTopView()
        case .evenColumns: EvenColumnsView()
        case .overlayArrangement: OverlayArrangementView()
        case .avoidDivision: AvoidDivisionView()
        case .foldedUnfolded: FoldUnFoldedView()
        case .verticalToolbar: VerticalToolBarView()
        case .containerMargins: ContainerMarginsView()
        }
    }
}

