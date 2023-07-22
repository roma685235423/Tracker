import Foundation

enum DayOfWeek: String, CaseIterable, Comparable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var localizedString: String {
        switch self {
        case .monday:
            return NSLocalizedString("schedule.monday", comment: "")
        case .tuesday:
            return NSLocalizedString("schedule.tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("schedule.wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("schedule.thursday", comment: "")
        case .friday:
            return NSLocalizedString("schedule.friday", comment: "")
        case .saturday:
            return NSLocalizedString("schedule.saturday", comment: "")
        case .sunday:
            return NSLocalizedString("schedule.sunday", comment: "")
        }
    }
    
    var localizedStringShort: String {
        switch self {
        case .monday:
            return NSLocalizedString("schedule.mondayShort", comment: "")
        case .tuesday:
            return NSLocalizedString("schedule.tuesdayShort", comment: "")
        case .wednesday:
            return NSLocalizedString("schedule.wednesdayShort", comment: "")
        case .thursday:
            return NSLocalizedString("schedule.thursdayShort", comment: "")
        case .friday:
            return NSLocalizedString("schedule.fridayShort", comment: "")
        case .saturday:
            return NSLocalizedString("schedule.saturdayShort", comment: "")
        case .sunday:
            return NSLocalizedString("schedule.sundayShort", comment: "")
        }
    }

    static func < (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
