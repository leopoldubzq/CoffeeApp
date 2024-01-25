//
//  CoverFlowView.swift
//  Coverflow
//
//  Created by Balaji Venkatesh on 12/01/24.
//

import SwiftUI

/// Custom View
struct CoverFlowView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    /// Customization Properties
    var itemWidth: CGFloat
    var enableReflection: Bool = false
    var spacing: CGFloat = 0
    var rotation: Double
    var items: Item
    var content: (Item.Element) -> Content
    var iPadSpacing: CGFloat = 48
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflection)
                            .visualEffect { content, geometryProxy in
                                content
                                    .rotation3DEffect(.init(degrees: rotation(geometryProxy)),
                                                      axis: (x: 0, y: 1, z: 0), anchor: .center)
                            }
                            .scrollTransition(transition: { content, phase in
                                content
                                    .blur(radius: phase.isIdentity ? 0 : 3)
                                    .opacity(phase.isIdentity ? 1 : 0.1)
                            })
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
                .overlay(alignment: .bottom) {
                    CustomPagingIndicator(activeTint: Color.primary, inActiveTint: .secondary,
                                          cellItemPadding: (size.width - itemWidth) / 2,
                                          cellItemSpacing: (spacing < 0 ? -spacing : spacing),
                                          opacityEffect: true, clipEdges: false)
                    .offset(y: UIDevice.isIPad ? 70 : 0)
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
    
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        /// Converting into progress
        let progress = midX / scrollViewWidth
        /// Limiting Progress between 0-1
        let cappedProgress = max(min(progress, 1), 0)
        /// Limiting Rotation between 0-90
        let cappedRotation = max(min(rotation, 90), 0)
        let degree = cappedProgress * (cappedRotation * 2)
        return cappedRotation - degree
    }
}

/// Cover Flow Item Model
struct CoverFlowItem: Identifiable {
    let id: UUID = .init()
    var color: Color
}

/// View Extensions
extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader {
                        let size = $0.size
                        
                        self
                            /// Flipping Upside Down
                            .scaleEffect(y: -1)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(colors: [
                                            .white,
                                            .white.opacity(0.7),
                                            .white.opacity(0.5),
                                            .white.opacity(0.3),
                                            .white.opacity(0.1),
                                            .white.opacity(0),
                                        ] + Array(repeating: Color.clear, count: 5), startPoint: .top, endPoint: .bottom)
                                    )
                            }
                            /// Moving to Bottom
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                    }
                }
            }
    }
}

#Preview {
    CoffeesListView()
}
