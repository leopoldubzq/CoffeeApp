import Foundation

enum CAError: Error {
    case basicError(String)
    case emptyFirestoreDocument
    case failedToDownloadImageUrl
    case failedToConvertImageToData
    case failedToCreateFirestoreDocument
    
    var message: String {
        switch self {
        case .basicError(let string):
            return string
        case .emptyFirestoreDocument:
            return "The given object doesn't exist in the database"
        case .failedToDownloadImageUrl:
            return "Failed to download image URL"
        case .failedToConvertImageToData:
            return "Failed to convert image to data"
        case .failedToCreateFirestoreDocument:
            return "Failed to create Firestore Document"
        }
    }
}
