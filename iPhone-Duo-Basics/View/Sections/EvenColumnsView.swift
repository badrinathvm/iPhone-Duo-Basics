//
//  EvenColumnsView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/26/26.
//

import SwiftUI

@available(anyAppleOS 27.1, *)
struct EvenColumnsView: View {
    @State private var alignsToFold = true
    
    private let minimumColumnWidth: CGFloat = 130
    private let spacing: CGFloat = 8
    
    var body: some View {
        GeometryReader { proxy in
            // 👇 The API: include inactive regions to know where the fold would be.
            let fold = proxy.reservedRegions(kind: .division, options: [ ReservedRegion.QueryOptions.includeInactive ])
                .first { $0.frame.height > $0.frame.width }?.frame
            
            ScrollView {
                if alignsToFold, let fold {
                    FoldAlignedGrid(
                        fold: fold,
                        width: proxy.size.width,
                        minimumColumnWidth: minimumColumnWidth,
                        spacing: spacing)
                } else {
                    let columnCount = max(Int(proxy.size.width / minimumColumnWidth), 2)
                    LazyVGrid(
                        columns: Array(
                                    repeating:  GridItem(.flexible(),
                                    spacing: spacing
                                ),
                        count: columnCount),
                        spacing: spacing
                    ) {
                        ForEach(0..<60, id: \.self) { index in
                            Tile(index: index)
                        }
                   }
                }
            }
            .overlay {
                if let fold {
                    FoldLine(x: fold.midX)
                }
            }
            .animation(.smooth, value: alignsToFold)
        }
        .safeAreaInset(edge: .bottom) {
            Toggle("Align to fold", isOn: $alignsToFold)
                .padding()
                .glassEffect(in: .capsule)
                .padding()
                .frame(maxWidth: 420)
        }
    }
}

private struct Tile: View {
    let index: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hue: Double(index % 15) / 15, saturation: 0.45, brightness: 0.92).gradient)
            .frame(height: 110)
            .overlay {
                Text("\(index + 1)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.white)
            }
    }
}

private struct FoldAlignedGrid: View {
    let fold: CGRect
    let width: CGFloat
    let minimumColumnWidth: CGFloat
    let spacing: CGFloat
    
    var body: some View {
        let leadingWidth = max(fold.minX, 0)
        let trailingWidth = max(width - fold.maxX, 0)
        let columnsPerSide = max(Int(min(leadingWidth, trailingWidth) / minimumColumnWidth), 1)
        let rowLength = columnsPerSide * 2
        let indices = Array(0..<60)
        
        HStack(alignment: .top, spacing: 0) {
            half(indices.filter { $0 % rowLength < columnsPerSide }, columns: columnsPerSide)
                .frame(width: leadingWidth)
            
            Color.clear
                .frame(width: fold.width)
            
            half(indices.filter { $0 % rowLength >= columnsPerSide }, columns: columnsPerSide)
                .frame(width: trailingWidth)
        }
    }
    
    private func half(_ indices: [Int], columns: Int) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns), spacing: spacing) {
            ForEach(indices, id: \.self) { index in
                Tile(index: index)
            }
        }
    }
}

private struct FoldLine: View {
    let x: CGFloat
    
    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: CGPoint(x: x, y:0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            context.stroke(path, with: .color(.pink), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
        }
        .allowsHitTesting(false)
    }
}
