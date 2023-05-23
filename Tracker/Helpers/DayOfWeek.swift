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

extension DayOfWeek {
    static func dayCodeString(from selectedDays: [DayOfWeek]?) -> String? {
        guard let selectedDays = selectedDays else { return nil }
        var binaryRepresentation = ""
        for day in Self.allCases {
            if selectedDays.contains(day) {
                binaryRepresentation.append("1")
            } else {
                binaryRepresentation.append("0")
            }
        }
        return binaryRepresentation
    }
    
    
    static func decodeFrom(dayCodeString: String?) -> [DayOfWeek]? {
        guard let binaryString = dayCodeString else { return nil }
        var selectedWeekdays = [DayOfWeek]()
        for (index, char) in binaryString.enumerated() {
            guard char == "1" else { continue }
            guard let weekday = Self.allCases[safe: index] else { continue }
            selectedWeekdays.append(weekday)
        }
        return selectedWeekdays
    }
}
