//
//  PagingIndicator.swift
//  AnimatedPageIndicator
//
//  Created by Balaji Venkatesh on 01/01/24.
//

import SwiftUI

struct CustomPagingIndicator: View {
    /// Customization Properties
    var activeTint: Color = .primary
    var inActiveTint: Color = .primary.opacity(0.15)
    var cellItemPadding: CGFloat
    var cellItemSpacing: CGFloat
    var opacityEffect: Bool = false
    var clipEdges: Bool = false
    var body: some View {
        GeometryReader {
            /// Entire View Size for Calculating Pages
            let width = $0.size.width
            /// ScrollView Bounds
            if let scrollViewWidth = $0.bounds(of: .scrollView(axis: .horizontal))?.width, scrollViewWidth > 0 {
                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                let calculatedScrollViewWidth: CGFloat = scrollViewWidth - (cellItemPadding * 2) - cellItemSpacing
                let totalPages = Int(width / calculatedScrollViewWidth)
                /// Progress
                let freeProgress = -minX / calculatedScrollViewWidth
                let clippedProgress = min(max(freeProgress, 0.0), CGFloat(totalPages - 1))
                let progress = clipEdges ? clippedProgress : freeProgress
                /// Indexes
                let activeIndex = Int(progress)
                let nextIndex = Int(progress.rounded(.awayFromZero))
                let indicatorProgress = progress - CGFloat(activeIndex)
                /// Indicator Width's (Current & Upcoming)
                let currentPageWidth = 18 - (indicatorProgress * 18)
                let nextPageWidth = indicatorProgress * 18
                
                HStack(spacing: 10) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(.clear)
                            .frame(width: 8 + (activeIndex == index ? currentPageWidth : nextIndex == index ? nextPageWidth : 0), height: 8)
                            .overlay {
                                ZStack {
                                    Capsule()
                                        .fill(inActiveTint)
                                    
                                    Capsule()
                                        .fill(activeTint)
                                        .opacity(opacityEffect ? activeIndex == index ? 1 - indicatorProgress : nextIndex == index ? indicatorProgress : 0 : 1)
                                }
                            }
                    }
                }
                .frame(width: scrollViewWidth)
                .offset(x: -minX)
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    CoffeesListView()
}
