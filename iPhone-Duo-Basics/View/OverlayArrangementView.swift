//
//  OverlayArrangementView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/26/26.
//

import SwiftUI

@available(anyAppleOS 27.1, *)
struct OverlayArrangementView: View {
    @State private var edge: HorizontalEdge = .leading
    var body: some View {
        ArrangementView {
            ResultPanel(edge: $edge)
            // 👇 The API: the edge to occupy when the arrangement goes side by side.
                .overlayArrangementEdge(edge)
        } secondary: {
            MapPlaceholder()
        }
        // 👇 The API: the primary view floats over the secondary one.
        .arrangementViewStyle(.overlay)
    }
}

@available(anyAppleOS 27.1, *)
private struct MapPlaceholder: View {
    var body: some View {
        LinearGradient(colors: [.teal, .mint, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay {
                Image(systemName: "map")
                    .font(.system(size: 160, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.35))
            }
            .overlay(alignment: .bottomTrailing) {
                ZIndexLabel()
                    .padding()
            }
    }
}

@available(anyAppleOS 27.1, *)
private struct ZIndexLabel: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex

    var body: some View {
        Text("Map · zIndex \(zIndex)")
            .font(.caption.monospaced().weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.black.opacity(0.25), in: .capsule)
            .foregroundStyle(.white)
    }
}

@available(anyAppleOS 27.1, *)
struct ResultPanel: View {
    @Binding var edge: HorizontalEdge
    
    var body: some View {
        PanelContent(edge: $edge)
            .padding()
            .frame(maxWidth: 360)
            .glassEffect(in: .rect(cornerRadius: 28))
            .padding()
    }
}

@available(anyAppleOS 27.1, *)
private struct PanelContent: View {
    @Binding var edge: HorizontalEdge
    @State private var isExpanded = true
    
    // 👇 The API: above 0 while this view floats over the map.
    @Environment(\.overlayArrangementZIndex) private var zIndex
    
    private let places = ["Hinge & Bean", "The Fold", "Crease Café"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {
                withAnimation(.smooth) { isExpanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Coffee Nearby")
                            .font(.title3.bold())
                        Text("\(places.count) places · zIndex \(zIndex)")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                ForEach(places, id: \.self) { name in
                    Label(name, systemImage: "cup.and.saucer.fill")
                }
                Divider()
                Picker("Side-by-side edge", selection: $edge) {
                    Text("Leading").tag(HorizontalEdge.leading)
                    Text("Trailing").tag(HorizontalEdge.trailing)
                }
                .pickerStyle(.segmented)
                Text("The edge this panel takes when the arrangement goes side by side.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        // Collapse while floating over the map, expand when side by side.
        .onChange(of: zIndex, initial: true) {
            withAnimation(.smooth) {
                isExpanded = zIndex == 0
            }
        }
    }
}

