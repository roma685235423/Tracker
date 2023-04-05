import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let dailySchedule: [IsScheduleActiveToday]
}
