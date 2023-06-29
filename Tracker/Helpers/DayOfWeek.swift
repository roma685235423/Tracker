import UIKit

enum DayOfWeek: String, CaseIterable, Comparable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"

    static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
