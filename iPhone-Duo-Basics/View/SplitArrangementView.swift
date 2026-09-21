//
//  SplitArrangementView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/20/26.
//

import SwiftUI

/// `ArrangementView` takes a primary and secondary view,

@available(anyAppleOS 27.1, *)
struct SplitArrangementView: View {
    @State private var ratio = 0.4
    @State private var axes: AxesOption = .horizontal
    /// The seam only exists while both panes are on screen; in the single-pane
    /// case there is nothing to resize.
    @State private var isSecondaryVisible = false
    @State private var containerSize: CGSize = .zero
    
    var body: some View {
        ArrangementView {
            PaneView(title: "Primary", symbol: "list.bullet", color: .teal, skeleton: .list, axes: axes, share: ratio)
                .overlay(alignment: axes == .horizontal ? .trailing : .bottom) {
                    if isSecondaryVisible {
                        SeamHandle(
                            ratio: $ratio,
                            axis: axes.axis,
                            length: axes == .horizontal ? containerSize.width : containerSize.height
                        )
                        .padding(axes == .horizontal ? .trailing : .bottom, 4)
                    }
                }
                .splitArrangementLayoutRatio(ratio)
        } secondary: {
            PaneView(title: "Secondary", symbol: "doc.richtext", color: .indigo, skeleton: .document, axes: axes, share: 1 - ratio)
                .onAppear { isSecondaryVisible = true }
                .onDisappear { isSecondaryVisible = false }
        }
        // 👇 The API: split the two panes along the allowed axes.
        // This values applies to the primary view, for eg:  if set in horizontal, two views will be shown landscape mode and in the portrait mode only the primary view is shown.
        .arrangementViewStyle(.split.axes(axes.value))
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { size in
            containerSize = size
        }
        .safeAreaInset(edge: .bottom) {
            Picker("Axes", selection: $axes) {
                ForEach(AxesOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .glassEffect(in: .capsule)
            .padding()
            .frame(maxWidth: 420)
        }
    }
}

fileprivate enum AxesOption: String, CaseIterable, Identifiable {
    case horizontal, vertical
    
    var id: Self { self }
    
    var title: String { rawValue.capitalized }
    
    var value: Axis.Set {
        switch self {
        case .horizontal: Axis.Set.horizontal
        case .vertical: Axis.Set.vertical
        }
    }

    /// The single axis the panes are laid out along.
    var axis: Axis {
        switch self {
        case .horizontal: Axis.horizontal
        case .vertical: Axis.vertical
        }
    }
}

private struct PaneView: View  {
    let title: String
    let symbol: String
    let color: Color
    let skeleton: Skeleton
    let axes: AxesOption
    /// This pane's share of the split, shown as a chip.
    let share: Double
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            content(showsIcon: true, showsSkeleton: true)
            content(showsIcon: true)
            content(showsIcon: false)
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color.gradient, in: .rect(cornerRadius: 28))
        .padding(6)
    }
    
    private func content(showsIcon: Bool, showsSkeleton: Bool = false) -> some View {
        VStack(spacing: 16) {
            if showsIcon {
                Image(systemName: symbol)
                    .font(.system(size: 44, weight: .semibold))
            }
            Text(title)
                .font(.title2.bold())
//            Text(axisDescription)
//                .font(.callout.monospaced())
//                .padding(.horizontal, 10)
//                .padding(.vertical, 4)
//                .background(.white.opacity(0.2), in: .capsule)

            if showsSkeleton {
                SkeletonView(kind: skeleton)
                    .frame(maxWidth: 220)
            }
            if showsIcon {
                HStack(spacing: 6) {
                    chip(Text("axis: \(axes.title.lowercased())"))
                    chip(Text(share, format: .percent.precision(.fractionLength(0))))
                }
            }
        }
    }

    private func chip(_ text: Text) -> some View {
        text
            .font(.caption.monospaced())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.white.opacity(0.2), in: .capsule)
    }
}

private enum Skeleton {
    case list, document
}

/// Placeholder content that hints at what each pane is for: rows for a list,
/// a hero image and text lines for a document.
private struct SkeletonView: View {
    let kind: Skeleton

    var body: some View {
        switch kind {
        case .list:
            VStack(spacing: 6) {
                ForEach(0..<4) { row in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(.white.opacity(row == 0 ? 0.9 : 0.6))
                            .frame(width: 12, height: 12)
                        Capsule()
                            .fill(.white.opacity(0.55))
                            .frame(height: 7)
                            .padding(.trailing, Self.listTrailing[row])
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(.white.opacity(row == 0 ? 0.34 : 0.14), in: .rect(cornerRadius: 10))
                }
            }
        case .document:
            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.22))
                    .frame(height: 44)
                ForEach(0..<3) { line in
                    Capsule()
                        .fill(.white.opacity(0.5))
                        .frame(height: 7)
                        .padding(.trailing, Self.documentTrailing[line])
                }
            }
        }
    }

    private static let listTrailing: [CGFloat] = [0, 28, 12, 44]
    private static let documentTrailing: [CGFloat] = [18, 0, 46]
}
