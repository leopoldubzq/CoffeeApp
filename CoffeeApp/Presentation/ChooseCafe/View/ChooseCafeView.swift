import SwiftUI

struct ChooseCafeView: View {
    
    @Binding var selectedCafe: CafeDto?
    @StateObject private var viewModel = ChooseCafeViewModel()
    @State private var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(getCafes(), id: \.uid) { cafe in
                Text(cafe.title)
                    .onTapGesture {
                        selectedCafe = cafe
                        dismiss()
                    }
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Wybierz kawiarnię")
            .searchable(text: $searchText, 
                        placement: .navigationBarDrawer,
                        prompt: Text("Szukaj"))
        }
    }
    
    private func getCafes() -> [CafeDto] {
        searchText.isEmpty ? viewModel.cafes : viewModel.cafes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
    }
}

#Preview {
    ChooseCafeView(selectedCafe: .constant(nil))
}
