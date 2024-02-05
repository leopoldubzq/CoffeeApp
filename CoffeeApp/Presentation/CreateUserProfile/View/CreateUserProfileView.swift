import SwiftUI

struct CreateUserProfileView: View {
    
    @Binding private var user: UserDto
    @State private var usernameText: String = ""
    @FocusState private var usernameTextFieldFocused: Bool
    @State private var chooseCafeViewPresented: Bool = false
    @StateObject private var viewModel = CreateUserProfileViewModel()
    
    init(user: Binding<UserDto>) {
        self._user = user
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Stwórz profil")
                    .font(.title2)
                    .fontWeight(.semibold)
                VStack(spacing: 8) {
                    Text("Nick")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.top)
                        .foregroundStyle(.secondary)
                    TextField("Aa", text: $usernameText)
                        .padding(10)
                        .background(Color("GroupedListCellBackgroundColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .focused($usernameTextFieldFocused)
                }
                VStack(spacing: 8) {
                    if viewModel.selectedCafe != nil {
                        Text("Wybrana kawiarnia")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.top)
                            .foregroundStyle(.secondary)
                    }
                    ChooseCafeButton()
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .overlay(alignment: .top) { SafeAreaView() }
        .onTapGesture {
            usernameTextFieldFocused = false
        }
        .sheet(isPresented: $chooseCafeViewPresented) {
            ChooseCafeView(selectedCafe: $viewModel.selectedCafe)
        }
        .onChange(of: viewModel.selectedCafe) { _, newValue in
            user.currentCafe = newValue
        }
    }
    
    @ViewBuilder
    private func ChooseCafeButton() -> some View {
        Button { chooseCafeViewPresented.toggle() } label: {
            HStack {
                Text(viewModel.selectedCafe == nil ? "Wybierz kawiarnię" : viewModel.selectedCafe!.title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal)
            .background(Color("GroupedListCellBackgroundColor"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(viewModel.selectedCafe == nil ? .secondary : Color.primary)
        }
    }
        
}

#Preview {
    CreateUserProfileView(user: .constant(UserDto(uid: UUID().uuidString,
                                                  email: "leopold.romanowski@gmail.com")))
}
