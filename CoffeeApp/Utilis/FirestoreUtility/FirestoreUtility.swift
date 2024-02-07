import Firebase

enum FirestoreCollection: String {
    case users
    case menu
    case cafes
}

struct FirestoreUtility {
    static func collectionReference(_ collectionReference: FirestoreCollection) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    static func documentReference(uid: String) -> DocumentReference {
        return Firestore.firestore().document(uid)
    }
}
