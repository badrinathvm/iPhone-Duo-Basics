//
//  ReservedRegionView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/26/26.
//

import SwiftUI

@available(anyAppleOS 27.1, *)
struct ReservedRegionView: View {
    @State private var kind: ReservedRegion.Kind = .division
    @State private var includeInactive = true
    
    private var options: ReservedRegion.QueryOptions {
        includeInactive ? [.includeInactive ]: []
    }
    
    var body: some View {
        GeometryReader { proxy in
            // 👇 The API: ask the geometry proxy for regions of a given kind.
            let regions = proxy.reservedRegions(kind: kind, options: options)
            
            RegionCanvas(regions: regions)
                .overlay(alignment: .bottom) {
                    ControlPanel(
                        kind: $kind,
                        includeInactive: $includeInactive,
                        regions: regions
                    )
                    .padding()
                    // The reader ignores the safe area to match the screen; the panel shouldn't.
                    .padding(proxy.safeAreaInsets)
                }
        }
        .ignoresSafeArea()
    }
}


@available(anyAppleOS 27.1, *)
private struct RegionCanvas: View {
    var regions: [ReservedRegion]
    
    var body: some View {
        Canvas { context, size in
            drawGrid(in: &context, size: size)
            
            for region in regions {
                let color: Color = region.isActive ? .pink : .gray
                let frame = region.frame
                
                // The reserved rect is the frame minus its margins.
                let reserved = CGRect(
                    x: frame.minX + region.margins.leading,
                    y: frame.minY + region.margins.top,
                    width: max(frame.width - region.margins.leading - region.margins.trailing, 0),
                    height: max(frame.height - region.margins.top - region.margins.bottom, 0)
                )
                
                context.fill(Path(frame), with: .color(color.opacity(0.15)))
                context.stroke(Path(frame), with: .color(color), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                
                if reserved.width == 0 || reserved.height == 0 {
                    // A zero-width rect, like the fold line: draw it as a line.
                    var line = Path()
                    line.move(to: CGPoint(x: reserved.minX, y: reserved.minY))
                    line.addLine(to: CGPoint(x: reserved.maxX, y: reserved.maxY))
                    context.stroke(line, with: .color(color), lineWidth: 3)
                } else {
                    context.fill(Path(reserved), with: .color(color.opacity(0.55)))
                }
            }
        }
        .background(.background)
        .allowsHitTesting(false)
    }
    
    private func drawGrid(in context: inout GraphicsContext, size: CGSize) {
        let step: CGFloat = 24
        var path = Path()
        for x in stride(from: 0, through: size.width, by: step) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
        }
        for y in stride(from: 0, through: size.height, by: step) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
        }
        context.stroke(path, with: .style(.quaternary), lineWidth: 0.5)
    }
}

@available(anyAppleOS 27.1, *)
private struct ControlPanel: View {
    @Binding var kind: ReservedRegion.Kind
    @Binding var includeInactive: Bool
    
    let regions: [ReservedRegion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Kind", selection: $kind) {
                Text("Division").tag(ReservedRegion.Kind.division)
                Text("Occlusion").tag(ReservedRegion.Kind.occlusion)
            }
            .pickerStyle(.segmented)
            
            Toggle("Include inactive regions", isOn: $includeInactive)
                .font(.subheadline)
            
            Divider()
            
            if regions.isEmpty {
                Text("No regions of this kind right now. Try unfolding the device or switching the kind.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(regions) { region in
                    RegionDetails(region: region)
                }
            }
        }
        .padding()
        .frame(maxWidth: 420)
        .glassEffect(in: .rect(cornerRadius: 24))
    }
}

@available(anyAppleOS 27.1, *)
private struct RegionDetails: View {
    let region: ReservedRegion

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(region.isActive ? .pink : .gray)
                    .frame(width: 8, height: 8)
                Text(region.isActive ? "Active" : "Inactive")
                    .font(.subheadline.weight(.semibold))
            }
            Group {
                Text("frame: \(format(region.frame))")
                Text("margins: \(format(region.margins))")
            }
            .font(.caption.monospaced())
            .foregroundStyle(.secondary)
        }
    }

    private func format(_ rect: CGRect) -> String {
        "(\(Int(rect.minX)), \(Int(rect.minY)), \(Int(rect.width)) × \(Int(rect.height)))"
    }

    private func format(_ insets: EdgeInsets) -> String {
        "t \(Int(insets.top)) l \(Int(insets.leading)) b \(Int(insets.bottom)) tr \(Int(insets.trailing))"
    }
}
