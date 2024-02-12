import Firebase

protocol AuthProtocol {
    func getUserUid() -> String
    func isLoggedIn() -> Bool
}

extension AuthProtocol {
    func getUserUid() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }
    func isLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
}
