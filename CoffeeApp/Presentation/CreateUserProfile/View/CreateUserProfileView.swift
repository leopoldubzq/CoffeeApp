import SwiftUI

struct CreateUserProfileView: View {
    
    @State private var usernameText: String = ""
    @FocusState private var usernameTextFieldFocused: Bool
    @FocusState private var emailTextFieldFocused: Bool
    @State private var chooseCafeViewPresented: Bool = false
    @StateObject private var viewModel = CreateUserProfileViewModel()
    
    init(user: Binding<UserDto>) {
        viewModel.user = user.wrappedValue
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text("Stwórz profil")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .trailing) {
                            SaveButton()
                        }
                    NickSectionTextField()
                    VStack(spacing: 8) {
                        if viewModel.selectedCafe != nil {
                            SectionText("Wybrana kawiarnia")
                        }
                        ChooseCafeButton()
                    }
                    .padding(.top, viewModel.selectedCafe == nil ? 24 : 0)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .overlay(alignment: .top) { SafeAreaView() }
            .sheet(isPresented: $chooseCafeViewPresented) {
                ChooseCafeView(selectedCafe: $viewModel.selectedCafe)
            }
            .onChange(of: viewModel.selectedCafe) { _, newValue in
                viewModel.user?.currentCafe = newValue
            }
            .onChange(of: usernameText) { _, newValue in
                viewModel.user?.name = newValue
            }
        }
        .frame(maxHeight: .infinity)
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
    
    @ViewBuilder
    private func SaveButton() -> some View {
        Button {
            viewModel.updateUser {
                
            }
        } label: {
            Text("Zapisz")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                
        }
        .enabled(validToSave())
    }
    
    @ViewBuilder
    private func NickSectionTextField() -> some View {
        VStack {
            SectionText("Nick")
            TextField("Aa", text: $usernameText)
                .padding(10)
                .background(Color("GroupedListCellBackgroundColor"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($usernameTextFieldFocused)
                .textInputAutocapitalization(.never)
                .onSubmit { usernameTextFieldFocused = false }
        }
    }
    
    @ViewBuilder
    private func SectionText(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            .padding(.top, 8)
            .foregroundStyle(.secondary)
    }
    
    private func validToSave() -> Bool {
        !usernameText.isEmpty && viewModel.selectedCafe != nil
    }
}

#Preview {
    CreateUserProfileView(user: .constant(UserDto(uid: UUID().uuidString,
                                                  email: "leopold.romanowski@gmail.com")))
}
