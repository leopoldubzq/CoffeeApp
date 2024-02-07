import SwiftUI

struct CreateUserProfileView: View {
    
    var completion: VoidCallback
    @State private var user: UserDto
    @State private var usernameText: String = ""
    @FocusState private var usernameTextFieldFocused: Bool
    @FocusState private var emailTextFieldFocused: Bool
    @State private var chooseCafeViewPresented: Bool = false
    @StateObject private var viewModel = CreateUserProfileViewModel()
    
    init(user: UserDto, completion: @escaping VoidCallback) {
        self.completion = completion
        self.user = user
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    UsernameSectionTextField()
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
            .navigationTitle("Uzupełnij profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { SaveButton() }
            .sheet(isPresented: $chooseCafeViewPresented) {
                ChooseCafeView(selectedCafe: $viewModel.selectedCafe)
            }
            .onChange(of: viewModel.selectedCafe) { _, newValue in
                viewModel.user?.currentCafe = newValue
            }
            .onChange(of: usernameText) { _, newValue in
                viewModel.user?.name = newValue
            }
            .onAppear {
                guard viewModel.user == nil else { return }
                viewModel.user = user
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Wczytywanie")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.init(uiColor: .systemBackground))
                }
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
            viewModel.user?.accountConfigured = true
            viewModel.updateUser { completion() }
        } label: {
            Text("Zapisz")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                
        }
        .enabled(validToSave())
    }
    
    @ViewBuilder
    private func UsernameSectionTextField() -> some View {
        VStack {
            SectionText("Imię")
            TextField("Twoje imię", text: $usernameText)
                .padding(10)
                .background(Color("GroupedListCellBackgroundColor"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .focused($usernameTextFieldFocused)
                .textInputAutocapitalization(.never)
                .onSubmit { usernameTextFieldFocused = false }
            Text("Od 3 do 20 znaków")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .font(.caption)
                .foregroundStyle(.secondary)
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
        !usernameText.isEmpty && usernameText.count >= 3 && usernameText.count <= 20 && viewModel.selectedCafe != nil
    }
}

#Preview {
    NavigationStack {
        CreateUserProfileView(user: UserDto(uid: UUID().uuidString,
                                            email: "leopold.romanowski@gmail.com")) {}
    }
}
