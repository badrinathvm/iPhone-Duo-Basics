//
//  AvoidDivisionView.swift
//  iPhone-Duo-Basics
//
//  Created by Rani Badri on 9/26/26.
//

import SwiftUI

@available(anyAppleOS 27.1, *)
struct AvoidDivisionView: View {
    @State private var respectInActive = true
    
    var body: some View {
        GeometryReader { proxy in
            // 👇 The API: find where the content should divide.
            let options: ReservedRegion.QueryOptions = respectInActive ? [.includeInactive] : []
            let fold = proxy.reservedRegions(kind: .division, options: options).first?.frame
            
            if let fold, fold.width > fold.height {
                // horizontal fold (tabletop), pages on top and bottom
                VStack {
                    Page(number: 1)
                        .frame(height: max(fold.minY, 0))
                        .border(Color.red)
                    
                    FoldGap()
                        .frame(height: fold.height)
                    
                    Page(number: 2)
                        .frame(height: max(proxy.size.height - fold.maxY,0))
                        .border(Color.black)
                }
            } else if let fold {
                // Vertical fold (Book), pages on the left and right
                HStack {
                    Page(number: 1)
                        .frame(width: max(fold.minX, 0))
                        .border(Color.red)
                    
                    FoldGap()
                        .frame(width: fold.width)
                    
                    Page(number: 2)
                        .frame(width: max(proxy.size.width - fold.maxX, 0))
                        .border(Color.blue)

                }
            } else {
                Page(number: 1)
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity)
            }
        }
        .background(Color(red: 0.98, green: 0.96, blue: 0.91))
        .safeAreaInset(edge: .bottom) {
            Toggle("Respect inactive regions", isOn: $respectInActive)
                .padding()
                .glassEffect(in: .capsule)
                .padding()
                .frame(maxWidth: 420)
        }
    }
}


private struct FoldGap: View {
    var body: some View {
        LinearGradient(
            colors: [.black.opacity(0), .black.opacity(0.08), .black.opacity(0)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private struct Page: View {
    let number: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if number == 1 {
                    Text("Chapter One")
                        .font(.system(.largeTitle, design: .serif).bold())
                }
                Text(number == 1 ? Self.first : Self.second)
                    .font(.system(.body, design: .serif))
                    .lineSpacing(6)
                Text("\(number)")
                    .font(.system(.footnote, design: .serif))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top)
            }
            .padding(24)
        }
        .foregroundStyle(.black.opacity(0.85))
    }

    private static let first = """
    The phone lay open on the table like a small book. Its two halves caught the morning light at slightly different angles, and the crease between them was barely visible — but it was there, and the app knew it.

    Instead of running a paragraph straight across the fold, the layout asked the system where the division was and simply stepped around it. Page one ended just before the crease.
    """

    private static let second = """
    Page two began just after it. Nothing was hidden, nothing was split mid-word, and the reader never had to think about the hardware at all.

    When the phone was folded shut again, the division region disappeared, and the two pages quietly became one. Good adaptive layout is mostly invisible.
    """
}
