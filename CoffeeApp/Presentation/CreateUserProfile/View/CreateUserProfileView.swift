import SwiftUI

struct CreateUserProfileView: View {
    
    @Binding private var user: UserDto
    @State private var usernameText: String = ""
    @State private var emailText: String = ""
    @FocusState private var usernameTextFieldFocused: Bool
    @FocusState private var emailTextFieldFocused: Bool
    @State private var chooseCafeViewPresented: Bool = false
    @StateObject private var viewModel = CreateUserProfileViewModel()
    
    init(user: Binding<UserDto>) {
        self._user = user
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    Text("Stwórz profil")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .trailing) {
                            Button {} label: {
                                Text("Zapisz")
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                    
                            }
                            .disabled(usernameText.isEmpty || viewModel.selectedCafe == nil)
                        }
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
                            .textInputAutocapitalization(.never)
                            .onSubmit {
                                usernameTextFieldFocused = false
                            }
                        Text("Email")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .padding(.top)
                            .foregroundStyle(.secondary)
                        TextField("Email", text: $emailText)
                            .padding(10)
                            .background(Color("GroupedListCellBackgroundColor"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .focused($emailTextFieldFocused)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .onSubmit {
                                emailTextFieldFocused = false
                            }
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
                user.currentCafe = newValue
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
        
}

#Preview {
    CreateUserProfileView(user: .constant(UserDto(uid: UUID().uuidString,
                                                  email: "leopold.romanowski@gmail.com")))
}
