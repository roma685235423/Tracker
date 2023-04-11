import UIKit

struct IsScheduleActiveToday {
    let dayOfWeek: String
    var schedulerIsActive: Bool = false
    let dayOfWeekNumber: Int
}

extension IsScheduleActiveToday: Equatable {
    static func == (lhs: IsScheduleActiveToday, rhs: IsScheduleActiveToday) -> Bool {
        return lhs.dayOfWeekNumber == rhs.dayOfWeekNumber
    }
}
