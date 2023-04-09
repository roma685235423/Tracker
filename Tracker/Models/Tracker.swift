import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let dailySchedule: [IsScheduleActiveToday]?
    
    init(id: UUID = UUID(), label: String, color: UIColor, emoji: String, dailySchedule: [IsScheduleActiveToday]?) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.dailySchedule = dailySchedule
    }
}
