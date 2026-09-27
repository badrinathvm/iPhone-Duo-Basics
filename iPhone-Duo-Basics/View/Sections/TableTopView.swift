//
//  TableTopView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/26/26.
//

import SwiftUI

@available(anyAppleOS 27.1, *)
struct TableTopView: View {
    @State private var isPlaying = true
    @State private var progress = 0.35
    
    var body: some View {
        GeometryReader { proxy in
            // 👇 The API: only active regions; there's none while the device is flat or closed.
            let fold = proxy.reservedRegions(kind: .division).first?.frame
            
            Group {
                if let fold, fold.width > fold.height {
                    tableTopLayout(fold: fold, size: proxy.size)
                } else if let fold {
                    bookLayout(fold: fold, size: proxy.size)
                } else {
                    regularLayout
                }
            }
        }
    }
    
    // MARK: Layouts

    private func tableTopLayout(fold: CGRect, size: CGSize) -> some View {
        VStack(spacing: 0) {
            Artwork()
                .padding(24)
                .frame(height: max(fold.minY, 0))
            Color.clear
                .frame(height: fold.height)
            VStack(spacing: 20) {
                Label("Tabletop", systemImage: "laptopcomputer")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                trackInfo
                controls
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .frame(height: max(size.height - fold.maxY, 0))
        }
        .transition(.blurReplace)
    }
    
    private func bookLayout(fold: CGRect, size: CGSize) -> some View {
        HStack(spacing: 0) {
            Artwork()
                .padding(32)
                .frame(width: max(fold.minX, 0))
            Color.clear
                .frame(width: fold.width)
            VStack(spacing: 24) {
                Label("Book", systemImage: "book")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
                trackInfo
                controls
            }
            .padding(32)
            .frame(width: max(size.width - fold.maxX, 0))
        }
        .frame(maxHeight: .infinity)
        .transition(.blurReplace)
    }
    
    private var regularLayout: some View {
        VStack(spacing: 28) {
            Artwork()
                .frame(maxWidth: 320)
            
            Label("Regular", systemImage: "settings")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.orange)
            
            trackInfo
            controls
            Text("Fold the device partially to move the controls away from the fold.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.blurReplace)
    }
    
    private var trackInfo: some View {
        VStack(spacing: 4) {
            Text("Hinge Blues")
                .font(.title2.bold())
            Text("The Foldables")
                .foregroundStyle(.secondary)
        }
    }
    
    private var controls: some View {
        VStack(spacing: 20) {
            Slider(value: $progress)
                .tint(.indigo)
            HStack(spacing: 48) {
                Button("Previous", systemImage: "backward.fill") {}
                Button(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause.fill" : "play.fill") {
                    isPlaying.toggle()
                }
                .font(.largeTitle)
                .contentTransition(.symbolEffect(.replace))
                Button("Next", systemImage: "forward.fill") {}
            }
            .labelStyle(.iconOnly)
            .font(.title)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: 420)
    }
    
    private struct Artwork: View {
        var body: some View {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    MeshGradient(
                        width: 2,
                        height: 2,
                        points: [[0, 0], [1, 0], [0, 1], [1, 1]],
                        colors: [.indigo, .purple, .pink, .orange]
                    )
                )
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
        }
    }
}


