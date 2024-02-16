import SwiftUI

struct CafeDetailsView: View {
    
    var cafe: CafeDto
    @State private var scrollOffsetY: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @State private var imageHeight: CGFloat = 300
    @Environment(\.dismiss) private var popView
    
    var body: some View {
        
        GeometryReader { proxy in
            OffsetObservingScrollView(offset: $scrollOffsetY) {
                VStack {
                    CafeImage(screenHeight: proxy.size.height)
                    Group {
                        Text(cafe.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .offset(y: proxy.size.height * 0.4)
                    .padding(.horizontal)
                }
            }
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
            .overlay(alignment: .top) {
                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .extraLight))
                    .ignoresSafeArea(edges: .top)
                    .frame(width: proxy.size.width, height: 50)
                    .overlay(alignment: .center) {
                        Text(cafe.title)
                            .font(.headline)
                            .foregroundStyle(Color.init(uiColor: .label))
                            .offset(y: 16 - min(16, -(scrollOffsetY * 0.2)))
                            .padding(.top, proxy.safeAreaInsets.top > 0 ? 0 : 8)
                    }
                    .opacity(min(1, -scrollOffsetY / (getImageHeight() * 0.4)))
                    .overlay(alignment: .leading) {
                        Button { popView() } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(Color.init(uiColor: .label))
                                
                                .frame(width: 40, height: 40)
                                .background(
                                    Color("GroupedListCellBackgroundColor")
                                        .opacity(1.0 + (scrollOffsetY * 0.01))
                                )
                                .clipShape(Circle())
                        }
                        .padding(.leading, 24)
                        .padding(.top, proxy.safeAreaInsets.top > 0 ? 0 : 8)
                        .frame(width: 44, height: 44)
                        .opacity(min(1, (1.0 - (scrollOffsetY / (getImageHeight() * 0.4)))))
                    }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    private func CafeImage(screenHeight: CGFloat) -> some View {
        GeometryReader { proxy in
            let size = proxy.frame(in: .named("CafeDetails")).size
            Image("kawiarnia_drukarnia")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: (screenHeight * 0.4) + max(0, scrollOffsetY))
                .clipped()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            .linearGradient(colors: [
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.5),
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.1)
                            ], startPoint: .bottom, endPoint: .center)
                        )
                }
                .overlay(alignment: .bottom) {
                    Text(cafe.title)
                        .padding()
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.white)
                }
                .offset(y: min(0, -scrollOffsetY))
        }
    }
    
    private func getImageHeight() -> CGFloat {
        (getKeyWindow()?.frame.size.height ?? 0.0) * 0.4
    }
}

#Preview {
    CafeDetailsView(cafe: CafeDto.mock.first!)
}
