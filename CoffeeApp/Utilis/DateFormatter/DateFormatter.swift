import Foundation

final class DateManager {
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd.MM.yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
}
