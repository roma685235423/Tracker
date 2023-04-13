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
