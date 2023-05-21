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


extension DayOfWeek {
    static func code(_ weekdays: [DayOfWeek]?) -> String? {
        guard let weekdays else { return nil }
        let indexes = weekdays.map { Self.allCases.firstIndex(of: $0) }
        var result = ""
        for i in 0..<7 {
            if indexes.contains(i) {
                result += "1"
            } else {
                result += "0"
            }
        }
        return result
    }
    
    static func decode(from string: String?) -> [DayOfWeek]? {
        guard let string else { return nil }
        var weekdays = [DayOfWeek]()
        for (index, value) in string.enumerated() {
            guard value == "1" else { continue }
            let weekday = Self.allCases[index]
            weekdays.append(weekday)
        }
        return weekdays
    }
}
