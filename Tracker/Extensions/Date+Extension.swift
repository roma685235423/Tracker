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
}
