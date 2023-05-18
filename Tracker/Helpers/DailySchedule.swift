import UIKit

struct DailySchedule {
    let dayOfWeek: String
    var schedulerIsActive: Bool = false
    let dayOfWeekNumber: Int
}

extension DailySchedule: Equatable {
    static func == (lhs: DailySchedule, rhs: DailySchedule) -> Bool {
        return lhs.dayOfWeekNumber == rhs.dayOfWeekNumber
    }
}


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
