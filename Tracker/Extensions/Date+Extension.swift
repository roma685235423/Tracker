import Foundation

extension Date {
    
    func getDate() -> Date {
        let calendarComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: calendarComponents)
        return date!
    }
}
