//
//  DuoSections.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/20/26.
//

import Foundation

enum DuoSection: String, CaseIterable, Identifiable {
    case hinge = "Hinge"
//    case reservedRegions = "Reserved Regions"
    case arrangements = "Arrangements"
//    case barsAndMargins = "Bars And Margins"
//    case adaptivity = "Adaptivity"

    var id: Self { self }

    var duoSections: [Duo] {
        Duo.allCases.filter { $0.section == self }
    }
}

enum Duo: String, CaseIterable, Identifiable, Hashable {
    case hingeAngle
    case hingeHistory
//    case reservedRegions
    case splitArrangement

    var id: Self { self }

    var section: DuoSection {
        switch self {
        case .hingeAngle, .hingeHistory: .hinge
        case .splitArrangement: .arrangements
//        case .reservedRegions: .reservedRegions
        }
    }

    var title: String {
        switch self {
        case .hingeAngle: "Hinge Angle"
        case .hingeHistory: "Hinge Angle History"
        case .splitArrangement: "Split Arrangement"
//        case .reservedRegions: "Reserved Regions"
        }
    }

    var summary: String {
        switch self {
        case .hingeAngle:
            "Read the live hinge angle with onHingeChange and mirror it in a 3D model of the device."
        case .hingeHistory:
            "Record hinge updates over time and plot them with Swift Charts."
        case .splitArrangement:
            "Place two views side by side with ArrangementView and tune the ratio between them."
//        case .reservedRegions:
//            "Query occlusion and division regions from GeometryProxy and draw them on top of your UI."
        }
    }

    var symbol: String {
        switch self {
        case .hingeAngle: "rotate.3d"
        case .hingeHistory: "chart.xyaxis.line"
//        case .reservedRegions: "rectangle.dashed"
//        case .avoidDivision: "book.pages"
//        case .tabletop: "laptopcomputer"
//        case .evenColumns: "square.grid.2x2"
        case .splitArrangement: "rectangle.split.2x1"
//        case .overlayArrangement: "square.on.square"
//        case .verticalToolbar: "sidebar.left"
//        case .containerMargins: "square.dashed.inset.filled"
//        case .foldedUnfolded: "arrow.left.and.right.square"
        }
    }
}
