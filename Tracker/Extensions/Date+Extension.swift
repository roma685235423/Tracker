import Foundation

extension Date {
    // MARK: - Public method
    func getDate() -> Date? {
        let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let day = calendarComponents.day, let month = calendarComponents.month, let year = calendarComponents.year
        else { return nil }
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents  = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        return calendar.date(from: dateComponents) ?? nil
    }
    
    func getStringFromLocalizedDate() -> String {
        let dateFormatter = DateFormatter()
        let locale = Locale.current.identifier
        
        if locale.hasPrefix("ru") {
            dateFormatter.dateFormat = "dd.MM.yy"
        } else {
            dateFormatter.dateFormat = "MM/dd/yy"
        }
        
        return dateFormatter.string(from: self)
    }
}
