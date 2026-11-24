import Foundation
struct Order: Codable {
    var id: Int
    var user: User?
    var order_date: String
    var total: Double
    var status: String
    
    
    func formattedDate(language: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        guard let date = inputFormatter.date(from: order_date) else {
            return order_date
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.calendar = Calendar(identifier: .gregorian)
        outputFormatter.timeStyle = .none
        outputFormatter.locale = Locale(identifier: language)

        return outputFormatter.string(from: date)
    }
}
