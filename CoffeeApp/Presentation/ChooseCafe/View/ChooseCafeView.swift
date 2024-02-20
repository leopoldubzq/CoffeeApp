import SwiftUI

struct ChooseCafeView: View {
    
    @Binding var selectedCafe: CafeDto?
    var refreshCompletion: VoidCallback?
    @StateObject private var viewModel = ChooseCafeViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var route: [Route] = []
    
    var body: some View {
        NavigationStack(path: $route) {
            List {
                if let selectedCafe {
                    Section("Wybrana kawiarnia") {
                        HStack(spacing: 12) {
                            VStack {
                                Image("kawiarnia_drukarnia")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.top, 18)
                                    
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text(selectedCafe.title)
                                    .font(.headline)
                                Text(selectedCafe.description)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .lineLimit(3)
                                Spacer()
                            }
                            .padding(.top, 18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "info.circle")
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            route.append(.cafeDetails(CafeDto.mock.first!))
                        }
                    }
                }
                Section(selectedCafe == nil ? "Kawiarnie" : "Pozostałe kawiarnie") {
                    ForEach(getCafes(), id: \.uid) { cafe in
                        Button {
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0.08)) {
                                selectedCafe = cafe
                            }
                        } label: {
                            Text(cafe.title)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Wybierz kawiarnię")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                Button("Zapisz") {
                    HapticManager.shared.impact(.soft)
                    refreshCompletion?()
                    dismiss()
                }
                .fontWeight(.semibold)
            }
            .navigationDestination(for: Route.self, destination: { $0.handleDestination(route: $route) })
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Wczytywanie")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init(uiColor: .systemBackground))
                }
                
            }
            .onLoad { viewModel.getCafes() }
            .onChange(of: selectedCafe) { _, newValue in
                viewModel.selectedCafe = newValue
            }
        }
    }
    
    private func getCafes() -> [CafeDto] {
        viewModel.cafes.filter { $0.uid != selectedCafe?.uid }
    }
}

#Preview {
    ChooseCafeView(selectedCafe: .constant(CafeDto.mock.first!))
}
